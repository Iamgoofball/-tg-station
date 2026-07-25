"""Syntax checking rules — validates DM language syntax constructs."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..lexer import TokenType
from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class SyntaxRule(BaseRule):
    name = "syntax"
    description = "Validate DM syntax: type paths, proc definitions, statements"

    def check(self, tokens, lines, reporter, filename):
        """Validate DreamMaker syntax constructs in the token stream.

        Checks type path segments for invalid characters, detects
        double-slash proc definitions, flags suspicious ``var/``
        declarations, and reports unnecessary trailing semicolons.
        """
        i = 0
        n = len(tokens)

        while i < n:
            token = tokens[i]

            if token.type == TokenType.TYPE_PATH:
                path = token.value
                segments = path.split("/")
                for seg in segments:
                    if seg and not seg[0].isalpha() and seg[0] != "_":
                        reporter.add(
                            filename=filename,
                            line=token.line,
                            column=token.column,
                            severity=Severity.ERROR,
                            message=f"Invalid type path segment: '/{seg}'",
                            rule=self.name + "/type-path",
                        )
                        break

            if token.type == TokenType.PROC:
                prev = self._prev_significant(tokens, i)
                if prev and prev.type == TokenType.SLASH and tokens[i - 2].type == TokenType.SLASH:
                    reporter.add(
                        filename=filename,
                        line=token.line,
                        column=token.column,
                        severity=Severity.ERROR,
                        message="Invalid proc definition: use single '/' for type paths",
                        rule=self.name + "/proc-def",
                    )

            if token.type == TokenType.VAR:
                next_tok = self._next_significant(tokens, i + 1)
                if next_tok and next_tok.type == TokenType.SLASH:
                    after_slash = self._next_significant(tokens, i + 2)
                    if after_slash and not self._is_valid_var_decl(after_slash):
                        reporter.add(
                            filename=filename,
                            line=token.line,
                            column=token.column,
                            severity=Severity.WARNING,
                            message=(
                                "Suspicious var declaration — "
                                "expected type or identifier after 'var/'"
                            ),
                            rule=self.name + "/var-decl",
                        )

            if (
                token.type == TokenType.SEMICOLON
                and i + 1 < n
                and tokens[i + 1].type == TokenType.NEWLINE
            ):
                reporter.add(
                    filename=filename,
                    line=token.line,
                    column=token.column,
                    severity=Severity.INFO,
                    message="Unnecessary semicolon at end of line",
                    rule=self.name + "/trailing-semicolon",
                )

            i += 1

    @staticmethod
    def _next_significant(tokens, start):
        """Return the next meaningful token after the given index.

        Skips over newlines, line comments, and block comment
        markers to find the first significant token. Returns None
        if no such token exists before end of stream.
        """
        for t in tokens[start:]:
            if t.type not in (
                TokenType.NEWLINE,
                TokenType.LINE_COMMENT,
                TokenType.BLOCK_COMMENT_START,
                TokenType.BLOCK_COMMENT_END,
            ):
                return t
        return None

    @staticmethod
    def _prev_significant(tokens, end):
        """Return the nearest meaningful token before the given index.

        Scans backwards from the end position, skipping whitespace
        and comment tokens. Returns the first significant token found
        or None if none exist before the start of the stream.
        """
        for t in reversed(tokens[:end]):
            if t.type not in (
                TokenType.NEWLINE,
                TokenType.LINE_COMMENT,
                TokenType.BLOCK_COMMENT_START,
                TokenType.BLOCK_COMMENT_END,
            ):
                return t
        return None

    @staticmethod
    def _is_valid_var_decl(token):
        """Check whether a token is valid in a var declaration context.

        Returns True for identifiers, type paths, and modifier keywords
        (static, global, const, tmp) that can follow ``var/`` in a valid
        DreamMaker variable declaration.
        """
        return token.type in (
            TokenType.IDENTIFIER,
            TokenType.TYPE_PATH,
            TokenType.STATIC,
            TokenType.GLOBAL,
            TokenType.CONST,
            TokenType.TMP,
        )
