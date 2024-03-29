% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulatedose.R
\name{simulate_dose_response}
\alias{simulate_dose_response}
\title{simulation function}
\usage{
simulate_dose_response(dilutions, phi, a, b, nreplicates, is_log = FALSE)
}
\arguments{
\item{dilutions}{Numeric vector {8, 16, 32, 64, 128, 256, 512, 1024}.}

\item{phi}{Model estimate.}

\item{a}{Model estimate.}

\item{b}{Model estimate.}

\item{nreplicates}{Number of replicates at each dilution (by default value of 2).}

\item{is_log}{Is logistic function on log-concentration scale? (by default False).}
}
\value{
A numeric vector of length 8
}
\description{
simulation function
}
\examples{
dilutions <- vector()
for(i in 3:10){j <- 2^i; dilutions <- c(dilutions, j)};
phi = 42; a = 4; b = 1.2; nreplicates = 2
simulate_dose_response(dilutions, phi, a, b, nreplicates)

}
