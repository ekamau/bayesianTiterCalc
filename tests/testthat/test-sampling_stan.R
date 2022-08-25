test_that("Stan model function works", {
  ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2);
  stan_data = list(N = nrow(simData),
                   nreplicates = rep(2, nrow(simData)),
                   survival = simData$number_surviving,
                   dilution = simData$dilution,
                   nsample = max(simData$draw),
                   sample = simData$draw,
                   is_log = 1)

  fit <- sampling_stan(standata = stan_data, iter=100, chains=1, init = 'random');

  expect_type(fit, "S4")
})
