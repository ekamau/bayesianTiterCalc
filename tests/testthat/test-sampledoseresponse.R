test_that("sampledoseresponse function works", {
  ndraws = 2; dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
  simD <- sample_dose_response(ndraws, dilutions, nreplicates_per_dilution);

  expect_s3_class(simD, 'data.frame')
})
