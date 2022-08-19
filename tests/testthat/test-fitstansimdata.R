test_that("multiplication works", {
  phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2, phi_Vals);

  iter = 100; chains = 1;
  fit <- fitStanSimData(simData, iter, chains);

  expect_s4_class(fit, 'stanfit')
})
