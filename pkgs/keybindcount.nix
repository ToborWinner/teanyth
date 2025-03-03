{
  writeShellScriptBin,
  wtype,
  discord-counting-tools,
  ...
}:

writeShellScriptBin "keybindcount" ''
  set -e

  if [[ ! -f ~/.cache/dct/num.txt ]] ; then
    mkdir -p ~/.cache/dct
    echo -n '1' > ~/.cache/dct/num.txt;
  fi

  output=$(${discord-counting-tools}/bin/discord-counting-tools $1 `cat ~/.cache/dct/num.txt`)
  echo -n "$output" | wl-copy
  hyprctl dispatch submap reset
  ${wtype}/bin/wtype -M ctrl v -m ctrl -P Return -p Return
  hyprctl dispatch submap counting
  num=$(cat ~/.cache/dct/num.txt)
  echo -n $((num + 2)) > ~/.cache/dct/num.txt
''
