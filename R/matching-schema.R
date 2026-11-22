# Build-time normalization only; accessors never transform the rows.
wcvp_normalize_matching_names <- function(x) {
  components <- c("genus", "species", "infraspecific_rank", "infraspecies")
  missing <- setdiff(components, names(x))
  if (length(missing)) stop("Missing matching components: ", paste(missing, collapse = ", "))
  for (nm in components) {
    value <- stringr::str_squish(as.character(x[[nm]]))
    value[!is.na(value) & value == ""] <- NA_character_
    x[[nm]] <- value
  }
  rank <- toupper(x$infraspecific_rank)
  aliases <- c(SUBSP = "SUBSP.", `SUBSP.` = "SUBSP.", SSP = "SUBSP.", `SSP.` = "SUBSP.",
    VAR = "VAR.", `VAR.` = "VAR.", SUBVAR = "SUBVAR.", `SUBVAR.` = "SUBVAR.",
    F = "F.", `F.` = "F.", FO = "F.", `FO.` = "F.", FORM = "F.", FORMA = "F.",
    SUBF = "SUBF.", `SUBF.` = "SUBF.")
  known <- !is.na(rank) & rank %in% names(aliases)
  rank[known] <- unname(aliases[rank[known]])
  x$infraspecific_rank <- rank
  x
}

wcvp_matching_arrow_table <- function(x) {
  table <- arrow::Table$create(wcvp_normalize_matching_names(x))
  meta <- table$schema$metadata
  meta[["wcvpdata.matching_schema_version"]] <- "1"
  table$ReplaceSchemaMetadata(meta)
}

#' Inspect the matching backbone normalization contract
#'
#' Reads Parquet schema metadata without materializing the backbone.
#' Version 1 guarantees character genus, species, infraspecific_rank and
#' infraspecies columns, squished whitespace, missing rather than empty
#' components, and uppercase canonical ranks (SUBSP., VAR., SUBVAR., F., SUBF.).
#' Unknown ranks are preserved in uppercase. Rows, identifiers, names and
#' authorship are preserved. This is a data contract, not a search index.
#' @return A character schema version, or NULL for an unversioned file.
#' @export
wcvp_matching_schema <- function() {
  wcvp_open_dataset("matching_names")$schema$metadata[["wcvpdata.matching_schema_version"]]
}
