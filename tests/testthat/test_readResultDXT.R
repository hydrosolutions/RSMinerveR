test_that("readResultsDXT returns expected", {
  filepath <- normalizePath(file.path("Tutorial01-results.dst"))
  start_date <- "09.02.2013 00:00:00"  # format = "%m.%d.%Y %H:%M:%S"
  end_date <- "09.09.2013 00:00:00"  # format = "%m.%d.%Y %H:%M:%S"
  recordingTimeStep <- "3600"
  chunk_size <- getChunkSize(
    lubridate::as_datetime(start_date,format = "%m.%d.%Y %H:%M:%S"),
    lubridate::as_datetime(end_date, format = "%m.%d.%Y %H:%M:%S"),
    recordingTimeStep
  )

  result <- readResultDXT(filepath, chunk_size)

  expect_false(is.null(result))

  testvalue <- result %>%
    dplyr::filter(Variable == "Station:ETP",
                  Object == "Estacion SOCONT 3",
                  Datetime == lubridate::as_datetime("2013-09-09 00:00:00"))

  expect_equal(12168, dim(result)[1])
  expect_equal(4, dim(result)[2])
  expect_equal(0, testvalue$Value)

})
