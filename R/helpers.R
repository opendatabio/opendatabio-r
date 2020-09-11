#' OpenDataBio Import Helpers
#'
#' Functions to retrieve codes and ids required to import data. Taxon levels, Trait types, Nomenclatural Types
#' 
#' @return data.frame or vector depending on function
#' @param level character. Taxon string level, 'species', 'fam.'. Default 'all'
#' @examples
#' odb_taxonLevelCodes()
#' odb_taxonLevelCodes(level='clade')
#' odb_traitTypeCodes()
#' odb_nomenclaturalTypes()
#' odb_detModifiers()
#' @export
#' @rdname helper_functions
odb_taxonLevelCodes = function(level="all") {
 codes = c(-100, 0, 10, 30, 30, 30, 30, 40, 60, 60, 70, 70, 80, 80,90, 90, 100, 120, 120, 130, 130, 150, 150, 180, 180, 190, 190, 190, 210, 210, 210, 210,220, 220, 240, 240, 270, 270, 270)
 names = c("clade", "kingdom", "subkingd.", "div.", "phyl.", "phylum", "division",  "subdiv.", "cl.", "class", "subcl.", "subclass", "superord.",  "superorder", "ord.", "order", "subord.", "fam.", "family", "subfam.", "subfamily",  "tr.", "tribe", "gen.", "genus", "subg.", "subgenus", "sect.", "section","sp.", "spec.", "species", "subsp.", "subspecies", "var.", "variety", "f.", "fo.", "form")
 if (sum(names%in%tolower(level))>0) {
  codes[match(tolower(level),names)]
 } else {
  data.frame(name=names,code=codes,stringsAsFactors = F)
 }
}

#' @export
#' @rdname helper_functions
odb_traitTypeCodes = function() {
 trcodes = c(QUANT_INTEGER = 0, QUANT_REAL = 1, CATEGORICAL = 2, CATEGORICAL_MULTIPLE = 3,ORDINAL = 4, TEXT = 5, COLOR = 6, LINK = 7, SPECTRAL =8)
 trcodes
}

#' @export
#' @rdname helper_functions
odb_nomenclaturalTypes <- function() {
 c(NotType=0,Type = 1,  Holotype = 2,  Isotype = 3,  Paratype = 4,  Lectotype = 5, Isolectotype = 6,  Syntype = 7,  Isosyntype = 8,  Neotype = 9,  Epitype = 10, Isoepitype = 11,  Cultivartype = 12,  Clonotype = 13,  Topotype = 14, Phototype = 15)
}

#' @export
#' @rdname helper_functions
odb_detModifiers <- function() {
 code.to.use = c(NONE=0,SS = 1,  SL = 2,  CF = 3,  AFF = 4,  VEL_AFF = 5)
 code = c("none","s.s.",'s.l.','cf.','aff.','vel aff.')
 definition = c('not modifying','sensu strictu, close to core species definition','sensu lato, in the broad sense','to be compared, confirmed, but likely this species','affinis means similar but possibly not the same','vel aff. means this species or something similar')
 data.frame(code.to.use,code,definition,stringsAsFactors = F)
}

