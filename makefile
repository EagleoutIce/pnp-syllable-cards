XLS_FILE := $(shell ls *.xlsx)

EXTRA_ARGS := ''

.PHONY: assemble convert compile

assemble: compile
	bash create-sheets.sh

compile: convert
	sltx -q raw-compile ${EXTRA_ARGS} card-builder

convert:
	xlsx2csv $(XLS_FILE) > cards-base.src
	cp cards-base.src cards.src
	sed -i 's/\"\([^"]*\)\"/{\1}/g' cards.src
	sed -i 's/„\([^"]*\)“/\\say{\1}/g' cards.src
	sed -i 's/$$/;/' cards.src
