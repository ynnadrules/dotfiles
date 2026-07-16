# Requires asdf; skip quietly if it isn't installed yet
if ! command -v asdf >/dev/null 2>&1
then
  echo "asdf not found; skipping Ruby install"
  exit 0
fi

# Add the ruby plugin (idempotent guard in case the script is re-run)
if ! asdf plugin list 2>/dev/null | grep -qx ruby
then
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
fi

# Install the latest stable Ruby and set it as the global default
ruby_version=$(asdf latest ruby)
echo "Installing Ruby $ruby_version via asdf"
asdf install ruby "$ruby_version"
asdf set --home ruby "$ruby_version"

exit 0
