test_that("read parameters correctly", {
  filepath <- normalizePath(file.path("Tutorial_Parameters.txt"))
  testvar <- readRSMParameters(filepath)
  val1 <- testvar %>% dplyr::filter(Object == "Comparator") %>%
    dplyr::select(Values)
  expect_equal("A", val1$Values)
})
