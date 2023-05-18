#' simulation functions
#'
#' @param dilution Numeric value of {8, 16, 32, 64, 128, 256, 512, 1024}.
#' @param phi Model estimate.
#' @param a Model estimate.
#' @param b Model estimate.
#' @param nreplicates Number of replicates at each dilution (by default value of 2).
#' @param is_log Is logistic function on log-concentration scale? (by default False).
#'
#' @return A numeric value
#' @export
#' @importFrom stats rbinom
#'
#' @examples
#' dilution = 16; phi = 42; a = 4; b = 1.2; nreplicates = 2
#' simulate_cell_survival(dilution, phi, a, b, nreplicates)
#'
simulate_cell_survival <- function(dilution, phi, a, b, nreplicates, is_log=FALSE) {
  concentration <- phi / dilution
  if(is_log)
    concentration <- log(phi / dilution)
  probability <- logistic(concentration, a, b)
  rbinom(1, nreplicates, probability)
}
