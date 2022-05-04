# Katcros - Fennel Macros by Kat

This is a collection of macros intended to the functionality of various Neovim related Fennel needs. Neovim based macros are found in `macros/nvim`, with the rest of the macro groups being self explanatory.

# Macros

## nvim.api
These macros deal with interfacing with Neovim directly. They are split up accordingly

### maps
Handles key maps, attempts to mimic the simplicity of Vimscript's syntax. These all function similarly. There are 4 ways for a map macro to expand to depending on the arguments used. A left-hand-side and right-hand-side argument are always needed, but a description and options table is optional, with the options table always being last.

#### Syntax
```fennel
; options table, no description
(map-macro lhs rhs {opts value})
; expansion
(vim.keymap.set :mode lhs rhs {opts value})

; description and options table
(map-macro lhs rhs "Map description" {opts value})
; expansion
(vim.keymap.set :mode lhs rhs {opts value :desc "Map description"})

; description, no options table
(map-macro lhs rhs "Map description")
; expansion
(vim.keymap.set :mode lhs rhs {:desc "Map description"})

; no other arguments
(map-macro lhs rhs)
; expansion
(vim.keymap.set :mode lhs rhs)
```

Note that the mode is not explicitly set by an argument. This is to mimic Vimscript further.

#### Maps Macro List

| Macro | Mode | NoRemap |
| ----- | ---- | ------- |
|`nno-` | Normal | `true` |
|`ino-` | Insert | `true` |
|`vno-` | Visual | `true` |
|`tno-` | Terminal | `true` |
|`cno-` | Command-line | `true` |
|`ono-` | Operator | `true` |
|`nm-` | Normal | `false` |
|`im-` | Insert | `false` |
|`vm-` | Visual | `false` |
|`tm-` | Terminal | `false` |
|`cm-` | Command-line | `false` |
|`om-` | Operator | `false` |
|`nomap-` | Multiple | `true` |
|`map-` | Multiple | `false` |

`map-` and `nomap-` take a sequential table of character strings for the corresponding mode. This allows you to map across multiple modes, and are the only macros in which the mode is required.

#### Examples
```fennel
; macro forms
(nomap- [:n :v] ";" ":" "Swap char search and command-line enter")
(nomap- [:n :v] ":" ";" "Swap command-line enter and char search")

(nno- :<leader>r :<C-l> "Return <C-l> functionality")

(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(nno- :<leader>f (fn [] (files)) "Open FZF file window" {:silent true})

; expanded forms
(vim.keymap.set [:n :v] ";" ":" {:desc "Swap char search and command-line enter"})
(vim.keymap.set [:n :v] ":" ";" {:desc "Swap command-line enter and char search "})

(vim.keymap.set :n :<leader>r :<C-l> {:desc "Return <C-l> functionality"})

(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(vim.keymap.set :n :<leader>f (fn [] (files)) {:silent true :desc "Open FZF file window"})
```

# Usage
These macros are primarily meant for Neovim, but can be used for anything if needed.

## Using with Aniseed Directly

[Aniseed](https://github.com/Olical/aniseed)

If making Aniseed plugins, git subtree management is handled mostly fine for you already. See an example Makefile below:
```makefile
.PHONY: deps compile test

default: deps compile test

deps:
	deps/aniseed/scripts/dep.sh Olical aniseed origin/master
	deps/aniseed/scripts/dep.sh katawful katcros-fnl origin/main

compile:
	rm -rf lua
	# Remove this if you only want Aniseed at compile time.
	# deps/aniseed/scripts/embed.sh aniseed test-fennel
	deps/aniseed/scripts/embed.sh katcros-fnl test-fennel
	# move compile.sh below embed.sh
	deps/aniseed/scripts/compile.sh

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
```
Note that `compile.sh` is now moved below `embed.sh`. This is not the default behavior. If you use the default assumption, Aniseed will be unable to compile with the loaded macros despite [Conjure](https://github.com/Olical/conjure) working. The macros will inject themselves into your plugin repo under `deps/` like aniseed.

The path for this method is: `your-plugin.katcros-fnl.macro-path`.

## This Repo as a Neovim Package
If using these macros, say for Neovim configs or a standalone Fennel project (through Hotpot or Tangerine), simply add this repo to your package manager. This will allow access to these macros globally without requiring integration into your project directly. This method is not suggested for plugins as macros can become out of sync, whereas a git subtree only updates whenever the plugin is updated by you.

The path for this method is: `katcros-fnl.macro-path`.

## This Repo as a Subtree
This is the preferred method for any Fennel project. Currently I do not have any scripts that manage this, you will have to manage and update them for you. See Aniseed's scripts for suggestions.

The path for this method depends on the implementation.

# Make
While these are just macros, some use cases may require having the macros available in the equivalent `lua/` folder. `make` requires `rsync` to achieve this.

# License
This is currently not licensed on purpose as I explore ways to distribute these macros for projects. This comes with all the risks of non-licensed copyright code: https://choosealicense.com/no-permission/
