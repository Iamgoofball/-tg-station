#!/usr/bin/env python3
"""Small, dependency-free structural linter for Dream Maker source."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable


@dataclass(frozen=True, order=True)
class Diagnostic:
    path: str
    line: int
    column: int
    severity: str
    code: str
    message: str


@dataclass(frozen=True)
class Token:
    kind: str
    value: str
    line: int
    column: int


OPENERS = {"(": ")", "[": "]", "{": "}"}
CLOSERS = {value: key for key, value in OPENERS.items()}
DIRECTIVES_WITH_END = {"if": "endif", "ifdef": "endif", "ifndef": "endif"}
IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def tokenize(text: str, path: str) -> tuple[list[Token], list[Diagnostic]]:
    """Tokenize syntax significant DM characters while preserving locations."""
    tokens: list[Token] = []
    diagnostics: list[Diagnostic] = []
    line = column = 1
    index = 0
    length = len(text)

    def advance(value: str) -> None:
        nonlocal line, column
        newlines = value.count("\n")
        if newlines:
            line += newlines
            column = len(value.rsplit("\n", 1)[-1]) + 1
        else:
            column += len(value)

    while index < length:
        start_line, start_column = line, column
        char = text[index]

        if char.isspace():
            advance(char)
            index += 1
            continue

        if text.startswith("//", index):
            end = text.find("\n", index)
            end = length if end < 0 else end
            advance(text[index:end])
            index = end
            continue

        if text.startswith("/*", index):
            end = text.find("*/", index + 2)
            if end < 0:
                diagnostics.append(Diagnostic(
                    path, start_line, start_column, "error", "DM001",
                    "unterminated block comment",
                ))
                break
            value = text[index:end + 2]
            advance(value)
            index = end + 2
            continue

        if text.startswith("@@", index):
            cursor = text.find("@", index + 2)
            cursor = length if cursor < 0 else cursor + 1
            value = text[index:cursor]
            if not value.endswith("@") or len(value) == 2:
                diagnostics.append(Diagnostic(
                    path, start_line, start_column, "error", "DM002",
                    "unterminated custom-delimited string",
                ))
            tokens.append(Token("string", value, start_line, start_column))
            advance(value)
            index = cursor
            continue

        if text.startswith("@{", index) or text.startswith('{"', index):
            opener = text[index:index + 2]
            closer = "}" if opener == "@{" else '"}'
            cursor = index + 2
            while cursor < length and not text.startswith(closer, cursor):
                if text[cursor] == "\\":
                    cursor += 2
                else:
                    cursor += 1
            if cursor < length:
                cursor += len(closer)
            value = text[index:cursor]
            if not value.endswith(closer):
                diagnostics.append(Diagnostic(
                    path, start_line, start_column, "error", "DM002",
                    "unterminated block string",
                ))
            tokens.append(Token("string", value, start_line, start_column))
            advance(value)
            index = cursor
            continue

        if char in "\"'":
            quote = char
            cursor = index + 1
            escaped = False
            interpolation_depth = 0
            nested_quote = False
            while cursor < length:
                current = text[cursor]
                if quote == '"' and not escaped:
                    if current == "[" and not nested_quote:
                        interpolation_depth += 1
                    elif current == "]" and not nested_quote and interpolation_depth:
                        interpolation_depth -= 1
                    elif current == '"' and interpolation_depth:
                        nested_quote = not nested_quote
                    elif current == '"' and not interpolation_depth:
                        cursor += 1
                        break
                elif quote == "'" and not escaped and current == quote:
                    cursor += 1
                    break
                escaped = current == "\\" and not escaped
                if current != "\\":
                    escaped = False
                cursor += 1
            else:
                cursor = length
            value = text[index:cursor]
            if (not value.endswith(quote) or len(value) == 1) and quote == '"':
                diagnostics.append(Diagnostic(
                    path, start_line, start_column, "error", "DM002",
                    f"unterminated {quote} string",
                ))
            tokens.append(Token("string", value, start_line, start_column))
            advance(value)
            index = cursor
            continue

        if char == "#" and not text[text.rfind("\n", 0, index) + 1:index].strip():
            end = index
            while True:
                newline = text.find("\n", end)
                if newline < 0:
                    end = length
                    break
                end = newline + 1
                if not text[index:end].rstrip("\r\n").endswith("\\"):
                    break
            first_line = text[index:end]
            block_start = first_line.find('{"')
            if block_start >= 0:
                block_end = text.find('"}', index + block_start + 2)
                end = length if block_end < 0 else block_end + 2
            value = text[index:end]
            tokens.append(Token("directive", value, start_line, start_column))
            advance(value)
            index = end
            continue

        if char in "()[]{}":
            tokens.append(Token("delimiter", char, start_line, start_column))
            advance(char)
            index += 1
            continue

        if char == "/" or char.isalpha() or char == "_":
            cursor = index + 1
            while cursor < length and (
                text[cursor].isalnum() or text[cursor] in "_/"
            ):
                if text.startswith("//", cursor) or text.startswith("/*", cursor):
                    break
                cursor += 1
            value = text[index:cursor]
            tokens.append(Token("word", value, start_line, start_column))
            advance(value)
            index = cursor
            continue

        tokens.append(Token("symbol", char, start_line, start_column))
        advance(char)
        index += 1

    return tokens, diagnostics


def delimiter_diagnostics(tokens: Iterable[Token], path: str) -> list[Diagnostic]:
    stack: list[Token] = []
    diagnostics: list[Diagnostic] = []
    for token in tokens:
        if token.kind != "delimiter":
            continue
        if token.value in OPENERS:
            stack.append(token)
        elif not stack:
            diagnostics.append(Diagnostic(
                path, token.line, token.column, "error", "DM003",
                f"unexpected closing delimiter {token.value!r}",
            ))
        elif stack[-1].value != CLOSERS[token.value]:
            opener = stack.pop()
            diagnostics.append(Diagnostic(
                path, token.line, token.column, "error", "DM004",
                f"{token.value!r} closes {opener.value!r} opened at "
                f"{opener.line}:{opener.column}",
            ))
        else:
            stack.pop()
    for opener in stack:
        diagnostics.append(Diagnostic(
            path, opener.line, opener.column, "error", "DM005",
            f"unclosed delimiter {opener.value!r}",
        ))
    return diagnostics


def directive_diagnostics(tokens: Iterable[Token], path: str) -> list[Diagnostic]:
    stack: list[tuple[str, Token]] = []
    diagnostics: list[Diagnostic] = []
    for token in tokens:
        if token.kind != "directive":
            continue
        match = re.match(r"#\s*([A-Za-z_][A-Za-z0-9_]*)\b(.*)", token.value)
        if not match:
            diagnostics.append(Diagnostic(
                path, token.line, token.column, "error", "DM006",
                "malformed preprocessor directive",
            ))
            continue
        name, rest = match.group(1).lower(), match.group(2).strip()
        if name in DIRECTIVES_WITH_END:
            stack.append((DIRECTIVES_WITH_END[name], token))
        elif name in {"else", "elif"}:
            if not stack or stack[-1][0] != "endif":
                diagnostics.append(Diagnostic(
                    path, token.line, token.column, "error", "DM007",
                    f"#{name} without a matching conditional",
                ))
        elif name == "endif":
            if not stack or stack[-1][0] != name:
                diagnostics.append(Diagnostic(
                    path, token.line, token.column, "error", "DM008",
                    "#endif without a matching conditional",
                ))
            else:
                stack.pop()
        elif name == "define" and not rest:
            diagnostics.append(Diagnostic(
                path, token.line, token.column, "error", "DM009",
                "#define requires a macro name",
            ))
        elif name == "include" and not re.match(r'^[<"].+[>"]$', rest):
            diagnostics.append(Diagnostic(
                path, token.line, token.column, "error", "DM010",
                '#include expects a path enclosed in "" or <>',
            ))
    for expected, opener in stack:
        diagnostics.append(Diagnostic(
            path, opener.line, opener.column, "error", "DM011",
            f"conditional directive has no #{expected}",
        ))
    return diagnostics


def line_diagnostics(text: str, path: str) -> list[Diagnostic]:
    diagnostics: list[Diagnostic] = []
    for number, raw_line in enumerate(text.splitlines(), 1):
        if raw_line.rstrip(" \t") != raw_line:
            diagnostics.append(Diagnostic(
                path, number, len(raw_line.rstrip(" \t")) + 1, "warning", "DM102",
                "trailing whitespace",
            ))
    return diagnostics


def lint_text(text: str, path: str = "<input>") -> list[Diagnostic]:
    tokens, diagnostics = tokenize(text, path)
    diagnostics.extend(delimiter_diagnostics(tokens, path))
    diagnostics.extend(directive_diagnostics(tokens, path))
    diagnostics.extend(line_diagnostics(text, path))
    return sorted(set(diagnostics))


def discover(root: Path) -> list[Path]:
    code_root = root / "code"
    if not code_root.is_dir():
        raise FileNotFoundError(f"{code_root}: code directory not found")
    return sorted(path for path in code_root.rglob("*.dm") if path.is_file())


def lint_files(root: Path, paths: Iterable[Path]) -> list[Diagnostic]:
    diagnostics: list[Diagnostic] = []
    for path in paths:
        relative = str(path.relative_to(root))
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError as error:
            diagnostics.append(Diagnostic(
                relative, 1, error.start + 1, "error", "DM013",
                "source is not valid UTF-8",
            ))
            continue
        except OSError as error:
            diagnostics.append(Diagnostic(
                relative, 1, 1, "error", "DM014", f"cannot read source: {error}",
            ))
            continue
        diagnostics.extend(lint_text(text, relative))
    return sorted(diagnostics)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "root", nargs="?", default=".", type=Path,
        help="repository root containing code/ (default: current directory)",
    )
    parser.add_argument(
        "--format", choices=("text", "json"), default="text",
        help="diagnostic output format",
    )
    parser.add_argument(
        "--warnings-as-errors", action="store_true",
        help="return a failing status when warnings are present",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    root = args.root.resolve()
    try:
        paths = discover(root)
    except FileNotFoundError as error:
        print(f"dmlint: {error}", file=sys.stderr)
        return 2
    diagnostics = lint_files(root, paths)
    if args.format == "json":
        print(json.dumps({
            "files": len(paths),
            "diagnostics": [asdict(item) for item in diagnostics],
        }, indent=2))
    else:
        for item in diagnostics:
            print(
                f"{item.path}:{item.line}:{item.column}: "
                f"{item.severity} {item.code}: {item.message}"
            )
        print(
            f"dmlint: checked {len(paths)} file(s), "
            f"{sum(item.severity == 'error' for item in diagnostics)} error(s), "
            f"{sum(item.severity == 'warning' for item in diagnostics)} warning(s)"
        )
    has_errors = any(item.severity == "error" for item in diagnostics)
    has_warnings = any(item.severity == "warning" for item in diagnostics)
    return int(has_errors or (args.warnings_as_errors and has_warnings))


if __name__ == "__main__":
    raise SystemExit(main())
