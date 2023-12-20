# Katcros v1 - Fennel Macros by Kat

This is a collection of macros intended to the functionality of various Neovim related Fennel needs. Neovim based macros are found in `macros/nvim`, with the rest of the macro groups being self explanatory.

# Warning

These macros are considered deprecated in full. Please use the katcros v2 repo for updated macros with complete syntax. This readme is updated solely for the functionality found here.

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
|`set-` | setter | For setting the value of an object |
|`get-` | getter | For getting the value of an object |
|`do-` | execution | Execute the object |

```fennel
;; No returned value, cannot be manipulated by itself
;; "cre-command usercommand"
(cre-command :UserCommand (fn [] (print "Hello world")) "Usercomamnd hello world")
;; Returns a value, can be manipulated with 'autocmd' variable
;; "def-command usercommand"
(local user-command (def-command :UserCommand (fn [] (print "Hello world")) "BufEnter hello world")
;; Clear out all "BufEnter" autocommands
;; "cle-awk event bufenter"
(cle-auc! {:event :BufEnter})
;; Delete 'autocmd' autocommand explicitly
;; "del-awk autocmd"
(del-auc! autocmd)
;; Set option 'number'
;; "set-opt number true"
(set-opt number true)
;; Get value of option 'number'
;; "get-opt number"
(get-opt number)
;; Do VimL function
;; "do-vim-el"
(do-viml has "nvim-0.7")
```

Each convention prefix is meant to pronounced literally, for instance `cre-command` is pronounced as "kree-command".

## `!`
In Fennel's style guide, `!` as a suffix refers to file-system operations. I have extended this to imply state updates. `cle-` and `del-` are explicit updates of Neovim's state, and thus will always be suffixed by `!`. This character can be pronounced as "bang". `cle-auc!` would be pronounced as "kle-awk-bang".

## `-`
`-` as a suffix implies a shortening from Vim/Neovim functions. For instance, `nno-` would not be pronounced as 'en-en-oh', but as "normal mode remap" from `nnoremap`. The use of these is minimized where appropriate, and likely will be removed entirely from these macros at a future date.

## `<-`, `->`
In Fennel's style guide, `->` is used for conversion functions. For instance taking a string and making it into a sequential table would be `string->table`. `->` thus gets read as "to", making this function "string to table". This convention is used where appropriate.

Conversely, `<-` becomes "from", and implies a source to look from *or* a file to read from if it is a file system operation. A function to clear an autocommand specifically from a list of events would be `cle-auc<-event!`, which would be read as "kle-awk-from-event". This is generally used when one only wishes to do 1 level of search.

## General Signatures
In order to maintain consistency, macros here have an expectation of signature behavior. It varies a bit from macro type to macro type.

### Creation Macro
```fennel
(cre-macro immediate-info command ?description ?args-table)
```
For `immediate-info`, this varies immensely based on the macro in use. For mappings macros, this is actually 2 symbols/lists:
```fennel
(map- mode-table left-hand-side command ?description ?args-table)
```
For an autocommand macro, it is also 2 symbols/lists. It is kept this way to maintain the general idea of how the Vimscript versions of these functions work overall, rather than go out of the way to make a new syntax.

Additionally, the description and/or args-table are **always** optionally if desired. If either are passed nil then the other will still function as expected.

`immediate-info` (generally) must end up as a string, you can pass a symbol or list that returns a string if needed.

```fennel
(let [user-command "MyReallyAwesomeAndVeryLongUserCommand"]
  (cre-command user-command (fn [] (print "hi"))))
```

### Definition Macro
This macro behaves the same as the equivalent creation macro, but returns a value. This is useful if you want to further manipulate said values:

```fennel
(let [user-command (def-command "UserCommand" (fn [] (print "hi")))]
  (del-command! user-command))
```

### Deletion and Clear Macros
For these macros, a "deletion" is specifically about removing the entire object. After the expanded macro is run, the object passed will not exist according to Neovim. A "clearing", on the other hand, will only remove the values present for the object. Neovim will still be aware of the object:

```fennel
(cle-auc<-event! :BufEnter) ; clear any autocommands found for BufEnter
(del-command! "UserCommand") ; delete the entire user command "UserCommand"
```

Deletion/clearing will depend on how the macro in use works, and is in part determined by the underlying API (e.g. `nvim_clear_autocmds` vs `nvim_del_user_command`).

The argument passed depends on the macro in question, although it is usually self-evident.

### Get Macro
"Get" macros are designed to get the value of some object. This is purely a data access. The data type returned depends on the macro:

```fennel
(get-auc {:group "SomeCoolGroup"}) ; get autocommands from group "SomeCoolGroup"
(print (get-opt mouse)) ; print the value of option "mouse"
```

### Set Macro
"Set" macros are designed to set the value of some object. This (mostly, see below) implies that the value exists. This is mostly for options macros.

```fennel
(set-opt mouse true)
(set-var :g :cool_var true)
```

Note that due to how Vim variables work, this macro is slightly incongruent in that the variable does not need to exist before being set. This behavior may change in the future.

### Do Macro
The `do-` macros that interface with `vim.cmd` have the ability to take a key value table that expands to the proper `key=value` syntax for said functions. The following example will expand to:
```fennel
(do-ex highlight :Normal {:guifg :white})
(vim.cmd {:cmd "highlight" :args [Normal "guifg=white"] :output true})
```
All `do-` macros can take any amount of arguments as needed by the function.

#### `do-viml` Truthy Return
This macro wraps any 0/1 boolean VimL function and outputs a proper Fennel boolean for you. See the example:

```fennel
(if (do-viml filereadable :test.txt) (print "is readable"))
(if (= (vim.fn.filereadable :test.txt) 1) (print "is readable"))
```

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

#### User-Commands
Macros allow full manipulation of user-commands.

##### `cre-command`
Creates a user-command:
```fennel
(cre-command command-name command description args-table)
```
If the command is to be Vimscript, it must be passed as an entirely enclosed string. A Lua function reference or a defined function can be used.
```fennel
(cre-command :ReallyCoolCommand (fn [] (print "butts")) 
                               "Does some really cool things"
                               {:nargs 0})
(fn some-function [args] (print (vim.inspect args)))
(cre-command :PrintCommandArgs some-function {:nargs :*})
(cre-command :ChangeColorscheme "colorscheme blue"
                               "Changes colors to blue")
```

###### Expansion
```fennel
(vim.api.nvim_create_user_command command-name command {:desc description arg-key arg-value})
```

###### Examples
```fennel
;; macro form
(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(cre-command :FZFOpenFile (fn [] (files)) "Open files")

;; expansion
(fn files [opts]
  ((. (require :fzf-lua) :files) opts))
(vim.api.nvim_create_user_command :FZFOpenFile (fn [] (files)) {:desc "Open files"})
```

##### `def-command`
Defines a user-command:
```fennel
(def-command command-name command ?description ?args-table)
```
This macro behaves the same as [`cre-command`](#cre-command), but returns `command-name` to be passed to variables. If the returned value is not needed, use `cre-command` instead.

###### Expansion
```fennel
(do (vim.api.nvim_create_user_command command-name command {:desc description arg-key arg-value})
    command-name)
```

###### Examples
```fennel
;; macro form
(local user-command (def-command :TempUserCommand
                                 (fn [] (print "hello"))
                                 {:buffer true}))
;; expansion
(local user-command (do (vim.api.nvim_create_user_command :TempUserCommand
                                                      (fn [] (print "hello"))
                                                      {:buffer 0})
                        :TempUserCommand))
```

##### `del-command`
Deletes a user-command:
```fennel
(del-command command-name ?buffer)
```
User-commands created for a buffer must pass `?buffer` due to limitations in the API.

###### Expansion
```fennel
(del-command command-name)
(vim.api.nvim_del_user_command command-name)

(del-command command-name true)
(vim.api.nvim_buf_del_user_command command-name 0)

(del-command command-name buffer)
(vim.api.nvim_buf_del_user_command command buffer)
```

##### `do-command`
Runs a user command:
```fennel
(do-command command-name args)
```

###### Expansion
```fennel
(do-command command-name)
(vim.cmd {:cmd command-name :output true})

(do-command command-name :arg)
(vim.cmd {:cmd command-name :args [:arg] :output true})
```

#### `do-ex`
Runs a Ex command:

##### Syntax
```fennel
(do-ex function :arg)
; expansion
(vim.cmd {:cmd :function :args [:arg] :output true})

(do-ex function :arg {:key :value})
(vim.cmd {:cmd :function :args [:arg "key=value"] :output true})
```

#### `do-viml`
Run a VimL function, returning a boolean for boolean returning functions:

##### Syntax
```fennel
(do-viml function)
((. vim.fn "function"))

(do-viml did_filetype)
(do (let [result_2_auto ((. vim.fn "did_filetype"))] (if (= result_2_auto 0) false true)))

(do-viml expand "%" vim.v.true)
((. vim.fn "expand") "%" vim.v.true)

(do-viml has :nvim)
(do (let [result_2_auto ((. vim.fn "has") "arg")] (if (= result_2_auto 0) false true)))
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
Handles setting of options and scoped variables. All option macros can take a flag for `append`, `prepend` and `remove` to keep all functionality. These flags are always the last option of the macro.

### Mono-option Macros
To simplify syntax, there are macros for setting only 1 option:

#### `set-opt`
This sets a single option, not keeping in mind scope of the option (global & local)

##### Syntax
```fennel
(set-opt option value)
(tset vim.opt "option" value)

(set-opt option value :append)
(: (. vim.opt "option") "append" value)
```

#### `set-local-opt`
This sets an option that has the `buf` or `win` scope as a local option. Returns an error if a global option is passed.

##### Syntax
```fennel
(set-local-opt spell true)
(tset vim.opt_local "spell" true)

(set-local-opt spell true :append)
(: (. vim.opt_local "spell") "append" true)
```

#### `set-global-opt`
This sets an option that has the `global` scope as a global option. Returns an error if a local option is passed.

##### Syntax
```fennel
(set-global-opt mouse :nvi)
(tset vim.opt_global "mouse" "nvi")

(set-global-opt mouse :nvi :append)
(: (. vim.opt_global "mouse") "append" "nvi")
```

#### `set-opt-auto`
This automatically sets an option as either local or global.

##### Syntax
```fennel
(set-opt-auto mouse :nvi)
(tset vim.opt_global "mouse" "nvi")

(set-opt-auto spell true)
(tset vim.opt_local "spell" true)
```

### Plural-option Macros
These macros set multiple of options, following the same rules as the mono-option macros. These macros are sorted to always return the same order of operations. These are not sorted as the passed options, they are sorted with `table.sort`:

``` fennel
(set-opts {spell true mouse :nvi})
(do (tset vim.opt "spell" true) (do (tset vim.opt "mouse" "nvi")))
```

- `set-opts`
- `set-local-opts`
- `set-global-opts`
- `set-opts-auto`

### `get-opt`
Gets an option.

#### Syntax
```fennel
(get-opt spell)
(: (. vim.opt "spell") "get")
```

### `set-var`
Sets a vim variable. Supports scope indexing. When using a scope index, returns an error on compilation if anything other than `b`, `w`, or `t` scope is used.

#### Syntax
```fennel
(set-var :g variable "Value")
(tset (. vim "g") "variable" "Value")

(set-var (. :b 1) variable "Value")
(tset (. (. vim "b") 1) "variable" "Value")
```

### `set-vars`
Sets multiple vim variable using a key/value table. Supports scope indexing. When using a scope index, returns an error on compilation if anything other than `b`, `w`, or `t` scope is used.

#### Syntax
```fennel
(option.set-vars :g {:variable_1 "Value" :variable_2 true})
(do (tset (. vim "g") "variable_2" true) (tset (. vim "g") "variable_1" "Value"))

(option.set-vars (. :b 1) {:variable_1 "Value" :variable_2 true})
(do (tset (. (. vim "b") 1) "variable_2" true) (tset (. vim "g") "variable_1" "Value"))
```

### `get-var`
Gets a vim variable. Supports scope indexing. When using a scope index, returns an error on compilation if anything other than `b`, `w`, or `t` scope is used.

#### Syntax
```fennel
(get-var :g variable)
(. (. vim "g") "variable")

(get-var (. :b 1) variable)
(. (. (. vim "b") 1) "variable")
```


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

#### `cle-auc!`
Clears an autocommand using `vim.api.nvim_clear_autocommands`.

##### Syntax
```fennel
(cle-auc! (:buffer 0})
(vim.api.nivm_clear_autocmds {:buffer 0})
```

#### `cle-auc<-event!`, `cle-auc<-pattern!`, `cle-auc<-buffer!`, `cle-auc<-group!`
Takes the appropriate type, single and plural, and only that type and clears the autocommands using `vim.api.nvim_clear_autocommands`

- `cle-auc<-event!`: takes a string or sequential table of strings corresponding to event name
- `cle-auc<-pattern!`: takes a string or sequential table of strings corresponding to a pattern
- `cle-auc<-buffer!`: takes a int buffer number
- `cle-auc<-group!`: takes a string or sequential table of strings corresponding to group name

##### Syntax
```fennel
(cle-auc<-event! :Event)
(vim.api.nvim_clear_autocmd {:event "Event"})
```

#### `get-auc!`
Clears an autocommand using `vim.api.nvim_get_autocmds`.

##### Syntax
```fennel
(get-auc! (:buffer 0})
(vim.api.nivm_get_autocmds {:buffer 0})
```

#### `get-auc<-event!`, `get-auc<-pattern!`, `get-auc<-buffer!`, `get-auc<-group!`
Takes the appropriate type, single and plural, and only that type and gets the autocommands using `vim.api.nvim_get_autocmds`

- `get-auc<-event!`: takes a string or sequential table of strings corresponding to event name
- `get-auc<-pattern!`: takes a string or sequential table of strings corresponding to a pattern
- `get-auc<-group!`: takes a string or sequential table of strings corresponding to group name

##### Syntax
```fennel
(get-auc<-event! :Event)
(vim.api.nvim_get_autocmds {:event "Event"})
```

#### `del-aug!`
Deletes an autogroup by name or by id.

##### Syntax
```fennel
(del-aug! :Group)
(vim.api.nvim_del_augroup_by_name "Group")

(del-aug! 0)
(vim.api.nvim_del_augroup_by_id 0)
```

#### `do-auc`
Fires an autocmd using `vim.api.nvim_exec_autocmds`.

##### Syntax
```fennel
(do-auc :Event)
(vim.api.nvim_exec_autocmds "Event" {})

(do-auc [:Event1 :Event2] {:group :Group})
(vim.api.nvim_exec_autocmds ["Event1" "Event2"] {:group "Group"})
```

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
This is the preferred method for any Fennel project. Currently I do not have any scripts that manage this, you will have to manage and update them for you.

The path for this method depends on the implementation.

# Development
To test these macros, run the script in `scripts/setup-test-deps.sh`. Then run `make test` using the makefile. Plenary and an installation of Olical/nfnl is used for testing.

Compilation is provided through Olical/nfnl

# License
This is licensed under Unlicense.
