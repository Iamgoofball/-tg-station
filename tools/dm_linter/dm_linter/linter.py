"""
dm-linter: Main linter module.

Orchestrates the file discovery, tokenization, parsing, and linting workflow.
"""

import os
import sys
import json
from typing import List, Optional, Tuple

from .lexer import Lexer, LexerError
from .parser import Parser, ParseError
from .rules import LintResult, Severity, run_rules, BUILTIN_RULES, LintRule


class DMProject:
    """Represents a DM project rooted at a directory."""
    
    def __init__(self, root_dir: str):
        self.root_dir = os.path.abspath(root_dir)
    
    def find_dm_files(self) -> List[str]:
        """Recursively discover all .dm files under code/."""
        dm_files = []
        code_dir = os.path.join(self.root_dir, 'code')
        if not os.path.isdir(code_dir):
            # Try searching from root
            code_dir = self.root_dir
        
        for dirpath, dirnames, filenames in os.walk(code_dir):
            for f in filenames:
                if f.endswith('.dm'):
                    dm_files.append(os.path.join(dirpath, f))
        
        return sorted(dm_files)


def lint_file(filepath: str, rules: Optional[List[LintRule]] = None) -> Tuple[List[LintResult], Optional[str]]:
    """Lint a single .dm file. Returns (results, error_message)."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            source = f.read()
    except Exception as e:
        return [], f"Failed to read file: {e}"
    
    return lint_source(source, filepath, rules)


def lint_source(source: str, filename: str = "<unknown>", 
                rules: Optional[List[LintRule]] = None) -> Tuple[List[LintResult], Optional[str]]:
    """Lint a string of DM source code. Returns (results, error_message)."""
    # Tokenize
    lexer = Lexer(source, filename)
    try:
        tokens = lexer.tokenize()
    except LexerError as e:
        return [LintResult(
            severity=Severity.ERROR,
            message=f"Lexer error: {e.message}",
            line=e.line, column=e.col,
            filename=filename,
            rule_id="lexer",
        )], str(e)
    except Exception as e:
        return [LintResult(
            severity=Severity.ERROR,
            message=f"Lexer error: {e}",
            line=0, column=0,
            filename=filename,
            rule_id="lexer",
        )], str(e)
    
    # Parse
    parser = Parser(tokens)
    try:
        ast = parser.parse()
    except ParseError as e:
        return [LintResult(
            severity=Severity.ERROR,
            message=f"Parse error: {e}",
            line=0, column=0,
            filename=filename,
            rule_id="parser",
        )], str(e)
    except Exception as e:
        return [LintResult(
            severity=Severity.ERROR,
            message=f"Parse error: {e}",
            line=0, column=0,
            filename=filename,
            rule_id="parser",
        )], str(e)
    
    # Run rules
    results = run_rules(source, ast, filename, rules)
    return results, None


def count_by_severity(results: List[LintResult]) -> Tuple[int, int, int]:
    """Count errors, warnings, infos."""
    errors = sum(1 for r in results if r.severity == Severity.ERROR)
    warnings = sum(1 for r in results if r.severity == Severity.WARNING)
    infos = sum(1 for r in results if r.severity == Severity.INFO)
    return errors, warnings, infos


def format_summary(results: List[LintResult], total_files: int) -> str:
    """Format a summary of lint results."""
    errors, warnings, infos = count_by_severity(results)
    return (
        f"\n{'='*60}\n"
        f"Summary: {total_files} files, "
        f"{errors} errors, {warnings} warnings, {infos} infos\n"
        f"{'='*60}"
    )


def format_json(results: List[LintResult]) -> str:
    """Format results as JSON."""
    output = []
    for r in results:
        output.append({
            "filename": r.filename,
            "line": r.line,
            "column": r.column,
            "severity": r.severity.name.lower(),
            "rule_id": r.rule_id,
            "message": r.message,
        })
    return json.dumps(output, indent=2)
