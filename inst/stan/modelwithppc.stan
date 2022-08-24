functions{
  real logistic(real a, real b, real concentration){
    real prob = 1 / (1 + exp(-(a + b * concentration)));
    return prob;
  }
}

data {
  int N;
  int nreplicates[N];
  int survival[N];
  int dilution[N];
  int nsample;
  int sample[N];
  int is_log;
}

parameters {
  real<lower=0> a;
  real<lower=0> b;
  real<lower=0> phi[nsample];
}

model {
  for(i in 1:N) {
    real concentration;
    if(is_log == 1)
      concentration = log(phi[sample[i]] / dilution[i]);
    else
      concentration = phi[sample[i]] / dilution[i];

    survival[i] ~ binomial(nreplicates[i], logistic(a, b, concentration));
  }

  // priors
  a ~ cauchy(0, 10);
  b ~ cauchy(0, 10);
  phi ~ lognormal(log(6), 0.5);
}

generated quantities{
  vector[N] survival_sim;
  vector[N] prob;

  for(i in 1:N){
    real concentration;

    if(is_log == 1)
      concentration = log(phi[sample[i]] / dilution[i]);
    else
      concentration = phi[sample[i]] / dilution[i];
    prob[i] = logistic(a, b, concentration);
    survival_sim[i] = binomial_rng(nreplicates[i], prob[i]);

  }

}
