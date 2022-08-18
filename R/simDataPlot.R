#' Plot simulated data:
#'
#' @param simData A dataframe of simulated titration data
#' @param n Numeric value of number of samples/draws to plot
#' @return Plot
#' @export
#'
#' @importFrom dplyr if_else mutate %>% bind_rows
#'
#' @examples
#'
simData.plot <- function(simData, n) {
  simData %>%
  filter(draw %in% 1:n) %>%
  group_by(draw, dilution) %>%
  summarise(outcome=number_surviving) %>%
  ggplot(aes(x=dilution, y=outcome)) +
    geom_point() +
    scale_x_log10() +
    ylim(0, 2) +
    facet_wrap(~draw)
}
