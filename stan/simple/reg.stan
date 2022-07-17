data {
    int<lower=0> N; // number of observation
    vector[N] x; 
    vector[N] y; 

}


parameters {
    real alpha;
    real beta; 
    real<lower=0> sigma; 
}


model {
    y ~ normal(x * beta + alpha, sigma);
}
