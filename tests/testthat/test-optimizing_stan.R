test_that("Stan model function works", {
<<<<<<< HEAD
  ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower = 0.75, upper = 16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
  simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution);
=======
  ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(lower=0.75, upper=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2);
>>>>>>> 56e38b656833ad7b39168f00a1c8eea377a05719
  stan_data = list(N = nrow(simData),
                   nreplicates = rep(nreplicates_per_dilution, nrow(simData)),
                   survival = simData$number_surviving,
                   dilution = simData$dilution,
                   nsample = max(simData$draw),
                   sample = simData$draw,
                   is_log = 1)

  fit <- optimizing_stan(standata = stan_data, iter=100, init = 'random');

  expect_type(fit, "list")
})
