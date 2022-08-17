logistic <- function(concentration, a, b) {
  1 / (1 + exp(-(a + b * concentration)))
}
