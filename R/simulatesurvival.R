#' simulation functions
#'
#' @param dilution Numeric value {8, 16, 32, 64, 128, 256, 512, 1024}.
#' @param phi Model estimate.
#' @param a Model estimate.
#' @param b Model estimate.
#' @param nreplicates Fixed value of 2.
#'
#' @return A numeric value
#' @export
#' @importFrom stats rbinom
#'
#' @examples
#' dilution = 16; phi = 42; a = 4; b = 1.2; nreplicates = 2
#' simulate_cell_survival(dilution, phi, a, b, nreplicates)
#'
simulate_cell_survival <- function(dilution, phi, a, b, nreplicates=2) {
  concentration <- phi / dilution
  probability <- logistic(concentration, a, b)
  rbinom(1, nreplicates, probability)
}
