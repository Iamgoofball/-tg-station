# Architecture

`dmlint` is a modular, standalone linter for DreamMaker (`.dm`) source files. It follows a pipeline architecture with clear separation of concerns.

## Pipeline

```
Source Files → Scanner → Lexer → Parser → Rules → Reporter → Output
```

### 1. Scanner (`scanner.py`)

Recursively discovers all `.dm` files under a root directory. Skips known non-code directories (`.git`, `node_modules`, etc.). Returns `Path` objects and a `read_file_lines()` helper for reading file content with encoding fallback (UTF-8 → Latin-1).

### 2. Lexer (`lexer.py`)

Regex-based tokenizer that converts DM source code into a stream of `Token` objects. Each token has:
- `type`: A `TokenType` enum value
- `value`: The matched string
- `line`, `column`: Source position

**Token categories:**
- **Keywords**: `if`, `else`, `while`, `for`, `proc`, `var`, `return`, etc.
- **Preprocessor**: `#define`, `#include`, `#ifdef`, `#endif`, `#undef`, etc.
- **Literals**: Strings (`"..."`), resource paths (`'...'`), numbers
- **Operators**: `==`, `!=`, `&&`, `||`, `+=`, `-=`, etc.
- **Type paths**: `/datum`, `/obj/item`, `/mob/living/carbon/human`
- **Comments**: `//` line, `/* */` block (nestable)
- **Structural**: `{ } ( ) [ ] , ; : .`

The lexer uses a single compiled regex (`_TOKEN_RE`) with named groups. Order of patterns matters: longer patterns (e.g., `==`) must appear before shorter ones (`=`). Type path (`/...`) appears before standalone slash (`/`).

### 3. Rules (`rules/`)

Each rule is a class extending `BaseRule`. Rules receive the full token list, source lines, a `Reporter` instance, and the current filename. Rules are independent — they can be enabled, disabled, or extended without affecting others.

#### Rule Implementations

**BracketRule** (`brackets.py`):
- Stack-based bracket matching
- Tracks `{ }`, `( )`, `[ ]`
- Reports mismatched pairs (referencing opener location)
- Reports unclosed and unmatched closing brackets

**DefineRule** (`defines.py`):
- Tracks `#define` names to detect redefinitions (warning)
- Validates `#ifdef`/`#ifndef`/`#endif` pairing (error for mismatch)
- Checks `#undef` targets exist
- Validates `#include` has a quoted path argument

**CommentRule** (`comments.py`):
- Depth counter for nestable `/* */` comments
- Reports unexpected `*/` outside comments
- Reports unclosed block comments at EOF

**QuoteRule** (`quotes.py`):
- Line-by-line analysis for unmatched double-quotes
- Accounts for escape sequences (`\"`) and comment regions
- Reports single unmatched quotes as errors (clear typos)

**StyleRule** (`style.py`):
- Trailing whitespace detection (warning)
- Mixed tabs and spaces (warning)
- Hard tab indentation (info)
- Line length > 200 chars (info)
- Empty `{}` blocks (info)

**SyntaxRule** (`syntax.py`):
- Type path segment validation (e.g., `/123invalid` flagged)
- Double-slash proc definition detection
- Suspicious `var/` declarations
- Trailing unnecessary semicolons

### 4. Reporter (`reporter.py`)

Collects `Diagnostic` objects and formats output:
- **Terminal**: GCC-style `file:line:col: severity: message [rule]`
- **JSON**: Machine-parseable array of diagnostic objects

Summary statistics (error/warning/info counts) included at the end.

### 5. CLI (`cli.py`)

Argument parsing via `argparse`:
- `path`: Root directory to scan (default: `.`)
- `--json`: JSON output mode
- `--rule`: Enable specific rules only
- `--exclude-rule`: Disable specific rules
- `--quiet`: Suppress non-error output
- `--version`: Print version

Exits with code 1 when errors are found, 0 otherwise.

## Design Decisions

- **No external dependencies**: Uses only Python stdlib. Zero pip install required.
- **Regex-based lexer**: Fast enough for CI on large codebases. A full parser generator (PLY/Lark) would add dependency overhead with marginal benefit for linting.
- **Rule independence**: Each rule is isolated. Adding a new rule requires only creating a new class and registering it — no changes to existing code.
- **GCC-style output**: Familiar to developers who use gcc/clang. Machine-parseable for CI tooling.
