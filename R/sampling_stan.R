#' Fit a Stan model to the simulated data
#'
#' @export
#'
#' @param inputdata A dataframe for constructing Stan input data
#' @param ... Arguments passed to 'rstan::sampling' e.g., iter, chains
#'
#' @return An object of class 'stanfit'
#' @example
#' phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16)
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2, phi_Vals)
#'
#' fit <- sampling_stan(inputdata = simData, iter=100, chains=1, init='random')
#'
sampling_stan <- function(inputdata, ...) {
  standata = list(N = nrow(inputdata), nreplicates = rep(2, nrow(inputdata)), survival = inputdata$number_surviving,
                  dilution = inputdata$dilution, nsample = max(inputdata$draw), sample = inputdata$draw, is_log = 1)
  out <- rstan::sampling(stanmodels$simulations, data = standata, ...)
  return(out)
}
