"""Style rules — indentation, line length, whitespace conventions."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ..reporter import Severity
from .base import BaseRule

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class StyleRule(BaseRule):
    name = "style"
    description = "Check code style: indentation, line length, trailing whitespace"

    MAX_LINE_LENGTH: int = 200

    def check(self, tokens, lines, reporter, filename):
        """Inspect source lines for style convention violations.

        Checks each line for trailing whitespace, mixed tabs/spaces,
        hard-tab indentation, excessive line length, and empty brace
        blocks. Issues are reported at appropriate severity levels
        (warnings and info).
        """
        for i, line in enumerate(lines, start=1):
            stripped = line.rstrip("\n")

            # Trailing whitespace
            if stripped != stripped.rstrip(" \t"):
                reporter.add(
                    filename=filename,
                    line=i,
                    column=len(stripped.rstrip(" \t")) + 1,
                    severity=Severity.WARNING,
                    message="Trailing whitespace",
                    rule=self.name + "/trailing-whitespace",
                )

            # Mixed tabs and spaces
            if "\t" in stripped and "    " in stripped.replace("\t", ""):
                reporter.add(
                    filename=filename,
                    line=i,
                    column=1,
                    severity=Severity.WARNING,
                    message="Mixed tabs and spaces for indentation",
                    rule=self.name + "/mixed-indent",
                )

            # Hard tabs
            if stripped.startswith("\t"):
                reporter.add(
                    filename=filename,
                    line=i,
                    column=1,
                    severity=Severity.INFO,
                    message="Line indented with hard tab (prefer spaces)",
                    rule=self.name + "/tab-indent",
                )

            # Line length
            if len(stripped) > self.MAX_LINE_LENGTH:
                reporter.add(
                    filename=filename,
                    line=i,
                    column=self.MAX_LINE_LENGTH + 1,
                    severity=Severity.INFO,
                    message=f"Line too long ({len(stripped)} > {self.MAX_LINE_LENGTH} characters)",
                    rule=self.name + "/line-length",
                )

            # Empty block
            if stripped.rstrip().endswith("{}") or stripped.rstrip().endswith("{ }"):
                reporter.add(
                    filename=filename,
                    line=i,
                    column=len(stripped) - 1,
                    severity=Severity.INFO,
                    message="Empty block — consider adding a comment or removing",
                    rule=self.name + "/empty-block",
                )
