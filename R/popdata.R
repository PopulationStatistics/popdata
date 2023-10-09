#' Access UNHCR Popdata platform figures
#'
#' Access UNHCR Popdata platform figures
#'
#' @param report character, the type of report asr, mysr  
#' @param table character, any of the following tables from within popdata: 
#'  *  "refugees",  # Table II. Refugee population and changes
#'  *  "refugeeLike", # Table IIb. Refugee-like population and changes
#'  *  "demographics", 
#'  *  "rsd", # Table IV. Individual asylum applications and refugee status determination
#'  *  "as2", # Asylum Seekers-RSD not required
#'  *  "idp", # Table V. Internally displaced persons (IDPs)
#'  *  "returnees", # Table VI. Returnees, Returnee persons and Other persons of concern to UNHCR
#'  *  "stateless", # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR
#'  *  "other", # Table VI. Others, Other persons and Other persons of concern to UNHCR
#'  *  "oip",  # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR /
#'              #  E. Other people in need of international protection
#'  *  "hostCommunity", # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR
#'             # F. Host Community
#'  *  "comments" 
#'                    
#'                    
#' @param year integer, the year
#' @param quiet logical, print message on updating session cookie or not.
#' options(popdata_quiet = TRUE) can also be used
#'
#' @return A tibble
#' @export
popdata <- function(report = c("asr", "mysr"),
                    table = c(  "refugees",   "refugeeLike",  "demographics",
                          "rsd",   "as2",  "idp", "returnees", "stateless", 
                          "other",  "oip",   "hostCommunity",  "comments"  ),
                    year = 2022,
                    quiet = getOption("popdata_quiet")) {
  report <- match.arg(report)
  path <- sprintf("/admin/export/download/%s/%s/%s",
                  report, table, year)
  res <- pd_GET(path, quiet = quiet)
  res <- res$parse(encoding = "UTF-8")
  read_pd_csv(res)
}

#' Access end year report
#' @param year year for release 
#' @param table character, any of the following tables from within popdata:
#'  *  "refugees", 
#'  *  "refugeeLike",
#'  *  "demographics",
#'  *  "rsd",
#'  *  "as2", 
#'  *  "idp",
#'  *  "returnees", 
#'  *  "stateless", 
#'  *  "other",
#'  *  "oip", 
#'  *  "hostCommunity",
#'  *  "comments" 
#' @param quiet option
#' @rdname popdata
#' @export
pd_asr <- function(table = c(  "refugees",   "refugeeLike",  "demographics",
                             "rsd",   "as2",  "idp", "returnees", "stateless", 
                             "other",  "oip",   "hostCommunity",  "comments"),
                   year = 2022,
                   quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "asr", table = table,
          year = year, quiet = quiet)
}

#' Access midyear report
#' @param year year for release 
#' @param table character, any of the following tables from within popdata:
#'  *  "refugees",  # Table II. Refugee population and changes
#'  *  "refugeeLike", # Table IIb. Refugee-like population and changes
#'  *  "rsd", # Table IV. Individual asylum applications and refugee status determination
#'  *  "as2", # Asylum Seekers-RSD not required
#'  *  "idp", # Table V. Internally displaced persons (IDPs)
#'  *  "returnees", # Table VI. Returnees, Returnee persons and Other persons of concern to UNHCR
#'  *  "stateless", # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR
#'  *  "other", # Table VI. Others, Other persons and Other persons of concern to UNHCR
#'  *  "oip",  # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR /
#'              #  E. Other people in need of international protection
#'  *  "hostCommunity", # Table VI. Returnees, Stateless persons and Other persons of concern to UNHCR
#'             # F. Host Community
#'  *  "comments" 
#'                  
#'    
#'   "demographics" is not available for mid year...              
#' @param quiet option
#' @rdname popdata
#' @export
pd_mysr <- function(table = c(  "refugees",   "refugeeLike", 
                              "rsd",   "as2",  "idp", "returnees", "stateless", 
                              "other",  "oip",   "hostCommunity",  "comments"),
                    year = 2023,
                    quiet = getOption("popdata_quiet")) {
  table <- match.arg(table)
  popdata(report = "mysr", table = table,
          year = year, quiet = quiet)
}



#' @importFrom crul HttpClient auth
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @param report character, the type of report asr, mysr  
#' @noRd
#' @export
pd_map <- function(report = c("asr", "mysr"),
                   quiet = getOption("popdata_quiet")) {
  report <- match.arg(report)
  path <- sprintf("/complianceMapData/2/%s", report)
  res <- pd_GET(path, quiet = quiet)
  res <- res$parse(encoding = "UTF-8")
  res <- fromJSON(res)
  pd_augment(as_tibble(res)[, c("code", "status")], code)
}
 
