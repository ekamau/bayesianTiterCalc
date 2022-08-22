
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayesianTiterCalc

<!-- badges: start -->
<!-- badges: end -->

bayesianTiterCalc is a Bayesian inference method that calculates a serum
sample’s antibody concentration and titer based on data from a standard
neutralization assay. The method uses a logistic function in a
statistical model to simulate mortality in cell culture as a function of
antibody concentration. Given the limited information per sample that’s
inherent in the experimental design of neutralization assays (number of
replicates per dilution and number of dilutions), the advantage of
Bayesian inference here is the use of probability distributions to
incorporate uncertainty in the outcome.

## Installation

You can install the development version of bayesianTiterCalc from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ekamau/bayesianTiterCalc")
```

## Usage

What to do with the package The most common output of a serum
neutralization assay is the calculation of endpoint antibody titer. For
this, (1) How to calculate endpoint antibody titer and concentration (2)
How to simulate data (3) what other output do we need?

Example of data simulation: 30 serum samples with two replicates per
dilution point.

``` r
library(bayesianTiterCalc)
phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; 
prior_phi <- list(n=0.75, m=16)
dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)

simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, 
                                nreplicates_per_dilution=2, phi_Vals)
head(simData)
#> # A tibble: 6 × 4
#>   dilution number_surviving number_replicates  draw
#>      <dbl>            <int>             <dbl> <int>
#> 1        8                2                 2     1
#> 2       16                2                 2     1
#> 3       32                2                 2     1
#> 4       64                2                 2     1
#> 5      128                2                 2     1
#> 6      256                2                 2     1
table(simData$number_surviving)
#> 
#>   2 
#> 240
```

The function *sample_dose_response* samples from a uniform distribution
{a, b} and calls the *simulate_dose_response* function.

Plot four simulated samples to see how they look like and if they
resemble the actual data:

``` r
simData.plot(simData, 4)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

Check if simulated data is non monotonic, i.e., mortality of cell
cultures increases with higher serum dilutions. Non-monotonic data would
show ‘accidental’ death or survival of cell cultures in between dilution
levels. In the *table* output, ‘0’ and ‘1’ represents monotonic and
non-monotonic data points, respectively.

``` r
non_monotone <- check_monotone(simData)
table(non_monotone$is_non_monotone)
#> 
#>  0 
#> 30
```

Prepare data for analysis with Stan:

``` r
stan_data <- list(
  N = nrow(simData),
  nreplicates = rep(2, nrow(simData)),
  survival = simData$number_surviving,
  dilution = simData$dilution,
  nsample = max(simData$draw),
  sample = simData$draw,
  is_log = 1
)
```

Call Stan:

``` r
library(rstan)
#> Loading required package: StanHeaders
#> Loading required package: ggplot2
#> rstan (Version 2.21.5, GitRev: 2e1f913d3ca3)
#> For execution on a local, multicore CPU with excess RAM we recommend calling
#> options(mc.cores = parallel::detectCores()).
#> To avoid recompilation of unchanged Stan programs, we recommend calling
#> rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE, javascript=FALSE)

iter = 100; chains = 1;
#fit <- fitStanSimData(simData, iter, chains)
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
