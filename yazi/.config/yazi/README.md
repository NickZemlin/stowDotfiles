# YaziConfig

Personal Yazi setup with a Tokyo Night theme and vim-style relative motions.

## Theme

- Flavor: `tokyonight` (Tokyo Night "night" palette, matching the Neovim `tokyonight-night` colorscheme).
- Selected in `theme.toml` via `[flavor] dark = "tokyonight"`; the flavor lives in `flavors/tokyonight.yazi/`.
- Code preview highlighting uses `flavors/tokyonight.yazi/tmtheme.xml`.

## Plugins

### relative-motions

Vim-style motions (`3j`, `12k`, `10gg`, ...). Keys `1`–`9` start a relative
motion (they previously switched tabs), so switch tabs with `gt` (e.g. `2gt` =
tab 2). Options are configured in `init.lua` (relative line numbers +
status-bar motion indicator). See the
[plugin README](https://github.com/dedukun/relative-motions.yazi) for the full
motion list.

The plugin is **vendored** at `plugins/relative-motions.yazi/` and patched for
Yazi 26: upstream (`dedukun/relative-motions.yazi`) still calls the removed
`ya.mgr_emit`, so the local copy uses `ya.emit` instead (see upstream issue
[#32](https://github.com/dedukun/relative-motions.yazi/pull/32)). No
installation step is needed — just pull this repo.

> For other plugins, you can manage them declaratively via `package.toml` and
> `ya pkg add` / `ya pkg install` (use the full `/opt/homebrew/bin/ya` if `ya`
> is aliased to something else). `plugins/*` is git-ignored except for the
> vendored `relative-motions.yazi/`.

## Image preview

Image preview requires the Kitty graphics protocol to pass through tmux (this
setup runs Ghostty → tmux → yazi). The relevant settings live in
`~/.config/tmux/tmux.conf`:

```tmux
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

Without `allow-passthrough on`, images render ~2x too large (only the top-left
quarter is visible). `allow-passthrough` applies immediately on
`tmux source-file`; the `update-environment` lines need a tmux re-attach.

## PDF preview

PDF preview uses Yazi's built-in `pdf` previewer, which rasterizes pages with
`pdftoppm` (Poppler). Poppler must be installed on the machine:

```sh
brew install poppler
```

Without `pdftoppm`, PDFs fail to preview (`Failed to start pdftoppm`).
