#' @noRd
assert_cache <- function(x)
  if (!inherits(x, "HoardClient"))
    stop("Not a `hoardr` cache object", call. = FALSE)

#' @noRd
#' @importFrom crul HttpClient auth
pd_GET <- function(path, cookie =  Sys.getenv("POPDATA_COOKIE", "")) {
  cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                        opts = list(cookie = cookie))
  res <- cli$get(path)
  res$raise_for_status()
  ts <- tryCatch(res$raise_for_ct(type = "text/csv"),
                 error = function(e) e)
  if (inherits(ts, "error")) {
    pd_session()
    res <- cli$get(path)
    res$raise_for_status()
  }
  res$raise_for_ct(type = "text/csv")
  res
}
