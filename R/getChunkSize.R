#' Calculate the number of time steps to read for each model component.
#'
#' RSMinerve result files can be stored in .dst files where time series of each
#' model component are stored in rows. \code{getChunkSize} can be used to
#' determine the chunk size of each model output.
#'
#' @param start_date Lubridate datetime of the start of the simulation
#' @param end_date Lubridate datetime of the end of the simulation
#' @param recordingTimeStep The simulations recording time step (in seconds) in character or as numeric.
#' @return A numeric of the number of time steps, including one header line, to be read.
#' @examples
#' start_date <- lubridate::as_datetime("01.20.2021 00:00:00",
#'                                      format = "%m.%d.%Y %H:%M:%S")
#' end_date <- lubridate::as_datetime("01.25.2021 00:00:00",
#'                                    format = "%m.%d.%Y %H:%M:%S")
#' recordingTimeStep <- 3600  # In seconds
#' chunk_size <- getChunkSize(start_date, end_date, recordingTimeStep)
#' @export
getChunkSize <- function(start_date, end_date, recordingTimeStep) {
  chunk_size <- lubridate::interval(start_date, end_date) /
    lubridate::seconds(1) / as.numeric(recordingTimeStep) + 2
}
