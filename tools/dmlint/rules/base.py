"""Base class for lint rules."""

from __future__ import annotations

import abc
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class BaseRule(abc.ABC):
    """Abstract base for all lint rules.

    Subclasses must implement the ``check`` method, which receives
    the token stream, source lines, a reporter, and a filename,
    recording any diagnostics via the provided reporter instance.
    """

    name: str
    description: str

    @abc.abstractmethod
    def check(
        self,
        tokens: list[Token],
        lines: list[str],
        reporter: Reporter,
        filename: str,
    ) -> None:
        ...

    def fix(self, lines: list[str]) -> list[str]:
        """Apply auto-fixes to source lines (optional override).

        Returns a modified copy of the lines with fixable issues
        corrected.  The default implementation returns the lines
        unchanged.
        """
        return lines[:]
