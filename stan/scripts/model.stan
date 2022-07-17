
functions {
    real one_comp(real time, real dose, real CL, real V, real ka) {
        real k; 
        k = CL/V; 

        return dose/V * ka/(ka - k) * (exp(-k * time) - exp(-ka * time)); 
    }
}
data {
    int<lower = 1> N; 
    int<lower = 1> nObs;
    int<lower = 1> iObs[nObs]; 
    
    int<lower = 1> cmt[N]; 
    int evid[N];
    real amt[N]; 
    real time[nObs]; 
    int addl[N];
    real rate[N]; 
    int ss[N];
    real ii[N];


    vector<lower = 0>[nObs] cObs; 
}

transformed data {
    int nTheta = 3;
    int nCmt = 2;
}

parameters {
    real<lower = 0.01> CL;
    real<lower = 0.01> V; 
    real<lower = 0.01> ka;
    real<lower = 0> sigma; 
}


transformed parameters {
    real theta[nTheta] = {CL, V, ka}; 
    vector<lower = 0>[nObs] yhat; 
    for (i in 1:nObs) {
         yhat[i] = one_comp(time[i], amt[i], CL, V, ka ); 
    }
}


model {
    // priors 
    CL ~ lognormal(log(8), 0.3); 
    V  ~ lognormal(log(25), 0.1); 
    ka ~ lognormal(log(1.5), 0.1); 
    sigma ~ cauchy(0, 1); 

    cObs ~ lognormal(log(yhat[iObs]), sigma); 
}

generated quantities {
  real concentrationObsPred[nObs] 
    = lognormal_rng(log(yhat[iObs]), sigma);

  vector[nObs] log_lik;
  for (i in 1:nObs)
    log_lik[i] = lognormal_lpdf(cObs[i] | 
                                  log(yhat[iObs[i]]), sigma);
}

