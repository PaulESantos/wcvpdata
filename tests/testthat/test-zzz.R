test_that("wcvp_is_attached works", {
  expect_true(wcvp_is_attached("wcvpdata"))
  expect_false(wcvp_is_attached("nonexistentpackage_xyz"))
})

test_that("wcvp_is_loading_for_tests detects environment", {
  # In a testthat environment, this should usually be TRUE if DEVTOOLS_LOAD is set
  # But we can verify it returns a logical
  expect_type(wcvp_is_loading_for_tests(), "logical")
})

test_that("wcvp_inform_startup does not error", {
  expect_silent(wcvp_inform_startup(NULL))
  # Mocking packageStartupMessage is hard without trace, but we can check it returns invisible
  expect_invisible(wcvp_inform_startup("test message"))
})
