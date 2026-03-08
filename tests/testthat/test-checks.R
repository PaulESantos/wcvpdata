describe("wcvp_version()", {
  it("returns version in expected format", {
    expect_type(wcvp_version(), "character")
    expect_match(wcvp_version(long = FALSE), "^\\d+$")
    expect_match(wcvp_version(long = TRUE), "^Version \\d+ \\(\\d{2} [A-Za-z]{3} \\d{4}\\)$")
  })
})

describe("wcvp_check_version()", {
  # Mocking wcvp_get_upload_date to avoid network calls and be predictable
  withr::local_envvar(R_TESTS = "")

  it("identifies when package is up to date", {
    local_mocked_bindings(
      wcvp_get_upload_date = function() metadata$upload_date
    )
    expect_true(wcvp_check_version(silent = TRUE))
  })

  it("identifies when package is out of date", {
    local_mocked_bindings(
      wcvp_get_upload_date = function() "2099-01-01"
    )
    expect_false(wcvp_check_version(silent = TRUE))
    expect_warning(wcvp_check_version(silent = FALSE), "not the most recent version")
  })

  it("handles network failures gracefully", {
    local_mocked_bindings(
      wcvp_get_upload_date = function() NULL
    )
    expect_null(wcvp_check_version(silent = TRUE))
    expect_warning(wcvp_check_version(silent = FALSE), "Could not check")
  })
})
