"""Lint rules package."""

from .brackets import BracketRule
from .defines import DefineRule
from .comments import CommentRule
from .quotes import QuoteRule
from .style import StyleRule
from .syntax import SyntaxRule

__all__ = [
    "BracketRule",
    "DefineRule",
    "CommentRule",
    "QuoteRule",
    "StyleRule",
    "SyntaxRule",
    "ALL_RULES",
]

ALL_RULES = [
    BracketRule,
    DefineRule,
    CommentRule,
    QuoteRule,
    StyleRule,
    SyntaxRule,
]
