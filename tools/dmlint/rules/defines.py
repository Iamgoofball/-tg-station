"""Preprocessor directive rules — validates #define, #include, etc."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..lexer import TokenType
from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class DefineRule(BaseRule):
    name = "defines"
    description = "Validate #define/#include/#ifdef/#endif preprocessor directives"

    def check(self, tokens, lines, reporter, filename):
        ifdef_stack: list[tuple[Token, str]] = []
        defines: dict[str, int] = {}

        i = 0
        while i < len(tokens):
            token = tokens[i]

            if token.type == TokenType.DEFINE:
                name_token = self._next_significant(tokens, i + 1)
                if name_token and name_token.type == TokenType.IDENTIFIER:
                    name = name_token.value
                    if name in defines:
                        reporter.add(
                            filename=filename,
                            line=token.line,
                            column=token.column,
                            severity=Severity.WARNING,
                            message=(
                                f"Redefinition of '#define {name}' — "
                                f"previously defined at line {defines[name]}"
                            ),
                            rule=self.name,
                        )
                    else:
                        defines[name] = token.line

            elif token.type == TokenType.IFDEF:
                name_token = self._next_significant(tokens, i + 1)
                name = name_token.value if name_token else "?"
                ifdef_stack.append((token, name))

            elif token.type == TokenType.IFNDEF:
                name_token = self._next_significant(tokens, i + 1)
                name = name_token.value if name_token else "?"
                ifdef_stack.append((token, name))

            elif token.type == TokenType.ENDIF:
                if not ifdef_stack:
                    reporter.add(
                        filename=filename,
                        line=token.line,
                        column=token.column,
                        severity=Severity.ERROR,
                        message="#endif without matching #ifdef/#ifndef",
                        rule=self.name,
                    )
                else:
                    ifdef_stack.pop()

            elif token.type == TokenType.INCLUDE:
                next_tok = self._next_significant(tokens, i + 1)
                if next_tok and next_tok.type not in (
                    TokenType.STRING,
                    TokenType.RESOURCE,
                ):
                    reporter.add(
                        filename=filename,
                        line=token.line,
                        column=token.column,
                        severity=Severity.WARNING,
                        message="#include should have a quoted path argument",
                        rule=self.name,
                    )

            elif token.type == TokenType.UNDEF:
                name_token = self._next_significant(tokens, i + 1)
                if name_token and name_token.type == TokenType.IDENTIFIER:
                    if name_token.value not in defines:
                        reporter.add(
                            filename=filename,
                            line=token.line,
                            column=token.column,
                            severity=Severity.WARNING,
                            message=f"#undef '{name_token.value}' that was never defined",
                            rule=self.name,
                        )

            i += 1

        for if_tok, name in ifdef_stack:
            reporter.add(
                filename=filename,
                line=if_tok.line,
                column=if_tok.column,
                severity=Severity.ERROR,
                message=f"Unclosed #ifdef/#ifndef '{name}' — missing #endif",
                rule=self.name,
            )

    @staticmethod
    def _next_significant(tokens, start):
        for t in tokens[start:]:
            if t.type not in (
                TokenType.NEWLINE,
                TokenType.LINE_COMMENT,
                TokenType.BLOCK_COMMENT_START,
                TokenType.BLOCK_COMMENT_END,
            ):
                return t
        return None
