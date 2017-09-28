#' Base functions
#'
#' These are some basic getter functions to show the uses of the API
#' @examples
#' taxons = odb_get_taxons("level=210&valid=0&external=1")
#' @export
#' @import httr
#' @import jsonlite
odb_get_taxons <- function(params = c(), odb_cfg = .odb_cfg) {
    params = odb_params(params)
    base_url = "http://localhost/opendatabio/api/"
    api_version = "v0/"
    endpoint = "taxons?"
    url = paste0(base_url, api_version, endpoint, params)
    result = stop_for_status(httr::GET(url,
                                       accept("application/json"),
                                       content_type("application/json"),
                                       add_headers(Authorization="AA78BDF7912")
                                       ))
    if(headers(result)$'content-type' != "application/json")
        stop("Wrong answer type from server: ", headers(result)$'content-type')
    fromJSON(toJSON(content(result)))$data
}


#' A convenience helper to transform R named vectors or lists to HTML syntax.
#' This is normally used inside the getter functions. Note that if this function
#' receives a string, it returns the same string. This can be used to construct more
#' complex queries.
#' @return string
#' @param params named list, named vector or string.
#' @examples
#' odb_params(list(level=210, valid=TRUE))
#' odb_params("search=edulis")
#' @export
odb_params <- function(params = c()) {
    if (class(params) == "character") {
        return(params)
    }
    # we convert logical values to numeric
    logic = sapply(params, is.logical)
    params[logic] = as.numeric(params[logic])
    # and "connect" them to their names
    params = paste(names(params),params,sep="=")
    # finally, we paste together all the values
    return(paste(params, collapse="&"))
}
