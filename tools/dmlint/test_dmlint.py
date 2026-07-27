import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import dmlint


class LexerTests(unittest.TestCase):
    def test_ignores_delimiters_in_comments_and_strings(self):
        source = 'var/message = "not syntax: { ]" // )\n/* ( */\n'
        self.assertEqual(dmlint.lint_text(source), [])

    def test_comment_immediately_after_word_is_ignored(self):
        source = "value = null// don't parse this ;)\n"
        self.assertEqual(dmlint.lint_text(source), [])

    def test_unterminated_string_has_location(self):
        result = dmlint.lint_text('var/name = "unfinished', "code/bad.dm")
        self.assertEqual(result[0].code, "DM002")
        self.assertEqual((result[0].path, result[0].line, result[0].column),
                         ("code/bad.dm", 1, 12))

    def test_unterminated_comment_is_an_error(self):
        result = dmlint.lint_text("/* never closed")
        self.assertEqual(result[0].code, "DM001")


class StructureTests(unittest.TestCase):
    def test_balanced_nested_delimiters(self):
        self.assertEqual(dmlint.lint_text("/proc/f(x)\n\treturn list(x[1])\n"), [])

    def test_nested_string_in_interpolation(self):
        source = 'var/message = "value: [isnull(x) ? "null" : "[x]"]"\n'
        self.assertEqual(dmlint.lint_text(source), [])

    def test_raw_and_block_strings(self):
        source = 'var/a = regex(@{""|[\\\\n]})\nvar/b = {"[literal]"}\nvar/c = regex(@@["()]@)\n'
        self.assertEqual(dmlint.lint_text(source), [])

    def test_mismatched_delimiter_reports_opener(self):
        result = dmlint.lint_text("call([1, 2})")
        codes = {item.code for item in result}
        self.assertIn("DM004", codes)
        self.assertIn("DM004", codes)

    def test_preprocessor_stack(self):
        self.assertEqual(dmlint.lint_text("#ifdef TEST\n#endif\n"), [])
        result = dmlint.lint_text("#else\n")
        self.assertEqual(result[0].code, "DM007")

    def test_directive_arguments(self):
        codes = {item.code for item in dmlint.lint_text("#define\n#include foo.dm\n")}
        self.assertEqual(codes, {"DM009", "DM010"})

    def test_valid_type_path(self):
        self.assertEqual(dmlint.lint_text("/obj/item/tool\n"), [])

    def test_multiline_macro_is_opaque(self):
        source = "#define BUILD(X) call(X);\\\n/list/new(){\\\n}\n"
        self.assertEqual(dmlint.lint_text(source), [])

    def test_block_string_macro_is_opaque(self):
        source = '#define SCRIPT {"\nif (x) { return ")"; }\n"}\n'
        self.assertEqual(dmlint.lint_text(source), [])


class DiscoveryAndCliTests(unittest.TestCase):
    def test_discovery_is_recursive_sorted_and_dm_only(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "code" / "nested").mkdir(parents=True)
            (root / "code" / "z.dm").write_text("", encoding="utf-8")
            (root / "code" / "nested" / "a.dm").write_text("", encoding="utf-8")
            (root / "code" / "ignored.txt").write_text("", encoding="utf-8")
            self.assertEqual(
                [item.relative_to(root).as_posix() for item in dmlint.discover(root)],
                ["code/nested/a.dm", "code/z.dm"],
            )

    def test_json_cli_and_error_exit(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "code").mkdir()
            (root / "code" / "bad.dm").write_text("call(]\n", encoding="utf-8")
            result = subprocess.run(
                [sys.executable, dmlint.__file__, "--format", "json", str(root)],
                check=False, capture_output=True, text=True,
            )
            payload = json.loads(result.stdout)
            self.assertEqual(result.returncode, 1)
            self.assertEqual(payload["files"], 1)
            self.assertTrue(payload["diagnostics"])

    def test_missing_code_directory_is_usage_error(self):
        with tempfile.TemporaryDirectory() as directory:
            result = subprocess.run(
                [sys.executable, dmlint.__file__, directory],
                check=False, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 2)
            self.assertIn("code directory not found", result.stderr)


if __name__ == "__main__":
    unittest.main()
