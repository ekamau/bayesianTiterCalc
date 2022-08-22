#' Fit a Stan model to the simulated data
#'
#' @export
#'
#' @param stan_data List that forms Stan input data
#' @param ... Arguments passed to 'rstan::sampling' e.g., iter, chains
#'
#' @return An object of class 'stanfit'
#'
simulations_stan <- function(simData, ...) {
  standata = list(N = nrow(simData), nreplicates = rep(2, nrow(simData)), survival = simData$number_surviving,
                   dilution = simData$dilution, nsample = max(simData$draw), sample = simData$draw, is_log = 1)
  out <- rstan::sampling(stanmodels$simulations, data = standata, ...)
  return(out)
}
