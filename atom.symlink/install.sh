#!/bin/sh
if test "$(which apm)"; then
  apm upgrade --confirm false

  modules="
    atom-beautify
    atom-wrap-in-tag
    color-picker
    editorconfig
    file-icons
    go-plus
    go-rename
    language-diff
    language-docker
    language-puppet
    language-terraform
    linter
    linter-jshint
    linter-ruby
    sort-lines
    wakatime
  "
  for module in $modules; do
    apm list | grep -q "$module" || apm install "$module"
  done

  modules="
    metrics
    exception-reporting
  "
  for module in $modules; do
    apm list | grep -q "$module" || apm remove "$module"
  done
fi
