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
    """Build the argument parser for the dmlint CLI."""
    parser = argparse.ArgumentParser(
        prog="dmlint",
        description="Standalone DreamMaker linter",
    )
    parser.add_argument(
        "paths",
        nargs="*",
        default=["code"],
        help="Directories or files to lint (default: code/)",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results as JSON (CI-friendly)",
    )
    parser.add_argument(
        "--rule",
        action="append",
        dest="rules",
        help="Only run the specified rule(s). May be repeated.",
    )
    parser.add_argument(
        "--exclude-rule",
        action="append",
        dest="exclude_rules",
        default=[],
        help="Exclude the specified rule(s). May be repeated.",
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
    """Entry point for the dmlint CLI.

    Args:
        argv: Command-line arguments (defaults to sys.argv[1:]).

    Returns:
        Exit code (0 on success, 1 if errors found, 2 on internal error).
    """
    parser = build_parser()
    args = parser.parse_args(argv)

    # Resolve rule set
    selected_rules = list(ALL_RULES)
    if args.rules:
        selected_rules = [r for r in selected_rules if r.name in args.rules]
        if not selected_rules:
            print(f"dmlint: no rules matched {args.rules}", file=sys.stderr)
            return 2

    if args.exclude_rules:
        selected_rules = [r for r in selected_rules if r.name not in args.exclude_rules]

    if not selected_rules:
        print("dmlint: no rules selected after filtering", file=sys.stderr)
        return 2

    # Discover files
    dm_files: list[Path] = []
    for path_str in args.paths:
        path = Path(path_str)
        if path.is_file():
            if path.suffix == ".dm":
                dm_files.append(path)
        else:
            dm_files.extend(discover_dm_files(path))

    if not dm_files:
        if not args.quiet:
            paths_display = "', '".join(args.paths)
            print(f"dmlint: no .dm files found under '{paths_display}'", file=sys.stderr)
        return 0

    if not args.quiet:
        print(f"dmlint: scanning {len(dm_files)} .dm file(s) under {', '.join(args.paths)}")

    # Instantiate rules
    rule_instances = [rule_cls() for rule_cls in selected_rules]

    # Instantiate reporter
    reporter = Reporter(json_output=args.json)

    lexer = Lexer()

    # Lint every file
    for dm_file in dm_files:
        try:
            lines = read_file_lines(dm_file)
        except OSError as exc:
            reporter.add(
                filename=str(dm_file),
                line=0,
                column=0,
                severity=Severity.ERROR,
                message=f"Cannot read file: {exc}",
                rule="internal",
            )
            continue

        try:
            tokens = lexer.tokenize("".join(lines))
        except Exception as exc:
            reporter.add(
                filename=str(dm_file),
                line=0,
                column=0,
                severity=Severity.ERROR,
                message=f"Lexer error: {exc}",
                rule="internal",
            )
            continue

        for rule in rule_instances:
            try:
                rule.check(tokens, lines, reporter, str(dm_file))
            except Exception:
                reporter.add(
                    filename=str(dm_file),
                    line=0,
                    column=0,
                    severity=Severity.ERROR,
                    message=f"Rule {rule.name} crashed",
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
                    with open(dm_file, "w", encoding="utf-8") as fh:
                        fh.writelines(fixed_lines)
                    if not args.quiet:
                        print(f"dmlint: fixed {dm_file}")
                    files_fixed += 1
            except OSError:
                pass
        if not args.quiet and files_fixed:
            print(f"dmlint: {files_fixed} file(s) reformatted")

    # Final output
    reporter.finalize()
    return reporter.exit_code()


if __name__ == "__main__":
    raise SystemExit(main())
