#' @noRd
#' @importFrom crul HttpClient auth
popdata_connect <- function(username = Sys.getenv("POPDATA_USER", ""),
                            password = Sys.getenv("POPDATA_PWD", ""),
                            cookie =  Sys.getenv("POPDATA_COOKIE", "")) {
  cli <- HttpClient$new(url = "https://popdata.unhcr.org",
                        auth = auth(user = username,
                                    pwd = password),
                        opts = list(cookie = cookie))
  cli
}


#' Popdata credential
#'
#' Popdata credential
#'
#' @param username character, popdata user name
#' @param password character, popdata password
#' @param cookie character, popdata cookie
#'
#' @export
popdata_setup <- function(username = NULL,
                          password = NULL,
                          cookie =  NULL) {
  if (!is.null(username))
    Sys.setenv("POPDATA_USER" = username)

  if (!is.null(password))
    Sys.setenv("POPDATA_PWD" = password)

  if (!is.null(cookie))
    Sys.setenv("POPDATA_COOKIE" = cookie)

  invisible(list(username = Sys.getenv("POPDATA_USER", ""),
                 password = Sys.getenv("POPDATA_PWD", ""),
                 cookie =  Sys.getenv("POPDATA_COOKIE", ""),
                 url = "https://popdata.unhcr.org"))
}
