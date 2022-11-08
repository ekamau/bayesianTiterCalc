
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayesianTiterCalc

<!-- badges: start -->

[![R-CMD-check.yaml](https://github.com/ekamau/bayesianTiterCalc/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ekamau/bayesianTiterCalc/actions)
[![R-CMD-check](https://github.com/ekamau/bayesianTiterCalc/workflows/R-CMD-check/badge.svg)](https://github.com/ekamau/bayesianTiterCalc/actions)
[![codecov](https://codecov.io/gh/ekamau/bayesianTiterCalc/branch/master/graph/badge.svg?token=61D5K98II1)](https://codecov.io/gh/ekamau/bayesianTiterCalc)
<!-- badges: end -->

bayesianTiterCalc is a Bayesian inference method that calculates a serum
sample’s antibody concentration, $\phi$, and titer based on data from a
standard virus neutralization assay. The method uses a dose-response
relationship in a logistic function to simulate mortality of cell
monolayers as a function of antibody concentration.

Given the limited information per sample that’s inherent in the
experimental design of neutralization assays (number of replicates per
dilution and number of dilutions), the advantage of Bayesian inference
here is the use of probability distributions to incorporate uncertainty
in the outcome.

## Installation

You can install the development version of bayesianTiterCalc from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ekamau/bayesianTiterCalc")
```

## Usage

Example of data simulation: 30 serum samples with two replicates per
dilution point.

``` r
library(bayesianTiterCalc)
ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower = 0.75, upper = 16)
dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution)
head(simData)
table(simData$number_surviving)
```

Plot four simulated samples:

``` r
library(tidyverse)

simData %>%
  filter(.data$draw %in% 1:4) %>%
  group_by(.data$draw, .data$dilution) %>%
  summarise(outcome = .data$number_surviving) %>%
  ggplot(aes(x = .data$dilution, y = .data$outcome)) +
    geom_point() +
    scale_x_log10() +
    ylim(0, 2) +
    facet_wrap(~ .data$draw)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="60%" height="50%" />

Check for monotonicity, i.e., mortality of cell monolayers increases
with higher serum dilutions. Non-monotonic data would show ‘accidental’
or unusual death or survival of cells in between dilution steps. In the
*table* output, ‘0’ and ‘1’ represents monotonic and non-monotonic data
points, respectively.

``` r
non_monotone <- simData %>%
  group_by(simData$draw) %>%
  summarise(is_non_monotone = non_monotonic(simData$number_surviving))

table(non_monotone$is_non_monotone)
#> 
#>  0 
#> 30
```

Model fitting:

``` r
stan_data = list(N = nrow(simData),
                 nreplicates = rep(nreplicates_per_dilution, nrow(simData)),
                 survival = simData$number_surviving,
                 dilution = simData$dilution,
                 nsample = max(simData$draw),
                 sample = simData$draw,
                 is_log = 1)

fit <- sampling_stan(standata = stan_data, chains=4, iter = 1000, init = 'random')
```

Summarize the model fitted data:
