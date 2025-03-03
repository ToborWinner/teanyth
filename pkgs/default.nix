lib:

let
  isNixPackage =
    { name, type }: type == "directory" || (lib.strings.hasSuffix ".nix" name && name != "default.nix");
  removeSuffix = name: lib.removeSuffix ".nix" name;
in
builtins.map
  (x: {
    name = removeSuffix x.name;
    path = ./${x.name};
  })
  (
    builtins.filter isNixPackage (
      lib.mapAttrsToList (name: type: { inherit name type; }) (builtins.readDir ./.)
    )
  )
