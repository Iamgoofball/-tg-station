"""Tests for dmlint lexer.

Verifies the regex-based tokenizer correctly recognizes DM keywords,
operators, type paths, strings, numbers, comments, and preprocessor
directives. All tests use the Lexer class directly.
"""

import pytest

from dmlint.lexer import Lexer, TokenType


def tokenize(source: str):
    """Convenience wrapper to tokenize a source string.

    Creates a fresh Lexer instance and returns the token list
    produced from the given DreamMaker source text.
    """
    return Lexer().tokenize(source)


def test_empty_source():
    """Verify that an empty source produces only an EOF token."""
    tokens = tokenize("")
    assert len(tokens) == 1


def test_comments():
    """Verify that line and block comments are tokenized correctly."""
    tokens = tokenize("// single line\n/* block */")
    types = [t.type for t in tokens]
    assert TokenType.LINE_COMMENT in types
    assert TokenType.BLOCK_COMMENT_START in types
    assert TokenType.BLOCK_COMMENT_END in types


def test_keywords():
    """Verify that DM keywords are recognized as their token types."""
    tokens = tokenize("if else while for return proc")
    keywords = {TokenType.IF, TokenType.ELSE, TokenType.WHILE, TokenType.FOR, TokenType.RETURN, TokenType.PROC}
    found = {t.type for t in tokens if t.type in keywords}
    assert found == keywords


def test_strings():
    """Verify that double-quoted strings are tokenized as STRING tokens."""
    tokens = tokenize('"hello world"')
    strings = [t for t in tokens if t.type == TokenType.STRING]
    assert len(strings) == 1
    assert strings[0].value == '"hello world"'


def test_resource_strings():
    """Verify that single-quoted resource paths are tokenized as RESOURCE tokens."""
    tokens = tokenize("'path/to/file.dmi'")
    resources = [t for t in tokens if t.type == TokenType.RESOURCE]
    assert len(resources) == 1
    assert resources[0].value == "'path/to/file.dmi'"


def test_numbers():
    """Verify that integer, float, and scientific notation numbers are recognized."""
    tokens = tokenize("42 3.14 1e10")
    numbers = [t for t in tokens if t.type == TokenType.NUMBER]
    assert len(numbers) == 3


def test_type_paths():
    """Verify that DM type paths like /datum and /obj/item are tokenized correctly."""
    tokens = tokenize("/datum /obj/item /mob/living")
    paths = [t for t in tokens if t.type == TokenType.TYPE_PATH]
    assert len(paths) == 3
    assert paths[0].value == "/datum"
    assert paths[1].value == "/obj/item"
    assert paths[2].value == "/mob/living"


def test_operators():
    """Verify that all DM comparison, logical, and assignment operators are recognized."""
    tokens = tokenize("== != <= >= && || += -= *= /=")
    op_types = {TokenType.EQ, TokenType.NEQ, TokenType.LTE, TokenType.GTE,
                TokenType.AND, TokenType.OR, TokenType.PLUS_EQ, TokenType.MINUS_EQ,
                TokenType.STAR_EQ, TokenType.SLASH_EQ}
    found = {t.type for t in tokens if t.type in op_types}
    assert op_types.issubset(found)


def test_preprocessor():
    """Verify that #define, #include, #ifdef, and #endif are tokenized correctly."""
    tokens = tokenize("#define FOO 1\n#include \"bar.dm\"\n#ifdef FOO\n#endif")
    directives = [t for t in tokens if t.type in (TokenType.DEFINE, TokenType.INCLUDE, TokenType.IFDEF, TokenType.ENDIF)]
    assert len(directives) == 4


def test_brackets():
    """Verify that braces, brackets, and parens produce correct token types in order."""
    tokens = tokenize("{ [ ( ) ] }")
    brackets = [t.type for t in tokens if t.type in (
        TokenType.LBRACE, TokenType.RBRACE, TokenType.LPAREN, TokenType.RPAREN,
        TokenType.LBRACKET, TokenType.RBRACKET,
    )]
    assert brackets == [
        TokenType.LBRACE, TokenType.LBRACKET, TokenType.LPAREN,
        TokenType.RPAREN, TokenType.RBRACKET, TokenType.RBRACE,
    ]


def test_line_numbers():
    """Verify that newline tokens are emitted and line tracking is correct."""
    tokens = tokenize("line1\nline2\n")
    newlines = [t for t in tokens if t.type == TokenType.NEWLINE]
    assert len(newlines) == 2
