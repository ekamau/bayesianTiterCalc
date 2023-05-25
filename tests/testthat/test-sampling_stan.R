ndraws <- 30
dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10)
nreplicates_per_dilution <- 2
sim_data <- sample_dose_response(ndraws, dilutions, nreplicates_per_dilution)

test_that("Sampling works", {
  fit <- fit_stan(data = sim_data, iter = 10, chains = 1);

  expect_type(fit, "S4")
})


test_that("Optimising works", {

  fit <- fit_stan(data = sim_data, is_sampling=FALSE)

  expect_type(fit, "list")
})

test_that("Priors work", {

  fit <- fit_stan(data = sim_data, is_sampling=FALSE)
  a_default <- fit$par$a
  b_default <- fit$par$b
  phi_default <- fit$par$phi[1]

  # higher center prior for a
  prior_a <- list(mu = 1000, sigma=1)
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  prior_a=prior_a)
  a_high <- fit$par$a
  expect_true(a_high > a_default)

  # higher center prior for b
  prior_b <- list(mu = 1000, sigma=1)
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  prior_b=prior_b)
  b_high <- fit$par$b
  expect_true(b_high > b_default)

  # higher phi priors
  prior_phi <- list(mu = 10000, sigma=0.1)
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  prior_phi=prior_phi)
  phi_high <- fit$par$phi[1]
  expect_true(phi_high > phi_default)
})

test_that("fixing a or b works", {
  # fix a
  a_true <- 2
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  a=a_true)
  expect_equal(fit$par$a, a_true)

  # fix b
  b_true <- 2
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  b=b_true)
  expect_equal(fit$par$b, b_true)

  # fix both
  a_true <- 2
  b_true <- 4
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  a=a_true,
                  b=b_true)
  expect_equal(fit$par$a, a_true)
  expect_equal(fit$par$b, b_true)
})

test_that("including ppc works", {

  # by default these probabilities aren't returned
  fit <- fit_stan(data = sim_data, is_sampling=FALSE)
  expect_equal(length(fit$par$prob), 0)

  # including these should be of same length as dataset
  fit <- fit_stan(data = sim_data, is_sampling=FALSE,
                  include_ppc = TRUE)
  n_sims <- dplyr::n_distinct(sim_data$id) * 20 # default num
  expect_equal(length(fit$par$prob), n_sims)
})
