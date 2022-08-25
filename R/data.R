#' Example of serum neutralization data.
#'
#' A dataset containing the output of virus neutralization at eight serum dilutions. The data contains results from 10
#' serum samples.
#'
#' @format A data frame with 80 rows and 9 variables
#' \describe{
#'   \item{sampleID}{sample ID}
#'   \item{Age}{Age of individual}
#'   \item{Year}{Year of sample collection}
#'   \item{titer}{Antibody titer as calculated conventionally}
#'   \item{rep1}{Outcome of assay in first replicate, '1' for alive, '0' for dead}
#'   \item{rep2}{Outcome of assay in second replicate, '1' for alive, '0' for dead}
#'   \item{outcome}{sum of rep 1 and rep2}
#'   \item{dilutions}{serum dilution, per sample}
#'   ...
#' }
#' @source Data generated using a method described in \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8386771/}
#'
"evTitrations"

#' Reed and Muench titration data.
#'
#' A dataset containing the serum titration data as published in the Reed and Muench paper, 1938.
#'
#' @format A data frame with 9 rows and 4 variables
#' \describe{
#'   \item{dilution}{serum dilution}
#'   \item{Alive}{Number of animals surviving}
#'   \item{Dead}{Number of animals dead}
#'   \item{Survival}{Percentage of samples that survive at each dilution}
#'   ...
#' }
#' @source A Simple Method of Estimating Fifty Per Cent Endpoints, The American Journal of Hygiene, 1938
#'
"reedmuenchTitrations"
