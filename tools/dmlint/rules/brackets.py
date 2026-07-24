"""Bracket matching rule — checks for balanced braces, parens, and brackets."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..lexer import TokenType
from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class BracketRule(BaseRule):
    name = "brackets"
    description = "Validate balanced braces, parentheses, and brackets"

    OPENERS: dict[TokenType, TokenType] = {
        TokenType.LBRACE: TokenType.RBRACE,
        TokenType.LPAREN: TokenType.RPAREN,
        TokenType.LBRACKET: TokenType.RBRACKET,
    }

    CLOSERS: dict[TokenType, TokenType] = {
        TokenType.RBRACE: TokenType.LBRACE,
        TokenType.RPAREN: TokenType.LPAREN,
        TokenType.RBRACKET: TokenType.LBRACKET,
    }

    BRACKET_NAMES: dict[TokenType, str] = {
        TokenType.LBRACE: "{",
        TokenType.RBRACE: "}",
        TokenType.LPAREN: "(",
        TokenType.RPAREN: ")",
        TokenType.LBRACKET: "[",
        TokenType.RBRACKET: "]",
    }

    def check(self, tokens, lines, reporter, filename):
        stack: list[tuple[TokenType, Token]] = []

        for token in tokens:
            if token.type in self.OPENERS:
                stack.append((token.type, token))
            elif token.type in self.CLOSERS:
                expected = self.CLOSERS[token.type]
                if not stack:
                    reporter.add(
                        filename=filename,
                        line=token.line,
                        column=token.column,
                        severity=Severity.ERROR,
                        message=f"Unmatched closing '{self.BRACKET_NAMES[token.type]}'",
                        rule=self.name,
                    )
                else:
                    opener_type, opener_token = stack.pop()
                    if opener_type != expected:
                        reporter.add(
                            filename=filename,
                            line=token.line,
                            column=token.column,
                            severity=Severity.ERROR,
                            message=(
                                f"Mismatched bracket: expected "
                                f"'{self.BRACKET_NAMES[self.OPENERS.get(opener_type, TokenType.EOF)]}' "
                                f"but found '{self.BRACKET_NAMES[token.type]}' (opened at line "
                                f"{opener_token.line})"
                            ),
                            rule=self.name,
                        )

        for opener_type, opener_token in stack:
            reporter.add(
                filename=filename,
                line=opener_token.line,
                column=opener_token.column,
                severity=Severity.ERROR,
                message=(
                    f"Unclosed '{self.BRACKET_NAMES[opener_type]}' — missing "
                    f"'{self.BRACKET_NAMES[self.OPENERS[opener_type]]}'"
                ),
                rule=self.name,
            )
