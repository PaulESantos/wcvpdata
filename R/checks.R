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
#' @param silent Raise a warning if the version is out of date.
#'
#' @return A logical value; TRUE if the packaged version is up to date,
#'   FALSE otherwise.
#'
#' @importFrom cli cli_warn
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

  if (!silent && !up_to_date) {
    cli::cli_warn(c(
      "WCVP data not the most recent version!",
      "i" = "Using {wcvp_version()} uploaded on {.val {metadata$upload_date}}.",
      "i" = "Latest version was uploaded on {.val {latest_date}}."
    ))
  }

  up_to_date
}
