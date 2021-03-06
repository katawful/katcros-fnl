# Katcros - Fennel Macros by Kat

This is a collection of macros intended to the functionality of various Neovim related Fennel needs. Neovim based macros are found in `macros/nvim`, with the rest of the macro groups being self explanatory.

# Naming Conventions
Macros available are intended to keep with Fennel [style conventions](https://fennel-lang.org/style#names) as much as possible. The conventions should be understandable at a glance, but for clarity in the project they will be described here.

## Creation, Definition, Clearing, and Deletion
The Neovim API is generally very clear in its naming on what each API function acheives. `nvim_del` is for global deletion operations, `nvim_win_del` for window deletion operations, and so on. In order to maintain this level of explicit clarity, I have used a clear naming convention for each of these base operations:

| Convention | Operation | Description |
|---|---|---|
|`cre-` | create | For creation of objects, but not return of one |
|`def-` | definition | For definition of created objects, returns a value |
|`cle-` | clearing | For clearing of an object's values, but not deletion |
|`del-` | deletion | For deleting an object entirely |

```fennel
;; No returned value, cannot be manipulated by itself
(cre-auc :BufEnter :* (fn [] "Hello world") "BufEnter hello world")
;; Returns a value, can be manipulated with 'autocmd' variable
(local autocmd (def-auc :BufEnter :* (fn [] "Hello world") "BufEnter hello world")
;; Clear out all "BufEnter" autocommands
(cle-auc! {:event :BufEnter})
;; Delete 'autocmd' autocommand explicitly
(del-auc! autocmd)
```

Each convention prefix is meant to pronounced literally, for instance `cre-auc` is pronounced as "kree-awk".

## `!`
In Fennel's style guide, `!` as a suffix refers to file-system operations. I have extended this to imply state updates. `cle-` and `del-` are explicit updates of Neovim's state, and thus will always be suffixed by `!`. This character can be pronounced as "bang". `cle-auc!` would be pronounced as "kle-awk-bang".

## `-`
`-` as a suffix implies a shortening from Vim/Neovim functions. For instance, `nno-` would not be pronounced as 'en-en-oh', but as "normal mode remap" from `nnoremap`. The use of these is minimized where appropriate, and likely will be removed entirely from these macros at a future date.

## `<-`, `->`
In Fennel's style guide, `->` is used for conversion functions. For instance taking a string and making it into a sequential table would be `string->table`. `->` thus gets read as "to", making this function "string to table". This convention is used where appropriate.

Conversely, `<-` becomes "from", and implies a source to look from *or* a file to read from if it is a file system operation. A function to clear an autocommand specifically from a list of events would be `cle-auc<-event!`, which would be read as "kle-awk-from-event". This is generally used when one only wishes to do 1 level of search.

# Macros

## nvim.api
These macros deal with interfacing with Neovim directly. They are split up accordingly

### maps
Handles key maps, attempts to mimic the simplicity of Vimscript's syntax. These all function similarly. A left-hand-side and right-hand-side argument are always needed, but a description and options table is optional, with the options table always being last.

#### Syntax
```fennel
; options table, no description
(map-macro lhs rhs {:buffer true})
; expansion
(vim.keymap.set :mode lhs rhs {:buffer true})

; description and options table
(map-macro lhs rhs "Map description" {:buffer true})
; expansion
(vim.keymap.set :mode lhs rhs {:buffer true :desc "Map description"})

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
(vim.keymap.set [:n :v] ":" ";" {:desc "Swap command-line enter and char search"})

(vim.keymap.set :n :<leader>r :<C-l> {:desc "Return <C-l> functionality"})

(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(vim.keymap.set :n :<leader>f (fn [] (files)) {:silent true :desc "Open FZF file window"})
```

### utils
Handles various utilities that aren't associated with any specific grouping

#### `command-`
Creates a user command. Like the map macros, can take optional description and options table.

##### Syntax
```fennel
; no description or options table
(command- name command)
; expansion
(vim.api.nvim_create_user_command name command)

; description, no options table
(command- name command "Command description")
; expansion
(vim.api.nvim_create_user_command name command {:desc "Command description"})

; description and options table
(command- name command "Command description" {:nargs 1})
; expansion
(vim.api.nvim_create_user_command name command {:nargs 1 :desc "Command description"})

; no description, options table
(command- name command {:nargs 1})
; expansion
(vim.api.nvim_create_user_command name command {:nargs 1})
```

##### Examples
```fennel
; macro form
(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(command- :FZFOpenFile (fn [] (files)) "Open files")

; expansion
(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(vim.api.nvim_create_user_command :FZFOpenFile (fn [] (files)) {:desc "Open files"})
```

#### `com-`
Run Ex commands a bit more list like. Mostly a convenience macro, does not offer any special functionality.

##### Syntax
```fennel
(com- function arg-string)
; expansion
(vim.api.nvim_command "function arg-string")
```

### colors
Handles color management.

#### `col-`
Set a colorscheme.

##### Syntax
```fennel
(col- "kat.nvim")
; expansion
(vim.cmd "colorscheme kat.nvim")
```

### options
Handles setting of options and scoped variables.

#### `set-` and Friends
The macros that contain `set` all have the same macro signature, and are designed to set internal Neovim options (such as 'indentexpr'). They contain the same limitations as the appropriate Lua tables (e.g. `vim.o`), they still evaluate to Vimscript. If a Lua/Fenel function is to be used, it must be passed as you were with Vimscript still. This is a limitation to be improved upon.

##### Syntax
```fennel
(set- option value)
```
`option` is always evaluated to a string, it does not need to be a string itself. `value` must always be passed, even for options being set to true. This is for clarity of use, and functionality.

##### Set Macros List

| Macro | Use | Expanded Function |
| ----- | --- | ----------------- |
|`set-` | Attempts to match option | `nvim_set_option`, `nvim_win_set_option`, `nvim_buf_set_option`|
|`setl-` | Set local option | `vim.opt_local` |
|`setg-` | Set global option | `vim.opt_global` |
|`setw-` | Set window option | `nvim_win_set_option` |
|`seta-` | Append a value to option | `(tset vim.opt option (+ vim.opt.option value))` |
|`setp-` | Prepend a value to option | `(tset vim.opt option (^ vim.opt.option value))` |
|`setr-` | Remove a value from option | `(tset vim.opt option (- vim.opt.option value))` |

##### Examples
```fennel
; macro forms
(set- mouse "a")
(set- number true)
(set- hidden false)
(setl- expandtab true)
(seta- clipboard "unnamedplus")
(setr- nrformats :octal)

; expansion
(vim.api.nvim_set_option "mouse" "a")
(vim.api.nvim_win_set_option 0 "number" true)
(vim.api.nvim_set_option "hidden" false)
(tset vim.opt_local "expandtab" true)
(tset vim.opt "clipboard" (+ (. vim.opt "clipboard") "unnamedplus"))
(tset vim.opt "nrformats" (- (. vim.opt "nrformats") "octal"))
```

#### `let-`
This sets scoped variables.

##### Syntax
```fennel
(let- :scope :variable value)
; expansion
(tset vim.scope :variable value)
```

The scope can be any valid variable table: `g`, `b`, `w`, `t`, `v`, or `env`

### autocommands
Handles dealing with autocommands and autogroups.

#### `def-aug-`
Defines an autogroup to be returned for a variable.

##### Syntax
```fennel
(local augroup (def-aug- "GroupName" true))
; expansion
(local augroup (vim.api.nvim_create_augroup "GroupName" {:clear false}))
```
The boolean is optional. It inverts the functionality of `nvim_create_augroup`. If set to false or nil (i.e. no argument after the name), then the default behavior of `nvim_create_augroup` will be used. This means augroups will clear upon each call.

#### `auc-`
Creates an autocommand. It is not designed to be accepted by a variable for manipulation. Like maps and user command macros, it can take an optional description and options table. The events, pattern, and callback are required.

##### Syntax
```fennel
; no description or options table, lua callback
(auc- :Event "*.file" (fn [] (print "callback")))
; expansion
(vim.api.nvim_create_autocmd :Event {:pattern "*.file" :callback (fn [] (print "callback"))})

; description, no options table, vimscript callback
(auc- :Event "*.file" "echo 'command'" "Autocmd description")
; expansion
(vim.api.nvim_create_autocmd :Event {:pattern "*.file" :command "echo 'command'" :desc "Autocmd description"})

; no description, options table, called lua callback
(fn [] auto-callback (print "called function"))
(auc- :Event "*.file" auto-callback {:buffer 0})
; expansion
(vim.api.nvim_create_autocmd :Event {:pattern "*.file" :callback auto-callback :buffer 0})

; description and options table, called lua callback
(fn [] auto-callback (print "called function"))
(auc- :Event "*.file" auto-callback "Autocmd description" {:buffer 0})
; expansion
(vim.api.nvim_create_autocmd :Event {:pattern "*.file" :callback auto-callback :desc "Autocmd description" :buffer 0})
```

#### `aug-`
Absorbs `auc-` calls within its list, and injects the group throughout each. Only accepts `auc-` after the group variable.

##### Syntax
```fennel
(aug- group
  (auc- :Event "*" (fn [] (print "callback"))))
; expansion minus auc-
(auc- :Event "*" (fn [] (print "callback")) {:group group})
; full expansion
(vim.api.nvim_create_autocmd :Event {:pattern "*" :callback (fn [] (print "callback")) :group group})
```

The group must have been previously defined, it cannot be passed through with this macro. For additional notice, only `auc-` calls are accepted. Attempting to use anything else will result in a compile-time error. This is *not* a way to be programmatic about autocommand creation, it is only equivalent to the `->` threading macros in function. Any programmatic work of autocommands must be done in a list outside of this scope.

#### Examples
```fennel
; macro form
(let [highlight (def-aug- "highlightOnYank")]
  (aug- highlight
        (auc- "TextYankPost" :* 
              (fn [] ((. (require :vim.highlight) :on_yank)))
              "Highlight yank region")))
(let [terminal (def-aug- "terminalSettings")]
  (aug- terminal
   (auc- "TermOpen" :* (fn [] (setl- number false)) "No number")
   (auc- "TermOpen" :* (fn [] (setl- relativenumber false)) "No relative number")
   (auc- "TermOpen" :* (fn [] (setl- spell false)) "No spell")
   (auc- "TermOpen" :* (fn [] (setl- bufhidden :hide)) "Bufhidden")))

; expansion
(let [highlight (vim.api.nvim_create_augroup "highlightOnYank" {:clear true})]
  (vim.api.nvim_create_autocmd "TextYankPost"
                               {:pattern :*
			        :callback (fn [] ((. (require :vim.highlight) :on_yank)))
				:desc "Highlight yank region"
				:group highlight}))
(let [terminal (vim.api.nvim_create_augroup "terminalSettings" {:clear true})]
  (vim.api.nvim_create_autocmd "TermOpen" 
                               {:pattern :* 
			        :callback (fn [] (setl- number false))
				:group terminal
				:desc "No number"})
  (vim.api.nvim_create_autocmd "TermOpen" 
                               {:pattern :* 
			        :callback (fn [] (setl- relativenumber false)) 
				:group terminal
				:desc "No relative number"})
  (vim.api.nvim_create_autocmd "TermOpen" 
                               {:pattern :* 
			        :callback (fn [] (setl- spell false)) 
				:group terminal
				:desc "No spell"})
  (vim.api.nvim_create_autocmd "TermOpen" 
                               {:pattern :* 
			        :callback (fn [] (setl- bufhidden :hide)) 
				:group terminal
				:desc "Bufhidden"})))
```

## nvim.packer
These macros modify some usage for packer.nvim, mostly for my own preferences.

### `plugInit`
Condenses the standard packer setup into a one line call, does not support configuring packer.nvim in the same call at the moment.

#### Syntax
```fennel
(plugInit
  (use :wbthomason/packer.nvim)
  (use :Olical/aniseed)
  (use :lewis6991/impatient.nvim))
; expansion
((. (require :packer) :startup)
  (fn []
    (do
      (use :wbthomason/packer.nvim)
      (use :Olical/aniseed)
      (use :lewis6991/impatient.nvim))))
```

### `Plug`
Compiles to `use`. No other use than an alias.

## lispism
These macros are attempts at adapting forms to something a bit more Lisp-like, since Fennel compiles to Lua.

### `opt-`
Replaces the standard table value lookup.

#### Syntax
```fennel
; with a passed value
(opt- origin lookup {:value true})
; expansion
((. (require origin) lookup {:value true}))

; without a passed value
(opt- origin lookup)
; expansion
((. (require origin) lookup))
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

Since these are compile time dependencies, you may find that your Fennel config files won't be able to compile, you can add this repo to your `init.lua` bootstrap before the compile call. See below for an example:

```lua
local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

-- make the package path ~/.local/share/nvim/plug
local packer_path = fn.stdpath("data") .. "/site/pack"

function ensure (user, repo)
	local install_path = fmt("%s/packer/start/%s", packer_path, repo, repo)
	if fn.empty(fn.glob(install_path)) > 0 then
		execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
		execute(fmt("packadd %s", repo))
	end
end
ensure("wbthomason", "packer.nvim")
ensure("katawful", "katcros-fnl")
-- load compiler
ensure("Olical", "aniseed")
-- load aniseed environment
vim.g["aniseed#env"] = {module = "init"}
```

The path for this method is: `katcros-fnl.macro-path`.

## This Repo as a Subtree
This is the preferred method for any Fennel project. Currently I do not have any scripts that manage this, you will have to manage and update them for you. See Aniseed's scripts for suggestions.

The path for this method depends on the implementation.

# Make
While these are just macros, some use cases may require having the macros available in the equivalent `lua/` folder. `make` requires `rsync` to achieve this.

# License
This is licensed under GPLv3.
