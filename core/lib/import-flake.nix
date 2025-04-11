let
  inherit (builtins) removeAttrs attrNames mapAttrs;
in
rec {
  /**
    Get the arguments that describe a flake if importing without `builtins.getFlake` is needed.
    Note that this evaluates the entirety of the inputs, which might require downloads of unused inputs.
    This output is valid to be serialized to JSON.
  */
  flakeArguments =
    flake:
    let
      self =
        (removeAttrs flake (
          (attrNames (flake.outputs or { }))
          ++ [
            "outputs"
            "inputs"
            "outPath"
          ]
        ))
        // (
          if flake ? sourceInfo then { sourceInfo = removeAttrs flake.sourceInfo [ "outPath" ]; } else { }
        );
      inputs = mapAttrs (_: flakeArguments) flake.inputs;
    in
    {
      inherit self;
      path = flake.outPath;
      ${if flake ? outputs then null else "noOutputs"} = true;
    }
    // (if flake ? inputs then { inherit inputs; } else { });

  /**
    Construct and import a flake without using `builtins.getFlake` from the output of flakeArguments.
    This will be evaluated lazily, so flake inputs you don't use will not be imported.
  */
  importFlake =
    flakeArguments:
    let
      flakeAttrs = import (flakeArguments.path + "/flake.nix");
      inputs = mapAttrs (_: importFlake) flakeArguments.inputs;
      outputs = flakeAttrs.outputs (inputs // { inherit self; });
      self =
        (if flakeArguments.noOutputs or false then { } else outputs // { inherit outputs; })
        // flakeArguments.self
        // {
          outPath = flakeArguments.path;
        }
        // (if flakeArguments ? inputs then { inherit inputs; } else { })
        // (
          if flakeArguments.self ? sourceInfo then
            {
              sourceInfo = flakeArguments.self.sourceInfo // {
                outPath = flakeArguments.path;
              };
            }
          else
            { }
        );
    in
    self;

  /**
    Path of this file if sharing it is necessary. Better to access it through lib than to use the relative path.
  */
  selfPath = ./import-flake.nix;
}
