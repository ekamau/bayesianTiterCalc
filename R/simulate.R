library(tidyverse)

simulate_cell_survival <- function(dilution, phi, a, b, nreplicates=2) {
  concentration <- phi / dilution
  probability <- logistic(concentration, a, b)
  rbinom(1, nreplicates, probability)
}

simulate_dose_response <- function(dilutions, phi, a, b, nreplicates=2) {
  survivals <- vector(length = length(dilutions))
  for(i in seq_along(survivals))
    survivals[i] <- simulate_cell_survival(dilutions[i], phi, a, b, nreplicates)
  tibble(dilution=dilutions, number_surviving=survivals, number_replicates=nreplicates)
}
