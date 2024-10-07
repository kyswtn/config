#!/bin/sh

# If any command fails, fail the script.
set -e

# So that i can call ghostty CLI on macOS.
if [ "$(uname)" == "Darwin" ]; then
	ln -sf /Applications/Ghostty.app/Contents/MacOS/ghostty /usr/local/bin/ghostty
fi
