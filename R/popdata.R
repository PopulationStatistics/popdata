#' Popdata figures
#'
#' Popdata figures
#'
#' @importFrom readr read_csv2
#'
#' @param report character, the type of report asr, mysr or pf
#' @param table character, the indicator refugees, refugeeLike, returnees,
#' demographics, idp, rsd, stateless, vda, other, hostcommunity, coo, ppg or specifics
#' @param year integer, the year
#' @param quiet logical, print message on updating session cookie or not.
#' options(popdata_quiet = TRUE) can also be used
#'
#' @return A tibble
#' @export
popdata <- function(report = c("asr", "mysr", "pf"),
                    table = c("refugees", "refugeeLike",
                              "returnees", "demographics", "idp",
                              "rsd", "stateless", "vda", "other",
                              "hostcommunity", "coo", "ppg", "specific"),
                    year = 2020,
                    quiet = getOption("popdata_quiet")) {
  report <- match.arg(report)
  path <- sprintf("/admin/export/download/%s/%s/%s",
                  report, table, year)
  res <- pd_GET(path, quiet = quiet)
  res <- res$parse(encoding = "UTF-8")
  suppressMessages(read_csv2(res))
}

#' @rdname popdata
#' @export
pd_asr <- function(table = c("refugees", "refugeelike", "refugeeLike",
                             "returnees", "demographics", "idp",
                             "rsd", "stateless", "vda", "other",
                             "hostcommunity", "hostCommunity"),
                   year = 2020,
                   quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "asr", table = table,
          year = year, quiet = quiet)
}

#' @rdname popdata
#' @export
pd_mysr <- function(table = c("refugees", "returnees", "idp",
                              "rsd", "stateless", "other"),
                    year = 2020,
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
