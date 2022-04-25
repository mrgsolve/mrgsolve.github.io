library(spelling)

files <- list.files(".", pattern = "qmd", full.names=TRUE)
spell_check_files(files)

spell_check_files("index.qmd")

