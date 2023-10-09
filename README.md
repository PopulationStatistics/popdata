
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {popdata} <img src="man/figures/hex_popdata.png" align="right" width="140" />

`{popdata}` is an R client for
[popdata.unhcr.org](https://popdata.unhcr.org), the internal data
curation platform for the population statistics gathered by UNHCR
operations throughout the world.

Operations report the data they gather there so that Quality Assurance
processes can be applied.

This packages allows to pull previews of incoming dataset from the
system, **before official release** (end year and mid-year) in order to:

- offer regional figures consolidation preview for bureau directors,

- identify potential patterns,

- prepare interpretation narratives.

Please check the package [vignettes](articles/RegionalSummary.html) to
benefit from reproducible examples and quick-start your own regional
reviews.

## Installation & Usage

You can get `{popdata}` from Github:

``` r
## install.packages("pak")
pak::pkg_install("populationstatistics/popdata")
```

Now that `chromote` can access a web browser (preferably `chrome`), you
can use `pd_login` to log and store the login cookie in the package
cache (`$HOME/.cache/R/popdata` in Unix based distribution).

``` r
library(popdata)

pd_login()
# In the first run, it will generate a session cookie 
# that will need be updated if you inactive for a long period of time (approx. 30 min).
## Check that a file was stored
pd_cache_list()
## [1] "popdata_azure_cookies.rds"
```

As long as you keep this `rds` file in the package cache and as long as
you don’t change your POPDATA username and password, you can keep this
file to interact with `{popdata}`, no need to re-log using `pd_login`.

Once logged-in, you can run `pd_asr`or `pd_mysr` to get the data you
need from POPDATA (end year or mid year report).

``` r
ref <- pd_asr(table = "refugees", year = 2023)
```

The data returned by the server uses UNHCR country codes (which are
different from ISO code!). Use `pd_augment()` to augment the results
from the previous query with country and unhcr region name - by “origin”
and/ or “asylum”.

``` r
ref <- pd_augment(ref, expand = "origin")
```
