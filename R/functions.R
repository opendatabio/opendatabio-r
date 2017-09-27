#' Base functions
#'
#' These are some basic getter functions to show the uses of the API
#' @examples
#' taxons = odb_get_taxons("level=210&valid=0&external=1")
#' @export
#' @import httr
#' @import jsonlite
odb_get_taxons <- function(params = NULL) {
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
