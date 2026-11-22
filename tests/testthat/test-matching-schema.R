test_that("normalization preserves records and is idempotent", {
  x <- data.frame(genus = c(" Acer ", "Acer\u00a0rubrum", NA),
    species = c("rubrum", " ", "a  b"),
    infraspecific_rank = c(" ssp ", "Forma", "novel"),
    infraspecies = c(" x ", "", NA), plant_name_id = c(3, 1, 2),
    taxon_authors = c(" A.  B.", "C.", NA))
  out <- wcvp_normalize_matching_names(x)
  expect_identical(out$genus, c("Acer", "Acer rubrum", NA_character_))
  expect_identical(out$species, c("rubrum", NA_character_, "a b"))
  expect_identical(out$infraspecific_rank, c("SUBSP.", "F.", "NOVEL"))
  expect_identical(out$infraspecies, c("x", NA_character_, NA_character_))
  expect_identical(out$plant_name_id, x$plant_name_id)
  expect_identical(out$taxon_authors, x$taxon_authors)
  expect_identical(wcvp_normalize_matching_names(out), out)
  expect_error(wcvp_normalize_matching_names(x["genus"]), "Missing matching")
})

test_that("supported aliases are canonicalized", {
  ranks <- c("subsp", "subsp.", "ssp", "ssp.", "var", "var.", "subvar",
    "subvar.", "f", "f.", "fo", "fo.", "form", "forma", "subf", "subf.", "", NA)
  x <- data.frame(genus = "Acer", species = "rubrum",
    infraspecific_rank = ranks, infraspecies = NA_character_)
  expect_identical(wcvp_normalize_matching_names(x)$infraspecific_rank,
    c(rep("SUBSP.", 4), rep("VAR.", 2), rep("SUBVAR.", 2), rep("F.", 6),
      rep("SUBF.", 2), NA_character_, NA_character_))
})

test_that("packaged data satisfies its declared contract", {
  expect_identical(wcvp_matching_schema(), "1")
  x <- wcvp_matching_names(TRUE)
  expect_identical(attr(x, "wcvpdata_matching_schema"), "1")
  expect_identical(wcvp_normalize_matching_names(x), x)
  expect_equal(nrow(x), metadata$name_rows)
  projected <- wcvp_matching_names(TRUE, c("genus", "species"))
  expect_named(projected, c("genus", "species"))
  expect_identical(attr(projected, "wcvpdata_matching_schema"), "1")
  expect_s3_class(wcvp_matching_names(), "Dataset")
})

test_that("R writer persists schema metadata", {
  x <- data.frame(genus = " Acer ", species = "rubrum", infraspecific_rank = "ssp",
    infraspecies = "x")
  path <- tempfile(fileext = ".parquet")
  on.exit(unlink(path))
  arrow::write_parquet(wcvp_matching_arrow_table(x), path)
  ds <- arrow::open_dataset(path)
  expect_identical(ds$schema$metadata[["wcvpdata.matching_schema_version"]], "1")
  expect_identical(arrow::read_parquet(path)$infraspecific_rank, "SUBSP.")
})
