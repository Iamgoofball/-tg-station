"""Tests for dmlint rules.

Exercises all six lint rules (brackets, defines, comments, quotes,
style, syntax) with both valid and invalid DM source fragments to
verify correct detection of errors and warnings.
"""

import pytest

from dmlint.lexer import Lexer
from dmlint.reporter import Reporter
from dmlint.rules.brackets import BracketRule
from dmlint.rules.comments import CommentRule
from dmlint.rules.defines import DefineRule
from dmlint.rules.quotes import QuoteRule
from dmlint.rules.style import StyleRule
from dmlint.rules.syntax import SyntaxRule


def _check(rule_cls, source, filename="test.dm"):
    """Run a single rule against source text."""
    lexer = Lexer()
    tokens = lexer.tokenize(source)
    lines = source.splitlines(keepends=True)
    reporter = Reporter()
    rule = rule_cls()
    rule.check(tokens, lines, reporter, filename)
    return reporter


# ── BracketRule ───────────────────────────────────────────────────


def test_balanced_brackets(self):
    """Balanced brackets should produce no diagnostics."""
    r = _check(BracketRule, "{ ( [ ] ) }")
    assert r.error_count == 0


def test_unmatched_opening_brace(self):
    """An unclosed { should be reported as an error."""
    r = _check(BracketRule, "{")
    assert r.error_count > 0
    assert any("Unclosed" in d.message for d in r.diagnostics)


def test_unmatched_closing_paren(self):
    """A closing ) without opening ( should be an error."""
    r = _check(BracketRule, ")")
    assert r.error_count > 0
    assert any("Unmatched closing" in d.message for d in r.diagnostics)


def test_mismatched_brace_paren(self):
    """{ ) should report mismatched brackets."""
    r = _check(BracketRule, "{ )")
    assert r.error_count > 0


# ── DefineRule ────────────────────────────────────────────────────


def test_valid_define(self):
    """A well-formed #define should pass."""
    r = _check(DefineRule, "#define FOO 1\n")
    assert r.warning_count == 0


def test_redefinition_warns(self):
    """Redefining a constant should produce a warning."""
    r = _check(DefineRule, "#define FOO 1\n#define FOO 2\n")
    assert any("HAVE_BEEN_REDEFINED" in d.message or "redefined" in d.message.lower()
               for d in r.diagnostics)


def test_warning_without_message(self):
    """#warning without an argument should be flagged."""
    r = _check(DefineRule, "#warning\n")
    assert r.warning_count > 0


def test_error_without_message(self):
    """#error without an argument should be flagged."""
    r = _check(DefineRule, "#error\n")
    assert r.warning_count > 0


def test_missing_endif(self):
    """An #ifdef without matching #endif should report error."""
    r = _check(DefineRule, "#ifdef FOO\n")
    assert r.error_count > 0
    assert any("#endif without matching" in d.message for d in r.diagnostics)


def test_unclosed_ifdef(self):
    """An unclosed #ifdef should be reported as an error."""
    r = _check(DefineRule, "#ifdef FOO\n// code")
    assert r.error_count > 0
    assert any("Unclosed" in d.message for d in r.diagnostics)


def test_balanced_ifdef(self):
    """A properly paired #ifdef/#endif should be clean."""
    r = _check(DefineRule, "#ifdef FOO\n#endif\n")
    assert r.error_count == 0


# ── CommentRule ───────────────────────────────────────────────────


def test_valid_line_comment(self):
    """Line comments should not cause diagnostics."""
    r = _check(CommentRule, "// this is a comment\n")
    assert r.error_count == 0


def test_valid_block_comment(self):
    """Properly closed block comments should be fine."""
    r = _check(CommentRule, "/* comment */\n")
    assert r.error_count == 0


def test_nested_block_comments(self):
    """Nested /* /* */ */ block comments should be valid."""
    r = _check(CommentRule, "/* outer /* inner */ */\n")
    assert r.error_count == 0


def test_unclosed_block_comment(self):
    """An unclosed /* should be reported as an error."""
    r = _check(CommentRule, "/* unclosed")
    assert r.error_count > 0
    assert any("Unclosed" in d.message for d in r.diagnostics)


# ── QuoteRule ─────────────────────────────────────────────────────


def test_valid_string(self):
    """Properly quoted strings should not flag."""
    r = _check(QuoteRule, '"hello"\n')
    assert r.error_count == 0


def test_unmatched_double_quote(self):
    """An unmatched " should be reported as an error."""
    r = _check(QuoteRule, '"unfinished')
    assert r.error_count > 0
    assert any("Unmatched" in d.message for d in r.diagnostics)


# ── StyleRule ─────────────────────────────────────────────────────


def test_trailing_whitespace_warns(self):
    """Trailing whitespace should produce a warning."""
    r = _check(StyleRule, "var/x = 1 \n")
    assert r.warning_count > 0
    assert any("Trailing whitespace" in d.message for d in r.diagnostics)


def test_long_line_warns(self):
    """A line exceeding MAX_LINE_LENGTH should warn."""
    long_line = "x = " + "a" * 201 + "\n"
    r = _check(StyleRule, long_line)
    assert r.warning_count > 0
    assert any("Line too long" in d.message for d in r.diagnostics)


def test_clean_line_no_warning(self):
    """A clean line should not produce warnings."""
    r = _check(StyleRule, "var/x = 1\n")
    assert r.warning_count == 0


def test_fix_trailing_whitespace(self):
    """fix() should strip trailing whitespace from all lines."""
    lines = ["var/x = 1 \n", " return \n"]
    rule = StyleRule()
    fixed = rule.fix(lines)
    assert fixed[0] == "var/x = 1\n"
    assert fixed[1] == " return\n"


def test_fix_tabs_to_spaces(self):
    """fix() should convert leading tabs to spaces."""
    lines = ["\t\treturn 42\n"]
    rule = StyleRule()
    fixed = rule.fix(lines)
    assert fixed[0] == "        return 42\n"  # 8 spaces (2 tabs × TAB_WIDTH)


def test_fix_mixed_trailing_and_tabs(self):
    """fix() should handle both trailing whitespace and tabs."""
    lines = ["\tvar/x = 1 \n"]
    rule = StyleRule()
    fixed = rule.fix(lines)
    assert fixed[0] == "    var/x = 1\n"


def test_fix_no_changes_needed(self):
    """fix() should return unchanged lines when nothing to fix."""
    lines = ["var/x = 1\n"]
    rule = StyleRule()
    fixed = rule.fix(lines)
    assert fixed == lines


# ── SyntaxRule ────────────────────────────────────────────────────


def test_valid_type_path(self):
    """Well-formed type paths should be accepted."""
    r = _check(SyntaxRule, "/obj/item/weapon")
    assert r.error_count == 0


def test_trailing_semicolon_warns(self):
    """Trailing semicolons should produce a warning."""
    r = _check(SyntaxRule, "var/x = 1;\n")
    assert any("semicolon" in d.message.lower() for d in r.diagnostics)
