# wcvpdata 0.7.0

# wcvpdata 0.6.0

* Replaced lazy-loaded `.rda` datasets with Zstandard-compressed Parquet
  tables for matching, synonyms, taxonomic distribution joins, and geographic
  distributions.
* Added lazy Arrow accessors: `wcvp_matching_names()`,
  `wcvp_synonym_index()`, `wcvp_distribution_names()`,
  `wcvp_distribution()`, and `wcvp_open_dataset()`.
* Removed the legacy `wcvp_checklist_names` and
  `wcvp_checklist_distribution` objects. Code using those objects must migrate
  to the new accessors.

# wcvpdata 0.5.1

* Added `wcvp_validate_data()` to validate the local bundled WCVP dataset dimensions and referential integrity.
* Updated bundled WCVP database to Version 16 (June 2026).
* Prepared package for CRAN submission.
* Added `@return` documentation to all exported functions.
* Added `@examples` to all exported datasets.
* Refined `DESCRIPTION` Title and Description fields for CRAN compliance.
* Added copyright holder (`[cph]`) role to authors in `DESCRIPTION`.
* Updated `README.md` with CRAN installation instructions and usage examples.
