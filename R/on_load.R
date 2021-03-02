.popdata_cm <- NULL # nocov start

#' @noRd
#' @importFrom memoise memoise
#' @importFrom cachem cache_mem
.onLoad <- function(libname, pkgname) {
  .popdata_cm <<- cachem::cache_mem()
  asr <<- memoise::memoise(asr,
                           cache = .popdata_cm)
  mysr <<- memoise::memoise(mysr,
                            cache = .popdata_cm)
  planning <<- memoise::memoise(planning,
                                cache = .popdata_cm)
  popdata_connect <<- memoise::memoise(popdata_connect,
                                      cache = .popdata_cm)
} # nocov end
