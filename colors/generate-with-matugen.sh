#!/usr/bin/env bash

# Usage: ./generate-with-matugen.sh IMAGE_PATH my-result.json
# my-result.json should only be the name, not a path.

set -e

if ! command -v matugen >/dev/null 2>&1; then
	echo "Matugen is not in PATH. Run 'nix shell n#matugen'"
	exit 1
fi

if [ -z "$1" ]; then
	echo "Error: missing input image path"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "Error: input image does not exist: $1"
	exit 1
fi

if [ -z "$2" ]; then
	echo "Error: missing output filename"
	exit 1
fi

INPUT_IMAGE="$1"
OUTPUT_FILE="$2"

# Create temporary directory
TMP_DIR="$(mktemp -d)" || {
	echo "Error: failed to create temporary directory"
	exit 1
}

cleanup() {
	rm -rf "$TMP_DIR"
}

trap cleanup EXIT INT TERM

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
OUTPUT_FILE_PATH="$SCRIPT_DIR/$OUTPUT_FILE"
MATUGEN_TEMPLATE="$SCRIPT_DIR/matugen-template.json"
CONFIG_PATH="$TMP_DIR/config.toml"

echo "Input: $INPUT_IMAGE"
echo "Output: $OUTPUT_FILE_PATH"
echo "Temp dir: $TMP_DIR"

cat <<EOF >"$CONFIG_PATH"
[config]

[templates.exporting]
input_path = '$MATUGEN_TEMPLATE'
output_path = '$OUTPUT_FILE_PATH'
EOF

matugen image "$INPUT_IMAGE" --show-colors --verbose --config "$CONFIG_PATH"
