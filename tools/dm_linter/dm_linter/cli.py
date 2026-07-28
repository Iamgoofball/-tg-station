"""
dm-linter: CLI entry point.

Usage:
  dm-linter [options] [path]
  
If no path is given, lints all .dm files under code/ in the current directory.
"""

import argparse
import sys
import os
from typing import Optional

from . import __version__
from .linter import DMProject, lint_file, format_summary, format_json, count_by_severity
from .rules import Severity


def main(argv: Optional[list] = None) -> int:
    """Main CLI entry point. Returns exit code."""
    parser = argparse.ArgumentParser(
        description="dm-linter: Standalone DreamMaker (.dm) source code linter",
    )
    parser.add_argument(
        'path', nargs='?', default='.',
        help="Path to project root or .dm file (default: current directory)"
    )
    parser.add_argument(
        '--json', action='store_true',
        help="Output results in JSON format"
    )
    parser.add_argument(
        '--quiet', '-q', action='store_true',
        help="Only output errors and warnings"
    )
    parser.add_argument(
        '--version', '-V', action='version',
        version=f'dm-linter {__version__}',
    )
    
    args = parser.parse_args(argv)
    
    # Determine what to lint
    path = os.path.abspath(args.path)
    
    if os.path.isfile(path) and path.endswith('.dm'):
        # Single file mode
        files_to_lint = [path]
        root_dir = os.path.dirname(path)
    elif os.path.isdir(path):
        # Project mode - find all .dm files
        project = DMProject(path)
        files_to_lint = project.find_dm_files()
        root_dir = path
    else:
        print(f"Error: '{path}' is not a valid path or .dm file", file=sys.stderr)
        return 1
    
    if not files_to_lint:
        print(f"No .dm files found under {path}/code/", file=sys.stderr)
        # Try broader search
        if os.path.isdir(path):
            for dirpath, _, filenames in os.walk(path):
                for f in filenames:
                    if f.endswith('.dm'):
                        files_to_lint.append(os.path.join(dirpath, f))
            if not files_to_lint:
                print(f"No .dm files found anywhere under {path}", file=sys.stderr)
                return 1
    
    # Lint each file
    all_results = []
    file_count = len(files_to_lint)
    files_with_issues = 0
    
    for fpath in files_to_lint:
        rel_path = os.path.relpath(fpath, root_dir)
        
        if not args.quiet:
            print(f"Linting {rel_path}...", file=sys.stderr)
        
        results, error = lint_file(fpath)
        
        if error:
            print(f"Error linting {rel_path}: {error}", file=sys.stderr)
            continue
        
        if results:
            files_with_issues += 1
        
        for r in results:
            r.filename = rel_path
            line = r.format()
            if args.quiet and r.severity == Severity.INFO:
                continue
            if args.json:
                all_results.append(r)
            else:
                print(line)
        
        all_results.extend(results)
    
    # Summary
    if args.json:
        print(format_json(all_results))
    elif not args.quiet:
        print(format_summary(all_results, file_count), file=sys.stderr)
    
    # Exit code: non-zero if any errors
    errors, warnings, infos = count_by_severity(all_results)
    return 1 if errors > 0 else 0


if __name__ == '__main__':
    sys.exit(main())
