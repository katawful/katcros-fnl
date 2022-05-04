# Katcros - Fennel Macros by Kat

This is a collection of macros intended to the functionality of various Neovim related Fennel needs.
Neovim based macros are found in `macros/nvim`, with the rest of the macro groups being self explanatory.

# Usage
These macros are primarily meant for Neovim, but can be used for anything if needed.

## Using with Aniseed Directly

[https://github.com/Olical/aniseed](Aniseed)

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
Note that `compile.sh` is now moved below `embed.sh`. This is not the default behavior. 
If you use the default assumption, Aniseed will be unable to compile with the loaded macros despite [https://github.com/Olical/conjure](Conjure) working.
The macros will inject themselves into your plugin repo under `deps/` like aniseed.

The path for this method is: `your-plugin.katcros-fnl.macro-path`.

## This Repo as a Neovim Package
If using these macros, say for Neovim configs or a standalone Fennel project (through Hotpot or Tangerine), simply add this repo to your package manager.
This will allow access to these macros globally without requiring integration into your project directly.
This method is not suggested for plugins as macros can become out of sync, whereas a git subtree only updates whenever the plugin is updated by you.

The path for this method is: `katcros-fnl.macro-path`.

## This Repo as a Subtree
This is the preferred method for any Fennel project.
Currently I do not have any scripts that manage this, you will have to manage and update them for you.
See Aniseed's scripts for suggestions.

The path for this method depends on the implementation.

# Make
While these are just macros, some use cases may require having the macros available in the equivalent `lua/` folder.
`make` requires `rsync` to achieve this.

# License
This is currently not licensed on purpose as I explore ways to distribute these macros for projects.
This comes with all the risks of non-licensed copyright code: https://choosealicense.com/no-permission/
