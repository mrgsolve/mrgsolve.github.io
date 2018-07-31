# Blog contributions
- Please fork repository and create pull request

## Creating a post

```r
blogdown::new_post("The Blog Post Title", rmd=TRUE)

blogdown::serve_site()
```
- Edit the file in `content/post`
- Please use caching (`knitr::opts_chunk$set(cache=TRUE, autodep=TRUE)`)
- Please slience messages and center figures (`knitr::opts_chunk$set(message=FALSE, fig.align="center")`)



