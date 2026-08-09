"""Write the packaged WCVP v16 Parquet tables with Zstandard compression.

Run from the package root after downloading and unpacking the WCVP release:

    python data-raw/write_parquet.py --source D:/wcvp_data/wcvp_16/wcvp

The R update script (data-raw/wcvp.R) is the canonical build recipe. This
small companion is provided for release builds on hosts without R/arrow.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import pyarrow.csv as csv
import pyarrow.parquet as parquet


TABLES = {
    "wcvp_matching_names.parquet": (
        "wcvp_names.csv",
        [
            "plant_name_id", "taxon_rank", "taxon_status", "family", "genus",
            "species", "infraspecific_rank", "infraspecies", "taxon_name",
            "taxon_authors", "accepted_plant_name_id", "parent_plant_name_id",
        ],
    ),
    "wcvp_synonym_index.parquet": (
        "wcvp_names.csv",
        [
            "plant_name_id", "accepted_plant_name_id", "taxon_name",
            "taxon_authors", "taxon_status", "homotypic_synonym",
            "basionym_plant_name_id",
        ],
    ),
    "wcvp_distribution_names.parquet": (
        "wcvp_names.csv",
        [
            "plant_name_id", "accepted_plant_name_id", "family", "genus",
            "species",
        ],
    ),
    "wcvp_distribution.parquet": ("wcvp_distribution.csv", None),
}


def read_table(path: Path, columns: list[str] | None):
    return csv.read_csv(
        path,
        read_options=csv.ReadOptions(use_threads=True),
        parse_options=csv.ParseOptions(delimiter="|", quote_char=False),
        convert_options=csv.ConvertOptions(include_columns=columns),
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=Path("inst/extdata"))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)

    for output_name, (input_name, columns) in TABLES.items():
        table = read_table(args.source / input_name, columns)
        output_path = args.output / output_name
        parquet.write_table(
            table,
            output_path,
            compression="zstd",
            use_dictionary=True,
            row_group_size=131_072,
        )
        print(f"{output_path}: {table.num_rows:,} rows, {table.num_columns} columns")


if __name__ == "__main__":
    main()
