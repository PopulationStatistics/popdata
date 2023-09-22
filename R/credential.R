#' Get Popdata session token
#'
#' Get Popdata session token
#'
#' @importFrom chromote ChromoteSession
#'
#' @export
pd_login <- function() {
  chrome <- ChromoteSession$new()
  chrome$Page$navigate("https://intranet.unhcr.org")
  chrome$view()
  readline("Hit [RETURN] to continue when you've logged in.")
  cookies <- chrome$Network$getAllCookies()
  chrome$close()
  bool <- vapply(cookies$cookies,
                 function(x) grepl( "^(.+)\\.unhcr\\.org$", x$domain),
                 logical(1))
  azure_cookies <- cookies$cookies[!bool]
  pd_cache <- pd_cache_get_dir()
  destfile <- file.path(pd_cache,
                        "popdata_azure_cookies.rds")
  saveRDS(azure_cookies, destfile)
  invisible(destfile)
}

#' Get Popdata session token
#'
#' Get Popdata session token
#'
#' @importFrom chromote ChromoteSession
#' @noRd
pd_session <- function() {
  pd_cache <- pd_cache_get_dir()
  cookie_file <- file.path(pd_cache,
                           "popdata_azure_cookies.rds")
  if (!file.exists(cookie_file))
    stop("Use `pd_login` to log into popdata",
         call. = FALSE)
  chrome <- ChromoteSession$new()
  chrome$Network$setCookies(cookies = readRDS(cookie_file))
  chrome$Page$navigate("https://popdata.unhcr.org/connect/azure")
  cookies <- chrome$Network$getAllCookies()
  cookies <- cookies$cookies
  chrome$close()
  bool <- vapply(cookies,
                 function(x) x$name == "PHPSESSID",
                 logical(1))
  popdata_cookies <- cookies[[which(bool)]]$value
  popdata_cookies <- paste0("PHPSESSID=", popdata_cookies, ";")
  Sys.setenv("POPDATA_COOKIE" = popdata_cookies)
  invisible(popdata_cookies)
}
