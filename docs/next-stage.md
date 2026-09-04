# Stage-2 plan (bridge stubs, inert — T9)

Status: Planned, NOT activated. Stage-1 boot unchanged.
Depends on: T4 only. Blocks: T8 verification.
Host context: Nvim 0.12.5 / zsh 5.9.2 / Ghostty truecolor / 0xProto present.

All Stage-2 items below are LIST ONLY. Stubs are commented/guarded and
must not change `zsh -i -c true` or `nvim --headless +qa` behavior.

## zsh — sheldon / fzf (list only)

- `sheldon` plugin manager (NOT activated)
- `fzf` fuzzy finder (NOT activated)
- `starship` prompt (NOT activated)
- Stub: `stow/zsh/.zshrc` tail has guarded no-op block:
  `command -v sheldon` guard with the `eval "$(sheldon source)"` line
  kept commented + `true` no-op.

## nvim — lazy-split / LSP / treesitter / lualine / colorscheme (list only)

- Current: `stow/nvim/.config/nvim/init.lua` (30 lines: lazy + noice + lexima)
- Stage-2: split `init.lua` into `lua/` modules (NOT activated)
- List only: LSP, treesitter, lualine, colorscheme
- Stub: `stow/nvim/.config/nvim/lua/stage2_bridge.lua` is a comment-only
  skeleton; `init.lua` still loads standalone (tail note only, no `require`).

## tmux — TPM / catppuccin / truecolor (list only)

- `TPM` plugin manager (NOT installed / NOT activated)
- `catppuccin/tmux` theme, flavour `mocha` (list only)
- truecolor passthrough (`tmux-256color`, `terminal-overrides`) (list only)
- Stub: `stow/tmux/.tmux.conf` is fully commented; `run '~/.tmux/plugins/tpm/tpm'`
  stays commented until Stage-2.

## ghostty — font materials (note only)

- Host: Ghostty truecolor, 0xProto present
- Stage-2 pin (NOT activated, note in `stow/ghostty/.config/ghostty/config`):
  `font-family = 0xProto Nerd Font Mono` (commented)

## Verification (Stage-1 boot unchanged)

```sh
zsh -i -c true && echo ZSH_OK
nvim --headless +qa && echo NVIM_OK
grep -c -E 'sheldon|stage2_bridge|TPM|0xProto' docs/next-stage.md stow/zsh/.zshrc stow/nvim/.config/nvim/init.lua stow/nvim/.config/nvim/lua/stage2_bridge.lua stow/tmux/.tmux.conf stow/ghostty/.config/ghostty/config
```

Expected: both smoke tests pass; grep count > 0 (bridge notes present,
all inert).
