##' ---
##' output: html_document
##' title: ""
##' ---


##' <BR>
##' 
##' 
##' # Resimulate random effect variates on demand
##' 
##' 
##' 

#+ message=FALSE
library(mrgsolve)
#+


##' ## `simeta` example
##' 
##' - In this example, we want to simulate a patient-specific baseline response
##' that is between 80 and 120.
##' - In the code, we start a loop that calls `simeta` with no 
##' arguments until the baseline is between the specified bounds
##' - For this example, we only calculate
##' `BASE` when `NEWIND <=1` ... or whenever we are working on the 
##' first record of an individual.  This ensures that we don't re-simulate
##' `BASE` at every simulation record.
##' - We have also implemented a counter (`i`) that ensures we only
##' try to resimulate 100 times.  If a value for `BASE` cannot be
##' generated in 100 tries, we give up.  
##' - You probably won't need to implement `FLAG` for your problem. I am 
##' only using `FLAG` here so we can selectively call the `simeta` code
##' to demonstrate how it is working.
##' 

code <- '
$PARAM TVBASE = 100, FLAG = 0

$CMT RESPONSE

$MAIN 

if(NEWIND <=1) {

  capture BASE = TVBASE*exp(EBASE);

  int i = 0;

  if(FLAG > 0) {
    while((BASE < 80) || (BASE > 120)) {
      if(++i > 100) {
        report("There was a problem simulating BASE");
      }
      simeta();
      BASE = TVBASE*exp(EBASE);
    }
  }
  
  RESPONSE_0 = BASE;
}


$OMEGA @labels EBASE
1

$CAPTURE EBASE
'

#+ message=FALSE
mod <- mcode("simeta", code)

##' ### Simulate without `simeta`
#+ comment='.'
system.time({
  out <- mod %>% mrgsim(nid=100, end=-1)
  sum <- summary(out)
})

#+ comment='.'
print(sum)

##' 
##' When we simulate with `FLAG=0`, the `simeta` code __isn't__ called and we
##' `BASE` values all over the place.
##' 

##' ### Simulate with `simeta`
#+ comment='.'
system.time({
  out <- mod %>% mrgsim(nid=100, end=-1, param=list(FLAG=1))
  sum <- summary(out)
})

#+ comment='.'
print(sum)

##' 
##' When we simulate with `FLAG=1`, the `simeta` code __is__ called and we
##' `BASE` values within the specified bounds.
##' 


##'
##' ## `simeps` example
##' 
##' - In this example, we want to re-simulate the residual error variate to 
##' make sure we have a concentration that is positive.
##' - We set up a loop that looks like the `simeta` example, but 
##' we work in `$TABLE` this time because we are calculating `CP`.
##' 
##' 

code <- '
$PARAM CL = 1, V = 20, FLAG=0

$SIGMA 50

$PKMODEL cmt="CENT"

$TABLE
capture CP = CENT/V + EPS(1);

int i = 0;
while(CP < 0 && FLAG > 0) {
  if(++i > 100) {
    report("Problem simulating positive CP");
  }
  simeps();
  CP = CENT/V + EPS(1);
}

'

#+ comment='.', message=FALSE
mod <- mcode("simeps", code)

##' ### Simulate without `simeps`
#+ comment='.'
system.time({
  out <- mod %>% ev(amt=100) %>% mrgsim(end=48)
  sum <- summary(out)
})

#+ comment='.'
print(sum)

##' 
##' __Negative__ concentrations are simulated when we __don't__ call the
##' `simeps` loop.
##' 

##' ### Simulate with `simeps`

#+ comment='.'
system.time({
  out <- mod %>% ev(amt=100) %>% mrgsim(end=48, param=list(FLAG=1))
  sum <- summary(out)
})

#+ comment='.'
print(sum)

##' 
##' Better ... all concentrations are positive.
##' 

