# .config inventory (read-only survey)

> Historical note (2026-10-07): the source dir `dotfiles/.config/` was a
> leftover from the whole-dir symlink era (all entries REJECT/GUI state,
> gitignored). It was retired to `~/.dotbackup/2026-10-07-legacy-dotconfig/`.
> `~/.config` is a real dir now; only nvim + ghostty are stow-linked.

- Source: `/home/sasnews/dotfiles/.config/` (enumerated with `ls -1`, no moves/deletes)
- Context: `~/.config` is a whole-dir symlink to the repo path above, so GUI cache/state is mixed in and hard to distinguish (survey purpose)
- Observed rows: 62 data rows below (61 entries from `ls -1` + 1 tmux future placeholder not present on disk)
- Verification note: uppercase keep/reject tokens appear ONLY in the table body below, so `grep -c -E 'KEEP|REJECT' docs/config-inventory.md` should return 62 (3 keep + 59 reject). Prose in this file uses lowercase on purpose.

## Verdict table (every top-level entry)

| Entry | Absolute path | Verdict | Reason (one line) |
|---|---|---|---|
| Arduino IDE | /home/sasnews/dotfiles/.config/Arduino IDE | REJECT | GUI IDE state/cache, machine-local, out of scope |
| Code | /home/sasnews/dotfiles/.config/Code | REJECT | VS Code GUI state/extensions cache, machine-local |
| Code - OSS | /home/sasnews/dotfiles/.config/Code - OSS | REJECT | VS Code OSS variant GUI state, machine-local |
| Codex | /home/sasnews/dotfiles/.config/Codex | REJECT | Tool state, out of declared keep scope |
| Electron | /home/sasnews/dotfiles/.config/Electron | REJECT | Electron framework cache, not user config |
| FreeCAD | /home/sasnews/dotfiles/.config/FreeCAD | REJECT | GUI CAD app state, machine-local |
| GIMP | /home/sasnews/dotfiles/.config/GIMP | REJECT | GUI image-editor state, machine-local |
| Kiro | /home/sasnews/dotfiles/.config/Kiro | REJECT | GUI/mercantile tool state, out of scope |
| PrusaSlicer | /home/sasnews/dotfiles/.config/PrusaSlicer | REJECT | 3D-printer slicer profiles/cache, machine-local |
| QtProject.conf | /home/sasnews/dotfiles/.config/QtProject.conf | REJECT | Qt GUI toolkit generated conf, machine-local |
| Raspberry Pi | /home/sasnews/dotfiles/.config/Raspberry Pi | REJECT | Hardware-vendor tool state, machine-local |
| arduino-ide | /home/sasnews/dotfiles/.config/arduino-ide | REJECT | Arduino IDE state (lowercase twin), machine-local |
| astro | /home/sasnews/dotfiles/.config/astro | REJECT | Tool cache/state, out of declared keep scope |
| autostart | /home/sasnews/dotfiles/.config/autostart | REJECT | Desktop autostart entries, host-specific |
| blender | /home/sasnews/dotfiles/.config/blender | REJECT | GUI 3D app state/cache, machine-local |
| btop | /home/sasnews/dotfiles/.config/btop | REJECT | Monitor tool state, out of declared keep scope |
| burn-my-windows | /home/sasnews/dotfiles/.config/burn-my-windows | REJECT | GNOME extension state, desktop-specific |
| configstore | /home/sasnews/dotfiles/.config/configstore | REJECT | Generic npm-style configstore cache, not curated |
| connections.db | /home/sasnews/dotfiles/.config/connections.db | REJECT | Connection database/state file, machine-local secret-adjacent |
| cool-retro-term | /home/sasnews/dotfiles/.config/cool-retro-term | REJECT | Novelty terminal GUI state, out of scope |
| dconf | /home/sasnews/dotfiles/.config/dconf | REJECT | GNOME binary settings db, host-specific |
| evolution | /home/sasnews/dotfiles/.config/evolution | REJECT | Mail client state, machine-local |
| fcitx | /home/sasnews/dotfiles/.config/fcitx | REJECT | Input-method state, host-specific |
| fcitx5 | /home/sasnews/dotfiles/.config/fcitx5 | REJECT | Input-method state (v5), host-specific |
| filezilla | /home/sasnews/dotfiles/.config/filezilla | REJECT | FTP client sites/queue state, machine-local |
| fish | /home/sasnews/dotfiles/.config/fish | REJECT | Shell config but out of declared keep scope for T4 |
| freerdp | /home/sasnews/dotfiles/.config/freerdp | REJECT | RDP client certs/cache, machine-local |
| gh | /home/sasnews/dotfiles/.config/gh | REJECT | GitHub CLI hosts/token-adjacent state, out of keep scope |
| ghostty | /home/sasnews/dotfiles/.config/ghostty | KEEP | Curated terminal config, stow candidate |
| gnome-session | /home/sasnews/dotfiles/.config/gnome-session | REJECT | GNOME session state, desktop-specific |
| gnome-xdg-terminals.list | /home/sasnews/dotfiles/.config/gnome-xdg-terminals.list | REJECT | GNOME-generated list, not curated |
| go | /home/sasnews/dotfiles/.config/go | REJECT | Go toolchain env/cache, out of keep scope |
| goa-1.0 | /home/sasnews/dotfiles/.config/goa-1.0 | REJECT | GNOME online-accounts state, host-specific |
| google-chrome | /home/sasnews/dotfiles/.config/google-chrome | REJECT | Browser profile/cache, must never be stowed |
| gtk-3.0 | /home/sasnews/dotfiles/.config/gtk-3.0 | REJECT | GTK theme generated conf, desktop-specific |
| gtk-4.0 | /home/sasnews/dotfiles/.config/gtk-4.0 | REJECT | GTK theme generated conf, desktop-specific |
| htop | /home/sasnews/dotfiles/.config/htop | REJECT | Monitor tool state, out of keep scope |
| ibus | /home/sasnews/dotfiles/.config/ibus | REJECT | Input-method bus state, host-specific |
| libreoffice | /home/sasnews/dotfiles/.config/libreoffice | REJECT | Office suite GUI state, machine-local |
| matplotlib | /home/sasnews/dotfiles/.config/matplotlib | REJECT | Plot lib cache/fonts, generated |
| mimeapps.list | /home/sasnews/dotfiles/.config/mimeapps.list | REJECT | XDG generated default-apps list, host-specific |
| monitors.xml | /home/sasnews/dotfiles/.config/monitors.xml | REJECT | GNOME display layout, host-specific |
| monitors.xml~ | /home/sasnews/dotfiles/.config/monitors.xml~ | REJECT | Backup of generated display layout, host-specific |
| mozc | /home/sasnews/dotfiles/.config/mozc | REJECT | Japanese IME state, host-specific |
| nautilus | /home/sasnews/dotfiles/.config/nautilus | REJECT | File-manager GUI state, desktop-specific |
| nvim | /home/sasnews/dotfiles/.config/nvim | KEEP | Curated editor config, stow candidate |
| obs-studio | /home/sasnews/dotfiles/.config/obs-studio | REJECT | Streaming app scenes/profiles, machine-local |
| opencode | /home/sasnews/dotfiles/.config/opencode | REJECT | Tool state, out of declared keep scope for T4 |
| pulse | /home/sasnews/dotfiles/.config/pulse | REJECT | Audio daemon state, host-specific |
| remmina | /home/sasnews/dotfiles/.config/remmina | REJECT | Remote-desktop profiles, machine-local secret-adjacent |
| simple-scan | /home/sasnews/dotfiles/.config/simple-scan | REJECT | Scanner app state, machine-local |
| systemd | /home/sasnews/dotfiles/.config/systemd | REJECT | User systemd units, host-specific |
| totem | /home/sasnews/dotfiles/.config/totem | REJECT | Video player GUI state, desktop-specific |
| user-dirs.dirs | /home/sasnews/dotfiles/.config/user-dirs.dirs | REJECT | XDG generated user-dirs, host-specific |
| user-dirs.locale | /home/sasnews/dotfiles/.config/user-dirs.locale | REJECT | XDG generated locale marker, host-specific |
| uv | /home/sasnews/dotfiles/.config/uv | REJECT | Python package-manager cache, out of keep scope |
| vlc | /home/sasnews/dotfiles/.config/vlc | REJECT | Media player GUI state, machine-local |
| xdg-terminals.list | /home/sasnews/dotfiles/.config/xdg-terminals.list | REJECT | XDG generated list, not curated |
| xr_driver | /home/sasnews/dotfiles/.config/xr_driver | REJECT | XR hardware driver state, machine-local |
| yay | /home/sasnews/dotfiles/.config/yay | REJECT | AUR helper cache, host-specific |
| yelp | /home/sasnews/dotfiles/.config/yelp | REJECT | Help viewer GUI state, desktop-specific |
| tmux (future placeholder, not on disk) | ~/.config/tmux or ~/.tmux.conf (to be created) | KEEP | Reserved terminal-multiplexer slot for stow plan |

## Stow-package mapping proposal (for follow-up, no changes made here)

- `stow/nvim/.config/nvim` <- `/home/sasnews/dotfiles/.config/nvim` (keep, highest priority)
- `stow/ghostty/.config/ghostty` <- `/home/sasnews/dotfiles/.config/ghostty` (keep)
- `stow/tmux/.config/tmux` (or home-level `.tmux.conf`) <- placeholder, to be created in later step
- everything else: do not create stow packages; leave under whole-dir symlink until migration unlinks it

## Notes

- No files were moved, deleted, or edited outside this inventory file; no ignore or layout changes made.
- `ls -1` showed 61 on-disk entries; plus the tmux placeholder this file lists 62 rows for the follow-up scope.
- Follow-up blocker cleared: the curated subset is exactly nvim + ghostty (+ tmux placeholder).
