library(cmdstanr)
library(tidyverse)
library(jsonlite) 
source('sims.r') 


cmdstanr::set_cmdstan_path("~/code/Torsten/cmdstan") 

data <- read_json('data.json', simplifyVector=T) 

init <- function() {
    list(CL = exp(rnorm(1, log(8), 0.1)), 
         V = exp(rnorm(1, log(25), 0.1)), 
         ka = exp(rnorm(1, log(1.5), 0.1)), 
         sigma = abs(rnorm(1, 0, 0.2)))
}


n_chains <- 4
model <- cmdstan_model("model.stan") 


fit <- model$sample(data=data, init=init, chains = n_chains,
            iter_warmup = 1500, iter_sampling = 500,
            adapt_delta=0.8, refresh=10) 
