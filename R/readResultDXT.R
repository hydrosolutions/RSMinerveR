#' Reading RSMinerve result file
#'
#' @param filepath String with path to file to be read.
#' @param chunk_size Numeric telling how many lines to read for each model component.
#' @return tibble with time series of simulation results for all model components.
#' @export
readResultDXT <- function(filepath, chunk_size) {
  #conn <- base::file(filepath, open = "r")
  #block_count <- base::scan(conn, nlines = 1)
  #block_count
  if (base::file.exists(filepath)) {
    # Read the number of lines in the file
    nlines_tot <- R.utils::countLines(filepath)[1]
    #raw <- readr::read_delim_chunked(filepath, chunk_size = chunk_size,
    #                                 delim = " ", col_types = "Dtn",
    #                                 col_names = c("Date", "Time", "Value"))
    return(NULL)
  } else {
    base::cat("Error: File", filepath, "not found.")
    return(NULL)
  }
}
