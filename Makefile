.PHONY: lua

default: lua

lua:
	rm -rf lua
	rsync -avur fnl/ lua/
