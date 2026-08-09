#' Functions to help check the WCVP data is okay and up to date.

#' View the version of WCVP available.
#'
#' `r lifecycle::badge("stable")`
#'
#' @param long Whether to return the version date with version number.
#'
#' @return A character string containing the version and date.
#'
#' @importFrom glue glue
#'
#' @export
#'
#' @examples
#' wcvp_version()
#'
wcvp_version <- function(long = TRUE) {
  if (long) {
    glue::glue("Version {metadata$version} ({metadata$version_date})")
  } else {
    as.character(metadata$version)
  }
}


#' Check if the packaged version of WCVP is up to date.
#'
#' `r lifecycle::badge("stable")`
#'
#' @param silent Suppress all messages and warnings.
#'
#' @return A logical value; TRUE if the packaged version is up to date,
#'   FALSE otherwise.
#'
#' @importFrom cli cli_warn cli_inform
#' @export
#'
#' @examples
#' wcvp_check_version()
#'
wcvp_check_version <- function(silent = FALSE) {
  latest_date <- wcvp_get_upload_date()
  if (is.null(latest_date)) {
    if (!silent) {
      cli::cli_warn("Could not check for latest WCVP version (offline or server error).")
    }
    return(invisible(NULL))
  }
  up_to_date <- latest_date == metadata$upload_date
  if (!silent) {
    if (up_to_date) {
      cli::cli_inform(c(
        "v" = "WCVP data is up to date.",
        "i" = "Current version: {wcvp_version()}, uploaded on {.val {metadata$upload_date}}."
      ))
    } else {
      cli::cli_warn(c(
        "!" = "WCVP data is not the most recent version.",
        "i" = "Using {wcvp_version()} uploaded on {.val {metadata$upload_date}}.",
        "i" = "Latest version was uploaded on {.val {latest_date}}."
      ))
    }
  }
  invisible(up_to_date)
}


#' Validate the local WCVP data against package metadata.
#'
#' `r lifecycle::badge("stable")`
#'
#' This function checks the bundled Parquet tables against package metadata and
#' basic integrity constraints. It materializes identifier columns only.
#' @param silent Suppress all messages and warnings.
#'
#' @return A logical value; `TRUE` if the local data matches the metadata and
#'   satisfies integrity checks, `FALSE` otherwise.
#'
#' @importFrom cli cli_warn cli_inform
#' @export
#'
#' @examples
#' wcvp_validate_data()
#'
wcvp_validate_data <- function(silent = FALSE) {
  names <- wcvp_matching_names(as_data_frame = TRUE,
    columns = c("plant_name_id")
  )
  distribution <- wcvp_distribution(as_data_frame = TRUE,
    columns = c("plant_name_id")
  )
  names_loaded <- tryCatch({
    is.data.frame(names)
  }, error = function(e) FALSE)

  dist_loaded <- tryCatch({
    is.data.frame(distribution)
  }, error = function(e) FALSE)

  if (!names_loaded || !dist_loaded) {
    if (!silent) {
      cli::cli_warn("Local WCVP datasets are not loaded or available.")
    }
    return(FALSE)
  }

  names_ok <- nrow(names) == metadata$name_rows

  dist_ok <- nrow(distribution) == metadata$dist_rows

  ref_ok <- all(distribution$plant_name_id %in% names$plant_name_id)

  all_ok <- names_ok && dist_ok && ref_ok

  if (!silent) {
    if (all_ok) {
      cli::cli_inform(c(
        "v" = "Local WCVP data validation successful.",
        "i" = "Names dataset: {nrow(names)} rows, {ncol(names)} columns.",
        "i" = "Distribution dataset: {nrow(distribution)} rows, {ncol(distribution)} columns."
      ))
    } else {
      if (!names_ok) {
        cli::cli_warn("Names dataset row count mismatches metadata ({metadata$name_rows}).")
      }
      if (!dist_ok) {
        cli::cli_warn("Distribution dataset row count mismatches metadata ({metadata$dist_rows}).")
      }
      if (!ref_ok) {
        cli::cli_warn("Referential integrity check failed: some distribution records reference invalid plant_name_id values.")
      }
    }
  }

  invisible(all_ok)
}

