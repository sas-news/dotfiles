#!/usr/bin/env bash
# Deprecated shim (T4 stow migration): whole-dir linking retired.
# Packages now live under stow/{zsh,nvim,ghostty,git,bin}/ and are
# linked per-package with GNU Stow. Do not restore legacy behavior here.
set -u
command echo "deprecated: use: just bootstrap" >&2
exit 1

