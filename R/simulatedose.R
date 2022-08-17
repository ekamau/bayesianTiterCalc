#' simulation function
#'
#' @param dilution Numeric value {8, 16, 32, 64, 128, 256, 512, 1024}.
#' @param phi Model estimate.
#' @param a Model estimate.
#' @param b Model estimate.
#' @param nreplicates Fixed value of 2.
#'
#' @return A numeric vector of length 8
#' @export
#'
#' @importFrom tidyr tibble
#'
#' @examples
#' dilution = 16; phi = 42; a = 4; b = 1.2; nreplicates = 2
#'
#' simulate_dose_response(dilution, phi, a, b, nreplicates)
#'
simulate_dose_response <- function(dilutions, phi, a, b, nreplicates=2) {
  survivals <- vector(length = length(dilutions))
  for(i in seq_along(survivals))
    survivals[i] <- simulate_cell_survival(dilutions[i], phi, a, b, nreplicates)
  tibble(dilution=dilutions, number_surviving=survivals, number_replicates=nreplicates)
}
