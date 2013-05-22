test_that("manyboxVis works on gae dev server", {
  testData <- t(matrix(rnorm(10000*100), nrow=100) + runif(100, 0, 2))
  vismManyBox <- manyboxVis(testData, gaeDevel=TRUE)
  expect_that(visManyBox@serverID!="error", is_true())
})
