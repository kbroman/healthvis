test_that("corrScatterVis works on gae dev server", {
  testData <- t(t(matrix(rnorm(100*50), ncol=50) + rnorm(100))*sample(c(-1,1), 50, replace=TRUE))
  visCorrScatter <- corrScatterVis(testData, gaeDevel=TRUE)
  expect_that(visCorrScatter@serverID!="error", is_true())
})
