// Not working, check ODE
functions {

    vector dxdt(real t, vector y, vector theta) {
        vector [2] ydot; 

        ydot[1] = theta[3] * y[1];
        ydot[2] = theta[3] * y[1] - (theta[1]/theta[2]) * y[2];

        return ydot; 
    }

}
data {
    int<lower = 1> N; 
    int<lower = 1> nObs;
    int<lower = 1> iObs[nObs]; 
    
    int<lower = 1> cmt[N]; 
    int evid[N];
    real amt[N]; 
    real time[N]; 
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
    vector<lower = 0>[N] yhat; 
    vector[2] y0 = {amt[N], 0.0};
    yhat = ode_rk45(dxdt, y0, time, theta); 
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

