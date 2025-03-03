{
  writeShellScriptBin,
  oath-toolkit,
  secretCommand ? "echo \"error\"",
  ...
}:

# TODO: Improve setup of 2fa command

writeShellScriptBin "2fa" ''
  ${oath-toolkit}/bin/oathtool --base32 --totp "`${secretCommand}`" -d 6
''
