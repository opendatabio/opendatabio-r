# Base workhorse for GET methods
odb_send_get = function(params, odb_cfg, endpoint) {
    params = odb_params(params)
    url = paste0(odb_cfg$base_url, "/", endpoint)
    if(nchar(params))
        url = paste0(url, "?", params)
    # Removes double slashes (probably due to "pasting" urls already with /)
    # Do NOT remove the double slashes after http:
    url = gsub("([^:])//", "\\1/", url)
    response = stop_for_status(httr::GET(url,
                                       odb_cfg$headers
                                       ))
    # Usually Accept is application/json, but this may be overriden using odb_config
    if(! grepl(http_type(response), odb_cfg$headers$headers["Accept"], ignore.case=TRUE))
        stop("Wrong answer type from server: ", http_type(response))
    return(response)
}

# Base workhorse for POST methods
odb_send_post = function(body, odb_cfg, endpoint) {
    url = paste0(odb_cfg$base_url, "/", endpoint)
    # Removes double slashes (probably due to "pasting" urls already with /)
    # Do NOT remove the double slashes after http:
    url = gsub("([^:])//", "\\1/", url)
    response = stop_for_status(httr::POST(url,
                                       odb_cfg$headers,
                                       body = body,
                                       encode = "json"
                                       ))
    # Usually Accept is application/json, but this may be overriden using odb_config
    if(! grepl(http_type(response), odb_cfg$headers$headers["Accept"], ignore.case=TRUE))
        stop("Wrong answer type from server: ", http_type(response))
    return(response)
}

#' Convert query parameters
#'
#' A convenience helper to transform R named lists to HTML syntax.
#'
#' This is normally used inside the getter functions. Note that if this function
#' receives an unnamed character string, it returns the same string. This can be used to construct more
#' complex queries.
#' 
#' @return character
#' @param params named list or character string.
#' @examples
#' odb_params(list(level=210, valid=TRUE))
#' odb_params("search=edulis")
#' @export
odb_params <- function(params = list()) {
    if (class(params) == "character" && length(names(params)) == 0) {
        return(params)
    }
    if (! is.list(params)) {
        stop("odb_params expects either a list or an unnamed character string")
    }
    # we convert logical values to numeric
    logic = sapply(params, is.logical)
    if (length(logic))
        params[logic] = as.numeric(params[logic])
    # we glue together params passed as vectors
    if(length(params))
        for (i in 1:length(params))
            params[[i]] = paste(params[[i]], collapse=",")
    # and "connect" them to their names
    params = paste(names(params),params,sep="=")
    # finally, we paste together all the values
    return(paste(params, collapse="&"))
}

#' Generate the connection configuration
#' 
#' Use this function to generate a base configuration for all the other functions. 
#' 
#' @return list
#' @param base_url character. The base URL for the API calls. It should start with the protocol ("http") 
#' and end with "api". Defaults to OpenDataBio test server.
#' @param token character. The API token for a registered user. The data that can be accessed will vary
#' from user to user! Leave blank for anonymous login.
#' @param api_version character. Use this to specify the API version to connect to. You can set this to NULL to connect to the latest API, but this might break your code.
#' @param \dots Further parameters to be passed to add_headers. 
#' @examples
#' cfg = odb_config(
#'    base_url = "http://localhost/opendatabio/api", 
#'    token = "ABCDEF", 
#'    api_version = "v0"
#' )
#' @export
#' @import httr
odb_config <- function(base_url, token, api_version, ...) {
    cfg = list()

    if (missing(base_url)) {
        cfg$base_url = "http://opendatabio.ib.usp.br/opendatabio/api"
    } else {
        cfg$base_url = base_url
    }
    if (missing (api_version))
        api_version = "v0"
    if (! is.null(api_version))
        cfg$base_url = paste(cfg$base_url, api_version, sep="/")

    headers = c(accept("application/json"), 
                content_type("application/json"),
                user_agent(default_ua()))
    if (! missing(token))
        headers = c(headers, add_headers(Authorization=token))
    if (length(list(...)) != 0)
        headers = c(headers, add_headers(...))
    cfg$headers = headers
    return (cfg)
}


# Default User Agent includes details on curl, httr and opendatabio versions
default_ua = function() {
    versions <- c(
      opendatabio = as.character(utils::packageVersion("opendatabio")),
      `r-curl` = as.character(utils::packageVersion("curl")),
      httr = as.character(utils::packageVersion("httr")))
    paste0(names(versions), "/", versions, collapse = " ")
}

#' Simple plotting function
#'
#' This is a plotting example for using rgeos with OpenDataBio data.
#' 
#' @export
#' @import graphics
#' @param locations data.frame, as returned by \code{\link{odb_get_locations}}
#' @param \dots additional graphic parameters
plot_locations = function(locations, ...) {
    dots = list(...)
    if (! is.data.frame(locations) || ! 'geom' %in% names(locations))
        stop("Locations needs to be a data.frame with a 'geom' column")
    if (! requireNamespace("rgeos", quietly = TRUE)) 
        stop("Please install rgeos: install.packages('rgeos')")
    wkts = c()
    if (! "main" %in% names(dots)) dots['main'] = "OpenDataBio locations plot"
    if (! "axes" %in% names(dots)) dots['axes'] = TRUE
    for(i in 1:nrow(locations))
    	wkts = c(wkts, rgeos::readWKT(locations$geom[[i]]))
    to_plot = do.call(rbind, c(wkts, makeUniqueIDs = TRUE))
    do.call(rgeos::plot, c(to_plot, dots))
}

#' Converts SpatialPolygonsDataFrame data for handling
#' 
#' This function converts SpatialPolygonsDataFrame to data.frame for easier importing to OpenDataBio.
#' 
#' This function requires that the suggested package 'rgeos' is installed. It fills some of the fields using 
#' the data supplied, and works best with http://gadm.org data. NOTE: this function is deprecated and will be replaced by a more in-depth vignette.
#' @export
#' @param data SpatialPolygonsDataFrame to be converted
#' @param name_arg a vector of names to be used
#' @param adm_level_arg a vector of adm_levels to be used
sp_to_df = function(data, name_arg = NA, adm_level_arg = NA) {
    if (class(data) != "SpatialPolygonsDataFrame") 
        stop ("Currently sp_to_df only accepts SpatialPolygonsDataFrame")
        warning("sp_to_df has been deprecated and will be removed in a future version!")
    adm_level <- NA; parent <- NA; geom <- NA; datum <- NA
    ## Extracts datum
    str = data@proj4string@projargs
    datum = gsub(".*datum=(.*?) .*", "\\1", str)

    # Extract fields from gadm data
    if('NAME_3' %in% names(data)) {
        name = data$NAME_3
        adm_level = 3
        parent = data$NAME_2
        geom = rgeos::writeWKT(data, TRUE)
    } else if('NAME_2' %in% names(data)) {
        name = data$NAME_2
        adm_level = 2
        parent = data$NAME_1 
        geom = rgeos::writeWKT(data, TRUE)
    } else if('NAME_1' %in% names(data)) {
        name = data$NAME_1
        adm_level = 1
        parent = data$NAME_0
        geom = rgeos::writeWKT(data, TRUE)
    } else if('NAME_FAO' %in% names(data)) {
        # TODO: check this!
        name = data$NAME_FAO
        adm_level = 0
        parent = NA
        geom = rgeos::writeWKT(data, FALSE)
    }
    if (length(geom) == 1 && is.na(geom))
        geom = rgeos::writeWKT(data, TRUE)
    # Uses fields from arguments
    if (length(name_arg) > 1 || !is.na(name_arg))
        name = name_arg
    if (length(adm_level_arg) > 1 || !is.na(adm_level_arg))
        adm_level = adm_level_arg
    return (data.frame(name = name, adm_level = adm_level, parent = parent, datum=datum, geom=geom))
}
