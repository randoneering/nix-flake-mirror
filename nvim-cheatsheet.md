# Neovim Cheat Sheet for Beginners

## Quick Mental Model

| Mode | What it does | How to enter it |
|---|---|---|
| Normal | move around, edit, copy, delete, paste | `Esc` |
| Insert | type text | `i`, `a`, `o` |
| Visual | select text | `v`, `V`, `Ctrl-v` |
| Command | save, quit, open files | `:` |

## Open, Save, Quit

| Keys | Action |
|---|---|
| `nvim file.txt` | open a file from the terminal |
| `:e file.txt` | open or switch to a file |
| `:w` | save |
| `:q` | quit |
| `:wq` | save and quit |
| `ZZ` | save and quit |
| `:q!` | quit without saving |

## Move Around

| Keys | Action |
|---|---|
| `h j k l` | left, down, up, right |
| `w` / `b` | next / previous word |
| `0` / `$` | start / end of line |
| `gg` / `G` | top / bottom of file |
| `Ctrl-d` / `Ctrl-u` | half page down / up |
| `:10` | jump to line 10 |

## Insert and Edit Text

| Keys | Action |
|---|---|
| `i` / `a` | insert before / after cursor |
| `I` / `A` | insert at start / end of line |
| `o` / `O` | new line below / above |
| `x` | delete character |
| `r` + key | replace one character |
| `cw` | change word |
| `dd` | delete current line |

## Copy, Paste, Delete

| Keys | Action |
|---|---|
| `yy` | copy (yank) line |
| `p` / `P` | paste after / before |
| `dd` | cut line |
| `dw` | cut word from cursor |
| `D` | cut to end of line |
| `u` | undo |
| `Ctrl-r` | redo |

## Select Text

| Keys | Action |
|---|---|
| `v` | start visual selection |
| `V` | select whole lines |
| `Ctrl-v` | block selection |
| `v` then `y` | select and copy |
| `v` then `d` | select and cut |

## Search

| Keys | Action |
|---|---|
| `/text` | search forward |
| `?text` | search backward |
| `n` / `N` | next / previous match |
| `:%s/old/new/g` | replace all in file |

## Useful Basics

| Keys | Action |
|---|---|
| `Esc` | get back to normal mode |
| `.` | repeat last change |
| `J` | join line with next line |
| `:help keyword` | open help |
| `:set number` | show line numbers |
| `:set nonumber` | hide line numbers |

## First Things to Remember

- If you are stuck, press `Esc`.
- If you want to type, press `i` first.
- If you want to save, use `:w`.
- If you want to quit, use `:q`.
- If Neovim will not let you quit, use `:q!` to leave without saving.
