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

    def fix(self, lines: list[str]) -> list[str]:
        """Apply auto-fixes: strip trailing whitespace and convert tabs to spaces.

        Processes each line to remove trailing whitespace characters and
        replaces leading hard-tab characters with spaces (4 spaces per tab).
        Tab characters in the middle of lines (after non-whitespace content)
        are left unchanged to avoid breaking aligned content.

        Args:
            lines: The source file lines (with trailing newlines preserved).

        Returns:
            A new list of lines with style fixes applied.
        """
        fixed: list[str] = []
        for line in lines:
            # Strip trailing whitespace (preserve trailing newline if present)
            had_newline = line.endswith("\n")
            stripped = line.rstrip("\n").rstrip(" \t")
            if had_newline:
                stripped += "\n"

            # Convert leading tabs to spaces
            leading = ""
            rest = stripped
            while rest.startswith("\t"):
                leading += " " * self.TAB_WIDTH
                rest = rest[1:]
            # Preserve the newline at end if present
            fixed.append(leading + rest)

        return fixed
