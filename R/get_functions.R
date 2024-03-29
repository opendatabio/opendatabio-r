#' Connection and data download functions
#'
#' These are some basic functions to interact with the API and download data.
#' See the full help on the package vignettes.
#' @examples
#' \dontrun{
#' cfg = odb_config()
#' # Test request
#' odb_test()
#' # Gets some taxons
#' param = list(level=210, valid=TRUE, limit=5)
#' taxons = odb_get_taxons(param, cfg)
#' print(taxons)
#' }
#' @export
#' @param params named list, named vector or character string. Represents the parameters to be sent for the server, such as "valid=1" to return only valid taxons. See \code{\link{odb_params}}
#' @param odb_cfg list. A configuration object, as generated by \code{\link{odb_config}}
#' @param simplify logical. Should the results be 'unlisted' before being returned?
#' @return odb_get methods usually return a \code{data.frame} is simplify=TRUE, but that depends on the JSON response received from the server.
#' @import jsonlite
#' @rdname get_functions
odb_test <- function(odb_cfg = odb_config()) {
    response = odb_send_get(list(), odb_cfg, "/")
    inner_response = fromJSON(toJSON(content(response)))
    cat("Host:", inner_response$meta$full_url, "\n")
    cat("Versions: server", inner_response$meta$odb_version, "api", inner_response$meta$api_version, "\n")
    return (inner_response$data)
}

#' @export
#' @rdname get_functions
odb_get_bibreferences <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "bibreferences")
 format_get_bibresponse(response)
}

#' @export
#' @rdname get_functions
odb_get_datasets <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "datasets")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_biocollections <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "biocollections")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_individuals <- function(params = list(), odb_cfg = odb_config(), simplify = TRUE) {
 response = odb_send_get(params, odb_cfg, "individuals")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_occurrences <- function(params = list(), odb_cfg = odb_config(), simplify = TRUE) {
    response = odb_send_get(params, odb_cfg, "individual-locations")
    format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_languages <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "languages")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_locations <- function(params = list(), odb_cfg = odb_config(), simplify = TRUE) {
    response = odb_send_get(params, odb_cfg, "locations")
    format_get_response(response, simplify)
}


#' @export
#' @rdname get_functions
odb_get_measurements <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "measurements")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_persons <- function(params = list(), odb_cfg = odb_config(), simplify = TRUE) {
    response = odb_send_get(params, odb_cfg, "persons")
    format_get_response(response, simplify)
}


#' @export
#' @rdname get_functions
odb_get_projects <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "projects")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_taxons <- function(params = list(), odb_cfg = odb_config(), simplify = TRUE) {
 response = odb_send_get(params, odb_cfg, "taxons")
 format_get_response(response, simplify)
}

#' @export
#' @rdname get_functions
odb_get_traits <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "traits")
 response = format_get_response_traits(response, simplify)
 response
}

#' @export
#' @rdname get_functions
odb_get_vouchers <- function (params = list(), odb_cfg = odb_config(), simplify = TRUE)
{
 response = odb_send_get(params, odb_cfg, "vouchers")
 format_get_response(response, simplify)
}
