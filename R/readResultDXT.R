#' Reading RSMinerve result file
#'
#' @param filepath String with path to file to be read.
#' @param chunk_size Numeric telling how many lines to read for each model component.
#' @return tibble with time series of simulation results for all model components.
#' @examples
#' filepath <- normalizePath(file.path("Tutorial01-results.dst"))
#' chunk_size <- getChunkSize(
#'   lubridate::as_datetime("09.02.2013 00:00:00",format = "%m.%d.%Y %H:%M:%S"),
#'   lubridate::as_datetime("09.09.2013 00:00:00", format = "%m.%d.%Y %H:%M:%S"),
#'   3600
#' )
#' result <- readResultDXT(filepath, chunk_size)
#' @export
readResultDXT <- function(filepath, chunk_size) {

  if (base::file.exists(filepath)) {

    # Replace fileending
    filepath <- gsub("dsx", "dst", filepath)

    # Read the number of lines in the file
    nlines_tot <- R.utils::countLines(filepath)[1]
    no_chunks <- nlines_tot / chunk_size

    if (no_chunks != base::round(no_chunks)) {
      base::cat("Error reading lines from file.")
      return(NULL)
    }

    conn <- base::file(filepath, open = "r")
    output <- NULL

    for (i in c(1:no_chunks)) {
      cat("Reading chunk", i, "of", no_chunks)
      next_chunk <- base::readLines(conn, n = chunk_size)
      output <- base::rbind(output, RSMinerveR::parse_block(next_chunk))
    }

    base::close.connection(conn)

    return(output)

  } else {

    base::cat("Error: File", filepath, "not found.")
    return(NULL)

  }
}
