# Define log functions
function _i() {
	echo "$1"
}

function _iWarn() {
	echo "WARNING: $1"
}

function _iError() {
	echo "ERROR: $1"
}

function _iVerbose() {
	if [[ -v VERBOSE ]]; then
		echo "$1"
	fi
}

_i "Starting Theme Activation"

if ! [[ $HOME -ef $expectedHome ]]; then
	_iError "HOME is set to '$HOME' but we expect '$expectedHome'"
	exit 1
fi

# Setup variables
if [[ -v VERBOSE ]]; then
	declare VERBOSE_ARG="--verbose"
else
	declare VERBOSE_ARG=""
fi

declare BACKUP_EXT="themebackup"

declare -r stateHome="${XDG_STATE_HOME:-$HOME/.local/state}"
declare -r hmStatePath="$stateHome/home-manager"
declare -r hmGcrootsDir="$hmStatePath/gcroots"
declare -r currentThemeGenGcPath="$hmGcrootsDir/current-theme"

declare oldThemeGenPath
if [[ -e $currentThemeGenGcPath ]]; then
	oldThemeGenPath="$(readlink -e "$currentThemeGenGcPath")"
else
	oldThemeGenPath=""
fi

declare -r newHmGenPath="${newHmGenPath:-}"

_iVerbose "Variables:"
_iVerbose "> storeDir=$storeDir"
_iVerbose "> newThemeGenPath=$newThemeGenPath"
_iVerbose "> oldThemeGenPath=$oldThemeGenPath"
_iVerbose "> newHmGenPath=$newHmGenPath"

# Sanity check Nix
_iVerbose "Sanity checking Nix"
nix-build --quiet --expr '{}' --no-out-link

function removeOldFile() {
	targetPath="$HOME/$1"

	# A symbolic link whose target path matches this pattern will be
	# considered part of a Home Manager generation.
	homeFilePattern="$(readlink -e $storeDir)/*-home-manager-files/*"

	# If it exists in the new theme, there is no need to remove it, it will be updated
	if [[ -e "$2/$1" ]]; then
		_iVerbose "Checking $targetPath: exists"
	# If in the home dir it's not a link into the store for a home manager files generation, then be on the safe side and don't delete the user's file
	elif [[ ! "$(readlink "$targetPath")" == $homeFilePattern ]]; then
		_iWarn "Path '$targetPath' does not link into a Home Manager generation. Skipping delete."
	elif [[ -n "$3" && -e "$3/$1" ]]; then
		_iVerbose "$targetPath exists in the new home manager generation: skipping removal."
	else
		# Delete the file
		_iVerbose "Deleting $targetPath"
		rm $VERBOSE_ARG "$targetPath"

		# Recursively delete empty parent directories.
		_iVerbose "Deleting empty directories leading to $targetPath"
		targetDir="$(dirname "$1")"
		if [[ "$targetDir" != "." ]]; then
			pushd "$HOME" >/dev/null

			# Call rmdir with a relative path excluding $HOME.
			# Otherwise, it might try to delete $HOME and exit
			# with a permission error.
			rmdir $VERBOSE_ARG \
				-p --ignore-fail-on-non-empty \
				"$targetDir"

			popd >/dev/null
		fi
	fi
}

# Remove the files from the old theme generation
function cleanOldGen() {
	if [[ -z oldThemeGenPath || ! -e "$oldThemeGenPath/files" ]]; then
		_iVerbose "No information about what files to delete from old theme: skipping."
		return
	fi

	_i "Cleaning up orphan links from $HOME"

	local newGenFiles oldGenFiles newHmGenFiles
	newGenFiles="$(readlink -e "$newThemeGenPath/files")"
	oldGenFiles="$(readlink -e "$oldThemeGenPath/files")"

	if [[ -n "$newHmGenPath" ]]; then
		newHmGenFiles="$(readlink -e "$newHmGenPath/home-files")"
	else
		newHmGenFiles=""
	fi

	# Find all files/links in the old generation
	find "$oldGenFiles" '(' -type f -or -type l ')' -printf '%P\0' | while IFS= read -r -d '' file; do
		removeOldFile $file $newGenFiles $newHmGenFiles
	done
}

function linkNewFile() {
	targetPath="$HOME/$1"

	if [[ -e "$targetPath" && ! -L "$targetPath" && -n "$BACKUP_EXT" ]]; then
		# The target exists, back it up
		_iWarn "File $targetPath already exists, it will be backed up"
		backup="$targetPath.$HOME_MANAGER_BACKUP_EXT"
		mv $VERBOSE_ARG "$targetPath" "$backup" || _iWarn "Moving '$targetPath' to backup location failed!"
	fi

	# Create the directories
	_iVerbose "Creating directories leading to $targetPath"
	mkdir -p $VERBOSE_ARG "$(dirname "$targetPath")"

	# Create the symlink (exit on fail)
	_iVerbose "Creating $targetPath"
	ln -Tsf $VERBOSE_ARG "$2/$1" "$targetPath" || exit 1
}

# Create the files of the new theme generation
function linkNewGen() {
	_i "Creating theme file links in $HOME"

	local newGenFiles
	newGenFiles="$(readlink -e "$newThemeGenPath/files")"

	find "$newGenFiles" '(' -type f -or -type l ')' -printf '%P\0' | while IFS= read -r -d '' file; do
		linkNewFile $file $newGenFiles
	done
}

cleanOldGen
linkNewGen

_i "Updating current theme"
nix-store --realise "$newThemeGenPath" --add-root "$currentThemeGenGcPath"

_i "Running file reload scripts"
