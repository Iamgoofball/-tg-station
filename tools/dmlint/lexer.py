"""Lexer for DreamMaker (.dm) source files.

Tokenizes DM code into a stream of tokens for use by the parser
and lint rules. Based on the official DreamMaker language reference:
https://www.byond.com/docs/ref/info.html
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from enum import Enum, auto


class TokenType(Enum):
    NEWLINE = auto()
    INDENT = auto()
    DEDENT = auto()
    EOF = auto()
    IF = auto()
    ELSE = auto()
    WHILE = auto()
    FOR = auto()
    DO = auto()
    SWITCH = auto()
    RETURN = auto()
    BREAK = auto()
    CONTINUE = auto()
    GOTO = auto()
    PROC = auto()
    VERB = auto()
    SET = auto()
    SPAWN = auto()
    NEW = auto()
    DEL = auto()
    VAR = auto()
    GLOBAL = auto()
    STATIC = auto()
    CONST = auto()
    TMP = auto()
    IN = auto()
    TO = auto()
    STEP = auto()
    AS = auto()
    NULL = auto()
    TRUE = auto()
    FALSE = auto()
    DEFINE = auto()
    INCLUDE = auto()
    IFDEF = auto()
    IFNDEF = auto()
    ENDIF = auto()
    UNDEF = auto()
    WARNING = auto()
    ERROR = auto()
    PRAGMA = auto()
    STRING = auto()
    NUMBER = auto()
    RESOURCE = auto()
    IDENTIFIER = auto()
    TYPE_PATH = auto()
    LBRACE = auto()
    RBRACE = auto()
    LPAREN = auto()
    RPAREN = auto()
    LBRACKET = auto()
    RBRACKET = auto()
    COMMA = auto()
    SEMICOLON = auto()
    COLON = auto()
    DOT = auto()
    COLON_ACCESS = auto()
    DOT_ACCESS = auto()
    EQUALS = auto()
    PLUS = auto()
    MINUS = auto()
    STAR = auto()
    SLASH = auto()
    PERCENT = auto()
    PLUS_EQ = auto()
    MINUS_EQ = auto()
    STAR_EQ = auto()
    SLASH_EQ = auto()
    AND = auto()
    OR = auto()
    NOT = auto()
    EQ = auto()
    NEQ = auto()
    LT = auto()
    GT = auto()
    LTE = auto()
    GTE = auto()
    BIT_AND = auto()
    BIT_OR = auto()
    BIT_XOR = auto()
    BIT_NOT = auto()
    LSHIFT = auto()
    RSHIFT = auto()
    INCREMENT = auto()
    DECREMENT = auto()
    QUESTION = auto()
    LINE_COMMENT = auto()
    BLOCK_COMMENT_START = auto()
    BLOCK_COMMENT_END = auto()
    BACKSLASH = auto()
    PREPROC_DIRECTIVE = auto()


@dataclass
class Token:
    type: TokenType
    value: str
    line: int
    column: int

    def __repr__(self) -> str:
        """Return a human-readable representation of this token.

        Includes the token type name, its value, and source position
        in line:column format for debugging and diagnostic output.
        """
        return f"Token({self.type.name}, {self.value!r}, {self.line}:{self.column})"


KEYWORDS: dict[str, TokenType] = {
    "if": TokenType.IF,
    "else": TokenType.ELSE,
    "while": TokenType.WHILE,
    "for": TokenType.FOR,
    "do": TokenType.DO,
    "switch": TokenType.SWITCH,
    "return": TokenType.RETURN,
    "break": TokenType.BREAK,
    "continue": TokenType.CONTINUE,
    "goto": TokenType.GOTO,
    "proc": TokenType.PROC,
    "verb": TokenType.VERB,
    "set": TokenType.SET,
    "spawn": TokenType.SPAWN,
    "new": TokenType.NEW,
    "del": TokenType.DEL,
    "var": TokenType.VAR,
    "global": TokenType.GLOBAL,
    "static": TokenType.STATIC,
    "const": TokenType.CONST,
    "tmp": TokenType.TMP,
    "in": TokenType.IN,
    "to": TokenType.TO,
    "step": TokenType.STEP,
    "as": TokenType.AS,
    "null": TokenType.NULL,
    "true": TokenType.TRUE,
    "false": TokenType.FALSE,
}

PREPROC_DIRECTIVES: dict[str, TokenType] = {
    "define": TokenType.DEFINE,
    "include": TokenType.INCLUDE,
    "ifdef": TokenType.IFDEF,
    "ifndef": TokenType.IFNDEF,
    "endif": TokenType.ENDIF,
    "undef": TokenType.UNDEF,
    "warning": TokenType.WARNING,
    "error": TokenType.ERROR,
    "pragma": TokenType.PRAGMA,
}

_TOKEN_SPEC: list[tuple[str, str | None]] = [
    ("SKIP", r"[ \t]+"),
    ("LINE_COMMENT", r"//[^\n]*"),
    ("BLOCK_COMMENT_START", r"/\*"),
    ("BLOCK_COMMENT_END", r"\*/"),
    ("NEWLINE", r"\n"),
    ("PREPROC_DIRECTIVE", r"#[ \t]*(define|include|ifdef|ifndef|endif|undef|warning|error|pragma)\b"),
    ("HASH", r"#"),
    ("STRING", r'"(?:[^"\\]|\\.)*"'),
    ("RESOURCE", r"'(?:[^'\\]|\\.)*'"),
    ("NUMBER", r"\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b"),
    ("TYPE_PATH", r"/[a-zA-Z_][a-zA-Z0-9_]*(?:/[a-zA-Z_][a-zA-Z0-9_]*)*"),
    ("DOT_ACCESS", r"\.\."),
    ("COLON_ACCESS", r"::"),
    ("PLUS_EQ", r"\+="),
    ("MINUS_EQ", r"-="),
    ("STAR_EQ", r"\*="),
    ("SLASH_EQ", r"/="),
    ("INCREMENT", r"\+\+"),
    ("DECREMENT", r"--"),
    ("EQ", r"=="),
    ("NEQ", r"!="),
    ("LTE", r"<="),
    ("GTE", r">="),
    ("AND", r"&&"),
    ("OR", r"\|\|"),
    ("LSHIFT", r"<<"),
    ("RSHIFT", r">>"),
    ("BIT_AND", r"&"),
    ("BIT_OR", r"\|"),
    ("BIT_XOR", r"\^"),
    ("BIT_NOT", r"~"),
    ("EQUALS", r"="),
    ("PLUS", r"\+"),
    ("MINUS", r"-"),
    ("STAR", r"\*"),
    ("SLASH", r"/"),
    ("PERCENT", r"%"),
    ("NOT", r"!"),
    ("LT", r"<"),
    ("GT", r">"),
    ("QUESTION", r"\?"),
    ("LBRACE", r"\{"),
    ("RBRACE", r"\}"),
    ("LPAREN", r"\("),
    ("RPAREN", r"\)"),
    ("LBRACKET", r"\["),
    ("RBRACKET", r"\]"),
    ("COMMA", r","),
    ("SEMICOLON", r";"),
    ("COLON", r":"),
    ("DOT", r"\."),
    ("BACKSLASH", r"\\"),
    ("IDENTIFIER", r"[a-zA-Z_][a-zA-Z0-9_]*"),
]

_TOKEN_RE = re.compile(
    "|".join(f"(?P<{name}>{pattern})" for name, pattern in _TOKEN_SPEC)
)


class Lexer:
    """Tokenize DreamMaker source code."""

    def __init__(self) -> None:
        """Initialize a new lexer with an empty token buffer.

        Sets up the internal token list and position counter used
        during tokenization and iteration over the token stream.
        """
        self.tokens: list[Token] = []
        self._pos = 0

    def tokenize(self, source: str) -> list[Token]:
        """Convert DreamMaker source text into a list of tokens.

        Uses a single compiled regex to match tokens, tracking line
        and column positions throughout. Returns the complete token
        stream including an EOF sentinel at the end.
        """
        self.tokens = []
        self._pos = 0
        line = 1
        col = 1

        for mo in _TOKEN_RE.finditer(source):
            kind = mo.lastgroup
            value = mo.group()
            assert kind is not None

            if kind == "SKIP":
                col += len(value)
                continue

            if kind == "NEWLINE":
                self.tokens.append(Token(TokenType.NEWLINE, value, line, col))
                line += 1
                col = 1
                continue

            if kind == "LINE_COMMENT":
                self.tokens.append(Token(TokenType.LINE_COMMENT, value, line, col))
                col += len(value)
                continue

            if kind == "BLOCK_COMMENT_START":
                self.tokens.append(Token(TokenType.BLOCK_COMMENT_START, value, line, col))
                col += len(value)
                continue

            if kind == "BLOCK_COMMENT_END":
                self.tokens.append(Token(TokenType.BLOCK_COMMENT_END, value, line, col))
                col += len(value)
                continue

            if kind == "HASH":
                self.tokens.append(Token(TokenType.PREPROC_DIRECTIVE, value, line, col))
                col += len(value)
                continue

            if kind == "PREPROC_DIRECTIVE":
                directive = value.lstrip("#").strip().split()[0] if value.strip() else ""
                tok_type = PREPROC_DIRECTIVES.get(directive, TokenType.PREPROC_DIRECTIVE)
                self.tokens.append(Token(tok_type, value, line, col))
                col += len(value)
                continue

            if kind == "STRING":
                self.tokens.append(Token(TokenType.STRING, value, line, col))
                col += len(value)
                continue

            if kind == "RESOURCE":
                self.tokens.append(Token(TokenType.RESOURCE, value, line, col))
                col += len(value)
                continue

            if kind == "NUMBER":
                self.tokens.append(Token(TokenType.NUMBER, value, line, col))
                col += len(value)
                continue

            if kind == "IDENTIFIER":
                tok_type = KEYWORDS.get(value, TokenType.IDENTIFIER)
                self.tokens.append(Token(tok_type, value, line, col))
                col += len(value)
                continue

            if kind == "TYPE_PATH":
                self.tokens.append(Token(TokenType.TYPE_PATH, value, line, col))
                col += len(value)
                continue

            tok_type = TokenType.__members__.get(kind.upper(), TokenType.IDENTIFIER)
            if tok_type == TokenType.IDENTIFIER and kind.upper() in TokenType.__members__:
                tok_type = TokenType[kind.upper()]
            elif kind.upper() in TokenType.__members__:
                tok_type = TokenType[kind.upper()]

            self.tokens.append(Token(tok_type, value, line, col))
            col += len(value)

        self.tokens.append(Token(TokenType.EOF, "", line, col))
        return self.tokens

    def __iter__(self):
        """Return self as an iterator, resetting the position counter.

        Allows the lexer to be used directly in for-loops and other
        iteration contexts over the tokenized stream.
        """
        self._pos = 0
        return self

    def __next__(self) -> Token:
        """Return the next token from the stream.

        Advances the internal position counter and returns the token
        at that position. Raises StopIteration when the stream is
        exhausted (all tokens have been consumed).
        """
        if self._pos >= len(self.tokens):
            raise StopIteration
        token = self.tokens[self._pos]
        self._pos += 1
        return token

    def peek(self, offset: int = 0) -> Token | None:
        """Look ahead in the token stream without consuming tokens.

        Returns the token at the given offset from the current position,
        or None if the offset falls beyond the end of the stream. Useful
        for rules that need multi-token lookahead.
        """
        idx = self._pos + offset
        if idx < len(self.tokens):
            return self.tokens[idx]
        return None
