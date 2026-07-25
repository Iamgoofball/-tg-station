# DM Linter

A standalone linter for DreamMaker (.dm) source files, implemented in Python.

Validates DreamMaker syntax and reports issues without invoking the DreamMaker compiler.

## Features

- Recursively discovers all `*.dm` files
- Tokenizes DM source into structured tokens
- Validates brace and parenthesis balance
- Checks proc/verb definition syntax
- Reports undefined variables
- Enforces consistent formatting
- Detects trailing whitespace and long lines
- JSON output for CI integration
- Modular architecture for custom rules

## Installation

```bash
pip install -e .
```

Or run directly:

```bash
python dm_linter.py [options] <files-or-directories>
```

## Usage

**Lint a single file:**
```bash
python dm_linter.py path/to/file.dm
```

**Lint all .dm files in a directory:**
```bash
python dm_linter.py code/ -r
```

**Lint the current code/ tree (default behavior with no args):**
```bash
python dm_linter.py
```

**Exit with non-zero on errors (for CI):**
```bash
python dm_linter.py code/ -r && echo "PASS" || echo "FAIL"
```

**JSON output (for CI integration):**
```bash
python dm_linter.py code/ -r -f json
```

## Options

| Flag | Description |
|------|-------------|
| `-r, --recursive` | Recursively search directories for .dm files |
| `-f, --format text|json` | Output format (default: text) |
| `--max-line-length N` | Maximum line length (default: 200) |
| `--no-trailing-whitespace` | Skip trailing whitespace check |
| `--no-line-length` | Skip line length check |
| `--no-empty-blocks` | Skip empty block check |

## Architecture

```
dm_linter/
├── dm_linter.py    # Main entry point, CLI, output formatting
├── tokenizer.py    # DM tokenizer (regex-based)
├── parser.py       # DM parser (recursive descent AST)
├── rules.py        # Lint rules and validation logic
├── tests/          # Unit tests
└── README.md       # This file
```

### Adding Custom Rules

Add new rules to `rules.py` as functions that take a token list and filename,
and return a list of `LintResult` objects. Then wire them into `lint_file()`.

## CI Integration

```yaml
# .github/workflows/lint.yml
name: DM Lint
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install -e dm_linter/
      - run: dm_linter code/ -r
```

## License

MIT
