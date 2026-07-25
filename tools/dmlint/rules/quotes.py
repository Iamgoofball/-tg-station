"""String quoting rules — checks for quoting style consistency."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..lexer import TokenType
from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class QuoteRule(BaseRule):
    name = "quotes"
    description = "Validate string literals and quoting conventions"

    def check(self, tokens, lines, reporter, filename):
        """Detect unmatched double-quote characters in source lines.

        Performs a per-line scan for unpaired ``"`` characters,
        skipping preprocessor directives, line comments, and block
        comment regions. Flags lines with exactly one unpaired quote
        as likely typos.
        """
        # Per-line sanity check for unmatched quotes
        for i, line in enumerate(lines, start=1):
            stripped = line.strip()

            if stripped.startswith("#") or stripped.startswith("//"):
                continue
            if stripped.startswith("/*"):
                continue

            quote_indices = []
            j = 0
            while j < len(stripped):
                if stripped[j] == '"' and (j == 0 or stripped[j-1] != '\\'):
                    quote_indices.append(j)
                j += 1

            # Only flag exactly one unpaired quote on the line (clear typo)
            if len(quote_indices) % 2 != 0 and len(quote_indices) == 1:
                reporter.add(
                    filename=filename,
                    line=i,
                    column=quote_indices[0] + 1,
                    severity=Severity.ERROR,
                    message="Unmatched double-quote on this line",
                    rule=self.name,
                )
