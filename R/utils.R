#' @noRd
assert_cache <- function(x)
  if (!inherits(x, "HoardClient"))
    stop("Not a `hoardr` cache object", call. = FALSE)

#' @noRd
assert_memoise_cache <- function(x)
  if (!inherits(x, "cache_mem"))
    stop("Not a `cachem` cache object", call. = FALSE)

#' @noRd
#' @importFrom crul HttpClient auth url_build
pd_GET <- function(path, cookie = Sys.getenv("POPDATA_COOKIE", ""), quiet = FALSE) {
  baseurl <- "https://popdata.unhcr.org"
  cli <- HttpClient$new(url = baseurl,
                        opts = list(cookie = cookie))
  res <- cli$get(path)
  res$raise_for_status()
  res <- tryCatch({stopifnot(res$url == url_build(baseurl, path)); res},
                  error = function(e) {
                    if (!quiet)
                      message("Your session cookie expired, generating a new one...")
                    pd_session()
                    cookie <- Sys.getenv("POPDATA_COOKIE", "")
                    cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                                          opts = list(cookie = cookie))
                    res <- cli$get(path)
                    res$raise_for_status()
                    tryCatch({stopifnot(res$url == url_build(baseurl, path)); res},
                             error = function(e) {
                               stop("Can't access the platform\nYou need log into popdata using 'pd_login' and try again!", call. = FALSE)
                             })
                  })
  res
}

#' @noRd
#' @importFrom readr read_delim locale
read_pd_csv <- function(x)
  suppressMessages(read_delim(x,
                              na = c("", "NA", "N/A"),
                              guess_max = 1e+05,
                              delim = ";",
                              locale = locale(decimal_mark = ".")))
