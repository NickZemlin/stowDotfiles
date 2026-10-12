# dotfiles

Personal configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a Stow package mirroring `$HOME`, so `nvim/` holds
`nvim/.config/nvim/` and gets symlinked to `~/.config/nvim`.

## Layout

```
nvim/       Neovim config      (.config/nvim)
yazi/       Yazi config        (.config/yazi)
tmux/       tmux config        (.config/tmux)
fastfetch/  fastfetch config   (.config/fastfetch)
ghostty/    Ghostty config     (.config/ghostty)
hypr/       Hyprland config    (.config/hypr)
noctalia/   Noctalia v5 config (.config/noctalia/config.toml)
```

## Requirements

- GNU Stow

## Install

```sh
cd ~/dotfiles && ./install.sh
```

This links the packages into `~/.config/{nvim,yazi,tmux,fastfetch,ghostty,hypr,noctalia}`.
Re-running is safe (idempotent). Back up and move existing, non-Stow-managed
config files out of the way before installing; Stow will not overwrite them.

To unlink:

```sh
./install.sh -D
```

To relink a single package after editing:

```sh
stow -R --target="$HOME" <package>
```

## Notes

- `nvim/.config/nvim/init.lua` appends `/opt/homebrew/bin:/usr/local/bin` to
  `PATH` so tree-sitter can be found on macOS; this is harmless on Linux.
- `tmux` uses `caffeinate` (macOS-only); `bootstrap.sh` skips it on Linux via
  `command -v caffeinate`.
- `tmux/plugins/` and `yazi/plugins/` are gitignored and installed at runtime.
- `hypr` uses Hyprland's Lua configuration API. Monitor/device settings and paths
  are specific to this machine; review them before using on another host.
- `noctalia` tracks a merged v5 export in `config.toml`, including the current
  GUI settings, not legacy JSON settings, generated colors, or downloaded plugins.
  Future GUI changes are saved to `~/.local/state/noctalia/settings.toml` and
  override the tracked config. To capture them, run `noctalia config export merged`
  and save its output outside the Noctalia config directory before replacing
  `noctalia/.config/noctalia/config.toml` (do not redirect onto a loaded config file).
- Hyprland and Noctalia must be installed separately. The configs also reference
  external programs and local assets (including xremap config, avatar, and
  wallpapers); this installer only creates links.
