#' Reads climate and discharge data into a tibble.
#'
#' The data is in a csv file that can also be imported to RS Minerve to form a database.
#'
#' @param filename Path to file with input data for RS Minerve.
#' @return Returns a tibble of the same format as \code{data} with data
#'         in hourly (climate) to decadal or monthly (discharge) time steps.
#'         Includes all attributes of the csv file
#' @export

read_minerve_forcing_csv <- function(filename) {

  # Read Metadata from file, write column headers and determine column types.
  header <- readr::read_csv(filename, col_names = FALSE, skip = 0, n_max = 7)
  colnames(header) <- paste(header[1, ], header[2, ], header[3, ], header[4, ],
                            header[5, ], header[6, ], header[7, ], sep = "-")
  colnames(header)[1] <- "Date"
  Nsb <- dim(header)[2] - 1  # Number of sub-basins in data table
  coltypes <- paste("c", strrep("n", times = Nsb), sep = "")

  data <- readr::read_csv(filename, col_names = colnames(header), skip = 8,
                          col_types = coltypes)
  date_vec <- lubridate::as_datetime(data$Date, format = "%d.%m.%Y %H:%M:%S")
  if (is.na(date_vec[1])) {
    date_vec <- lubridate::as_datetime(data$Date, format = "%d.%m.%y %H:%M")
  }
  if (is.na(date_vec[1])) {
    date_vec <- lubridate::as_datetime(data$Date, format = "%Y-%m.%d %H:%M:%S")
  }
  data$Date <- date_vec

  # Reformat data table and drop superfluous rows
  data_long <- tidyr::pivot_longer(data, -.data$Date,
                                   names_to = c("Station", "X", "Y", "Z", "Sensor",
                                                "Category", "Unit"),
                                   names_sep = "\\-", values_to = "Value",
                                   values_drop_na = TRUE)

  return(data_long)

}
