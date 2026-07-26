"""Command-line interface for dmlint."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from . import __version__
from .lexer import Lexer
from .reporter import Reporter, Severity
from .rules import ALL_RULES
from .scanner import discover_dm_files, read_file_lines


def build_parser() -> argparse.ArgumentParser:
    """Construct the argparse parser with all CLI options.

    Defines positional and optional arguments for scanning paths,
    output format selection, rule filtering, and verbosity control.
    Returns a fully configured ArgumentParser ready for parsing.
    """
    parser = argparse.ArgumentParser(
        prog="dmlint",
        description="Standalone linter for DreamMaker (.dm) source files",
    )
    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="Root directory to scan for .dm files (default: current directory)",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output diagnostics as JSON",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"dmlint {__version__}",
    )
    parser.add_argument(
        "--rule",
        action="append",
        dest="rules",
        help="Only run specific rule(s) (can be repeated). Default: all rules.",
    )
    parser.add_argument(
        "--exclude-rule",
        action="append",
        dest="exclude_rules",
        help="Exclude specific rule(s) (can be repeated).",
    )
    parser.add_argument(
        "-q", "--quiet",
        action="store_true",
        help="Suppress non-error output",
    )
    parser.add_argument(
        "--fix",
        action="store_true",
        help="Auto-correct fixable issues (trailing whitespace, tab indentation)",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    """Entry point for the dmlint command-line tool.

    Parses arguments, discovers .dm files, instantiates rules, and
    runs each rule against every file. Emits diagnostics in terminal
    or JSON format and returns a non-zero exit code on errors.
    """
    parser = build_parser()
    args = parser.parse_args(argv)

    # Resolve root path
    root = Path(args.path).resolve()
    if not root.exists():
        print(f"dmlint: error: path '{args.path}' does not exist", file=sys.stderr)
        return 1

    if not root.is_dir():
        print(f"dmlint: error: path '{args.path}' is not a directory", file=sys.stderr)
        return 1

    # Discover .dm files
    dm_files = discover_dm_files(root)
    if not dm_files:
        print(f"dmlint: no .dm files found under '{root}'", file=sys.stderr)
        return 0

    if not args.quiet:
        print(f"dmlint: scanning {len(dm_files)} .dm file(s) under '{root}'", file=sys.stderr)

    # Filter rules
    rules = ALL_RULES
    if args.rules:
        rule_names = set(args.rules)
        rules = [r for r in rules if r.name in rule_names]
    if args.exclude_rules:
        exclude = set(args.exclude_rules)
        rules = [r for r in rules if r.name not in exclude]

    if not rules:
        print("dmlint: no rules selected", file=sys.stderr)
        return 0

    # Instantiate rules
    rule_instances = [r() for r in rules]

    # Lint each file
    lexer = Lexer()
    reporter = Reporter()

    for dm_file in dm_files:
        try:
            lines = read_file_lines(dm_file)
            source = "".join(lines)
            tokens = lexer.tokenize(source)

            for rule in rule_instances:
                rule.check(tokens, lines, reporter, str(dm_file))
        except Exception as exc:
            reporter.add(
                filename=str(dm_file),
                line=1,
                column=1,
                severity=Severity.ERROR,
                message=f"Internal error while linting: {exc}",
                rule="internal",
            )

    # Apply auto-fixes when --fix is enabled
    if args.fix:
        files_fixed = 0
        for dm_file in dm_files:
            try:
                lines = read_file_lines(dm_file)
                fixed_lines = lines
                for rule in rule_instances:
                    fixed_lines = rule.fix(fixed_lines)
                if fixed_lines != lines:
                    with open(dm_file, "w", encoding="utf-8") as f:
                        f.writelines(fixed_lines)
                    files_fixed += 1
                    if not args.quiet:
                        print(f"dmlint: fixed {dm_file}", file=sys.stderr)
            except Exception as exc:
                if not args.quiet:
                    print(f"dmlint: error fixing {dm_file}: {exc}", file=sys.stderr)
        if not args.quiet and files_fixed > 0:
            print(f"dmlint: {files_fixed} file(s) reformatted", file=sys.stderr)

    # Emit results
    if args.json:
        reporter.emit_json()
    else:
        reporter.emit_terminal()

    # Exit non-zero on errors
    return 1 if reporter.has_errors() else 0


if __name__ == "__main__":
    sys.exit(main())
