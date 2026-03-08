describe("WCVP Names Data", {
  it("matches metadata and satisfies integrity constraints", {
    expect_valid_wcvp_names(wcvp_checklist_names)
    expect_equal(nrow(wcvp_checklist_names), metadata$name_rows)
    expect_equal(ncol(wcvp_checklist_names), 31)
  })
})

describe("WCVP Distribution Data", {
  it("matches metadata and satisfies referential integrity", {
    expect_valid_wcvp_distribution(wcvp_checklist_distribution, names_data = wcvp_checklist_names)
    expect_equal(nrow(wcvp_checklist_distribution), metadata$dist_rows)
    expect_equal(ncol(wcvp_checklist_distribution), 11)
  })
})
