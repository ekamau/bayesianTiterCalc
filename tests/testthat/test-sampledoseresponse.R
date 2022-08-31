test_that("sampledoseresponse function works", {
<<<<<<< HEAD
  ndraws = 2; a = 8.5; b = 2.5; prior_phi <- list(lower = 1.75, upper = 16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
  simD <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution);
=======
  ndraws = 2; a = 8.5; b = 2.5; prior_phi <- list(lower=0.75, upper=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  simD <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2);
>>>>>>> 56e38b656833ad7b39168f00a1c8eea377a05719

  expect_s3_class(simD, 'data.frame')
})
