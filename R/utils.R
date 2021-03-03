#' @noRd
assert_cache <- function(x)
  if (!inherits(x, "HoardClient"))
    stop("Not a `hoardr` cache object", call. = FALSE)

#' @noRd
assert_memoise_cache <- function(x)
  if (!inherits(x, "cache_mem"))
    stop("Not a `cachem` cache object", call. = FALSE)

#' @noRd
#' @importFrom crul HttpClient auth
pd_GET <- function(path, cookie = Sys.getenv("POPDATA_COOKIE", ""), quiet = FALSE) {
  cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                        opts = list(cookie = cookie))
  res <- cli$get(path)
  res$raise_for_status()
  res <- tryCatch({res$raise_for_ct(type = "text/csv"); res},
                  error = function(e) {
                    if (!quiet)
                      message("Your session has expired, generating a new cookie!")
                    pd_session()
                    cookie <- Sys.getenv("POPDATA_COOKIE", "")
                    cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                                          opts = list(cookie = cookie))
                    res <- cli$get(path)
                    res$raise_for_status()
                    res
                  })
  res
}
