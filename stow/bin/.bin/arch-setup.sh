#!/usr/bin/env bash
# Arch Linux first-run setup (Stage-1 management base, single host, no Nix).
# Idempotent: safe to re-run. Order: pacman -> AUR fallback note -> mise -> just bootstrap.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# Script lives at stow/bin/.bin/ -> repo root is three levels up.
DOTDIR="$(cd "${SCRIPT_DIR}/../../.." && pwd -P)"
MANIFEST="${DOTDIR}/packages/pacman.txt"

# 1. pacman: install curated manifest (skips already-installed via --needed).
# pacman reads stdin targets line-by-line verbatim — no comment handling —
# so '#' lines and inline notes in pacman.txt would become package names and
# abort the run with "target not found". Strip them first (same filter as
# `just pkg-diff`'s manifest()).
if [[ -f "${MANIFEST}" ]]; then
  sed 's/[[:space:]]*#.*//; /^[[:space:]]*$/d' "${MANIFEST}" | sudo pacman -S --needed --noconfirm -
else
  echo "missing manifest: ${MANIFEST}" >&2
  exit 1
fi

# 2. AUR fallback note: if a package is not in the official repos
# (e.g. an AUR-only helper such as paru/yay already on this host),
# install it manually with the AUR helper instead of editing this script.
# Example: paru -S --needed <pkg>   (no automation here by design)
command -v paru >/dev/null 2>&1 && echo "AUR helper available: paru" || echo "NOTE: no AUR helper found; see comment above for manual fallback"

# 3. mise: trust repo config and install pinned tools (see mise.toml).
if command -v mise >/dev/null 2>&1; then
  (cd "${DOTDIR}" && mise trust && mise install)
else
  echo "mise not found after pacman step; install it, then run: (cd ${DOTDIR} && mise trust && mise install)" >&2
  exit 1
fi

# 4. just: hand off to the management entry point.
if command -v just >/dev/null 2>&1; then
  (cd "${DOTDIR}" && just bootstrap)
else
  echo "just not found after pacman step; install it, then run: just bootstrap" >&2
  exit 1
fi

# 5. zsh setup (idempotent): powerlevel10k theme, skipped if already present.
if [[ ! -d "${HOME}/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/powerlevel10k"
else
  echo "powerlevel10k already present, skipping clone"
fi
