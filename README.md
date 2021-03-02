
<!-- README.md is generated from README.Rmd. Please edit that file -->

# popdata

`popdata` is an R client for the [UNHCR POPDATA
platform](https://popdata.unhcr.org).

## Introduction

The [UNHCR POPDATA platform](https://popdata.unhcr.org) is UNHCR
internal platform for population statistics.

## Installation

This package is not on yet on CRAN and to install it, you will need the
[`remotes`](https://github.com/r-lib/remotes) package. You can get
`popdata` from Gitlab or Github (mirror)

``` r
## install.packages("remotes")
remotes::install_gitlab("dickoa/popdata")
```

## popdata: A quick tutorial

``` r
library("popdata")
```

The `popdata` package requires you to add your `username`, `password`
and the session `cookie`.

You can store your username and password in your `.Renviron` file or
access it by calling `usethis::edit_r_environ()` (assuming you have the
`usethis` package installed) and entering:

``` bash
POPDATA_USER=xxxxxxxxxxxxxxxxxx
POPDATA_PWD=xxxxxxxxxxxxxxxxxx
```

The third environment variable used is `POPDATA_COOKIE` where you can
temporarily store the value of the session cookie.

Once the environment variables set you will need to restart your
session.

``` r
library("popdata")
popdata_setup(username = "xxxxxxxxxxxx",
              password = "xxxxxxxxxxxx",
              cookie = "xxxxxxxxxxxx")
```

If you stored your `username` and `password` in the .Renviron under
`POPDATA_USER` and `POPDATA_PWD`, you just need to set your session
cookie.

``` r
popdata_setup(cookie = "xxxxxxxxxxxx")
```

Now that we are connected to POPDATA, we can download data from the
Annual Statistical report.

``` r
asr(indicator = "refugees", year = 2019)
## # A tibble: 6,214 x 30
##    asylum origin year_start_total year_start_total_unhcr_assisted
##    <chr>  <chr>             <dbl>                           <dbl>
##  1 AFG    IRN                  34                              34
##  2 AFG    IRQ                   1                               1
##  3 AFG    PAK               72194                           72194
##  4 ALB    ARE                   3                               3
##  5 ALB    BUL                   1                               1
##  6 ALB    CHI                  12                              12
##  7 ALB    COD                   3                               3
##  8 ALB    FGU                   0                               0
##  9 ALB    GAZ                  14                              14
## 10 ALB    IND                   0                               0
## # … with 6,204 more rows, and 26 more variables:
## #   group_recognition <dbl>, temporary_protection <dbl>,
## #   individual_recognition <dbl>, resettlement_arrivals <dbl>,
## #   births <dbl>, increases_other <dbl>, increases_total <dbl>,
## #   decreases_voluntary_repatriation_total <dbl>,
## #   decreases_voluntary_repatriation_total_unhcr_assisted <dbl>,
## #   decreases_resettlement_total <dbl>,
## #   decreases_resettlement_total_unhcr_assisted <dbl>,
## #   cessation <dbl>, naturalization <dbl>, deaths <dbl>,
## #   decreases_other <dbl>, decreases_total <dbl>,
## #   year_end_total <dbl>, year_end_uasc_total <dbl>,
## #   year_end_uasc_0_4 <dbl>, year_end_uasc_5_11 <dbl>,
## #   year_end_uasc_12_14 <dbl>, year_end_uasc_0_14_total <dbl>,
## #   year_end_uasc_15_17 <dbl>,
## #   year_end_total_unhcr_assisted <dbl>, source <chr>,
## #   basis <chr>
```

## Meta

-   Please [report any issues or
    bugs](https://gitlab.com/dickoa/popdata/issues).
-   License: MIT
-   Please note that this project is released with a [Contributor Code
    of Conduct](CONDUCT.md). By participating in this project you agree
    to abide by its terms.
