# opendatabio R package

**OPENDATABIO HAS BEEN MOVE TO GIT LAB** - [OpenDataBio on GitLab](https://opendatabio.gitlab.io)

This package implements a client to an [OpenDataBio API](https://opendatabio.gitlab.io/docs/api/). This should allow for users with some experience in R to query an OpenDataBio database, to import and export data.

The package is written on top of [httr](http://httr.r-lib.org/) package. Advanced users are welcome to write their own requests using the `httr::GET` and `httr::POST` functions directly.

## Install

Installation is currently done only from GitHub.

The functions that plot maps use libgeos, so you probably want to `apt-get install libgeos`.

```R
> library(devtools)
> install_github("opendatabio/opendatabio-r", build_vignettes = FALSE)
```

## Basic usage

1. [OpenDataBio GET Data Tutorial](https://opendatabio.gitlab.io/docs/tutorials/01-get-r-vignette/)
1. [OpenDataBio POST Data Tutorial](https://opendatabio.gitlab.io/docs/tutorials/02-post-data-r-vignette/).

# Note to package developers!
Note that running `devtools::check()` or `devtools::test()` will overwrite your environment variables!

# License

The documentation site is licensed for use under a GPLv3 license. See the LICENSE file provided.
