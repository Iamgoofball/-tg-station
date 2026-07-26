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


def _check(rule_cls, source: str, filename: str = "test.dm") -> Reporter:
    """Run a single rule against source text and return the reporter.

    Tokenizes the source, splits into lines, creates a fresh reporter,
    and invokes the rule's check method. Returns the reporter so tests
    can inspect diagnostic counts and messages.
    """
    tokens = Lexer().tokenize(source)
    lines = source.split("\n")
    reporter = Reporter()
    rule_cls().check(tokens, lines, reporter, filename)
    return reporter


class TestBracketRule:
    def test_balanced(self):
        """Balanced brackets should produce zero errors."""
        r = _check(BracketRule, "proc/test() { var/x = 1 }")
        assert r.error_count == 0

    def test_unclosed_brace(self):
        """An unclosed brace should be reported as an error."""
        r = _check(BracketRule, "proc/test() { var/x = 1")
        assert r.error_count > 0
        assert any("Unclosed '{'" in d.message for d in r.diagnostics)

    def test_mismatched(self):
        """A mismatched bracket pair should be reported as an error."""
        r = _check(BracketRule, "proc/test() { var/x = [1) }")
        assert r.error_count > 0
        assert any("Mismatched" in d.message for d in r.diagnostics)

    def test_extra_closing(self):
        """An unmatched closing bracket should be reported as an error."""
        r = _check(BracketRule, "proc/test() }")
        assert r.error_count > 0
        assert any("Unmatched closing" in d.message for d in r.diagnostics)


class TestCommentRule:
    def test_closed_block_comment(self):
        """A properly closed block comment should produce no errors."""
        r = _check(CommentRule, "/* comment */")
        assert r.error_count == 0

    def test_unclosed_block_comment(self):
        """An unclosed block comment should be detected and reported."""
        r = _check(CommentRule, "/* comment")
        assert r.error_count > 0
        assert any("Unclosed block comment" in d.message for d in r.diagnostics)

    def test_nested_comments(self):
        """Nested block comments should be handled correctly."""
        r = _check(CommentRule, "/* outer /* inner */ outer */")
        assert r.error_count == 0

    def test_extra_close(self):
        """An unexpected closing comment marker should be flagged."""
        r = _check(CommentRule, "*/")
        assert r.error_count > 0
        assert any("Unexpected" in d.message for d in r.diagnostics)


class TestDefineRule:
    def test_valid_define(self):
        """A valid #define should produce no diagnostics."""
        r = _check(DefineRule, '#define FOO 1')
        assert r.error_count == 0

    def test_redefine_warning(self):
        """Redefining a macro should produce a warning."""
        r = _check(DefineRule, '#define FOO 1\n#define FOO 2')
        assert r.warning_count > 0
        assert any("Redefinition" in d.message for d in r.diagnostics)

    def test_endif_without_ifdef(self):
        """An #endif without a matching #ifdef should be an error."""
        r = _check(DefineRule, '#endif')
        assert r.error_count > 0
        assert any("#endif without matching" in d.message for d in r.diagnostics)

    def test_unclosed_ifdef(self):
        """An unclosed #ifdef should be reported as an error."""
        r = _check(DefineRule, '#ifdef FOO\n// code')
        assert r.error_count > 0
        assert any("Unclosed" in d.message for d in r.diagnostics)

    def test_balanced_ifdef(self):
        """A properly paired #ifdef/#endif should produce no errors."""
        r = _check(DefineRule, '#ifdef FOO\n// code\n#endif')
        assert r.error_count == 0


class TestQuoteRule:
    def test_balanced_quotes(self):
        """A line with balanced double-quotes should produce no errors."""
        r = _check(QuoteRule, 'var/msg = "hello"')
        assert r.error_count == 0

    def test_unmatched_quote(self):
        """A line with an unmatched double-quote should be flagged."""
        r = _check(QuoteRule, 'var/msg = "hello')
        assert r.error_count > 0
        assert any("Unmatched double-quote" in d.message for d in r.diagnostics)


class TestStyleRule:
    def test_trailing_whitespace(self):
        """Trailing whitespace should produce a warning."""
        r = _check(StyleRule, "var/x = 1   \n")
        assert r.warning_count > 0

    def test_tab_indent(self):
        """Hard-tab indentation should produce a diagnostic mentioning tabs."""
        r = _check(StyleRule, "\tvar/x = 1\n")
        assert any("tab" in d.message.lower() for d in r.diagnostics)

    def test_long_line(self):
        """Lines exceeding the maximum length should be flagged."""
        long_line = "var/x = \"" + ("a" * 250) + "\"\n"
        r = _check(StyleRule, long_line)
        assert any("Line too long" in d.message for d in r.diagnostics)

    def test_clean_line(self):
        """A clean, well-formatted line should produce no warnings."""
        r = _check(StyleRule, "var/x = 1\n")
        assert r.warning_count == 0

    def test_fix_trailing_whitespace(self):
        """fix() should strip trailing whitespace from all lines."""
        lines = ["var/x = 1   \n", "    return  \n"]
        rule = StyleRule()
        fixed = rule.fix(lines)
        assert fixed[0] == "var/x = 1\n"
        assert fixed[1] == "    return\n"

    def test_fix_tab_to_spaces(self):
        """fix() should convert leading tabs to 4-space indentation."""
        lines = ["\tvar/x = 1\n", "\t\treturn\n"]
        rule = StyleRule()
        fixed = rule.fix(lines)
        assert fixed[0] == "    var/x = 1\n"
        assert fixed[1] == "        return\n"

    def test_fix_preserves_newlines(self):
        """fix() should preserve trailing newlines on all lines."""
        lines = ["line1\n", "line2\n"]
        rule = StyleRule()
        fixed = rule.fix(lines)
        assert fixed[0].endswith("\n")
        assert fixed[1].endswith("\n")

    def test_fix_noop_on_clean(self):
        """fix() should return unchanged lines when there's nothing to fix."""
        lines = ["clean line\n", "    indented correctly\n"]
        rule = StyleRule()
        fixed = rule.fix(lines)
        assert fixed == lines


class TestSyntaxRule:
    def test_valid_type_path(self):
        """Valid type paths should produce no errors."""
        r = _check(SyntaxRule, "/datum /obj/item")
        assert r.error_count == 0

    def test_trailing_semicolon(self):
        """An unnecessary trailing semicolon should be flagged."""
        r = _check(SyntaxRule, "var/x = 1;\n")
        assert any("Unnecessary semicolon" in d.message for d in r.diagnostics)
