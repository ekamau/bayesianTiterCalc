test_that("simulate_dose_response() works", {
  dilutions <- vector();
  for(i in 3:10){j <- 2^i; dilutions <- c(dilutions, j)};
  expect_s3_class(simulate_dose_response(dilutions, 42, 4, 0.3, 2), 'data.frame')
})
