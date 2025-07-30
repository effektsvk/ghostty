#!/bin/bash

# This script downloads, extracts, and installs Zig for the current user.
# It installs the binary to ~/.local/bin and libraries to ~/.local/lib.

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
URL="https://s3.pl-waw.scw.cloud/effektsvk-dropshare/zig-x86_64-linux-0.15.0-dev.1274-147a85280.xz"
INSTALL_DIR_BIN="$HOME/.local/bin"
INSTALL_DIR_LIB_BASE="$HOME/.local/lib"
INSTALL_DIR_LIB_ZIG="$INSTALL_DIR_LIB_BASE/zig"

# --- Helper Functions ---
# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Main Script ---
echo "Starting Zig installation..."

# 1. Check for required tools
echo "Checking for required tools (wget, tar)..."
if ! command_exists wget; then
  echo "Error: wget is not installed. Please install it and try again."
  exit 1
fi
if ! command_exists tar; then
  echo "Error: tar is not installed. Please install it and try again."
  exit 1
fi
echo "Dependencies found."

# 2. Download the Zig archive
FILENAME=$(basename "$URL")
echo "Downloading Zig from $URL..."
wget --progress=bar -O "$FILENAME" "$URL"

# 3. Extract the archive
echo "Extracting $FILENAME..."
# Get the directory name that will be created after extraction
EXTRACTED_DIR=$(tar -tf "$FILENAME" | head -1 | cut -f1 -d"/")
tar -xf "$FILENAME"
echo "Extraction complete. Files are in './$EXTRACTED_DIR'"

# 4. Create installation directories
echo "Creating installation directories if they don't exist..."
mkdir -p "$INSTALL_DIR_BIN"
mkdir -p "$INSTALL_DIR_LIB_BASE"

# 5. Install Zig
echo "Installing Zig to $INSTALL_DIR_BIN and $INSTALL_DIR_LIB_ZIG..."
# Move the zig executable
mv "$EXTRACTED_DIR/zig" "$INSTALL_DIR_BIN/"
# Move the lib directory
mv "$EXTRACTED_DIR/lib" "$INSTALL_DIR_LIB_ZIG"
echo "Installation successful."

# 6. Clean up
echo "Cleaning up downloaded and temporary files..."
rm "$FILENAME"
rm -r "$EXTRACTED_DIR"
echo "Cleanup complete."

# 7. Post-installation instructions
echo ""
echo "----------------------------------------------------------------"
echo "✅ Zig has been installed successfully!"
echo ""
echo "❗️ IMPORTANT: To complete the installation, you must add"
echo "   '$INSTALL_DIR_BIN' to your shell's PATH."
echo ""
echo "Run the following command to add it to your .bashrc file:"
echo ""
echo "   echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
echo ""
echo "Afterward, restart your shell or run 'source ~/.bashrc' for the"
echo "changes to take effect."
echo ""
echo "You can then verify the installation by running:"
echo "   zig version"
echo "----------------------------------------------------------------"
