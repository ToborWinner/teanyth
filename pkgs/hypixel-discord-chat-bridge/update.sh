#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(dirname "$(realpath "$0")")

revision=$(curl -s https://api.github.com/repos/ToborWinner/hypixel-discord-chat-bridge/commits/main -H "Accept: application/vnd.github.VERSION.sha")

echo "New revision: $revision"
hash="$(nix hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --unpack 'https://github.com/ToborWinner/hypixel-discord-chat-bridge/archive/'"$revision"'.tar.gz')" | sed 's~/~\\/~g')"
echo "New hash (escaped): $hash"

sed -i -r 's/rev = "\w+"/rev = "'"$revision"'"/' "$SCRIPT_DIR"/default.nix
sed -i -r 's/sha256 = ".+"/sha256 = "'"$hash"'"/' "$SCRIPT_DIR"/default.nix
