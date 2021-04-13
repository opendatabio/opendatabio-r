# opendatabio R package

This package implements a client to the OpenDataBio API. This should allow for users
with some experience in R to query the database, import and export data, and run common analyses.
The package is written on top of [httr](http://httr.r-lib.org/) package.
Advanced users are welcome to write their own requests using the `httr::GET` and `httr::POST` 
functions directly.

## Install

Installation is currently done only from GitHub. 

The functions that plot maps use libgeos, so you probably want to `apt-get install libgeos`.

```R
> library(devtools)
> install_github("opendatabio/opendatabio-r", build_vignettes = TRUE)
```

## Basic usage

The first to be done is create a `odb_config` object to hold the configuration for connecting with your
OpenDataBio server. For anonymous use to the development server, simply use its default configuration:

```R
> cfg = odb_config()
```

Then, write a request using the [OpenDataBio API documentation](https://github.com/opendatabio/opendatabio/wiki/API),
and pass the configuration object. The parameters can be passed in a few different ways, check the documentation
for the `odb_params` function:

```R
> library(opendatabio)
> cfg = odb_config(token="YourToken")
> taxons = odb_get_taxons(list(valid = TRUE, fields = c("id","fullname","levelName"), level=120, limit=5))
> print(taxons)
   id        fullname levelName
1 144   Lycopodiaceae    Family
2 145 Selaginellaceae    Family
3 146      Isoetaceae    Family
4 160     Psilotaceae    Family
5 161    Equisetaceae    Family
```

A more in-depth explanation can be found with `vignette("opendatabio-reading")`.

Details on the data import can be found with `vignette("opendatabio-importing")`.

# Note to package developers!

Note that running `devtools::check()` or `devtools::test()` will overwrite your environment variables!
