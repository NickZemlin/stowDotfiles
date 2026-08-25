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
```

## Requirements

- GNU Stow

## Install

```sh
cd ~/dotfiles && ./install.sh
```

This symlinks `~/.config/{nvim,yazi,tmux,fastfetch,ghostty}` to the corresponding
directories here. Re-running is safe (idempotent).

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
