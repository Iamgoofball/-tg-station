# dm-linter

A standalone Python linter for DreamMaker (.dm) source code, the language used by BYOND for creating multiplayer worlds (Space Station 13 and other games).

## Features

- **Recursive file discovery**: Finds all `.dm` files under the `code/` directory
- **Lexer**: Full tokenizer for DM syntax including:
  - Preprocessor directives (`#define`, `#include`, `#ifdef`, etc.)
  - Path notation (`/atom/movable`, `/datum/proc/name`)
  - String interpolation (`"Hello [name]"`)
  - All DM operators and keywords
- **Parser**: Builds an AST from DM source code
- **Lint rules**:
  - Trailing whitespace detection
  - Line length checking
  - Mixed tab/space indentation
  - File header checking
  - Punctuation spacing
  - Undefined preprocessor symbols
- **Formats**: Human-readable text and JSON output
- **Exit codes**: Non-zero exit when errors are found (CI-friendly)

## Installation

```bash
# Install from source
cd tools/dm_linter
pip install .

# Or run directly
python -m dm_linter.cli
```

## Usage

```bash
# Lint all .dm files in the code/ directory
dm-linter /path/to/project

# Lint a single file
dm-linter /path/to/file.dm

# JSON output
dm-linter --json

# Quiet mode (hide info messages)
dm-linter --quiet

# Help
dm-linter --help
```

## Output Format

```
path/to/file.dm:42:5: warning: [trailing-whitespace] Trailing whitespace detected
path/to/file.dm:100:201: warning: [line-length] Line too long (210 > 200 characters)

====================================================================
Summary: 7414 files, 0 errors, 42 warnings, 156 infos
====================================================================
```

## Architecture

```
tools/dm_linter/
├── dm_linter/
│   ├── __init__.py     # Package init
│   ├── cli.py          # CLI entry point
│   ├── lexer.py        # DM tokenizer/lexer
│   ├── linter.py       # Main linter orchestration
│   ├── parser.py       # DM AST parser
│   └── rules.py        # Lint rules
├── tests/
│   └── test_linter.py  # Unit tests
├── pyproject.toml      # Python package config
└── README.md           # This file
```

## Extending

Add new lint rules by creating a function with the signature:

```python
def my_rule(source: str, ast: ASTNode, filename: str) -> List[LintResult]:
    ...
```

Then add it to the `BUILTIN_RULES` list in `rules.py`.

## License

MIT
