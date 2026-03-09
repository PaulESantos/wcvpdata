#' Custom expectations for WCVP data validation

#' Expect valid wcvp_names data frame
#'
#' @param data A data frame containing WCVP names.
#' @return The data frame invisibly.
#' @export
expect_valid_wcvp_names <- function(data) {
  # Check class and columns
  expect_s3_class(data, "data.frame")

  expected_cols <- c(
    "plant_name_id", "family", "genus", "taxon_name", "taxon_status", "taxon_rank"
  )
  expect_contains(names(data), expected_cols)

  # Check uniqueness of plant_name_id
  expect_equal(anyDuplicated(data$plant_name_id), 0)

  # Check for missing values in critical columns
  expect_all_true(!is.na(data$family))
  expect_all_true(!is.na(data$genus))
  expect_all_true(!is.na(data$taxon_name))

  invisible(data)
}

#' Expect valid wcvp_distribution data frame
#'
#' @param data A data frame containing WCVP distributions.
#' @param names_data A data frame containing WCVP names for referential integrity.
#' @return The data frame invisibly.
#' @export
expect_valid_wcvp_distribution <- function(data, names_data = NULL) {
  # Check class and columns
  expect_s3_class(data, "data.frame")

  expected_cols <- c(
    "plant_locality_id", "plant_name_id", "continent", "region", "area"
  )
  expect_contains(names(data), expected_cols)

  # Referential integrity with names if provided
  if (!is.null(names_data)) {
    expect_in(data$plant_name_id, names_data$plant_name_id)
  }

  invisible(data)
}
