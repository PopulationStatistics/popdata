#' Popdata ASR figures
#'
#' Popdata ASR figures
#'
#' @importFrom readr read_csv2
#' @importFrom janitor clean_names
#'
#' @param indicator character, the indicator
#' @param year integer, the year
#'
#' @return A tibble
#' @export
asr <- function(indicator = c("refugees", "refugeeLike",
                              "returnees", "demographics", "idp",
                              "rsd", "stateless", "vda", "other",
                              "hostcommunity"),
                    year = 2020) {
  indicator <- match.arg(indicator)
  path <- sprintf("/admin/export/download/asr/%s/%s", indicator, year)
  cli <- popdata_connect()
  res <- cli$get(path)
  res$raise_for_status()
  res$raise_for_ct(type = "text/csv")
  res <- res$parse(encoding = "UTF-8")
  res <- suppressMessages(read_csv2(res))
  clean_names(res)
}

#' Popdata MYSR figures
#'
#' Popdata MYSR figures
#'
#' @importFrom readr read_csv2
#' @importFrom janitor clean_names
#'
#' @param indicator character, the indicator
#' @param year integer, the year
#'
#' @return A tibble
#' @export
mysr <- function(indicator = c("refugees", "returnees", "idp",
                               "rsd", "stateless"),
                 year = 2020) {
  indicator <- match.arg(indicator)
  path <- sprintf("/admin/export/download/mysr/%s/%s", indicator, year)
  cli <- popdata_connect()
  res <- cli$get(path)
  res$raise_for_status()
  res$raise_for_ct(type = "text/csv")
  res <- res$parse(encoding = "UTF-8")
  res <- suppressMessages(read_csv2(res))
  clean_names(res)
}

#' Popdata Planning figures
#'
#' Popdata Planning figures
#'
#' @importFrom readr read_csv2
#' @importFrom janitor clean_names
#'
#' @param indicator character, the indicator
#' @param year integer, the year
#'
#' @return A tibble
#' @export
planning <- function(indicator = c("coo", "ppg", "specific"),
                     year = 2020) {
  indicator <- match.arg(indicator)
  path <- sprintf("/admin/export/download/pf/%s/%s", indicator, year)
  cli <- popdata_connect()
  res <- cli$get(path)
  res$raise_for_status()
  res$raise_for_ct(type = "text/csv")
  res <- res$parse(encoding = "UTF-8")
  res <- suppressMessages(read_csv2(res))
  clean_names(res)
}
