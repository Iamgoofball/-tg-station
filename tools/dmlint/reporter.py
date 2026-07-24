"""Diagnostic reporter for dmlint.

Produces machine-parseable diagnostics with filename, line, column,
severity, and message.
"""

from __future__ import annotations

import json
import sys
from dataclasses import dataclass, field
from enum import Enum


class Severity(Enum):
    ERROR = "error"
    WARNING = "warning"
    INFO = "info"


@dataclass
class Diagnostic:
    filename: str
    line: int
    column: int
    severity: Severity
    message: str
    rule: str = ""
    context: str = ""

    def format_terminal(self) -> str:
        """Format for terminal output (GCC-style)."""
        return (
            f"{self.filename}:{self.line}:{self.column}: "
            f"{self.severity.value}: {self.message} [{self.rule}]"
        )

    def format_json(self) -> dict:
        return {
            "filename": self.filename,
            "line": self.line,
            "column": self.column,
            "severity": self.severity.value,
            "message": self.message,
            "rule": self.rule,
            "context": self.context,
        }


@dataclass
class Reporter:
    diagnostics: list[Diagnostic] = field(default_factory=list)
    error_count: int = 0
    warning_count: int = 0
    info_count: int = 0

    def add(
        self,
        filename: str,
        line: int,
        column: int,
        severity: Severity,
        message: str,
        rule: str = "",
        context: str = "",
    ) -> None:
        diag = Diagnostic(
            filename=filename,
            line=line,
            column=column,
            severity=severity,
            message=message,
            rule=rule,
            context=context,
        )
        self.diagnostics.append(diag)

        if severity == Severity.ERROR:
            self.error_count += 1
        elif severity == Severity.WARNING:
            self.warning_count += 1
        else:
            self.info_count += 1

    def has_errors(self) -> bool:
        return self.error_count > 0

    def emit_terminal(self) -> None:
        for diag in self.diagnostics:
            print(diag.format_terminal(), file=sys.stderr)
        print(
            f"\n{self.error_count} errors, "
            f"{self.warning_count} warnings, "
            f"{self.info_count} info",
            file=sys.stderr,
        )

    def emit_json(self) -> None:
        print(json.dumps([d.format_json() for d in self.diagnostics], indent=2))
