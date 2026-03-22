#!/bin/zsh
set -xeuo pipefail

if ! command -v mcp-proxy >/dev/null 2>&1; then
  echo "Installing latest stable mcp-proxy"
  # Create temp dir
  TMP_DIR=$(mktemp -d)

  # Define destination
  DEST_DIR="$HOME/.tidewave/bin"
  mkdir -p "$DEST_DIR"

  # Download and extract into temp dir
  curl -sL https://github.com/tidewave-ai/mcp_proxy_rust/releases/latest/download/mcp-proxy-aarch64-apple-darwin.tar.gz | tar -xz -C "$TMP_DIR"

  # Move binary to destination (overwrite if exists)
  # Assuming the binary is named 'mcp-proxy'
  mv -f "$TMP_DIR/mcp-proxy" "$DEST_DIR/"

  # Clean up
  rm -rf "$TMP_DIR"

  echo "Installed mcp-proxy to $DEST_DIR"
else
  echo "mcp-proxy already exists in PATH. Skipping installation."
fi
