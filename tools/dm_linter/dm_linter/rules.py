"""
dm-linter: Lint rules for DreamMaker (.dm) source code.

Each rule is a function that takes a parsed AST and yields LintResult items.
"""

from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Optional, Callable

from .lexer import Token, TokenType, Lexer, LexerError
from .parser import ASTNode, NodeType


class Severity(Enum):
    ERROR = auto()
    WARNING = auto()
    INFO = auto()


@dataclass
class LintResult:
    severity: Severity
    message: str
    line: int
    column: int
    filename: str = ""
    rule_id: str = ""
    
    def format(self, filename: str = "") -> str:
        """Format as a standard lint diagnostic."""
        fn = filename or self.filename
        sev = self.severity.name.lower()
        return f"{fn}:{self.line}:{self.column}: {sev}: [{self.rule_id}] {self.message}"


# Rule type: function that inspects source text and/or AST
LintRule = Callable[[str, ASTNode, str], List[LintResult]]


def check_trailing_whitespace(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for trailing whitespace on lines."""
    results = []
    for i, line in enumerate(source.split('\n'), start=1):
        if line != line.rstrip():
            col = len(line.rstrip()) + 1
            results.append(LintResult(
                severity=Severity.WARNING,
                message="Trailing whitespace detected",
                line=i, column=col,
                filename=filename,
                rule_id="trailing-whitespace",
            ))
    return results


def check_missing_semicolons(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for missing semicolons at end of statements.
    
    DM doesn't strictly require semicolons, but for large codebases they
    improve readability and prevent subtle bugs with line continuations.
    """
    # This is a best-effort check - we look for likely statement boundaries
    results = []
    lines = source.split('\n')
    
    # DM doesn't enforce semicolons, so this is just a style warning
    # We skip this rule for DM code as semicolons are optional
    return results


def check_undefined_preprocessor(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for potentially misused preprocessor directives."""
    results = []
    
    # Collect all #define directives
    defines = set()
    for node in _collect_nodes(ast, NodeType.PREPROCESSOR_DIRECTIVE):
        parts = node.value.split()
        if len(parts) >= 2 and parts[0] == '#define':
            defines.add(parts[1])
    
    # Check for #ifdef on undefined symbols (simple check)
    defined_in_ifs = set()
    for node in _collect_nodes(ast, NodeType.PREPROCESSOR_DIRECTIVE):
        parts = node.value.split()
        if len(parts) >= 2 and parts[0] in ('#ifdef', '#ifndef'):
            symbol = parts[1]
            if symbol not in defines and symbol not in defined_in_ifs:
                # Only warn if it's likely a typo (similar names exist)
                similar = [d for d in defines if _similar(symbol, d)]
                if similar:
                    results.append(LintResult(
                        severity=Severity.WARNING,
                        message=f"Preprocessor symbol '{symbol}' not defined. Did you mean '{similar[0]}'?",
                        line=node.line, column=node.column,
                        filename=filename,
                        rule_id="undefined-preprocessor",
                    ))
                defined_in_ifs.add(symbol)
    
    return results


def check_long_lines(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for lines exceeding maximum length."""
    results = []
    max_line_length = 200
    
    for i, line in enumerate(source.split('\n'), start=1):
        if len(line) > max_line_length:
            results.append(LintResult(
                severity=Severity.WARNING,
                message=f"Line too long ({len(line)} > {max_line_length} characters)",
                line=i, column=max_line_length,
                filename=filename,
                rule_id="line-length",
            ))
    
    return results


def check_punctuation_spacing(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for consistent spacing around punctuation."""
    results = []
    
    for i, line in enumerate(source.split('\n'), start=1):
        # Check for missing space after comma
        for m in __import__('re').finditer(r',(?=[^\s)])', line):
            results.append(LintResult(
                severity=Severity.INFO,
                message="Missing space after comma",
                line=i, column=m.start() + 2,
                filename=filename,
                rule_id="comma-spacing",
            ))
    
    return results


def check_file_header(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check that files have appropriate headers."""
    results = []
    lines = source.split('\n')
    
    # Check if file has a comment header
    has_header = False
    for line in lines[:10]:
        stripped = line.strip()
        if stripped.startswith('/*') or stripped.startswith('//'):
            has_header = True
            break
    
    if not has_header and len(lines) > 20:
        results.append(LintResult(
            severity=Severity.INFO,
            message="File has no comment header",
            line=1, column=1,
            filename=filename,
            rule_id="file-header",
        ))
    
    return results


def check_mixed_indent(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    """Check for mixed tabs and spaces in indentation."""
    results = []
    
    for i, line in enumerate(source.split('\n'), start=1):
        stripped = line.lstrip()
        if stripped and len(line) != len(stripped):
            indent = line[:len(line) - len(stripped)]
            if '\t' in indent and '    ' in indent:
                results.append(LintResult(
                    severity=Severity.WARNING,
                    message="Mixed tabs and spaces in indentation",
                    line=i, column=1,
                    filename=filename,
                    rule_id="mixed-indent",
                ))
    
    return results


def _collect_nodes(node: ASTNode, node_type: NodeType) -> List[ASTNode]:
    """Collect all nodes of a given type in the AST."""
    results = []
    if node.type == node_type:
        results.append(node)
    for child in node.children:
        results.extend(_collect_nodes(child, node_type))
    return results


def _similar(a: str, b: str) -> bool:
    """Check if two strings are similar (Jaccard-like)."""
    if not a or not b:
        return False
    # Simple check: Levenshtein distance <= 2
    if len(a) < 3 or len(b) < 3:
        return False
    return __import__('difflib').SequenceMatcher(None, a, b).ratio() > 0.7


# Registry of all built-in rules
BUILTIN_RULES: List[LintRule] = [
    check_trailing_whitespace,
    check_long_lines,
    check_mixed_indent,
    check_file_header,
    check_punctuation_spacing,
    check_undefined_preprocessor,
]


def run_rules(source: str, ast: ASTNode, filename: str, 
              rules: Optional[List[LintRule]] = None) -> List[LintResult]:
    """Run all lint rules and return results."""
    if rules is None:
        rules = BUILTIN_RULES
    
    results = []
    for rule in rules:
        try:
            rule_results = rule(source, ast, filename)
            results.extend(rule_results)
        except Exception as e:
            results.append(LintResult(
                severity=Severity.ERROR,
                message=f"Rule error: {e}",
                line=0, column=0,
                filename=filename,
                rule_id="internal-error",
            ))
    
    return results
