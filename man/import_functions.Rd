% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_functions.R
\name{odb_get_jobs}
\alias{odb_get_jobs}
\alias{odb_get_log}
\alias{odb_get_affected_ids}
\alias{odb_import_individuals}
\alias{odb_import_locations}
\alias{odb_import_measurements}
\alias{odb_import_persons}
\alias{odb_import_taxons}
\alias{odb_import_traits}
\alias{odb_import_vouchers}
\title{Import functions}
\usage{
odb_get_jobs(params = list(), odb_cfg = odb_config(), simplify = TRUE)

odb_get_log(job_id, odb_cfg = odb_config())

odb_get_affected_ids(job_id, odb_cfg = odb_config())

odb_import_individuals(data, odb_cfg = odb_config(), common = list())

odb_import_locations(data, odb_cfg = odb_config(), common = list())

odb_import_measurements(data, odb_cfg = odb_config(), common = list())

odb_import_persons(data, odb_cfg = odb_config(), common = list())

odb_import_taxons(data, odb_cfg = odb_config(), common = list())

odb_import_traits(data, odb_cfg = odb_config(), common = list())

odb_import_vouchers(data, odb_cfg = odb_config(), common = list())
}
\arguments{
\item{params}{named list, named vector or character string. Represents the parameters to be sent for the server, such as "valid=1" to return only valid taxons. See \code{\link{odb_params}}}

\item{odb_cfg}{list. A configuration object, as generated by \code{\link{odb_config}}}

\item{simplify}{logical. Should the results be 'unlisted' before being returned?}

\item{job_id}{numeric. A single job id}

\item{data}{The data to be imported. The format is quite flexible, but normally a named \code{data.frame} is the best choice. See package vignettes for details}

\item{common}{Optional. A named list containing fields which are common to all imported data.}
}
\value{
odb_import methods usually return the submitted job id retrieved with \code{\link{odb_config}}
}
\description{
These are some basic functions to interact with the API to import data and monitor the submitted jobs. See the full help on the package vignettes
}
\examples{
\dontrun{
data = data.frame(
  name = c("Euterpe oleracea", "Euterpe edulis"),
  parent = "Euterpe",
  level=odb_taxonLevelCodes('species'),
)
odb_import_taxons(data, cfg)
}
}
