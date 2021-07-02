#' Reads RS Minerve result file and returns data.
#'
#' @param filename Path to file to be read. It is any csv file that is written by saving data from the Selection and plots tab in RSMinerve to a csv file.
#' @return data Tibble with data from file
#' @note An example RSMinerve results csv file is available under \url{http://raw.githubusercontent.com/hydrosolutions/RSMinerveR/main/tests/testthat/test_translateCSVtoDST.csv}. If the function generates funny numbers, please check the csv file. The decimal separators must be \code{.} and not \code{,}. If you find commas please change the settings of your PC (Control Panel, Clock and Region, Region, Additional settings, select \code{.} for the Decimal symbol, press "Apply" and close the Control Panel windows. and RSMinerve will write \code{,}.
#' @export
#'
readResultCSV <- function(filename) {
  data <- readr::read_csv(filename, skip = 1, col_names = T)
  colnames(data)[1] <- "date"
  data$date <- as.POSIXct(data$date, format = "%d.%m.%Y %H:%M:%S")
  data <- data |>
    dplyr::mutate(dplyr::across(-.data$date, ~base::as.numeric(.))) |>
    tidyr::pivot_longer(-.data$date, names_to = c("model", "variable"),
                        values_to = "value", names_sep = "( - )") |>
    tidyr::separate(.data$variable, into = c("variable", "unit"), sep = "\\s")
  return(data)
}
