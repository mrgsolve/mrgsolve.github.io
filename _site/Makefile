SHELL := /bin/bash
export PATH := /Applications/RStudio.app/Contents/MacOS/pandoc:$(PATH)
DEST := .


all:
	cd source && Rscript -e 'blogdown::build_site("")'
	

site:
	cp -r source/public/ ${DEST}
	#rsync -arv --delete public/ ../../mrgsolve.github.io
	#cd ${DEST} && git add * && git commit -am "publish"	



edits:
	git add user_guide/*
	git commit -am "edits"
	git push -u origin master 

render: 
	Rscript scripts/make_user_guide.R


.PHONY: doxygen
doxygen:
	doxygen scripts/Doxyfile
	git add doxygen/*
	


