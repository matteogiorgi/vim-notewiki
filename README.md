# Vim-Notewiki

A lightweight [Vim](https://www.vim.org/) / [NeoVim](https://neovim.io/) plugin for keeping a personal wiki of Markdown notes, with one-command export to styled, self-contained HTML via [Pandoc](https://pandoc.org/).

Notes are plain Markdown files linked to each other like a wiki. `vim-notewiki` adds the navigation, link-creation and export commands on top; it also bundles [vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax) for Pandoc-flavored Markdown highlighting and a small Beamer syntax extension.




## Features

- **Wiki-style navigation** — jump between notes by following `[text](file.md)` links with a single keystroke, and jump back with a breadcrumb-style history per window.
- **Quick link creation** — turn the word under the cursor into a Markdown link to `word.md` in one command.
- **One-shot HTML export** — render the current note to a self-contained, portable HTML file with MathJax support and automatic `.md` $\to$ `.html` link rewriting, so exported notes link to each other correctly.
- **Pandoc-flavored Markdown syntax** — full syntax highlighting for Pandoc Markdown (definition lists, footnotes, citations, fenced code with embedded language highlighting, etc.), vendored from vim-pandoc-syntax.
- **Beamer note-taking helper** — a small syntax addition (`syntax/beamer.vim`) for slides-style notes.
- **File-manager integration** — open the current note's directory, or the whole wiki, in your favorite file browser.




## Requirements

- Vim 8+ or Neovim, with a plugin manager (or just clone into your runtime path).
- [Pandoc](https://pandoc.org/installing.html) for the HTML export feature.
- Python 3 with [panflute](https://github.com/sergiocorreia/panflute) (`pip install panflute`) — used by the link-rewriting filter during export.




## Installation

With [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'matteogiorgi/vim-notewiki'
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use 'matteogiorgi/vim-notewiki'
```

Then run the plugin manager's install command (`:PlugInstall`, `:PackerSync`, ...).

The plugin activates automatically on `filetype=markdown` buffers; there is nothing else to configure to get started.




## Getting started

On load, `vim-notewiki` makes sure `~/notewiki` exists — this is the root of your wiki. Open (or create) its index with:

```vim
:NoteWikiIndex
```

From there, write a link such as `[my first note](note.md)` and press `<CR>` on it to create and open `note.md` right next to the current file. Every note you write lives as a plain `.md` file, so the whole wiki is just a directory tree you can inspect, `grep`, or version-control with git.




## Key mappings

Mappings below are active in Markdown buffers (`ftplugin/markdown/notewiki.vim`) and are built on top of `<Plug>` mappings, so they are easy to remap.

| Mapping         | `<Plug>`               | Action                                                                         |
|-----------------|------------------------|--------------------------------------------------------------------------------|
| `<leader>n`     | `(NoteWiki)`           | Open the index note of the current directory                                   |
| `<leader>N`     | `(NoteBrowse)`         | Open the current note's directory in a file browser                            |
| `<leader>p`     | `(NotePandoc)`         | Export the current note to HTML                                                |
| `<CR>`          | `(OpenLink)`           | Follow the link under the cursor, or create one from the word under the cursor |
| `<BS>`          | `(Back)`               | Go back to the note you came from                                              |
| `<Tab>`         | `(NextLink)`           | Jump to the next link in the note                                              |
| `<S-Tab>`       | `(PrevLink)`           | Jump to the previous link in the note                                          |
| `\`             | `(EndPar)`             | Insert an HTML-comment paragraph break                                         |
| `-` / `_`       | —                      | `:HeaderIncrease` / `:HeaderDecrease` (promote/demote the heading level)       |
| `j` / `k`       | —                      | Move by display line (`gj`/`gk`), useful with `wrap`                           |

Global mappings (available everywhere, not just in notes):

| Mapping       | Command                | Action                               |
|---------------|------------------------|--------------------------------------|
| `<leader>n`   | `:NoteWikiIndex`       | Open `~/notewiki/index.md`           |
| `<leader>N`   | `:NoteBrowseIndex`     | Open `~/notewiki` in a file browser  |

Other commands:

| Command            | Action                                                    |
|--------------------|-----------------------------------------------------------|
| `:ScratchBuffer`   | Open a disposable, unsaved scratch buffer for quick notes |




## Exporting notes to HTML

Running `:NotePandoc` (or `<leader>p`) on a Markdown note:

1. Copies the bundled `pandoc/` assets (stylesheet, header, link filter) next to your note the first time it is exported, so each wiki sub-directory ends up self-contained and portable.
2. Runs Pandoc with MathJax support, the note's parent directory name as the page title, and the `link2html.py` filter, which rewrites `.md` links to `.html` so the exported pages keep linking to each other correctly.
3. Writes the result as `pandoc/<notename>.html` next to your note.

This is handled by the [`makenote`](https://github.com/matteogiorgi/vim-notewiki/blob/main/pandoc/assets/makenote) script:

```bash
pandoc "$currfile" -s --to=html5 -o "$pandoc/$1.html" \
    --mathjax \
    --filter="$pandoc/assets/link2html.py" \
    -H "$pandoc/assets/header.html" \
    -T "$prefixtail"
```




## Configuration

```vim
" Where your notes live (default: ~/notewiki)
let $wikipages = fnamemodify('~/notewiki', ':p')

" File browser used to open note directories (default: xdg-open)
let g:notebrowser = 'xdg-open'
```

`vim-pandoc-syntax` (vendored under [`syntax/pandoc.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/syntax/pandoc.vim)) is highly configurable — see [`doc/pandoc-syntax.txt`](https://github.com/matteogiorgi/vim-notewiki/blob/main/doc/pandoc-syntax.txt) or `:help pandoc-syntax` for the full list of `g:pandoc#syntax#*` options (conceal characters, embedded code-block highlighting per language, emphasis styles, and more).




## Project layout

- [`plugin/notewiki.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/plugin/notewiki.vim) — core commands, mappings and navigation logic
- [`plugin/pandoc.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/plugin/pandoc.vim) — `:NotePandoc` export command
- [`plugin/pandoc-syntax-check.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/plugin/pandoc-syntax-check.vim) — marks vim-pandoc-syntax as loaded
- [`ftplugin/markdown/notewiki.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/ftplugin/markdown/notewiki.vim) — buffer-local settings and key mappings
- [`syntax/pandoc.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/syntax/pandoc.vim) — Pandoc-flavored Markdown syntax (vim-pandoc-syntax)
- [`syntax/beamer.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/syntax/beamer.vim) — Beamer syntax extension
- [`autoload/pandoc/syntax/color.vim`](https://github.com/matteogiorgi/vim-notewiki/blob/main/autoload/pandoc/syntax/color.vim) — highlight-group color definitions
- [`doc/pandoc-syntax.txt`](https://github.com/matteogiorgi/vim-notewiki/blob/main/doc/pandoc-syntax.txt) — vim-pandoc-syntax help/reference
- [`pandoc/assets/makenote`](https://github.com/matteogiorgi/vim-notewiki/blob/main/pandoc/assets/makenote) — the Pandoc export script
- [`pandoc/assets/header.html`](https://github.com/matteogiorgi/vim-notewiki/blob/main/pandoc/assets/header.html) — HTML `<head>` injected into exported notes
- [`pandoc/assets/link2html.py`](https://github.com/matteogiorgi/vim-notewiki/blob/main/pandoc/assets/link2html.py) — Pandoc filter rewriting `.md` links to `.html`
