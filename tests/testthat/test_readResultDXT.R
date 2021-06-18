test_that("readResultsDXT returns expected", {
  filepath <- "inst/extdata/Tutorial_Model.rsm"
    #"https://github.com/hydrosolutions/RSMinerveR/blob/main/inst/extdata/Tutorial_Model.rsm"
  expect_equal(NULL, readResultDXT(filepath))
})
