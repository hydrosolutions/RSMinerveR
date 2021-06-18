#' Parse individual blocks of data from lines
#'
#' @param block_lines A bunch of lines read from an RSMinerve .dst simulation output file.
#' @return A tibble with the data from the block.
#'
parse_block <- function(block_lines) {

  # Block name is just first line
  chars <- block_lines[1]
  name <- base::strsplit(chars, "\\|")[[1]][1]
  variable <- base::strsplit(chars, "\\|")[[1]][2]
  variable <- base::gsub("\\\\", ":", variable)

  # Split the array lines by spacing, then use them for a matrix
  mat_strings <- base::strsplit(block_lines[2:base::length(block_lines)], "\\t")

  output <- mat_strings %>%
    purrr::transpose() %>%
    tibble::as_tibble(.name_repair = "unique")
  base::colnames(output) <- base::c("Datetime", "Value")
  output_plus <- output %>%
    tidyr::unnest(c(Datetime, Value)) %>%
    dplyr::mutate(Datetime = lubridate::as_datetime(.data$Datetime,
                                             format = "%d.%m.%Y %H:%M:%S"),
           Value = base::as.numeric(.data$Value),
           Object = name,
           Variable = variable)

  return(output_plus)
}
