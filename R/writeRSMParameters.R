#' Write parameters to RS Minerve parameter file
#'
#' @param parameters Tibble with parameters for each RS Minerve object. Multiple parameter sets may be possible. See Details & Examples for more info on the column requirements.
#' @param outfilepath Character string with path to file to be written.
#' @return NULL for success.
#' @details `parameters` contains 5 columns:
#'            `Object` (character) identifying the RSMinerve object type (e.g. Station). See Vignette Parameters for more information on the objects available in RSMinerveR.
#'            `Name` is the user specified name of the object in the RSMinerve model (e.g. Meteo station A).
#'            `Parameters` names all parameters for each object (e.g. Zone, X [m], Y [m], etc.). See Vignette Parameters for more information on the parameters of the available objects in RSMinerveR.
#'            `Values` contains the parameter values (e.g. "A", 4500, 3000).
#'            `Parameter set` is used to differentiate between multiple parameter sets. The function will write length(unique(parameters$`Parameter set`)) parameter files, appending the value of Parameter set to the base file name.
#' @examples
#' To be written
#' @export
writeRSMParameters <- function(parameters, outfilepath) {

  # Test if multiple parameter files need to be written
  if ( base::length(base::unique(params$`Parameter set`)) > 1 ) {

  }

  return(NULL)
}
