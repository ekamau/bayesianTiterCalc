#' Fit a Stan model to the simulated data
#'
#' @export
#'
#' @param standata A dataframe for constructing Stan input data
#' @param ... Arguments passed to 'rstan::sampling' e.g., iter, chains
#'
#' @return An object of class 'stanfit'
#' @examples
<<<<<<< HEAD
#' ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower = 1.75, upper = 16)
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution)
=======
#' ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower=0.75, upper=16)
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2)
>>>>>>> 56e38b656833ad7b39168f00a1c8eea377a05719
#'
#' stan_data = list(N = nrow(simData), nreplicates = rep(nreplicates_per_dilution, nrow(simData)),
#' survival = simData$number_surviving, dilution = simData$dilution, nsample = max(simData$draw),
#' sample = simData$draw, is_log = 1)
#'
#' fit <- sampling_stan(standata = stan_data, iter = 100, init = 'random')
#'
optimizing_stan <- function(standata, ...) {
  rstan::optimizing(stanmodels$modelwithppc, data = standata, ...)
}

