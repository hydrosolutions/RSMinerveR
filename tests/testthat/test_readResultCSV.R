test_that("readResultsCSV returns expected", {
  filepath <- normalizePath(file.path("test_readResultCSV.csv"))
  result <- readResultCSV(filepath)

  # expect_false(is.null(result))
  #
  # testvalue <- result %>%
  #   dplyr::filter(Variable == "Station:ETP",
  #                 Object == "Estacion SOCONT 3",
  #                 Datetime == lubridate::as_datetime("2013-09-09 00:00:00"))
  #
  # expect_equal(12168, dim(result)[1])
  # expect_equal(4, dim(result)[2])
  # expect_equal(0, testvalue$Value)

})
