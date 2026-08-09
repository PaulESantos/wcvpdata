#' Open a packaged WCVP Parquet dataset
#'
#' Opens one of the columnar WCVP tables bundled with the package. The returned
#' Arrow Dataset is lazy: columns and rows are read only when a query is
#' collected.
#'
#' @param table One of `"matching_names"`, `"synonym_index"`,
#'   `"distribution_names"`, or `"distribution"`.
#'
#' @return An `arrow::Dataset`.
#' @export
#'
#' @examples
#' \dontrun{
#' wcvp_open_dataset("matching_names")
#' }
wcvp_open_dataset <- function(table) {
  table <- match.arg(table, wcvp_table_names())
  arrow::open_dataset(wcvp_parquet_path(table), format = "parquet")
}

#' WCVP matching backbone
#'
#' A compact taxonomic backbone for matching plant names. Unlike the legacy
#' lazy-data object, this reads no data until requested.
#'
#' @param as_data_frame If `FALSE` (the default), return a lazy Arrow Dataset.
#'   If `TRUE`, materialize the selected columns as a tibble.
#' @param columns Optional character vector of columns to read when
#'   `as_data_frame = TRUE`.
#'
#' @return An `arrow::Dataset` or a tibble.
#' @export
wcvp_matching_names <- function(as_data_frame = FALSE, columns = NULL) {
  wcvp_read_table("matching_names", as_data_frame, columns)
}

#' WCVP synonym index
#'
#' Accepted names and their nomenclatural synonym records.
#'
#' @inheritParams wcvp_matching_names
#' @return An `arrow::Dataset` or a tibble.
#' @export
wcvp_synonym_index <- function(as_data_frame = FALSE, columns = NULL) {
  wcvp_read_table("synonym_index", as_data_frame, columns)
}

#' WCVP taxonomic data for distribution joins
#'
#' Taxonomic identifiers and hierarchy needed to join geographic records.
#'
#' @inheritParams wcvp_matching_names
#' @return An `arrow::Dataset` or a tibble.
#' @export
wcvp_distribution_names <- function(as_data_frame = FALSE, columns = NULL) {
  wcvp_read_table("distribution_names", as_data_frame, columns)
}

#' WCVP geographic distribution records
#'
#' Geographic records mapped to TDWG WGSRPD levels.
#'
#' @inheritParams wcvp_matching_names
#' @return An `arrow::Dataset` or a tibble.
#' @export
wcvp_distribution <- function(as_data_frame = FALSE, columns = NULL) {
  wcvp_read_table("distribution", as_data_frame, columns)
}

wcvp_table_names <- function() {
  c("matching_names", "synonym_index", "distribution_names", "distribution")
}

wcvp_parquet_path <- function(table) {
  path <- system.file("extdata", paste0("wcvp_", table, ".parquet"),
    package = "wcvpdata"
  )
  if (!nzchar(path)) {
    stop("The packaged Parquet file for '", table, "' was not found.", call. = FALSE)
  }
  path
}

wcvp_read_table <- function(table, as_data_frame, columns) {
  if (!isTRUE(as_data_frame)) return(wcvp_open_dataset(table))
  arrow::read_parquet(wcvp_parquet_path(table), col_select = columns)
}
