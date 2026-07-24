"""File scanner — recursively discovers .dm files."""

from __future__ import annotations

import os
from pathlib import Path


def discover_dm_files(
    root: str | Path,
    exclude_dirs: set[str] | None = None,
) -> list[Path]:
    """Recursively find all .dm files under a root directory.

    Args:
        root: Root directory to search.
        exclude_dirs: Directory names to skip (e.g., {'node_modules', '.git'}).

    Returns:
        List of Path objects pointing to .dm files.
    """
    if exclude_dirs is None:
        exclude_dirs = {
            ".git",
            "node_modules",
            "__pycache__",
            ".venv",
            "venv",
            ".tox",
            "tools",
        }

    root = Path(root)
    dm_files: list[Path] = []

    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in exclude_dirs]

        for filename in filenames:
            if filename.lower().endswith(".dm"):
                dm_files.append(Path(dirpath) / filename)

    return dm_files


def read_file_lines(filepath: str | Path) -> list[str]:
    """Read a file and return lines, handling encoding issues."""
    path = Path(filepath)
    try:
        with open(path, encoding="utf-8") as f:
            return f.readlines()
    except UnicodeDecodeError:
        with open(path, encoding="latin-1") as f:
            return f.readlines()
