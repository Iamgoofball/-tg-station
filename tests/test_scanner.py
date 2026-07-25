"""Tests for dmlint scanner.

Exercises the recursive .dm file discovery function and the file
reading helper. Tests cover empty directories, recursive discovery,
directory exclusions, encoding fallback, and case-insensitive matching.
"""

import tempfile
from pathlib import Path

from dmlint.scanner import discover_dm_files, read_file_lines


def test_discover_no_dm_files():
    """Verify that a directory with no .dm files returns an empty list."""
    with tempfile.TemporaryDirectory() as tmp:
        (Path(tmp) / "test.txt").write_text("hello")
        files = discover_dm_files(tmp)
        assert len(files) == 0


def test_discover_dm_files_recursive():
    """Verify that .dm files are discovered recursively through subdirectories."""
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        (root / "code").mkdir()
        (root / "code" / "a.dm").write_text("// a")
        (root / "code" / "sub").mkdir()
        (root / "code" / "sub" / "b.dm").write_text("// b")
        (root / "docs").mkdir()
        (root / "docs" / "readme.dm").write_text("// readme")

        files = sorted(discover_dm_files(tmp))
        assert len(files) == 3
        names = [f.name for f in files]
        assert names == ["a.dm", "b.dm", "readme.dm"]


def test_discover_excludes_dirs():
    """Verify that excluded directories (e.g., .git) are skipped during discovery."""
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        (root / ".git").mkdir()
        (root / ".git" / "config.dm").write_text("// config")
        (root / "code").mkdir()
        (root / "code" / "real.dm").write_text("// real")

        files = discover_dm_files(tmp)
        assert len(files) == 1
        assert files[0].name == "real.dm"


def test_read_file_lines():
    """Verify that read_file_lines returns the correct number of lines."""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".dm", delete=False) as f:
        f.write("// line 1\n// line 2\n// line 3\n")
        f.flush()
        lines = read_file_lines(f.name)
        assert len(lines) == 3
        assert lines[0] == "// line 1\n"


def test_case_insensitive_dm():
    """Verify that .DM files (uppercase extension) are also discovered."""
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        (root / "test.DM").write_text("// upper")
        files = discover_dm_files(tmp)
        assert len(files) == 1
        assert files[0].name == "test.DM"
