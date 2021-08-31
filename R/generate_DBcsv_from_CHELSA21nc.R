#' Extract hourly time series from pre-cut CHELSA V2.1 raster bricks
#'
#' Function extracts precipitation (pr) or temperature (tas) data from raster
#' bricks and prepares a dataframe for later import in RSMinerve. Use
#' write.table() function to export as csv.
#'
#' @param CHELSA21_dir Path to CHELSA precipitation or temperature nc files
#'    which have been clipped to the bounding box of the catchment of interest.
#' @param data_type Specifies the variable to extract. Precipitation data :
#'    data_type = "pr" or temperature data: data_type = "tas".
#' @param HRU Vector object (multi-polygons) with hydrological response units
#'    for which the CHELSA V2.1 data should be extracted.
#' @param HRU_name_column (string) Name of the column in HRU with unique names
#'    for the hydrological response units. These names will be used as
#'    identifiers in RSMinerve.
#' @param start_year First year for which data should be made available
#'   (assuming data 'is' available from the start of that year)
#' @param end_year Last year from which data should be extracted (assuming data 'is' actually available until the end of that year)
#' @return Dataframe tibble with temperature in deg. C. and/or precipitation in
#'    mm/h
#' @note Acknowledgement: This function builds on
#'   hydrosolutions/riversCentralAsia::generate_ERA5_Subbasin_CSV
#' @details The CHELSA V2.1 raster bricks should be clipped to the bounding box
#'   of the catchment to be modelled for higher speed. The clipping can be done
#'   efficiently in cda (to do: Write a vignette on how to use cda for this). The
#'   CHELSA V2.1 nc files contain precipitation or temperature data for each
#'   raster point and each day of one year between 1979 and 2018. In some
#'   areas of Central Asia, the quality of the ERA5 product underlying the
#'   CHELSA v2.1 data set is not sufficient and only data until 2011 should be
#'   used. Please validate the CHELSA V2.1 data set prior to using it for
#'   modelling.
#' @export
#'
generate_DBcsv_from_CHELSA21nc <- function(CHELSA21_dir, data_type, HRU,
                                           HRU_name_column, start_year, end_year) {

  # Generate file list to load
  yrs <- start_year:end_year

  if (data_type == "pr") {
    filelist <- base::list.files(path = CHELSA21_dir, "_pr_", full.names = TRUE)
    if (purrr::is_empty(filelist)) {
      cat("ERROR: No precipitation data to read. \n")
      return(NULL)
    }
  } else if (data_type == "tas") {
    filelist <- base::list.files(path = CHELSA21_dir, "_tas_", full.names = TRUE)
    if (purrr::is_empty(filelist)) {
      cat("ERROR: No temperature data to read. \n")
      return(NULL)
    }
  } else {
    cat("Error: unrecognized data_type \"", paste(data_type), "\".\n")
    return(NULL)
  }
  # Only keep the years the user is interested in
  filelist <- filelist[base::sapply(paste0("_", base::as.character(yrs), "_55"),
                                    base::grep, filelist)]

  # Since the CHELSA V2.1 data is in +longlat, ensure HRU is in the same crs.
  HRU <- sf::st_transform(HRU,crs = sf::st_crs(4326))

  namesHRU <- c(HRU[[HRU_name_column]])
  # Fancy trick to generate an empty dataframe with column names from a vector
  # of characters.
  dataHRU_df <- namesHRU |>
    purrr::map_dfc(stats::setNames, object = base::list(base::numeric()))
  dates_vec <- c("Date") |>
    purrr::map_dfc(stats::setNames, object = base::list(base::character()))
  # Now, loop through the subbasins, one by one.
  for (yr in 1:length(filelist)){
    base::print(base::paste0('Processing File: ', filelist[yr]))
    raw_data <- raster::brick(filelist[yr])
    hru_data <- raster::extract(raw_data, HRU) |>
      base::lapply(colMeans, na.rm = TRUE)
    hru_data <- hru_data |> tibble::as_tibble(.name_repair = "unique")
    temp_dates_vec <- tibble::tibble(Date = base::as.character(raw_data@z$Date))
    base::names(hru_data) <- base::names(dataHRU_df)
    dataHRU_df <- dataHRU_df |> tibble::add_row(hru_data)
    dates_vec <- dates_vec |> tibble::add_row(temp_dates_vec)
  }

  # Now, solve that obnoxious time formatting problem for compatibility with
  # RSMinerve (see function posixct2rsminerveChar() for more details)
  datesChar <- riversCentralAsia::posixct2rsminerveChar(dates_vec$Date)
  datesChar <- datesChar |> dplyr::rename(Station = .data$value)

  # Final data tibble
  dataHRU_df_data <- dataHRU_df |> dplyr::mutate_all(as.character)
  dataHRU_df_data <- base::cbind(datesChar, dataHRU_df) |> tibble::as_tibble()

  # Construct csv-file header.  See the definition of the RSMinerve .csv database file at:
  # https://www.youtube.com/watch?v=p4Zh7zBoQho
  dataHRU_df_header_Station <-
    tibble::tibble(Station = c('X', 'Y', 'Z', 'Sensor', 'Category', 'Unit',
                               'Interpolation'))
  dataHRU_df_body <- namesHRU |>
    purrr::map_dfc(stats::setNames, object = base::list(base::logical()))

  # get XY (via centroids) and Z (mean alt. band elevation)
  HRU_XY <- sf::st_transform(HRU, crs = sf::st_crs(32642)) |>
    sf::st_centroid() |>
    sf::st_coordinates() |>
    tibble::as_tibble()
  HRU_Z <- HRU$Z |>
    tibble::as_tibble() |>
    dplyr::rename(Z = .data$value)
  HRU_XYZ <- base::cbind(HRU_XY, HRU_Z) |>
    base::as.matrix() |>
    base::t() |>
    tibble::as_tibble() |>
    dplyr::mutate_all(as.character)
  base::names(HRU_XYZ) <- base::names(dataHRU_df_body)

  # Sensor (P or T), Category, Unit and Interpolation
  nBands <- base::dim(HRU_XYZ)[2]
  if (data_type == "pr"){
    sensorType <- "P" |> base::rep(nBands)
    category <- "Precipitation" |> base::rep(nBands)
    unit <- "mm/d" |> base::rep(nBands)
    interpolation <- "Linear" |> base::rep(nBands)
    sensor <- base::rbind(sensorType, category, unit, interpolation) |>
      tibble::as_tibble()
  } else if (data_type == "tas") {
    sensorType <- "T" |> base::rep(nBands)
    category <- "Temperature" |> base::rep(nBands)
    unit <- "C" |> base::rep(nBands)
    interpolation <- "Linear" |> base::rep(nBands)
    sensor <- base::rbind(sensorType, category, unit, interpolation) |>
      tibble::as_tibble()
  } else {
    cat("ERROR data_type", data_type, "not found. ")
    return(NULL)
  }
  base::names(sensor) <- base::names(dataHRU_df_body)
  # Put everything together
  file2write <- HRU_XYZ |> tibble::add_row(sensor)
  file2write <- dataHRU_df_header_Station |> tibble::add_column(file2write)
  file2write <- file2write |>
    tibble::add_row(dataHRU_df_data |>
                      dplyr::mutate_all(as.character))
  file2write <- base::rbind(base::names(file2write), file2write)
  base::return(file2write)

}
