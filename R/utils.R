#' @noRd
assert_cache <- function(x)
  if (!inherits(x, "HoardClient"))
    stop("Not a `hoardr` cache object", call. = FALSE)

#' @noRd
#' @importFrom crul HttpClient auth
pd_GET <- function(path, cookie = Sys.getenv("POPDATA_COOKIE", "")) {
  cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                        opts = list(cookie = cookie))
  res <- cli$get(path)
  res$raise_for_status()
  res_content_type <- res$response_headers[["content-type"]]
  bool <- grepl("text/csv", res_content_type, ignore.case = TRUE)
  if (!bool) {
    pd_session()
    res <- cli$get(path)
    res$raise_for_status()
  }
  res
}
