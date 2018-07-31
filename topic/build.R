library(rmarkdown)
library(mrgsolve)

rsc <- file.path("content", "topic", c("map_bayes.R", "model-gallery.R",
        "modmrg.R"))


foo <- lapply(c(rsc),render,envir=new.env(),quiet=TRUE)

