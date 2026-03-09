test_that("wcvp_get_upload_date handles offline mode", {
  local_mocked_bindings(
    has_internet = function() FALSE,
    .package = "curl"
  )
  expect_null(wcvp_get_upload_date())
})

test_that("wcvp_get_upload_date handles server errors", {
  local_mocked_bindings(
    has_internet = function() TRUE,
    .package = "curl"
  )
  local_mocked_bindings(
    GET = function(...) stop("Server Error"),
    .package = "httr"
  )
  expect_null(wcvp_get_upload_date())
})
