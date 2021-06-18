test_that("getChunkSize returns as expected", {
  start_date <- lubridate::as_datetime("01.20.2021 00:00:00",
                                       format = "%m.%d.%Y %H:%M:%S")
  end_date <- lubridate::as_datetime("01.25.2021 00:00:00",
                                     format = "%m.%d.%Y %H:%M:%S")
  recordingTimeStep <- 3600
  expect_equal(122, getChunkSize(start_date, end_date, recordingTimeStep))
})
