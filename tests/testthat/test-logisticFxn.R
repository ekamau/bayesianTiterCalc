test_that("logistic() works", {
  a = 4; b = 0.3; concentration = 12.6;
  expect_equal(logistic(concentration, a, b), 0.9995822, tolerance=1e-3)
})
