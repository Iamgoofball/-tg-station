# DM Lint — DreamMaker Code Linter

Validates .dm source files without the DreamMaker compiler.

## Usage
```bash
python tools/dm-lint/dmlinter.py code/
```

## Rules
- Tab character detection (use spaces)
- Brace matching (unclosed blocks)
- Parenthesis matching
- Unclosed block comments
- Empty proc body warnings

## Tests
```bash
python tools/dm-lint/test_dmlinter.py
```
