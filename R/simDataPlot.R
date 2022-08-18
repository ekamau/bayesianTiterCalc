#' Plot simulated data
#'
#' @param simData A dataframe of simulated titration data
#' @param n Numeric value of number of samples/draws to plot
#' @return Plot
#' @export
#'
#' @importFrom dplyr if_else mutate %>% bind_rows filter group_by summarise
#' @importFrom ggplot2 ggplot aes geom_point scale_x_log10 ylim facet_wrap
#' @importFrom utils globalVariables
#' @importFrom rlang .data
#'
#' @examples
#' phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
#' dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
#' simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2, phi_Vals)
#' n = 4
#' simData.plot(simData, n)
#'
simData.plot <- function(simData, n) {
  simData %>%
  filter(.data$draw %in% 1:n) %>%
  group_by(.data$draw, .data$dilution) %>%
  summarise(outcome = .data$number_surviving) %>%
  ggplot(aes(x = .data$dilution, y = .data$outcome)) +
    geom_point() +
    scale_x_log10() +
    ylim(0, 2) +
    facet_wrap(~.data$draw)
}
