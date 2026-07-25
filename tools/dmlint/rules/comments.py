"""Comment rules — checks for unclosed block comments and comment style."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..lexer import TokenType
from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class CommentRule(BaseRule):
    name = "comments"
    description = "Validate block comment nesting and unclosed comments"

    def check(self, tokens, lines, reporter, filename):
        """Check block comment nesting and detect unclosed comments.

        Uses a depth counter to track nestable ``/* */`` blocks.
        Reports unexpected ``*/`` tokens outside comments and flags
        block comments that are left unclosed at end of file.
        """
        comment_depth = 0
        comment_start: Token | None = None

        for token in tokens:
            if token.type == TokenType.BLOCK_COMMENT_START:
                if comment_depth == 0:
                    comment_start = token
                comment_depth += 1
            elif token.type == TokenType.BLOCK_COMMENT_END:
                if comment_depth > 0:
                    comment_depth -= 1
                else:
                    reporter.add(
                        filename=filename,
                        line=token.line,
                        column=token.column,
                        severity=Severity.ERROR,
                        message="Unexpected '*/' outside of a block comment",
                        rule=self.name,
                    )

        if comment_depth > 0 and comment_start is not None:
            reporter.add(
                filename=filename,
                line=comment_start.line,
                column=comment_start.column,
                severity=Severity.ERROR,
                message=f"Unclosed block comment (depth {comment_depth}) — missing '*/'",
                rule=self.name,
            )
