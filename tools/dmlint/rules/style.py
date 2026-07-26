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
    TAB_WIDTH: int = 4

    def check(self, tokens, lines, reporter, filename):
        """Inspect source lines for style convention violations.

        Checks for:
        - Trailing whitespace on any line
        - Lines exceeding MAX_LINE_LENGTH characters
        - Hard tab indentation (reported as info-level tab-indent)
        - Mixed tabs and spaces on the same indent line
        - Empty block bodies (consecutive opening/closing braces)
        """
        for idx, line in enumerate(lines, start=1):
            stripped = line.rstrip("\n")

            # Trailing whitespace
            if stripped != stripped.rstrip():
                reporter.add(
                    filename=filename,
                    line=idx,
                    column=len(stripped.rstrip()) + 1,
                    severity=Severity.WARNING,
                    message="Trailing whitespace",
                    rule=f"{self.name}/trailing-whitespace",
                )

            # Line length
            content = stripped.rstrip()
            if len(content) > self.MAX_LINE_LENGTH:
                reporter.add(
                    filename=filename,
                    line=idx,
                    column=self.MAX_LINE_LENGTH + 1,
                    severity=Severity.WARNING,
                    message=f"Line too long ({len(content)} > {self.MAX_LINE_LENGTH})",
                    rule=f"{self.name}/line-length",
                )

            # Tab indentation (info level)
            indent = len(content) - len(content.lstrip())
            if indent > 0 and "\t" in content[:indent]:
                reporter.add(
                    filename=filename,
                    line=idx,
                    column=1,
                    severity=Severity.INFO,
                    message="Line indented with hard tab (prefer spaces)",
                    rule=f"{self.name}/tab-indent",
                )

            # Mixed tabs and spaces
            if indent > 0 and "\t" in content[:indent] and " " in content[:indent]:
                reporter.add(
                    filename=filename,
                    line=idx,
                    column=1,
                    severity=Severity.WARNING,
                    message="Mixed tabs and spaces in indentation",
                    rule=f"{self.name}/mixed-indent",
                )

            # Empty block — consecutive { and }
            stripped_content = content.strip()
            if stripped_content in ("{}", "()", "[]"):
                reporter.add(
                    filename=filename,
                    line=idx,
                    column=content.index(stripped_content[0]) + 1,
                    severity=Severity.INFO,
                    message="Empty block body — consider a comment explaining intent",
                    rule=f"{self.name}/empty-block",
                )

    def fix(self, lines: list[str]) -> list[str]:
        """Auto-correct trailing whitespace and tab indentation.

        Each hard tab at the start of a line is replaced with
        TAB_WIDTH spaces.  Trailing whitespace is stripped from
        every line.
        """
        fixed: list[str] = []
        for line in lines:
            stripped = line.rstrip("\n")
            # Strip trailing whitespace first
            cleaned = stripped.rstrip()
            # Convert leading tabs to spaces
            leading = ""
            rest = cleaned
            while rest and rest[0] == "\t":
                leading += " " * self.TAB_WIDTH
                rest = rest[1:]
            fixed.append(leading + rest + "\n")
        return fixed
