##' ---
##' title: "Access Models in the Internal Library"
##' author: ""
##' date: ""
##' ---

#+ echo=FALSE
library(knitr)
opts_chunk$set(comment='.',fig.path="img/modlib-",message=FALSE)


##' 
library(mrgsolve)


##' ### PK model
##' 
##' Here, we name the name of the model we want from the library (`pk2cmt`) and 
##' we point `mread` to the `project` directory where the internal model library is 
##' stored.  This internal library is located wherever `mrgsolve` is installed.  The install 
##' location for `mrgsolve` is not obvious, so we provide a function (`modlib`) that 
##' returns the currect path to the model library.
##' 
##' 
mod <- mread("pk2cmt", modlib())

mod %>%
  ev(amt=100,rate=3,addl=4,ii=48,cmt=2) %>%
  mrgsim(end=320) %>% 
  plot(CP~.)

##' 
see(mod)
#+

##' To get a list of available models
#+ eval=FALSE
?modlib
#+ eval=TRUE
modlib(list=TRUE)
#+
modlib()



##' ### Viral model
mod <- mread("viral1",modlib())

e <- 
  ev(amt=50, cmt="expos",time=2) + 
  ev(amt=0, cmt="expos", evid=8,time=11)

out <- 
  mod %>%
  ev(e) %>%
  update(end=28,delta=0.1) %>%
  knobs(delta=seq(0.2,0.8,0.1))


plot(out,logChange~time,groups=delta,auto.key=list(columns=4))


##' ### PK/PD model
mod <- mread("irm1", modlib())
#+
see(mod)
#+
mod %>% ev(amt=700,time=50) %>% param(n=1.5,KOUT=0.02) %>%
  mrgsim(end=480) %>% plot(CP+RESP~.)

##' ### Population PK model
mod <- mread("popex", modlib())

#+
mod %>%
  ev(amt=100) %>% 
  mrgsim(nid=100, end=96, delta=0.25) %>%
  plot(DV+ECL~.)
