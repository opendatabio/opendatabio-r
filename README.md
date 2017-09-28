# opendatabio R package

This package implements a client to the OpenDataBio API. This should allow for users
with some experience in R to query the database, import and export data, and run common analyses.
The package is written on top of [httr](http://httr.r-lib.org/) package.
Advanced users are welcome to write their own requests using the `httr::GET` and `httr::POST` 
functions directly.

## Install

Installation is currently done only from GitHub. 

```R
> library(devtools)
> install_github("opendatabio/opendatabio-r")
```

## Basic usage

The first to be done is create a `odb_config` object to hold the configuration for connecting with your
OpenDataBio server. For anonymous use to the development server, simply use its default configuration:

```R
> cfg = odb_config()
```

Then, write a request using the [OpenDataBio API documentation](https://github.com/opendatabio/opendatabio/wiki/API),
and pass the configuration object:

```R
> library(opendatabio)
> taxons = odb_get_taxons(list(valid = TRUE, fields = "id,fullname,levelName", limit=5), cfg)
> print(taxons)
      id        fullname levelName
    1  1   Excepturiceae    Family
    2  2 Perferendisceae    Family
    3  3  Cupiditateceae    Family
    4  4     Aliquamceae    Family
    5  5        Quiaceae    Family
```
