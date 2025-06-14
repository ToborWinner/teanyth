# Templates to be used with nix flake init -t ${settings.username}#name
{
  rust = {
    path = ./rust;
    description = "Rust project template";
  };
  haskell = {
    path = ./haskell;
    description = "Haskell project template";
  };
  manim = {
    path = ./manim;
    description = "Manim presentation project template";
  };
}
