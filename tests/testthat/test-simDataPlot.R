test_that("simData.plot works", {
  phi_Vals <- c(); ndraws = 30; a = 8.5; b = 2.5; prior_phi <- list(n=0.75, m=16);
  dilutions <- 2^c(3, 4, 5, 6, 7, 8, 9, 10);
  n = 4;
  simData <- sample_dose_response(ndraws, prior_phi, a, b, dilutions, nreplicates_per_dilution=2, phi_Vals)

  expect_equal(simData %>%
                 filter(draw %in% 1:n) %>%
                 group_by(draw, dilution) %>%
                 summarise(outcome=number_surviving) %>%
                 ggplot(aes(x=dilution, y=outcome)) +
                 geom_point() +
                  scale_x_log10() +
                  ylim(0, 2) +
                  facet_wrap(~draw),
               simData.plot(simData, n))
})
