#' simulation function
#'
#' @param dilutions Numeric vector {8, 16, 32, 64, 128, 256, 512, 1024}.
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
#' dilutions <- vector()
#' for(i in 3:10){j <- 2^i; dilutions <- c(dilutions, j)};
#' phi = 42; a = 4; b = 1.2; nreplicates = 2
#' simulate_dose_response(dilutions, phi, a, b, nreplicates)
#'
simulate_dose_response <- function(dilutions, phi, a, b, nreplicates) {
  survivals <- vector(length = length(dilutions))
  for(i in seq_along(survivals))
    survivals[i] <- simulate_cell_survival(dilutions[i], phi, a, b, nreplicates)
  tibble(dilution = dilutions, number_surviving = survivals, number_replicates = nreplicates)
}
