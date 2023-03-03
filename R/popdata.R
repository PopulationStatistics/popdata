#' Access UNHCR Popdata platform figures
#'
#' Access UNHCR Popdata platform figures
#'
#' @param report character, the type of report asr, mysr or pf
#' @param table character, the indicator refugees, refugeeLike, returnees,
#' demographics, idp, rsd, stateless, oip, other, hostcommunity, coo, ppg or specifics
#' @param year integer, the year
#' @param quiet logical, print message on updating session cookie or not.
#' options(popdata_quiet = TRUE) can also be used
#'
#' @return A tibble
#' @export
popdata <- function(report = c("asr", "mysr", "pf"),
                    table = c("refugees", "refugeeLike",
                              "returnees", "demographics", "idp",
                              "rsd", "stateless", "oip", "other",
                              "hostcommunity", "coo", "ppg", "specific",
                              "as2", "comments"),
                    year = 2022,
                    quiet = getOption("popdata_quiet")) {
  report <- match.arg(report)
  path <- sprintf("/admin/export/download/%s/%s/%s",
                  report, table, year)
  res <- pd_GET(path, quiet = quiet)
  res <- res$parse(encoding = "UTF-8")
  read_pd_csv(res)
}

#' @rdname popdata
#' @export
pd_asr <- function(table = c("refugees", "refugeelike", "refugeeLike",
                             "returnees", "demographics", "idp",
                             "rsd", "stateless", "oip", "other",
                             "hostcommunity", "hostCommunity",
                             "as2", "comments"),
                   year = 2022,
                   quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "asr", table = table,
          year = year, quiet = quiet)
}

#' @rdname popdata
#' @export
pd_mysr <- function(table = c("refugees", "refugeeLike","returnees", "idp",
                              "rsd", "stateless", "other", "oip", "hostCommunity",
                              "as2", "comments"),
                    year = 2022,
                    quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "mysr", table = table,
          year = year, quiet = quiet)
}

#' @rdname popdata
#' @export
pd_pf <- function(table = c("coo", "ppg", "specific"),
                  year = 2020,
                  quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "pf", table = table,
          year = year, quiet = quiet)
}


#' Augment data-frame with country metadata
#'
#' Augment data-frame with country metadata
#'
#' @param data tibble, dataset to augment
#' @param col unquoted expression, column containing UNHCR code
#' @param prefix character, string to prepend to metadata column names
#'
#' @return a tibble
#'
#' @importFrom dplyr left_join select relocate rename_with
#' @importFrom stringr str_c
#' @importFrom rlang `:=` .data
#'
#' @export
pd_augment <- function(data, col, prefix = NULL) {
  res <- left_join(data,
                   select(pd_countries, {{col}} := .data$code,
                          .data$region, .data$bureau,
                          .data$iso, .data$name),
                   by = as.character(as.list(match.call())[-1][2]))
  res <- relocate(res, .data$region, .data$bureau,
                  .data$iso, .data$name,
                  .before = {{col}})

  if (!is.null(prefix))
    res <- rename_with(res, ~ str_c(prefix, ., sep = "_"), .data$region:.data$name)

  res
}

#' @importFrom crul HttpClient auth
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
pd_map <- function(report = c("asr", "mysr"),
                   quiet = getOption("popdata_quiet")) {
  report <- match.arg(report)
  path <- sprintf("/complianceMapData/%s", report)
  res <- pd_GET(path, quiet = quiet)
  res <- res$parse(encoding = "UTF-8")
  res <- fromJSON(res)
  pd_augment(as_tibble(res)[, c("code", "status")], code)
}

utils::globalVariables("pd_countries")
