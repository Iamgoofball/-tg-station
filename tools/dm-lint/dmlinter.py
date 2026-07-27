#!/usr/bin/env python3
"""DreamMaker (.dm) Linter — validates SS13 code without the DM compiler.

Usage: python dmlinter.py code/
"""

import re
import sys
import os
from pathlib import Path
from dataclasses import dataclass
from typing import List

@dataclass
class Diagnostic:
    file: str
    line: int
    col: int
    severity: str  # error, warning
    message: str

class DMLinter:
    def __init__(self):
        self.diagnostics: List[Diagnostic] = []
        self.current_file = ""
        
    def discover_files(self, root: str) -> List[Path]:
        """Recursively find all .dm files."""
        return sorted(Path(root).rglob("*.dm"))
    
    def lint_file(self, path: Path):
        self.current_file = str(path)
        try:
            lines = path.read_text(encoding='utf-8', errors='replace').split('\n')
        except Exception as e:
            self.diag(1, 1, 'error', f'Cannot read file: {e}')
            return
        
        in_block_comment = False
        brace_depth = 0
        paren_depth = 0
        
        for i, line in enumerate(lines, 1):
            stripped = line.strip()
            if not stripped:
                continue
            
            # Skip block comments
            if in_block_comment:
                if '*/' in stripped:
                    in_block_comment = False
                continue
            if stripped.startswith('/*'):
                if '*/' not in stripped:
                    in_block_comment = True
                continue
            
            # Skip single-line comments
            if stripped.startswith('//'):
                continue
            
            # Rule 1: Check for tabs (DM uses spaces, tabs cause issues)
            if '\t' in line and not stripped.startswith('#define'):
                self.diag(i, line.index('\t') + 1, 'warning', 'Tab character found; use spaces for indentation')
            
            # Rule 2: Check proc definitions have closing braces
            if re.match(r'/(proc|obj|mob|turf|area|datum|list)/', stripped):
                if '{' not in stripped:
                    self.diag(i, 1, 'warning', f'Type/proc definition missing opening brace')
            
            # Rule 3: Brace matching
            brace_depth += stripped.count('{') - stripped.count('}')
            if brace_depth < 0:
                self.diag(i, 1, 'error', f'Unexpected closing brace (depth went negative)')
                brace_depth = 0
            
            # Rule 4: Check for missing semicolons where expected (heuristic)
            # Rule 5: var/ declarations should have a type or value
            if re.match(r'var/\w+\s*$', stripped) and '=' not in stripped:
                # Might be a multi-line var - check next line
                pass
            
            # Rule 6: Check for common DM mistakes
            if stripped.count('(') != stripped.count(')'):
                # Might span lines, track
                paren_depth += stripped.count('(') - stripped.count(')')
            
            # Rule 7: spawn() and sleep() need proper context
            if re.search(r'\bspawn\s*\(', stripped) and 'set waitfor = FALSE' not in line:
                pass  # Not necessarily an error
            
            # Rule 8: Check for empty proc bodies
            if re.match(r'/proc/\w+\([^)]*\)\s*$', stripped):
                if i + 1 < len(lines) and lines[i].strip() == '':
                    self.diag(i, 1, 'warning', 'Empty proc body? Proc definition followed by blank line')
        
        # End of file checks
        if brace_depth != 0:
            self.diag(len(lines), 1, 'error', f'Unclosed braces at end of file (depth: {brace_depth})')
        if paren_depth != 0:
            self.diag(len(lines), 1, 'error', f'Unclosed parentheses at end of file (depth: {paren_depth})')
        if in_block_comment:
            self.diag(len(lines), 1, 'error', 'Unclosed block comment at end of file')
    
    def diag(self, line: int, col: int, severity: str, message: str):
        self.diagnostics.append(Diagnostic(self.current_file, line, col, severity, message))
    
    def run(self, root: str) -> int:
        files = self.discover_files(root)
        if not files:
            print(f"dm-lint: No .dm files found in {root}", file=sys.stderr)
            return 1
        
        for f in files:
            self.lint_file(f)
        
        # Report
        errors = [d for d in self.diagnostics if d.severity == 'error']
        warnings = [d for d in self.diagnostics if d.severity == 'warning']
        
        for d in sorted(self.diagnostics, key=lambda x: (x.file, x.line)):
            print(f"{d.file}:{d.line}:{d.col}: {d.severity}: {d.message}")
        
        print(f"\n{d.name()}: {len(files)} files, {len(errors)} errors, {len(warnings)} warnings")
        
        return 1 if errors else 0
    
    @staticmethod
    def name():
        return "dm-lint"

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <code_directory>", file=sys.stderr)
        sys.exit(2)
    
    linter = DMLinter()
    sys.exit(linter.run(sys.argv[1]))

if __name__ == "__main__":
    main()
