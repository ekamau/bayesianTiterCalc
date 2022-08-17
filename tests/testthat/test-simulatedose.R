test_that("simulate_dose_response() works", {
  dilutions <- vector();
  for(i in 3:10){j <- 2^i; dilutions <- c(dilutions, j)};
  expect_equal(
    simulate_dose_response(dilutions, 42, 4, 0.3, 2), tidyr::as_tibble(data.frame(dilution = c(8,16,32,64,128,256,512,1024),
                                                                       number_surviving = rep(2,length(dilutions)),
                                                                       number_replicates = rep(2,length(dilutions))))
  )
})
