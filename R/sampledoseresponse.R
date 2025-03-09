#' simulate data that has sample dose response
#'
#' @param ndraws A numeric value for number of draws or simulations
#' @param dilutions Numeric value for number of dilutions per sample
#' @param nreplicates_per_dilution Numeric value for number of replicates per dilution
#'
#' @return A dataframe of simulated data
#' @export
#'
#' @importFrom tidyr tibble
#' @importFrom stats runif
#' @importFrom dplyr if_else mutate %>% bind_rows
#' @importFrom stats rlnorm rnorm
#'
#' @examples
#' ndraws = 30; dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
#' simData <- sample_dose_response(ndraws, dilutions, nreplicates_per_dilution)
#'
sample_dose_response <- function(ndraws, dilutions, nreplicates_per_dilution=2) {
  prior_a = list(mu = -5, sigma = 1);
  prior_b <- list(mu = 50, sigma = 1);
  prior_phi <- list(mu = 6, sigma = 0.5);
  as <- rnorm(ndraws, prior_a$mu, prior_a$sigma)
  bs <- rnorm(ndraws, prior_b$mu, prior_b$sigma)
  phis <- rlnorm(ndraws, log(prior_phi$mu), prior_phi$sigma)
  for(i in 1:ndraws) {
    a <- as[i]
    b <- bs[i]
    phi <- phis[i]
    dose_response <- simulate_dose_response(dilutions, phi, a, b, nreplicates_per_dilution) %>%
      mutate(id = i, phiValue = phi)

    if(i == 1)
      big_df <- dose_response
    else
      big_df <- big_df %>% bind_rows(dose_response)
  }
  big_df
}
