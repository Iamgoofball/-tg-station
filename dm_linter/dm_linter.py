#!/usr/bin/env python
import os
import sys
import argparse
import json

from tokenizer import tokenize
from parser import Parser
from rules import (
    lint_file_standalone, lint_file, LinterConfig,
    find_dm_files, LintResult
)


def format_text(results, show_all=False):
    if not results:
        return 'No issues found.\n'

    errors = [r for r in results if r.severity == 'error']
    warnings = [r for r in results if r.severity == 'warn']

    lines = []
    for r in results:
        prefix = 'E' if r.severity == 'error' else 'W'
        lines.append(f'{r.filename}:L{r.line}:{r.column}: {prefix}: {r.message}')

    summary = f'\n{len(errors)} errors, {len(warnings)} warnings'
    lines.append(summary)
    return '\n'.join(lines)


def format_json(results):
    data = []
    for r in results:
        data.append({
            'severity': r.severity,
            'message': r.message,
            'filename': r.filename,
            'line': r.line,
            'column': r.column,
        })
    return json.dumps(data, indent=2)


def main():
    parser = argparse.ArgumentParser(
        description='DM Linter - Standalone linter for DreamMaker (.dm) source files'
    )
    parser.add_argument('paths', nargs='*', help='Files or directories to lint')
    parser.add_argument('-r', '--recursive', action='store_true',
                       help='Recursively search directories for .dm files')
    parser.add_argument('-f', '--format', choices=['text', 'json'], default='text',
                       help='Output format (default: text)')
    parser.add_argument('--max-line-length', type=int, default=200,
                       help='Maximum line length (default: 200)')
    parser.add_argument('--no-trailing-whitespace', action='store_true',
                       help='Skip trailing whitespace check')
    parser.add_argument('--no-line-length', action='store_true',
                       help='Skip line length check')
    parser.add_argument('--no-empty-blocks', action='store_true',
                       help='Skip empty block check')
    args = parser.parse_args()

    config = LinterConfig()
    if args.no_trailing_whitespace:
        config.check_trailing_whitespace = False
    if args.no_line_length:
        config.check_long_lines = False
    if args.no_empty_blocks:
        config.check_empty_blocks = False
    config.max_line_length = args.max_line_length

    files_to_lint = []

    for path in args.paths:
        if os.path.isfile(path):
            files_to_lint.append(path)
        elif os.path.isdir(path):
            if args.recursive:
                files_to_lint.extend(find_dm_files(path))
            else:
                for entry in os.listdir(path):
                    full = os.path.join(path, entry)
                    if os.path.isfile(full) and entry.endswith('.dm'):
                        files_to_lint.append(full)
        else:
            print(f'Warning: path not found: {path}', file=sys.stderr)

    if not files_to_lint:
        if not args.paths:
            if os.path.isdir('code'):
                files_to_lint = find_dm_files('code')
            else:
                cwd_files = [f for f in os.listdir('.') if f.endswith('.dm')]
                files_to_lint = sorted(cwd_files)

    if not files_to_lint:
        print('No .dm files found to lint.', file=sys.stderr)
        sys.exit(1)

    all_results = []
    for fpath in sorted(files_to_lint):
        results = lint_file_standalone(fpath, config)
        all_results.extend(results)

    if args.format == 'json':
        print(format_json(all_results))
    else:
        print(format_text(all_results))

    errors = [r for r in all_results if r.severity == 'error']
    sys.exit(1 if errors else 0)


if __name__ == '__main__':
    main()
