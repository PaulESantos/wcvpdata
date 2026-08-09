describe("WCVP Parquet data", {
  it("exposes the specialized datasets lazily", {
    datasets <- list(
      matching_names = wcvp_matching_names(),
      synonym_index = wcvp_synonym_index(),
      distribution_names = wcvp_distribution_names(),
      distribution = wcvp_distribution()
    )

    expect_true(all(vapply(datasets, inherits, logical(1), what = "Dataset")))
  })

  it("reads selected matching columns only", {
    names <- wcvp_matching_names(
      as_data_frame = TRUE,
      columns = c("plant_name_id", "taxon_name")
    )
    expect_equal(nrow(names), metadata$name_rows)
    expect_named(names, c("plant_name_id", "taxon_name"))
  })
})
