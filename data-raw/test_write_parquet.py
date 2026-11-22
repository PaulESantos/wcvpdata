"""Run with python -m unittest discover -s data-raw -p test_write_parquet.py."""
import unittest
import pyarrow as pa
from write_parquet import normalize_matching_names

class MatchingSchemaTests(unittest.TestCase):
    def test_aliases_whitespace_nulls_and_preservation(self):
        ranks = [" ssp ", "subsp.", "VAR", "subvar", "fo.", "forma", "subf", "", None, "novel"]
        table = pa.table({"genus": [" Acer\u00a0 rubrum "] * len(ranks),
            "species": ["  "] * len(ranks), "infraspecific_rank": ranks,
            "infraspecies": [None] * len(ranks), "plant_name_id": list(range(len(ranks)))})
        out = normalize_matching_names(table)
        self.assertEqual(out["infraspecific_rank"].to_pylist(),
            ["SUBSP.", "SUBSP.", "VAR.", "SUBVAR.", "F.", "F.", "SUBF.", None, None, "NOVEL"])
        self.assertEqual(out["genus"].to_pylist(), ["Acer rubrum"] * len(ranks))
        self.assertEqual(out["species"].to_pylist(), [None] * len(ranks))
        self.assertTrue(out["plant_name_id"].equals(table["plant_name_id"]))
        self.assertTrue(normalize_matching_names(out).equals(out))
        self.assertEqual(out.schema.metadata[b"wcvpdata.matching_schema_version"], b"1")

if __name__ == "__main__":
    unittest.main()
