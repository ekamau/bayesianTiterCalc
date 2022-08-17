
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayesianTiterCalc

<!-- badges: start -->
<!-- badges: end -->

Serum neutralizing antibody titer is approximated as the highest serum
dilution that prevents virus infection of 50% of replicate inoculations.
bayesianTiterCalc is a Bayesian inference method that calculates a serum
sample’s antibody concentration and titer based on data from a standard
neutralization assay. The method uses a logistic function in a
statistical model to simulate mortality in cell culture as a function of
antibody concentration and was used with data on virus infection
challenge reported in Reed-Muench’s seminal paper in 1938 \[1\] as a
proof of concept. The method could reasonably fits the Reed-Muench’s
titration data at each serum dilution and reliably estimates the
endpoint protective antibody titer (dilution which prevents infection of
50% inoculated animals). Given the limited information per sample that’s
inherent in the experimental design of neutralization assays (number of
replicates per dilution and number of dilutions), the advantage of the
Bayesian inference method is that it incorporates uncertainty in the
outcome.

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
How to simulate data (3) what other output do we need? This is a basic
example which shows you how to solve a common problem:

``` r
library(bayesianTiterCalc)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
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
