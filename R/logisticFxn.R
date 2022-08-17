#' logistic function
#'
#' @param concentration Estimate from the model
#' @param a Estimate from the model
#' @param b Estimate from the model
#'
#' @return A numeric value
#' @export
#'
#' @examples
#' concentration = 0.02; a = 4; b = 0.1
#' logistic(concentration, a, b)
#'
logistic <- function(concentration, a, b) {
  1 / (1 + exp(-(a + b * concentration)))
}
