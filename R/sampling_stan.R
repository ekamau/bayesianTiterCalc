prepare_stan_data <- function(
    data,
    prior_a, prior_b, prior_phi,
    a, b,
    include_ppc) {

  nsample <- dplyr::n_distinct(data$id)
  if(max(data$id) != nsample)
    stop("Number of unique samples must match maximum id.")

  stan_data <- list(
    N=nrow(data),
    dilution=data$dilution,
    nreplicates=data$number_replicates,
    survival=data$number_surviving,
    sample=data$id,
    nsample=nsample
  )

  stan_data$is_a_known <- 0
  stan_data$is_b_known <- 0
  stan_data$a_fixed <- numeric(0)
  stan_data$b_fixed <- numeric(0)
  if(!is.null(a)) {
    stan_data$is_a_known <- 1
    stan_data$a_fixed <- as.array(a)
  }

  if(!is.null(b)) {
    stan_data$is_b_known <- 1
    stan_data$b_fixed <- as.array(b)
  }

  if(include_ppc)
    stan_data$is_include_ppc <- 1

  stan_data$mu_a = prior_a$mu
  stan_data$sigma_a = prior_a$sigma
  stan_data$mu_b = prior_b$mu
  stan_data$sigma_b = prior_b$sigma
  stan_data$mu_phi = prior_phi$mu
  stan_data$sigma_phi = prior_phi$sigma

  stan_data
}


multiple_optimisations <- function(model, data, max_tries, ...) {

  is_converged <- FALSE
  tries <- 0
  print("hello")
  print(data$is_a_known)
  print(data$a_fixed)
  data$a_fixed <- as.array(1)
  data$b_fixed <- as.array(1)
  while(!is_converged & tries <= max_tries) {

    opt <- rstan::optimizing(model, data = data, as_vector = FALSE)
    is_converged <- if_else(opt$return_code==0, TRUE, FALSE)
    tries <- tries + 1
  }
  opt
}

initialisation_function <- function(opt, a, b) {

  if(!is.null(a) & !is.null(b)) {
    start_vals <- list(phi = opt$par$phi)
  } else if(!is.null(a)) {
    start_vals <- list(b = opt$par$b, phi = opt$par$phi)
  } else if(!is.null(b)) {
    start_vals <- list(a = opt$par$a, phi = opt$par$phi)
  } else {
    start_vals <- list(a = opt$par$a, b = opt$par$b, phi = opt$par$phi)
  }

  initf <- function() {
    start_vals
  }

  initf
}

#' Fit a Stan model to the simulated data
#'
#' This fits a model of the form:
#'
#' number_surviving ~ binomial(n_replicates, theta(dilution))
#'
#' where theta(dilution) is a probability of surviving which depends on the dilution.
#' The functional form of this is:
#'
#' theta(dilution) = 1 / (1 + exp(a + b * log(phi / dilution)))
#'
#' where a, b and phi are parameters. a and b can either be estimated or specified
#' a priori; phi is always estimated.
#'
#' @export
#'
#' @param data A data frame with columns: 'dilution', 'number_surviving', 'number_replicates', 'id' (unique identifier for each sample).
#' @param is_sampling A Boolean (default is TRUE) indicating whether to perform sampling (if TRUE) or optimisation (if FALSE).
#' @param prior_a Parameters for Cauchy prior for a (by default list(mu=0, sigma=10)).
#' @param prior_b Parameters for Cauchy prior for b (by default list(mu=0, sigma=10)).
#' @param prior_phi Parameters for Cauchy prior for phi (by default list(mu=0, sigma=1000)).
#' @param a Fixed value for a if not estimated (by default NULL).
#' @param b Fixed value for b if not estimated (by default NULL).
#' @param include_ppc A Boolean (default is FALSE) indicating whether to include posterior predictive simulations.
#' @param n_optimisations Number of optimisations to perform (note optimisation is also performed as a precusor step to sampling). By default this is set to 5.
#' @param ... Arguments passed to 'rstan::sampling' or 'rstan::optimizing' e.g., iter, chains.
#'
#' @return An object of class 'stanfit'.
#' @examples
#' ndraws = 30; dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
#' sim_data <- sample_dose_response(ndraws, dilutions, nreplicates_per_dilution)
#'
#' # fit model to data not saving posterior predictive simulations
#' fit <- fit_stan(sim_data, iter = 100, chains = 4, init = 'random')
#'
fit_stan <- function(
    data,
    is_sampling=TRUE,
    prior_a=list(mu=0, sigma=10),
    prior_b=list(mu=0, sigma=10),
    prior_phi=list(mu=0, sigma=1000),
    a=NULL, b=NULL,
    include_ppc=FALSE,
    n_optimisations=5,
    ...) {

  stan_data <- prepare_stan_data(
    data,
    prior_a, prior_b, prior_phi,
    a, b,
    include_ppc
  )

  model <- stanmodels$logistic_model

  fit <- multiple_optimisations(model=model, data=stan_data, max_tries=n_optimisations, ...)

  if(is_sampling) {
    init_fn <- initialisation_function(fit, a, b)
    fit <- rstan::sampling(model, data = stan_data, init=init_fn, ...)
  }

  fit
}


