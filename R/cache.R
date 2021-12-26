#' Caching POPDATA downloaded files
#'
#' Manage cached POPDATA downloaded files
#'
#' @name pd_cache
#'
#' @details The default cache directory is
#' `~/.cache/R/popdata`, but you can set
#' your own path using `pd_cache_set_dir()`
#'
#'
#' @examples \dontrun{
#' pd_cache
#' ## change the default cache directory
#' tmp <- tempdir()
#' pd_cache_set_dir(tmp)
#'
#' ## print current cache directory
#' pd_cache_get_dir()
#'
#' ## List available files in the current cache directory
#' pd_cache_list()
#'
#' l <- pd_cache_list()[1] ## get the first file
#' pd_cache_delete(l) ## delete it
#'
#' pd_cache_clear() ## delete all cached files
#' }
NULL

#' Set the cache directory
#'
#' @rdname pd_cache
#'
#' @param path character, directory to set
#'
#' @return the cache directory
#' @export
pd_cache_set_dir <- function(path) {
  assert_cache(.pd_cache)
  .pd_cache$cache_path_set(path)
}

#' Print the cache directory
#'
#' @rdname pd_cache
#'
#' @return the cache directory
#' @export
pd_cache_get_dir <- function() {
  assert_cache(.pd_cache)
  .pd_cache$cache_path_get()
}

#' List of files available in the cache directory
#'
#' @rdname pd_cache
#'
#' @return list of files in the cache
#' @export
pd_cache_list <- function() {
  assert_cache(.pd_cache)
  list.files(.pd_cache$cache_path_get())
}

#' Delete a given file from cache
#'
#' @rdname pd_cache
#'
#' @param file Character, the file to delete
#'
#' @export
pd_cache_delete <- function(file) {
  assert_cache(.pd_cache)
  .pd_cache$delete(file)
}

#' Clear cache directory
#'
#' @rdname pd_cache
#'
#' @export
pd_cache_clear <- function() {
  assert_cache(.pd_cache)
  .pd_cache$delete_all()
}

#' Clear memory cache used to memoise popdata functions
#'
#' Clear memory cache used to memoise popdata functions
#'
#' @rdname pd_memoise_clear
#'
#' @export
pd_memoise_clear <- function() {
  assert_memoise_cache(.pd_cachemem)
  .pd_cachemem$reset()
}
