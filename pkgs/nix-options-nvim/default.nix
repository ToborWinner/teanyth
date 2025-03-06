{
  vimUtils,
  ...
}:

vimUtils.buildVimPlugin {
  name = "nix-options-nvim";
  src = ./src;
}
