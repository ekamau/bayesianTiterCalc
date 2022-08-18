test_that("sample dose response function works", {
  phi_Vals <- c(); ndraws = 2; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  simD <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2, phi_Vals);

  expect_s3_class(simD, 'data.frame')
})
