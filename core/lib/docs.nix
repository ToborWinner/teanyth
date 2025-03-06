/**
  Most of these functions are provided by either the nixpkgs lib or pkgs, but they use declarations instead of declarationPositions.
  In addition, they hide internal options. These functions are similar to the nixpkgs functions, but they have some tweaks.
*/
lib:

with lib;

{
  configuration ? null,
  options ?
    (configuration.extendModules {
      modules = singleton {
        # The nixpkgs option `virtualisation.xen.store.type.default` depends on `virtualisation.xen.store.path.default`,
        # which depends on the output path of the derivation for the xen package, which does not support aarch64-linux.
        nixpkgs.config.allowUnsupportedSystem = true;
      };
    }).options,
  # Allow failing evaluation of default
  allowBroken ? false,
  # Assume all values either have a defaultText or a default
  assumeDefault ? true,
  transformOption ? id,
}:

# TODO: Maybe open a PR to fix all those internal options that cause docs to depend on derivation out paths
# You can find them using builtins.getContext on the output JSON

let
  inherit (lib.options) renderOptionValue;

  # Taken from https://github.com/NixOS/nixpkgs/blob/f0d91fd0d01668b3e948cc52265bd54dd4e19917/nixos/lib/make-options-doc/default.nix#L117
  # Uses my custom optionAttrSetToDocList instead of the normal lib one
  rawOpts = optionAttrSetToDocList options;
  transformedOpts = map transformOption rawOpts;
  optionsList = lib.flip map transformedOpts (
    opt:
    opt
    // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != [ ]) {
      relatedPackages = genRelatedPackages opt.relatedPackages opt.name;
    }
  );

  # From https://github.com/NixOS/nixpkgs/blob/f0d91fd0d01668b3e948cc52265bd54dd4e19917/nixos/lib/make-options-doc/default.nix#L142
  genRelatedPackages =
    packages: optName:
    let
      unpack =
        p:
        if lib.isString p then
          { name = p; }
        else if lib.isList p then
          { path = p; }
        else
          p;
      describe =
        args:
        let
          title = args.title or null;
          name = args.name or (lib.concatStringsSep "." args.path);
        in
        ''
          - [${lib.optionalString (title != null) "${title} aka "}`pkgs.${name}`](
              https://search.nixos.org/packages?show=${name}&sort=relevance&query=${name}
            )${lib.optionalString (args ? comment) "\n\n  ${args.comment}"}
        '';
    in
    lib.concatMapStrings (p: describe (unpack p)) packages;

  # From https://github.com/NixOS/nixpkgs/blob/f0d91fd0d01668b3e948cc52265bd54dd4e19917/nixos/lib/make-options-doc/default.nix#L167
  # Modified to include visibility and whether the option is internal (my docs display internal options as well)
  optionsNix = builtins.listToAttrs (
    map (o: {
      name = o.name;
      value = removeAttrs o [
        "name"
        "visibleInternal"
        "loc"
      ];
    }) optionsList
  );

  # Taken from https://github.com/NixOS/nixpkgs/blob/f0d91fd0d01668b3e948cc52265bd54dd4e19917/lib/options.nix#L538
  # Modified to support declarationPositions instead of just declarations
  optionAttrSetToDocList = optionAttrSetToDocList' [ ];

  optionAttrSetToDocList' =
    _: options:
    concatMap (
      opt:
      let
        name = showOption opt.loc;
        docOption =
          {
            loc = opt.loc;
            inherit name;
            description = opt.description or null;
            declarations =
              let
                positions = opt.declarationPositions; # For now even unknown ones are allowed
                mapping =
                  declaration:
                  throwIfNot (hasPrefix "/nix/store/" declaration.file) ''
                    The content of options.json seems to depend on the path to nixpkgs, which is bad.
                    See https://github.com/NixOS/nixpkgs/blob/f0d91fd0d01668b3e948cc52265bd54dd4e19917/nixos/lib/make-options-doc/default.nix#L239 for more information.
                  '' declaration;
              in
              map mapping positions;
            internal = opt.internal or false;
            visibleInternal = if (opt ? visible && opt.visible == "shallow") then true else opt.visible or true;
            visible = opt.visible or true;
            readOnly = opt.readOnly or false;
            type = opt.type.description or "unspecified";
          }
          // optionalAttrs (opt ? example) {
            example = builtins.addErrorContext "while evaluating the example of option `${name}`" (
              renderOptionValue opt.example
            );
          }
          // optionalAttrs (opt ? defaultText || opt ? default) {
            default =
              let
                assumeWorking = builtins.addErrorContext "while evaluating the ${
                  if opt ? defaultText then "defaultText" else "default value"
                } of option `${name}`" (renderOptionValue (opt.defaultText or opt.default));

                # This is for example for `virtualisation.xen.store.type` on aarch64-linux, as explained at the start of the file.
                assumeBroken =
                  let
                    evaluated = builtins.tryEval (renderOptionValue (opt.defaultText or opt.default));
                  in
                  if evaluated.success then
                    evaluated.value
                  else
                    literalMD "There was an error in the evaluation of this default.";

                default = if allowBroken then assumeBroken else assumeWorking;
              in
              if !assumeDefault -> (opt ? "defaultText" || opt ? "default") then
                default
              else
                literalMD "No default provided.";
          }
          // optionalAttrs (opt ? relatedPackages && opt.relatedPackages != null) {
            inherit (opt) relatedPackages;
          };

        subOptions =
          let
            ss = opt.type.getSubOptions opt.loc;
          in
          if ss != { } then optionAttrSetToDocList' opt.loc ss else [ ];
        subOptionsVisible = docOption.visibleInternal && opt.visible or null != "shallow";
      in
      # To find infinite recursion in NixOS option docs:
      # builtins.trace opt.loc
      [ docOption ] ++ optionals subOptionsVisible subOptions
    ) (collect isOption options);

  optionsJSON = builtins.unsafeDiscardStringContext (builtins.toJSON optionsNix);
  optionsCTAGS = concatMapAttrsStringSep "\n" (
    name: value:
    "${name}\t${(head value.declarations).file}\t${toString (head value.declarations).line}"
  ) optionsNix;
in
{
  inherit optionsNix optionsJSON optionsCTAGS;
}
