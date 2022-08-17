test_that("nonmonotic function works", {
  x <- c(2,2,2,2,0,0,0,0);
  expect_equal(non_monotonic(x), 0)
})
