#' Convenience functions to tidy popdata tables
#' 
#' Convenience functions to tidy popdata tables
#' 
#' @rdname tidiers
#' 
#' @param data tibble, result of a call to `popdata()` or one of its wrappers.
#' 
#' @return a tibble
#' 
#' @export
pd_demo_tidy <- function(data) {
  assisted <-
    data |> 
    dplyr::select(-tidyselect::contains("total"), -typeOfAggregation, total = unhcrTotal) |> 
    dplyr::mutate(measure = "UnhcrAssisted")
  
  data <- 
    data |> 
    dplyr::select(-unhcrTotal) |> 
    tidyr::pivot_longer(tidyselect::contains("total"), 
                        names_to = c("sex", "ageRange"),
                        names_pattern = "total(Male|Female)_?(.+)", 
                        values_to = "total")
  
  total <- 
    data |> 
    dplyr::filter(typeOfAggregation == "Total", 
                  is.na(sex), 
                  is.na(ageRange))
  
  mf <- 
    data |> 
    dplyr::filter(typeOfAggregation == "M/F", 
                  !is.na(sex), 
                  ageRange == "Total") |> 
    dplyr::mutate(ageRange = NA_character_)
  
  mf1859 <- 
    data |> 
    dplyr::filter(typeOfAggregation == "M/F and 18-59",
                  !is.na(sex),
                  ageRange %in% c("0_4", "5_11", "12_17", "18_59", "60", "AgeUnknown")) |> 
    dplyr::filter(!(ageRange == "AgeUnknown" & total == 0)) |> 
    dplyr::mutate(ageRange = dplyr::na_if(ageRange, "AgeUnknown"))
  
  detailed <- 
    data |> 
    dplyr::filter(typeOfAggregation == "Detailed",
                  !is.na(sex),
                  ageRange %in% c("0_4", "5_11", "12_17", "18_24", "25_49", "50_59", "60", "AgeUnknown")) |> 
    dplyr::filter(!(ageRange == "AgeUnknown" & total == 0)) |> 
    dplyr::mutate(ageRange = dplyr::na_if(ageRange, "AgeUnknown"))
  
  list(total, mf, mf1859, detailed, assisted) |> 
    dplyr::bind_rows() |> 
    dplyr::mutate(ageRange = dplyr::case_when(ageRange == "60" ~ "60+",
                                              TRUE ~ stringr::str_replace(ageRange, "_", "-")),
                  measure = tidyr::replace_na(measure, "Total"),
                  total = tidyr::replace_na(total, 0))
}

#' @rdname tidiers
#' @export
pd_ref_stock <- function(data) {
  data |> 
    dplyr::select(asylum, origin, 
                   yearStartTotal, yearStartTotalUnhcrAssisted, 
                   yearEndTotal, yearEndUASCTotal, yearEndTotalUnhcrAssisted,
                   source, basis) |> 
    tidyr::pivot_longer(yearStartTotal:yearEndTotalUnhcrAssisted,
                        names_to = c("timePeriod", "measure"),
                        names_pattern = "(yearStart|yearEnd)(.+)",
                        values_to = "total")
}

#' @rdname tidiers
#' @export
pd_ref_flows <- function(data) {
  data |> 
    dplyr::select(asylum, origin,
                  groupRecognition:increasesOther,
                  decreasesVoluntaryRepatriationTotal:decreasesOther,
                  source, basis) |> 
    tidyr::pivot_longer(groupRecognition:decreasesOther,
                        names_to = c("flowType", "measure"),
                        names_pattern = "(.*?)(Total.*)?$",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure),
                  flowDirection = 
                    dplyr::if_else(flowType %in% c("groupRecognition", 
                                                   "temporaryProtection", 
                                                   "individualRecognition",
                                                   "resettlementArrivals",
                                                   "births",
                                                   "increasesOther"),
                                   1, -1))
}

#' @rdname tidiers
#' @export
pd_ref_uasc_byage <- function(data) {
  data |> 
    dplyr::select(asylum, origin,
                  yearEndUASC_0_4, yearEndUASC_5_11, yearEndUASC_12_14, yearEndUASC_15_17,
                  source, basis) |> 
    tidyr::pivot_longer(tidyselect::contains("UASC"),
                        names_to = "ageRange",
                        names_pattern = "yearEndUASC_(.+)",
                        values_to = "total") |> 
    dplyr::mutate(ageRange = stringr::str_replace(ageRange, "_", "-"))
}

#' @rdname tidiers
#' @export
pd_ref_uasc_bysex <- function(data) {
  data |> 
    dplyr::transmute(asylum, origin,
                     yearEndUASCFemale, yearEndUASCMale = yearEndUASCTotal - yearEndUASCFemale,
                     source, basis) |> 
    tidyr::pivot_longer(tidyselect::contains("UASC"),
                        names_to = "sex",
                        names_pattern = "yearEndUASC(.+)",
                        values_to = "total")
}

#' @rdname tidiers
#' @export
pd_roc_stock <- function(data) { pd_ref_stock(data) }

#' @rdname tidiers
#' @export
pd_roc_flows <- function(data) { pd_ref_flows(data) }

#' @rdname tidiers
#' @export
pd_roc_uasc_byage <- function(data) { pd_ref_uasc_byage(data) }

#' @rdname tidiers
#' @export
pd_roc_uasc_bysex <- function(data) { pd_ref_uasc_bysex(data) }

#' @rdname tidiers
#' @export
pd_rsd_meta <- function(data) {
  # FIXME: Should we tidy this table? And, if so, is the commented-out code the correct way to do it?
  data |>
    dplyr::distinct(asylum, ageRange, dplyr::across(tidyselect::contains("meta"))) |> 
    dplyr::group_by(asylum) |> 
    dplyr::mutate(rsdTable = stringr::str_c(asylum, dplyr::row_number(), sep = "-")) |> 
    dplyr::ungroup() # |> 
    # dplyr::mutate(ageRange = str_match(ageRange, "UASC (.+) years")[, 2],
    #               UASC = !is.na(ageRange),
    #               AveragePersonsPerCase = maX(1, AveragePersonsPerCase)) |>
    # tidyr::pivot_longer(tidyselect::matches("(application|decision)"),
    #                     names_to = c("unit", ".value"),
    #                     names_pattern = "meta_(application|decision)(.+)") |> 
    # dplyr::rename(typeOfProcedure = meta_typeOfProcedure)
}

#' @rdname tidiers
#' @export
pd_rsd_stock <- function(data) {
  data |> 
    dplyr::left_join(pd_rsd_meta(data), 
                     by = data |> dplyr::select(asylum, tidyselect::starts_with("meta"), ageRange) |> names()) |> 
    dplyr::select(asylum, origin, rsdTable,
                  totalStartYear, totalStartYearUNHCRAssisted, 
                  totalEndYear, totalEndYearUNHCRAssisted) |> 
    tidyr::pivot_longer(totalStartYear:totalEndYearUNHCRAssisted,
                        names_to = c("timePeriod", "measure"),
                        names_pattern = "total(StartYear|EndYear)(.+)?",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure))
}

#' @rdname tidiers
#' @export
pd_rsd_flows <- function(data) {
  data |> 
    dplyr::left_join(pd_rsd_meta(data),
                     by = data |> dplyr::select(asylum, tidyselect::starts_with("meta"), ageRange) |> names()) |> 
    dplyr::select(asylum, origin, rsdTable,
                  appliedDuringTheYear:otherClosed) |> 
    tidyr::pivot_longer(appliedDuringTheYear:otherClosed,
                        names_to = c("flowType"),
                        values_to = "total") |> 
    dplyr::mutate(flowDirection = dplyr::if_else(flowType == "appliedDuringTheYear", 1, -1),
                  measure = "Total")
}

#' @rdname tidiers
#' @export
pd_idp_stock <- function(data) {
  data |> 
    dplyr::select(origin, type, location,
                  totalStartYear, totalStartYearUNHCRAssisted,
                  totalMidYear, totalMidYearUNHCRAssisted,
                  source, basis) |> 
    tidyr::pivot_longer(totalStartYear:totalMidYearUNHCRAssisted,
                        names_to = c("timePeriod", "measure"),
                        names_pattern = "total(StartYear|MidYear)(.+)?",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure))
}

#' @rdname tidiers
#' @export
pd_idp_flows <- function(data) {
  data |> 
    dplyr::select(origin, type, location,
                  increasesNew, increasesOther, 
                  decreasesReturned, decreasesReturnedAssisted, decreasesRelocated, decreasesOther,
                  source, basis) |> 
    tidyr::pivot_longer(increasesNew:decreasesOther,
                        names_to = c("flowType", "measure"),
                        names_pattern = "(.+?)(Assisted)?$",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure),
                  flowDirection = dplyr::if_else(stringr::str_detect(flowType, "increases"), 1, -1))
}

# NOTE: There is no pd_ret_stock() because we don't keep returnees on our records from one year to the next...

#' @rdname tidiers
#' @export
pd_ret_flows <- function(data) {
  data |> 
    dplyr::rename(asylum = `asylum (from)`) |> 
    tidyr::pivot_longer(tidyselect::contains("total"),
                        names_to = c("flowType", "measure"),
                        names_pattern = "total(Returnees)(.+)?",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure))
}

#' @rdname tidiers
#' @export
pd_sta_stock <- function(data) {
  data |> 
    dplyr::select(-tidyselect::matches("(inc|dec)reases")) |> 
    tidyr::pivot_longer(tidyselect::contains("total"),
                        names_to = c("flowType", "measure"),
                        names_pattern = "total(YearStart|YearEnd)(.+)?",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure))
}

#' @rdname tidiers
#' @export
pd_sta_flows <- function(data) {
  data |> 
    dplyr::select(-tidyselect::contains("total")) |> 
    tidyr::pivot_longer(tidyselect::matches("(inc|dec)reases"),
                        names_to = "flowType",
                        values_to = "total") |> 
    dplyr::mutate(flowDirection = dplyr::if_else(stringr::str_detect(flowType, "increases"), 1, -1),
                  measure = "Total")
}

#' @rdname tidiers
#' @export
pd_ooc_stock <- function(data) {
  data |> 
    dplyr::select(-c(newArrivals:otherDecreases)) |> 
    tidyr::pivot_longer(tidyselect::contains("total"),
                        names_to = c("flowType", "measure"),
                        names_pattern = "total(YearStart|YearEnd)(.+)?",
                        values_to = "total") |> 
    dplyr::mutate(measure = dplyr::if_else(measure == "", "Total", measure))
}

#' @rdname tidiers
#' @export
pd_ooc_flows <- function(data) {
  data |> 
  dplyr::select(-tidyselect::contains("total")) |> 
    tidyr::pivot_longer(newArrivals:otherDecreases,
                        names_to = "flowType",
                        values_to = "total") |> 
    dplyr::mutate(flowDirection = dplyr::if_else(flowType %in% c("newArrivals", "otherIncreases"), 1, -1),
                  measure = "Total")
}

#' @rdname tidiers
#' @export
pd_vda_stock <- function(data) { pd_ooc_stock(data) }

#' @rdname tidiers
#' @export
pd_vda_flow <- function(data) { pd_ooc_flows(data) }

#' @rdname tidiers
#' @export
pd_hst_stock <- function(data) { pd_ooc_stock(data) }

#' @rdname tidiers
#' @export
pd_hst_flow <- function(data) { pd_ooc_flows(data) }
