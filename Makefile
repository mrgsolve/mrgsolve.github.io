SHELL := /bin/bash
export PATH := /Applications/RStudio.app/Contents/MacOS/pandoc:$(PATH)
DEST := .


all:
	Rscript -e 'rmarkdown::render_site()'
	open index.html
	
