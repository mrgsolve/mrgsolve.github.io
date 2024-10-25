SHELL := /bin/bash
export PATH := /Applications/RStudio.app/Contents/MacOS/pandoc:$(PATH)
DEST := .

all:
	quarto render
	open docs/index.html
