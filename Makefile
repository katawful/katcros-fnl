.PHONY: test

default: test

format:
	scripts/fnlfmt.sh

test:
	scripts/test.sh
