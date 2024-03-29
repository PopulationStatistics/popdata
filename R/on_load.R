.pd_cachemem <- NULL # nocov start
.pd_cache <- NULL

#' @noRd
#' @importFrom hoardr hoard
#' @importFrom memoise memoise
#' @importFrom cachem cache_mem
.onLoad <- function(libname, pkgname) {
  x <- hoardr::hoard()
  x$cache_path_set("popdata")
  if (!dir.exists( x$cache_path_get()))
    x$mkdir()
  .pd_cache <<- x
  .pd_cachemem <<- cachem::cache_mem(max_age = 60 * 30) ## 30 min
  popdata <<- memoise::memoise(popdata,
                               cache = .pd_cachemem)
  options(popdata_quiet = FALSE)
} # nocov end
