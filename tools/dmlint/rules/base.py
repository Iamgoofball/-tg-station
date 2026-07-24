"""Base class for lint rules."""

from __future__ import annotations

import abc
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from ..lexer import Token
    from ..reporter import Reporter


class BaseRule(abc.ABC):
    """Abstract base for all lint rules."""

    name: str = "base"
    description: str = ""

    @abc.abstractmethod
    def check(self, tokens: list[Token], lines: list[str], reporter: Reporter, filename: str) -> None:
        """Run this rule against tokenized source."""
        ...
