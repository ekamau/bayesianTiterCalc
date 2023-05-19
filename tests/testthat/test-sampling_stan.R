test_that("Stan model function works", {
  ndraws = 30; dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10); nreplicates_per_dilution = 2
  sim_data <- sample_dose_response(ndraws, dilutions, nreplicates_per_dilution);

  fit <- fit_stan(data = sim_data, iter = 10, chains = 1);

  expect_type(fit, "S4")
})
