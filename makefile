XLS_FILE := $(shell ls *.xlsx)
CSV := cards.src
EXTRA_ARGS :=

.PHONY: assemble convert compile annotate

assemble: compile
	bash create-sheets.sh

compile: convert
	sltx -q ${EXTRA_ARGS} raw-compile card-builder
convert:
	xlsx2csv $(XLS_FILE) > cards-base.src
	cp cards-base.src $(CSV)
	sed -i 's/\"\([^"]*\)\"/{\1}/g' $(CSV)
	sed -i 's/„\([^"]*\)“/\\say{\1}/g' $(CSV)
	sed -i 's/$$/;/' $(CSV)

annotate: assemble
	python3 annotate_tts_json.py "$(CSV)" "Full Deck AD.json" "Output-Deck.json"