#' Check if data is monotone
#'
#' @param simData A dataframe of simulated titration data
#'
#' @return A table
#' @export
#'
#' @importFrom dplyr if_else mutate %>% bind_rows filter group_by summarise
#' @importFrom utils globalVariables
#' @importFrom rlang .data
#'
#' @examples
#' phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions,
#' nreplicates_per_dilution=2, phi_Vals)
#' non_monotone <- check_monotone(simData)
#'
check_monotone <- function(simData){
  simData %>%
    group_by(.data$draw) %>%
    summarise(is_non_monotone = non_monotonic(.data$number_surviving))
}
