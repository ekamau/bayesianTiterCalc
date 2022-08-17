#' non monotonic logic/boolean function
#'
#' @param x A numeric vector, for each sample, of the number of wells with surviving cells per dilution
#'
#' @return A boolean '1' if non-monotonic and '0' if monotonic
#' @export
#'
#' @examples
#' x <- c(2,2,2,2,2,0,0,0)
#' non_monotonic(x)
#'
non_monotonic <- function(x) {
  res <- rle(x)
  changes <- diff(res$values)
  is_positive <- sum(changes > 0)
  if_else(is_positive > 0, 1, 0)
}
