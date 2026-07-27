#!/usr/bin/env python3
"""Tests for DM Linter."""
import unittest
import tempfile
import os
from pathlib import Path
from dmlinter import DMLinter

class TestDMLinter(unittest.TestCase):
    def setUp(self):
        self.linter = DMLinter()
        self.tmpdir = tempfile.mkdtemp()
    
    def tearDown(self):
        import shutil
        shutil.rmtree(self.tmpdir, ignore_errors=True)
    
    def write_dm(self, name, content):
        path = Path(self.tmpdir) / name
        path.write_text(content)
        return path
    
    def test_discovers_dm_files(self):
        self.write_dm("test.dm", "/proc/test()\n\treturn")
        self.write_dm("readme.txt", "not dm")
        files = self.linter.discover_files(self.tmpdir)
        self.assertEqual(len(files), 1)
        self.assertTrue(str(files[0]).endswith("test.dm"))
    
    def test_detects_tab_indentation(self):
        self.write_dm("tabs.dm", "/proc/test()\n\tvar/x = 1\n\treturn x")
        self.linter.lint_file(Path(self.tmpdir) / "tabs.dm")
        tabs = [d for d in self.linter.diagnostics if 'Tab' in d.message]
        self.assertGreater(len(tabs), 0)
    
    def test_unclosed_brace(self):
        self.write_dm("bad.dm", "/proc/test()\n\tvar/x = 1\n\tif(x) {\n\t\treturn\n")
        self.linter.lint_file(Path(self.tmpdir) / "bad.dm")
        braces = [d for d in self.linter.diagnostics if 'brace' in d.message.lower()]
        self.assertGreater(len(braces), 0)
    
    def test_valid_file_no_errors(self):
        self.write_dm("good.dm", "/proc/test()\n\tvar/x = 1\n\tif(x) {\n\t\treturn x\n\t}\n\treturn 0\n")
        self.linter.lint_file(Path(self.tmpdir) / "good.dm")
        errors = [d for d in self.linter.diagnostics if d.severity == 'error']
        self.assertEqual(len(errors), 0)
    
    def test_empty_proc_warning(self):
        self.write_dm("empty.dm", "/proc/empty()\n\n/obj/thing\n\tvar/name = \"thing\"\n")
        self.linter.lint_file(Path(self.tmpdir) / "empty.dm")
        warnings = [d for d in self.linter.diagnostics if d.severity == 'warning']
        self.assertGreater(len(warnings), 0)

if __name__ == "__main__":
    unittest.main()
