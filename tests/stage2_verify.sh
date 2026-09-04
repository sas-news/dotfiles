#!/bin/sh
# Stage-2 TDD harness (T0) — red pre-fix.
# Blocks final gate T5. POSIX sh. No stow, no HOME writes.
# Every result line is prefixed: STG2-<id> PASS|FAIL
# Exits 0 only when ALL checks pass; non-zero otherwise.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ZSHRC="$REPO_DIR/stow/zsh/.zshrc"
TMUXCONF="$REPO_DIR/stow/tmux/.tmux.conf"
FAIL=0

report() {
  # $1 = id (e.g. S1-ZSH), $2 = PASS|FAIL, $3... = detail
  id="$1"; shift
  res="$1"; shift
  echo "STG2-$id $res $*"
  if [ "$res" = "FAIL" ]; then
    FAIL=$((FAIL + 1))
  fi
}

# --- helper: active (non-comment) match in file ---
# $1 = file, $2 = extended-ish basic regex matched on non-comment lines
active_match() {
  f="$1"; pat="$2"
  [ -f "$f" ] || return 1
  grep -v '^[[:space:]]*#' "$f" | grep -q "$pat"
}

# STG2-S1-ZSH: HISTFILE must be XDG (active, uncommented, mentions XDG)
if active_match "$ZSHRC" 'HISTFILE=.*XDG'; then
  report "S1-ZSH" "PASS" "HISTFILE XDG active"
else
  report "S1-ZSH" "FAIL" "HISTFILE XDG missing (want active HISTFILE=.*XDG in stow/zsh/.zshrc)"
fi

# STG2-S1-TMUX: active tmux lines for default-terminal, Tc, mouse, tpm, mocha
_TMUX_OK=1
_TMUX_MISSING=""
for _pat in 'default-terminal' 'Tc' 'mouse' 'tpm' 'mocha'; do
  if ! active_match "$TMUXCONF" "$_pat"; then
    _TMUX_OK=0
    _TMUX_MISSING="$_TMUX_MISSING $_pat"
  fi
done
if [ "$_TMUX_OK" -eq 1 ]; then
  report "S1-TMUX" "PASS" "tmux default-terminal/Tc/mouse/tpm/mocha active"
else
  report "S1-TMUX" "FAIL" "tmux conf all-comments or missing active:$_TMUX_MISSING"
fi

# STG2-S2-ZSH-GUARD: guarded sheldon/fzf/zoxide/eza (command -v guard + active use)
_ZGUARD_OK=1
_ZGUARD_MISSING=""
# sheldon: guard + active eval "$(sheldon source)"
if active_match "$ZSHRC" 'command -v sheldon' && active_match "$ZSHRC" 'sheldon source'; then
  :
else
  _ZGUARD_OK=0; _ZGUARD_MISSING="$_ZGUARD_MISSING sheldon"
fi
# fzf: guard or active source/init
if active_match "$ZSHRC" 'command -v fzf' || active_match "$ZSHRC" 'fzf'; then
  :
else
  _ZGUARD_OK=0; _ZGUARD_MISSING="$_ZGUARD_MISSING fzf"
fi
# zoxide: guard or init
if active_match "$ZSHRC" 'command -v zoxide' || active_match "$ZSHRC" 'zoxide init'; then
  :
else
  _ZGUARD_OK=0; _ZGUARD_MISSING="$_ZGUARD_MISSING zoxide"
fi
# eza: guard or active use/alias
if active_match "$ZSHRC" 'command -v eza' || active_match "$ZSHRC" 'eza'; then
  :
else
  _ZGUARD_OK=0; _ZGUARD_MISSING="$_ZGUARD_MISSING eza"
fi
if [ "$_ZGUARD_OK" -eq 1 ]; then
  report "S2-ZSH-GUARD" "PASS" "guarded sheldon/fzf/zoxide/eza active"
else
  report "S2-ZSH-GUARD" "FAIL" "guarded lines missing/inert:$_ZGUARD_MISSING (sheldon block inert?)"
fi

# STG2-S2-TMUX-GUARD: TPM present + active bootstrap (uncommented run tpm)
_TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$_TPM_DIR" ] && active_match "$TMUXCONF" "tpm/tpm"; then
  report "S2-TMUX-GUARD" "PASS" "TPM present + bootstrap active"
else
  if [ ! -d "$_TPM_DIR" ]; then
    report "S2-TMUX-GUARD" "FAIL" "TPM absent ($_TPM_DIR missing) + bootstrap not active"
  else
    report "S2-TMUX-GUARD" "FAIL" "TPM bootstrap commented/absent in stow/tmux/.tmux.conf"
  fi
fi

# STG2-S3-P10K: p10k lines intact (instant-prompt + theme + .p10k.zsh)
_P10K_OK=1
active_match "$ZSHRC" 'p10k-instant-prompt' || _P10K_OK=0
active_match "$ZSHRC" 'powerlevel10k.zsh-theme' || _P10K_OK=0
active_match "$ZSHRC" '\.p10k\.zsh' || _P10K_OK=0
if [ "$_P10K_OK" -eq 1 ]; then
  report "S3-P10K" "PASS" "p10k lines intact"
else
  report "S3-P10K" "FAIL" "p10k lines missing (instant-prompt/theme/.p10k.zsh)"
fi

# STG2-S3-NVIM: config exists + nvim headless exit 0
_NVIM_CFG=""
for _c in "$REPO_DIR/stow/nvim/.config/nvim/init.lua" \
         "$REPO_DIR/stow/nvim/.config/nvim/init.vim" \
         "$REPO_DIR/packages/nvim/.config/nvim/init.lua" \
         "$REPO_DIR/.config/nvim/init.lua"; do
  if [ -f "$_c" ]; then _NVIM_CFG="$_c"; break; fi
done
if [ -z "$_NVIM_CFG" ]; then
  # fallback: any init.lua/init.vim under stow/packages/.config
  _FOUND=""
  if command -v find >/dev/null 2>&1; then
    _FOUND="$(find "$REPO_DIR/stow" "$REPO_DIR/packages" "$REPO_DIR/.config" \
      \( -name 'init.lua' -o -name 'init.vim' \) 2>/dev/null | head -n 1)"
  fi
  [ -n "$_FOUND" ] && _NVIM_CFG="$_FOUND"
fi
if [ -n "$_NVIM_CFG" ] && command -v nvim >/dev/null 2>&1 && nvim --headless -c 'qa' >/dev/null 2>&1; then
  report "S3-NVIM" "PASS" "nvim headless exit 0 ($_NVIM_CFG)"
else
  if [ -z "$_NVIM_CFG" ]; then
    report "S3-NVIM" "FAIL" "nvim config missing (no init.lua/init.vim) and/or headless check failed"
  elif ! command -v nvim >/dev/null 2>&1; then
    report "S3-NVIM" "FAIL" "nvim binary missing (config at $_NVIM_CFG)"
  else
    report "S3-NVIM" "FAIL" "nvim headless exit non-zero (config at $_NVIM_CFG)"
  fi
fi

# STG2-S3-GHOSTTY: 0xProto pin present (comment-only OK — ghostty out of Stage-2 scope; S3 asserts unchanged)
_GHOSTTY_CFG=""
for _g in "$REPO_DIR/stow/ghostty/.config/ghostty/config" \
         "$REPO_DIR/packages/ghostty/.config/ghostty/config" \
         "$REPO_DIR/.config/ghostty/config"; do
  if [ -f "$_g" ]; then _GHOSTTY_CFG="$_g"; break; fi
done
if [ -z "$_GHOSTTY_CFG" ] && command -v find >/dev/null 2>&1; then
  _GF="$(find "$REPO_DIR/stow" "$REPO_DIR/packages" "$REPO_DIR/.config" \
    -path '*ghostty*config' 2>/dev/null | head -n 1)"
  [ -n "$_GF" ] && _GHOSTTY_CFG="$_GF"
fi
if [ -n "$_GHOSTTY_CFG" ] && grep -q '0xProto' "$_GHOSTTY_CFG"; then
  report "S3-GHOSTTY" "PASS" "ghostty 0xProto pin present ($_GHOSTTY_CFG)"
else
  if [ -z "$_GHOSTTY_CFG" ]; then
    report "S3-GHOSTTY" "FAIL" "ghostty config missing (want active 0xProto font line)"
  else
    report "S3-GHOSTTY" "FAIL" "ghostty 0xProto comment-only/missing in $_GHOSTTY_CFG"
  fi
fi

if [ "$FAIL" -ne 0 ]; then
  echo "STG2-SUMMARY FAIL $FAIL check(s) failed"
  exit 1
else
  echo "STG2-SUMMARY PASS all checks passed"
  exit 0
fi
