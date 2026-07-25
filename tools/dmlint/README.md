# dmlint — DreamMaker Linter

A standalone linter for DreamMaker (`.dm`) source files, built in Python. Validates DM code against the official [DreamMaker language reference](https://www.byond.com/docs/ref/info.html) without requiring the DreamMaker compiler.

Designed for CI pipelines, local development, and automated tooling.

## Quick Start

```bash
# Install dependencies (Python 3.9+)
pip install pytest  # for tests only

# Run the linter on the code/ directory
python -m dmlint code/

# JSON output for machine consumption
python -m dmlint code/ --json

# Run only specific rules
python -m dmlint code/ --rule brackets --rule defines

# Exclude noisy rules
python -m dmlint code/ --exclude-rule style
```

## Features

- **Recursive discovery**: Scans all `code/**/*.dm` files automatically
- **Comprehensive validation**: Checks syntax, brackets, preprocessor directives, comments, quotes, and code style
- **Machine-parseable output**: GCC-style terminal output or JSON
- **Non-zero exit on errors**: CI-ready
- **Modular rules**: Easy to add, remove, or disable individual lint rules
- **No external dependencies**: Zero install beyond Python stdlib

## Rules

| Rule | Name | Checks |
|------|------|--------|
| Brackets | `brackets` | Balanced `{}`, `()`, `[]` |
| Defines | `defines` | `#define` redefinition, `#ifdef/#endif` pairing, `#undef` validity |
| Comments | `comments` | Unclosed `/* */` block comments, nesting |
| Quotes | `quotes` | Unmatched double-quote strings |
| Style | `style` | Trailing whitespace, mixed tabs/spaces, line length, empty blocks |
| Syntax | `syntax` | Type path validity, unnecessary semicolons, var declaration patterns |

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for module-level design details.

```
tools/dmlint/
├── cli.py          # Command-line interface (argparse)
├── lexer.py        # Regex-based tokenizer
├── scanner.py      # .dm file discovery
├── reporter.py     # Diagnostic reporting (terminal + JSON)
├── rules/          # Individual lint rules
│   ├── base.py     # Abstract base class
│   ├── brackets.py
│   ├── comments.py
│   ├── defines.py
│   ├── quotes.py
│   ├── style.py
│   └── syntax.py
└── __main__.py     # python -m dmlint entry point
```

## Extending

Create a new rule by subclassing `BaseRule`:

```python
from dmlint.rules.base import BaseRule
from dmlint.reporter import Severity

class MyRule(BaseRule):
    name = "my-rule"
    description = "My custom lint rule"

    def check(self, tokens, lines, reporter, filename):
        reporter.add(
            filename=filename,
            line=1,
            column=1,
            severity=Severity.WARNING,
            message="Custom warning",
            rule=self.name,
        )
```

Then register it in `rules/__init__.py` in the `ALL_RULES` list.

## Sample Output

Running on real DM files from the tgstation codebase:

```bash
# Scan the wiremod/datatypes directory (13 .dm files, all clean)
$ python -m dmlint code/modules/wiremod/datatypes --exclude-rule style
dmlint: scanning 13 .dm file(s) under 'code/modules/wiremod/datatypes'

0 errors, 0 warnings, 0 info

# Scan the wiremod/shell directory (19 .dm files, finds issues)
$ python -m dmlint code/modules/wiremod/shell --exclude-rule style
dmlint: scanning 19 .dm file(s) under 'code/modules/wiremod/shell'
code/modules/wiremod/shell/implant.dm:11:4579: error: Unmatched closing ')' [brackets]
code/modules/wiremod/shell/implant.dm:8:16: error: Unmatched double-quote on this line [quotes]
code/modules/wiremod/shell/implant.dm:11:66: error: Unmatched double-quote on this line [quotes]

3 errors, 0 warnings, 0 info

# JSON output (CI-friendly)
$ python -m dmlint code/modules/wiremod/shell --json --exclude-rule style
[
  {
    "filename": "code/modules/wiremod/shell/implant.dm",
    "line": 11,
    "column": 4579,
    "severity": "error",
    "message": "Unmatched closing ')'",
    "rule": "brackets"
  },
  ...
]
```

> **Note:** The `--exclude-rule style` flag skips the style rule which flags hard tabs (tgstation uses tabs for indentation). If your project uses spaces, you can omit this flag.

## Testing

```bash
cd tools/
python -m pytest tests/ -v
```

## License

This linter is part of the /tg/station codebase. See the repository LICENSE file.
