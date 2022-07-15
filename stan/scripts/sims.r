library(tidyverse)
library(mrgsolve)
library(jsonlite) 


model_code <- "
$PROB ONE COM
$CMT GUT CENT 
$PARAM CL=8.0, V=25.0, KA=1.5
$SIGMA 0.01
$ODE
dxdt_GUT = -KA * GUT; 
dxdt_CENT= KA * GUT - (CL/V) * CENT; 
$ERROR 
capture DV = CENT/V + (CENT/V)*EPS(1);
" 

model <- mcode("one_comp", model_code) 

sample_times <- c(0.5, 1, 1.5, 2, 4, 6, 8, 12, 24) 
dose <- 500
event <- ev(amt=500) 

sim <- model %>%
    mrgsim_df(event, tgrid=sample_times, end=24, carry_out="amt,evid,cmt") %>%
    select(ID, time, DV, amt, evid,cmt) %>%
    mutate(cmt=ifelse(cmt == 0, 2, 1),
           addl=24,
           ii=0,
           ss=0,
           rate=0)  


#----------------------------------------------------------------------------
# Create stan dataset
#----------------------------------------------------------------------------

N <- nrow(sim) 
iObs <- with(sim, (1:N)[evid == 0])
nObs <- length(iObs) 

stan_data <- with(sim,
                  list(iObs = iObs, 
                       N = N, 
                       nObs = nObs, 
                       cObs = DV[iObs],
                       time = time,
                       evid = evid,
                       amt  = amt,
                       cmt = cmt,
                       addl=addl,
                       ss=ss,
                       ii=ii,
                       rate=rate)) 

stan_json <- toJSON(stan_data)

write(stan_json, "data.json")

