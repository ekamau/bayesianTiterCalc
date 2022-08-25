#' Fit a Stan model to the Reed and Muench data (reedmuenchTitrations)
#'
#' @export
#'
#' @param standata A dataframe for constructing Stan input data
#' @param ... Arguments passed to 'rstan::sampling' e.g., iter, chains
#'
#' @return An object of class 'stanfit'
#'
sampling_rm <- function(standata, ...) {
  rstan::sampling(stanmodels$modelwithppc_reedmuench, data = standata, ...)
}
