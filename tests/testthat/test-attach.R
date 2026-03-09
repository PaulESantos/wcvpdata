describe("Version Highlighting", {
  it("strips ANSI codes correctly", {
    # Both should return the correct version string regardless of styling
    expect_equal(cli::ansi_strip(wcvp_highlight_version("0.0.1")), "0.0.1")
    expect_equal(cli::ansi_strip(wcvp_highlight_version("0.0.0.9000")), "0.0.0.9000")
  })
})

describe("Package Attachment", {
  it("formats arrival message correctly", {
    msg <- wcvp_attach_message(c("pkg1", "pkg2"))
    expect_match(cli::ansi_strip(msg), "Attaching wcvpdata ecosystem")
    expect_match(cli::ansi_strip(msg), "pkg1")
    expect_match(cli::ansi_strip(msg), "pkg2")
    expect_null(wcvp_attach_message(character(0)))
  })

  it("identifies missing core packages", {
    # We know wcvpdata is loaded because we are testing it
    expect_false("wcvpdata" %in% wcvp_core_unloaded())
  })

  it("handles missing libraries gracefully", {
    # Should return invisible(NULL) because 'nonexistentpackage' isn't installed
    expect_invisible(wcvp_same_library("nonexistentpackage"))
  })
})
