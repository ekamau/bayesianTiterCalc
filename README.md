
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

Example of data simulation: 30 serum samples with two replicates per
dilution point.

``` r
library(bayesianTiterCalc)
ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16)
dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2)
head(simData)
#> # A tibble: 6 × 5
#>   dilution number_surviving number_replicates  draw phiValue
#>      <dbl>            <int>             <dbl> <int>    <dbl>
#> 1        8                2                 2     1     5.41
#> 2       16                2                 2     1     5.41
#> 3       32                2                 2     1     5.41
#> 4       64                2                 2     1     5.41
#> 5      128                2                 2     1     5.41
#> 6      256                2                 2     1     5.41
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
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
#> ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
#> ✔ tibble  3.1.8     ✔ dplyr   1.0.9
#> ✔ tidyr   1.2.0     ✔ stringr 1.4.0
#> ✔ readr   2.1.2     ✔ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()

simData %>%
  filter(.data$draw %in% 1:4) %>%
  group_by(.data$draw, .data$dilution) %>%
  summarise(outcome = .data$number_surviving) %>%
  ggplot(aes(x = .data$dilution, y = .data$outcome)) +
    geom_point() +
    scale_x_log10() +
    ylim(0, 2) +
    facet_wrap(~ .data$draw)
#> `summarise()` has grouped output by 'draw'. You can override using the
#> `.groups` argument.
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

Model fitting:

``` r

stan_data = list(N = nrow(simData),
                 nreplicates = rep(2, nrow(simData)),
                 survival = simData$number_surviving,
                 dilution = simData$dilution,
                 nsample = max(simData$draw),
                 sample = simData$draw,
                 is_log = 1)


fit <- sampling_stan(standata = stan_data, chains=4, iter = 1000, init = 'random')
#> 
#> SAMPLING FOR MODEL 'modelwithppc' NOW (CHAIN 1).
#> Chain 1: 
#> Chain 1: Gradient evaluation took 0.000117 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 1.17 seconds.
#> Chain 1: Adjust your expectations accordingly!
#> Chain 1: 
#> Chain 1: 
#> Chain 1: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 1: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 1: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 1: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 1: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 1: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 1: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 1: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 1: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 1: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 1: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 1: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 1: 
#> Chain 1:  Elapsed Time: 0.469873 seconds (Warm-up)
#> Chain 1:                0.4565 seconds (Sampling)
#> Chain 1:                0.926373 seconds (Total)
#> Chain 1: 
#> 
#> SAMPLING FOR MODEL 'modelwithppc' NOW (CHAIN 2).
#> Chain 2: 
#> Chain 2: Gradient evaluation took 6e-05 seconds
#> Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.6 seconds.
#> Chain 2: Adjust your expectations accordingly!
#> Chain 2: 
#> Chain 2: 
#> Chain 2: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 2: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 2: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 2: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 2: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 2: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 2: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 2: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 2: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 2: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 2: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 2: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 2: 
#> Chain 2:  Elapsed Time: 0.558939 seconds (Warm-up)
#> Chain 2:                0.807934 seconds (Sampling)
#> Chain 2:                1.36687 seconds (Total)
#> Chain 2: 
#> 
#> SAMPLING FOR MODEL 'modelwithppc' NOW (CHAIN 3).
#> Chain 3: 
#> Chain 3: Gradient evaluation took 7.5e-05 seconds
#> Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.75 seconds.
#> Chain 3: Adjust your expectations accordingly!
#> Chain 3: 
#> Chain 3: 
#> Chain 3: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 3: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 3: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 3: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 3: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 3: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 3: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 3: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 3: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 3: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 3: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 3: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 3: 
#> Chain 3:  Elapsed Time: 0.672173 seconds (Warm-up)
#> Chain 3:                0.750025 seconds (Sampling)
#> Chain 3:                1.4222 seconds (Total)
#> Chain 3: 
#> 
#> SAMPLING FOR MODEL 'modelwithppc' NOW (CHAIN 4).
#> Chain 4: 
#> Chain 4: Gradient evaluation took 7.2e-05 seconds
#> Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.72 seconds.
#> Chain 4: Adjust your expectations accordingly!
#> Chain 4: 
#> Chain 4: 
#> Chain 4: Iteration:   1 / 1000 [  0%]  (Warmup)
#> Chain 4: Iteration: 100 / 1000 [ 10%]  (Warmup)
#> Chain 4: Iteration: 200 / 1000 [ 20%]  (Warmup)
#> Chain 4: Iteration: 300 / 1000 [ 30%]  (Warmup)
#> Chain 4: Iteration: 400 / 1000 [ 40%]  (Warmup)
#> Chain 4: Iteration: 500 / 1000 [ 50%]  (Warmup)
#> Chain 4: Iteration: 501 / 1000 [ 50%]  (Sampling)
#> Chain 4: Iteration: 600 / 1000 [ 60%]  (Sampling)
#> Chain 4: Iteration: 700 / 1000 [ 70%]  (Sampling)
#> Chain 4: Iteration: 800 / 1000 [ 80%]  (Sampling)
#> Chain 4: Iteration: 900 / 1000 [ 90%]  (Sampling)
#> Chain 4: Iteration: 1000 / 1000 [100%]  (Sampling)
#> Chain 4: 
#> Chain 4:  Elapsed Time: 0.632041 seconds (Warm-up)
#> Chain 4:                0.448915 seconds (Sampling)
#> Chain 4:                1.08096 seconds (Total)
#> Chain 4:
#> Warning: There were 1548 divergent transitions after warmup. See
#> https://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
#> to find out why this is a problem and how to eliminate them.
#> Warning: Examine the pairs() plot to diagnose sampling problems
#> Warning: Bulk Effective Samples Size (ESS) is too low, indicating posterior means and medians may be unreliable.
#> Running the chains for more iterations may help. See
#> https://mc-stan.org/misc/warnings.html#bulk-ess
#> Warning: Tail Effective Samples Size (ESS) is too low, indicating posterior variances and tail quantiles may be unreliable.
#> Running the chains for more iterations may help. See
#> https://mc-stan.org/misc/warnings.html#tail-ess
```

Summarize the model fitted data:

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
