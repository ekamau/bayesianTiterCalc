<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayesiantiters

<!-- badges: start -->

[![R-CMD-check](https://github.com/ekamau/bayesianTiterCalc/workflows/R-CMD-check/badge.svg)](https://github.com/ekamau/bayesianTiterCalc/actions)
[![codecov](https://codecov.io/gh/ekamau/bayesianTiterCalc/branch/main/graph/badge.svg?token=PgQrYAAQBz)](https://codecov.io/gh/ekamau/bayesianTiterCalc)

<!-- badges: end -->

bayesiantiters is a Bayesian inference method that calculates a serum sample’s antibody concentration, $\phi$, from
standard virus neutralization assay data using a mechanistic model. The method uses a dose-response relationship in a logistic function to simulate mortality of cell culture monolayers as a function of antibody concentration.

Given the limited information per sample that’s inherent in the
experimental design of neutralization assays (number of replicates per dilution and number of dilutions), the advantage of Bayesian inference here is the use of probability distributions to incorporate uncertainty in the outcome.


## Installation

You can install the development version of bayesianTiterCalc from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ekamau/bayesianTiterCalc")
```

