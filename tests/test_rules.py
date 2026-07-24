"""Tests for dmlint rules."""

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
    tokens = Lexer().tokenize(source)
    lines = source.split("\n")
    reporter = Reporter()
    rule_cls().check(tokens, lines, reporter, filename)
    return reporter


class TestBracketRule:
    def test_balanced(self):
        r = _check(BracketRule, "proc/test() { var/x = 1 }")
        assert r.error_count == 0

    def test_unclosed_brace(self):
        r = _check(BracketRule, "proc/test() { var/x = 1")
        assert r.error_count > 0
        assert any("Unclosed '{'" in d.message for d in r.diagnostics)

    def test_mismatched(self):
        r = _check(BracketRule, "proc/test() { var/x = [1) }")
        assert r.error_count > 0
        assert any("Mismatched" in d.message for d in r.diagnostics)

    def test_extra_closing(self):
        r = _check(BracketRule, "proc/test() }")
        assert r.error_count > 0
        assert any("Unmatched closing" in d.message for d in r.diagnostics)


class TestCommentRule:
    def test_closed_block_comment(self):
        r = _check(CommentRule, "/* comment */")
        assert r.error_count == 0

    def test_unclosed_block_comment(self):
        r = _check(CommentRule, "/* comment")
        assert r.error_count > 0
        assert any("Unclosed block comment" in d.message for d in r.diagnostics)

    def test_nested_comments(self):
        r = _check(CommentRule, "/* outer /* inner */ outer */")
        assert r.error_count == 0

    def test_extra_close(self):
        r = _check(CommentRule, "*/")
        assert r.error_count > 0
        assert any("Unexpected" in d.message for d in r.diagnostics)


class TestDefineRule:
    def test_valid_define(self):
        r = _check(DefineRule, '#define FOO 1')
        assert r.error_count == 0

    def test_redefine_warning(self):
        r = _check(DefineRule, '#define FOO 1\n#define FOO 2')
        assert r.warning_count > 0
        assert any("Redefinition" in d.message for d in r.diagnostics)

    def test_endif_without_ifdef(self):
        r = _check(DefineRule, '#endif')
        assert r.error_count > 0
        assert any("#endif without matching" in d.message for d in r.diagnostics)

    def test_unclosed_ifdef(self):
        r = _check(DefineRule, '#ifdef FOO\n// code')
        assert r.error_count > 0
        assert any("Unclosed" in d.message for d in r.diagnostics)

    def test_balanced_ifdef(self):
        r = _check(DefineRule, '#ifdef FOO\n// code\n#endif')
        assert r.error_count == 0


class TestQuoteRule:
    def test_balanced_quotes(self):
        r = _check(QuoteRule, 'var/msg = "hello"')
        assert r.error_count == 0

    def test_unmatched_quote(self):
        r = _check(QuoteRule, 'var/msg = "hello')
        assert r.error_count > 0
        assert any("Unmatched double-quote" in d.message for d in r.diagnostics)


class TestStyleRule:
    def test_trailing_whitespace(self):
        r = _check(StyleRule, "var/x = 1   \n")
        assert r.warning_count > 0

    def test_tab_indent(self):
        r = _check(StyleRule, "\tvar/x = 1\n")
        assert any("tab" in d.message.lower() for d in r.diagnostics)

    def test_long_line(self):
        long_line = "var/x = \"" + ("a" * 250) + "\"\n"
        r = _check(StyleRule, long_line)
        assert any("Line too long" in d.message for d in r.diagnostics)

    def test_clean_line(self):
        r = _check(StyleRule, "var/x = 1\n")
        assert r.warning_count == 0


class TestSyntaxRule:
    def test_valid_type_path(self):
        r = _check(SyntaxRule, "/datum /obj/item")
        assert r.error_count == 0

    def test_trailing_semicolon(self):
        r = _check(SyntaxRule, "var/x = 1;\n")
        assert any("Unnecessary semicolon" in d.message for d in r.diagnostics)
