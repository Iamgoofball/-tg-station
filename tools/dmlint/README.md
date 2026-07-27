# dmlint

`dmlint` is a standalone, dependency-free structural linter for Dream Maker
source. It is intended for fast local feedback and CI checks without launching
or embedding DreamMaker.

It recursively indexes `code/**/*.dm`, tracks exact source locations, ignores
syntax-like characters inside comments and strings, and validates:

- terminated string literals and block comments;
- paired parentheses, brackets, and braces;
- balanced `#if`/`#ifdef`/`#ifndef` and `#endif` directives;
- placement of `#else` and `#elif`;
- required `#define` and `#include` arguments;
- trailing whitespace.

This tool deliberately does not claim compiler equivalence. Dream Maker has
context-sensitive language behavior that a small standalone checker cannot
reproduce safely. Rules here are conservative and modular so valid project
syntax is not rejected merely because the linter does not understand it.

## Usage

From the repository root:

```sh
python3 tools/dmlint/dmlint.py
python3 tools/dmlint/dmlint.py --format json
python3 tools/dmlint/dmlint.py --warnings-as-errors
```

The optional positional argument selects another repository root. Text output
uses the stable form:

```text
code/example.dm:12:8: error DM003: unexpected closing delimiter ']'
```

The exit status is `1` when an error is found, `2` for invocation or repository
layout errors, and `0` otherwise. `--warnings-as-errors` also returns `1` for
warning-only output.

## Tests

```sh
cd tools/dmlint
python3 -m unittest -v
```

The tests cover comment/string handling, exact locations, delimiter and
preprocessor validation, recursive discovery, machine-readable output, and
exit-code behavior.

## Architecture and extension

`tokenize` performs one linear pass and emits only syntax-significant tokens,
making repository-scale cost proportional to bytes read. Validation functions
consume that token stream independently and return immutable `Diagnostic`
objects. `line_diagnostics` demonstrates a source-line rule that does not need
tokens.

To add a rule:

1. write a pure function accepting tokens or source lines plus the path;
2. return diagnostics with a unique code, precise location, and actionable
   message;
3. call it from `lint_text`;
4. add positive and negative tests, especially for comments and strings.

The implementation uses only the Python standard library and never shells out
to DreamMaker or another parser.
