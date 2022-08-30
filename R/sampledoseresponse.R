#' simulate data that has sample dose response
#'
#' @param ndraws A numeric value for number of draws or simulations
#' @param prior_phi A list with numeric values for boundaries of the uniform distribution
#' @param a Numeric value estimated by model
#' @param b Numeric value estimated by model
#' @param dilutions Numeric value for number of dilutions per sample
#' @param nreplicates_per_dilution Numeric value
#'
#' @return A dataframe of simulated data
#' @export
#'
#' @importFrom tidyr tibble
#' @importFrom stats runif
#' @importFrom dplyr if_else mutate %>% bind_rows
#'
#' @examples
#' ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower=0.75, upper=16);
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions,
#' nreplicates_per_dilution=2)
#'
sample_dose_response <- function(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2) {
  phis <- runif(ndraws, prior_phi$lower, prior_phi$upper)
  for(i in 1:ndraws) {
    phi <- phis[i]
    dose_response <- simulate_dose_response(dilutions, phi, a, b, nreplicates_per_dilution) %>%
      mutate(draw = i, phiValue = phi)

    if(i == 1)
      big_df <- dose_response
    else
      big_df <- big_df %>% bind_rows(dose_response)
  }
  big_df
}
