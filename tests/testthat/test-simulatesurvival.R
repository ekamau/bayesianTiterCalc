test_that("simulate_cell_survival() works", {
  phi = 42; dilution = 16; a = 4; b = 0.3; nreplicates = 2;
  concentration = phi/dilution;
  probability = 1 / (1 + exp(-(a + b * concentration)));
  rbinom(1, nreplicates, probability);

  expect_equal(simulate_cell_survival(dilution, phi, a, b, 2), 2)
})


