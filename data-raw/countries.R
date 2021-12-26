pd_countries <- jsonlite::fromJSON("https://api.unhcr.org/population/v1/regions/")$items
pd_countries <- dplyr::transmute(pd_countries, 
                                 bureau = name,
                                 countries = purrr::map(id, ~jsonlite::fromJSON(glue::glue("https://api.unhcr.org/population/v1/countries/",
                                                                                           "?type=coo&dataset=population&unhcr_region[]={.}"))$items))
pd_countries <- tidyr::unnest(pd_countries, countries)
pd_countries <- dplyr::select(pd_countries, -`0`, -id)

usethis::use_data(pd_countries, overwrite = TRUE)
