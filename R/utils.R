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
                                       ),
                               "send request.\n  Check a full list of error codes in\n  https://github.com/opendatabio/opendatabio/wiki/API#possible-errors")
    # Usually Accept is application/json, but this may be overriden using odb_config
    if(! grepl(http_type(response), odb_cfg$headers$headers["Accept"], ignore.case=TRUE))
        stop("Wrong answer type from server: ", http_type(response))
    return(response)
}

# Base workhorse for POST methods
odb_send_post = function(data, odb_cfg, endpoint, common) {
    url = paste0(odb_cfg$base_url, "/", endpoint)
    # Removes double slashes (probably due to "pasting" urls already with /)
    # Do NOT remove the double slashes after http:
    url = gsub("([^:])//", "\\1/", url)

    # Combines the "body" data.frame with the common fields passed
    body = list(data = data, header = common)
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
#' The 'encode' parameter is used to encode the parameter list, replacing special symbols with their corresponding
#' hexadecimal representation so they can be used as an URL. For instance, 'Capão da Canoa' would be encoded as
#' 'Cap%C3%A3o%20da%20Canoa'. Note that some special symbols such as = and & have special meaning in the URL scheme,
#' so if you call \code{odb_params} using a literal string, these will be ignored. If you need to run a query using these
#' symbols (such as if your locality name contains a &), you will need to use the list version of this function.
#' See the help on \code{\link[utils]{URLencode}} for the underlying encoding function.
#'
#' @return character
#' @param params named list or character string.
#' @param encode logical. Should the strings be encoded to URL scheme?
#' @examples
#' odb_params(list(level=210, valid=TRUE))
#' odb_params("search=edulis")
#' @export
odb_params <- function(params = list(), encode = TRUE) {
    if (class(params) == "character" && length(names(params)) == 0) {
        if (encode) {
            return(utils::URLencode(params, reserved = FALSE))
        } else {
            return(params)
        }
    }
    if (! is.list(params)) {
        stop("odb_params expects either a list or an unnamed character string")
    }
    # we convert logical values to numeric
    logic = sapply(params, is.logical)
    if (length(logic))
        params[logic] = as.numeric(params[logic])
    # we glue together params passed as vectors
    if(length(params) > 0)
        for (i in 1:length(params))
            params[[i]] = paste(params[[i]], collapse=",")
    # Here, we encode them to URL scheme
    if (encode & length(params) > 0) {
        for (i in 1:length(params))
            params[[i]] = utils::URLencode(as.character(params[[i]]), reserved = TRUE)
    }
    # and "connect" them to their names
    params = paste(names(params),params,sep="=")
    # finally, we paste together all the values
    return(paste(params, collapse="&"))
}

#' Generate the connection configuration
#'
#' Use this function to generate a base configuration for all the other functions.
#'
#' You can set the environment variables ODB_BASE_URL, ODB_TOKEN and ODB_API_VERSION to avoid typing these at each script. Please note that
#' if you need to use the \code{odb_config} function explicitly if you need more flexibility.
#'
#' @return list
#' @param base_url character. The base URL for the API calls. It should start with the protocol ("http")
#' and end with "api". Defaults to OpenDataBio test server.
#' @param token character. The API token for a registered user. The data that can be accessed will vary
#' from user to user! Leave blank for anonymous login.
#' @param api_version character. Use this to specify the API version to connect to. You can set this to NULL to connect to the latest API, but this might break your code.
#' @param \dots Further parameters to be passed to add_headers.
#' @examples
#' \dontrun{
#' cfg = odb_config(
#'    base_url = "http://localhost/opendatabio/api",
#'    token = "ABCDEF",
#'    api_version = "v0"
#' )
#' }
#' @export
#' @import httr
odb_config <- function(base_url, token, api_version, ...) {
    cfg = list()

    if (missing(base_url)) {
        if (Sys.getenv("ODB_BASE_URL") != "") {
            cfg$base_url = Sys.getenv("ODB_BASE_URL")
        } else {
            cfg$base_url = "http://localhost:8080/api"
        }
    } else {
        cfg$base_url = base_url
    }

    if (missing(api_version)) {
        if (Sys.getenv("ODB_API_VERSION") != "") {
            api_version = Sys.getenv("ODB_API_VERSION")
        } else {
            api_version = "v0"
        }
    }
    if (! is.null(api_version))
        cfg$base_url = paste(cfg$base_url, api_version, sep="/")

    headers = c(accept("application/json"),
                content_type("application/json"),
                user_agent(default_ua()))

    if (missing(token)) {
        if (Sys.getenv("ODB_TOKEN") != "") {
            headers = c(headers, add_headers(Authorization=Sys.getenv("ODB_TOKEN")))
        } # else... no default token!
    } else {
        headers = c(headers, add_headers(Authorization=token))
    }

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
sp_to_df <- function (data, name_arg = NA, adm_level_arg = NA)
{
 if (class(data) != "SpatialPolygonsDataFrame")
  stop("Currently sp_to_df only accepts SpatialPolygonsDataFrame")
 #warning("sp_to_df has been deprecated and will be removed in a future version!")
 adm_level <- NA
 parent <- NA
 geom <- NA
 datum <- NA
 str = data@proj4string@projargs
 datum = gsub(".*datum=(.*?) .*", "\\1", str)
 if ("NAME_3" %in% names(data)) {
  name = data$NAME_3
  adm_level = 3
  parent = data$NAME_2
  geom = rgeos::writeWKT(data, TRUE)
 }
 else if ("NAME_2" %in% names(data)) {
  name = data$NAME_2
  adm_level = 2
  parent = data$NAME_1
  geom = rgeos::writeWKT(data, TRUE)
 }
 else if ("NAME_1" %in% names(data)) {
  name = data$NAME_1
  adm_level = 1
  parent = data$NAME_0
  geom = rgeos::writeWKT(data, TRUE)
 }
 else if ("NAME_FAO" %in% names(data) | "NAME_0" %in% names(data)) {
  if ("NAME_FAO" %in% names(data)) {
   name = data$NAME_FAO
  } else {
   name = data$NAME_0
  }
  adm_level = 0
  parent = NA
  geom = rgeos::writeWKT(data, FALSE)
 }
 if (length(geom) == 1 && is.na(geom))
  geom = rgeos::writeWKT(data, TRUE)
 if (length(name_arg) > 1 || !is.na(name_arg))
  name = name_arg
 if (length(adm_level_arg) > 1 || !is.na(adm_level_arg))
  adm_level = adm_level_arg
 return(data.frame(name = name, adm_level = adm_level, parent = parent,
                   datum = datum, geom = geom))
}


##### Functions for formatting GET objects as data.frames
safe_unlist = function(column, nrow) {
    # Replaces "named list()" with NA as values
    column = lapply(column, function (x) {
                        if(length(x)==0)
                            return(NA)
                        return (x)
             })
    ret = unlist(column)
    # Replaces "data.frame with 0 columns"
    if (is.null(ret))
        return (rep(NA, nrow))
    return (ret)
}

format_get_response = function(response, simplify) {
    data = fromJSON(toJSON(content(response)))$data
    if (simplify)
        data = as.data.frame(lapply(data, safe_unlist, nrow(data)), stringsAsFactors = FALSE)
    return(data)
}
format_get_bibresponse <- function (response, simplify)
{
  data = fromJSON(toJSON(content(response)))$data
  dt = unlist(data)
  mm = matrix(dt,nrow=length(data),ncol=length(data[[1]]),byrow=TRUE)
  mm = as.data.frame(mm, stringsAsFactors = FALSE)
  colnames(mm) = names(data[[1]])
  return(mm)
}

##specific to traits
format_get_response_traits = function(response, simplify) {
  data = fromJSON(toJSON(content(response)))$data
  if (!simplify) {
    return(data)
  }
  categories = data$categories
  data$categories = NA
  data = as.data.frame(lapply(data, safe_unlist, nrow(data)), stringsAsFactors = FALSE)
  lc = sapply(categories,length)
  if (max(lc)>0) {
    categories = lapply(categories, safe_unlist_categories)
    data$categories = categories
  }
  return(data)
}

safe_unlist_categories = function(cat) {
  if (length(cat)==0) {
    return(NA)
  }
  cat[] = lapply(cat,safe_unlist,length(cat))
  return(cat)
}



#' Wait for a running job
#'
#' This function sleeps until a job finishes. It can be used to "queue"
#' jobs on the user side.
#' @param job Either a number representing a job id, or the response from a odb_import_* call
#' @param verbose logical. Should this function print job progress to screen?
#' @param interval numeric, time in seconds between prints
#' @inheritParams odb_get_taxons
#' @return data.frame, the final job object is silently returned to the user
#' @examples
#'\dontrun{
#'  wait_for_job(odb_import_locations(data, cfg), cfg)
#'}
#' @export
wait_for_job = function(job, odb_cfg = odb_config(), verbose = TRUE, interval = 10) {
    fields = c("id", "created_at", "updated_at", "status", "percentage")
    if (is.numeric(job) && length(job) == 1)
        job = odb_get_jobs(list(id=job, fields=fields), odb_cfg)
    if (!is.data.frame(job) || nrow(job) > 1)
        stop("job parameter must be a single number or a single job object")
    while (job$status %in% c("Submitted", "Processing")) {
        if (verbose) {
            cat("Job id", job$id, "status", job$status, "progress", job$percentage, "ETA", get_eta(job), "\n")
        }
        Sys.sleep(interval)
        job = odb_get_jobs(list(id=job$id, fields=fields), odb_cfg)
    }
    cat("Job id", job$id, "finished as", job$status, "\n")
    invisible(job)
}

get_eta = function(job) {
    progress = as.numeric(gsub("[-%]","", job$percentage))
    if (is.na(progress)) return(NA)
    created = strptime(job$created_at, format='%Y-%m-%d %H:%M:%S')
    updated = strptime(job$updated_at, format='%Y-%m-%d %H:%M:%S')
    return (as.character(created + 100 / progress * (updated - created)))
}

internal_clear_env = function() {
    Sys.setenv(ODB_TOKEN="", ODB_BASE_URL = "", ODB_API_VERSION = "")
}
