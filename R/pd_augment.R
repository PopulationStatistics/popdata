#' Augment data-frame with country to region mapping using he country code package
#'
#' Augment data-frame with country metadata using country code package - 
#' https://github.com/vincentarelbundock/countrycode/blob/848e9ce363026c98a38daac9777005925f18f582/dictionary/get_unhcr.R  
#'
#' @param data tibble, dataset to augment - 
#'               previously obtained from `pd_asr` or `pd_mysr` 
#' @param expand indicating either "asylum" or "origin" 
#'             
#'
#' @return a tibble
#'
#' @importFrom dplyr left_join select relocate rename_with
#' @importFrom stringr str_c
#' @importFrom countrycode countrycode
#' @importFrom rlang `:=` .data
#'
#' @export
pd_augment <- function(data, expand ) {
  
  ## Apply mapping
  data$unhcr.region <- countrycode::countrycode(sourcevar = data[[expand]], 
                                   origin = 'unhcr', 
                                   destination = 'unhcr.region')
  data$country.name <- countrycode::countrycode(sourcevar = data[[expand]], 
                            origin = 'unhcr', 
                            destination = 'country.name')
  
  ## Resort the column
  data <- dplyr::relocate(data, .data$unhcr.region,  .data$country.name, 
                   .before = {{expand}})
  
  ## Renaming the column
  data <- dplyr::rename_with(data, ~ stringr::str_c(expand, ., sep = "_"), .data$unhcr.region)
  data <- dplyr::rename_with(data, ~ stringr::str_c(expand, ., sep = "_"), .data$country.name)
  
  return(data)
}