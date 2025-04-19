{
  runCommand,
  buildPackages,
  jq,
  nixfmt-rfc-style,
  lib,
  ...
}:
{ parameters, args }:
runCommand "reduced-module-list.nix"
  {
    nativeBuildInputs = [ jq ];

    gen1 = ./gen-evaluated-options.nix;
    gen2 = ./gen-needed-modules.nix;

    parameterArgs = builtins.toJSON args;

    inherit parameters;

    passAsFile = [ "parameterArgs" ] ++ (lib.optional (builtins.isString parameters) "parameters");
  }
  ''
    export NIX_STATE_DIR=$TMPDIR/state

    ${buildPackages.nix}/bin/nix-instantiate \
    --eval --readonly-mode --show-trace --json --strict \
    --arg parameters "import $parameters${lib.optionalString (builtins.isString parameters) "Path"}" \
    --arg args "builtins.fromJSON (builtins.readFile $parameterArgsPath)" \
    $gen1 > configless.json 2> warnings.log || {
      echo "There was an error:$(cat warnings.log)"
      exit 1
    }

    # Get every line that has -| |- and get the content in-between the
    # outermost -| |-
    sed -n 's/.*-|\(.*\)|-.*/\1/p' warnings.log > traces

    # The contents of -| |- are JSON values. Make an array containing
    # the JSON value of each line
    json_array="[]"
    while IFS= read -r line; do
      json_array=$(echo "$json_array" | jq -c ". += [$line]")
    done < traces

    # Filter duplicates
    json_array=$(echo "$json_array" | jq -c "unique")

    echo -n "$json_array" > evaluated.json

    ${buildPackages.nix}/bin/nix-instantiate \
    --eval --readonly-mode --strict --show-trace \
    --arg parameters "import $parameters" \
    --arg args "builtins.fromJSON (builtins.readFile $parameterArgsPath)" \
    --arg options "builtins.fromJSON (builtins.readFile ./evaluated.json)" \
    --arg configless "builtins.fromJSON (builtins.readFile ./configless.json)" \
    $gen2 | ${lib.getExe nixfmt-rfc-style} --strict > $out
  ''
