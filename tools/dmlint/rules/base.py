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
    the full token list of a file and reports any issues found.
    """

    name: str = "base"
    description: str = ""

    @abc.abstractmethod
    def check(self, tokens: list[Token], lines: list[str], reporter: Reporter, filename: str) -> None:
        """Run this rule against tokenized source.

        Inspects the token stream and source lines for violations,
        recording any diagnostics via the provided reporter instance.
        """
        ...

    def fix(self, lines: list[str]) -> list[str]:
        """Apply auto-fixes to source lines (optional override).

        Returns a modified copy of the lines with any auto-correctable
        issues resolved. The default implementation returns lines unchanged.
        Subclasses that support auto-fix should override this method.

        Args:
            lines: The source file lines (with trailing newlines preserved).

        Returns:
            A new list of lines with fixes applied.
        """
        return lines
