
functions{
  vector logistic(real a, real b, int N_len, vector log_concentration){
    vector[N_len] denom = 1 + exp(-(a + b * log_concentration));
    return(1 ./ denom);
  }
}

data {
  int N;
  int nreplicates[N];
  int survival[N];
  vector[N] dilution;
  int nsample;
  int sample[N];
  int<lower=0, upper=1> is_a_known;
  int<lower=0, upper=1> is_b_known;
  real a_fixed[is_a_known];
  real b_fixed[is_b_known];
  real mu_a;
  real<lower=0> sigma_a;
  real mu_b;
  real<lower=0> sigma_b;
  real mu_phi;
  real<lower=0> sigma_phi;

  // PPC related
  int is_include_ppc;
  int N_sim;
  int sample_sim[N_sim];
  vector[N_sim] dilution_sim;
}

parameters {
  vector<lower=0>[nsample] phi;
  real a_param[is_a_known ? 0 : 1];
  real b_param[is_b_known ? 0 : 1];
}

transformed parameters {
  real a;
  real b;
  if(is_a_known) {
    a = a_fixed[1];
  } else {
    a = a_param[1];
  }
  if(is_b_known) {
    b = b_fixed[1];
  } else {
    b = b_param[1];
  }
}

model {
  vector[N] concentration = log(phi[sample] ./ dilution);
  survival ~ binomial_logit(nreplicates, a + b * concentration);

  // priors
  phi ~ normal(mu_phi, sigma_phi);
  if(!is_a_known)
    a ~ cauchy(mu_a, sigma_a);
  if(!is_b_known)
    b ~ cauchy(mu_b, sigma_b);
}

generated quantities{
  vector[is_include_ppc ? N_sim : 0] prob;
  {
    if(is_include_ppc) {
      vector[N_sim] concentration = log(phi[sample_sim] ./ dilution_sim);
      prob = logistic(a, b, N_sim, concentration);
    }
  }
}
