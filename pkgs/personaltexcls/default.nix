{
  stdenvNoCC,
  writeShellScript,
  ...
}:

stdenvNoCC.mkDerivation {
  pname = "personaltexcls";
  version = "1.0.0";
  src = ./personal.cls;
  outputs = [ "tex" ];
  nativeBuildInputs = [
    # From https://nixos.org/manual/nixpkgs/stable/#sec-language-texlive
    # multiple-outputs.sh fails if $out is not defined
    (writeShellScript "force-tex-output.sh" ''
      out="''${tex-}"
    '')
  ];
  dontConfigure = true;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $tex/tex/latex/personalcls/
    cp $src $tex/tex/latex/personalcls/personal.cls
  '';
}
