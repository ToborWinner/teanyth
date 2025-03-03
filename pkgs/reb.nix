{
  writeShellScriptBin,
  nh,
  dotfilesDir ? null,
  ...
}:

writeShellScriptBin "reb" (
  if dotfilesDir == null then
    ''
      echo "Cannot use reb script: dotfilesDir not overridden in package."
    ''
  else
    ''
      pushd ${dotfilesDir}

      git add -A

      ${nh}/bin/nh os switch

      # Commit only if switch was successful
      if [ $? -eq 0 ]; then
        # Add the key to ssh-add (if not already present) to sign the commit
        # if ! ssh-add -l > /dev/null 2>&1; then
          echo "SSH password needed for git commit signing."
          ssh-add
        # fi

        # Commit with the name of the new generation
        # git commit -m "$(nixos-rebuild list-generations | grep current)"
      fi

      popd
    ''
)
