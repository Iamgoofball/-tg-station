"""
dm-linter: Lexer / tokenizer for DreamMaker (.dm) source files.

Tokenizes DM source code into a stream of tokens for further analysis.
Handles DM-specific syntax including:
  - Preprocessor directives (#define, #undef, #if, #ifdef, etc.)
  - Path notation (/atom, /datum/proc/...)
  - Var declarations (var/, var/name = value)
  - String interpolation (embedded expressions)
  - DM operators and keywords
"""

import re
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Optional, Tuple


class TokenType(Enum):
    # Literals
    IDENTIFIER = auto()
    NUMBER = auto()
    STRING = auto()
    STRING_INTERPOLATED = auto()  # embedded [expr] in strings
    PUNCTUATION = auto()
    
    # Keywords
    KEYWORD_IF = auto()
    KEYWORD_ELSE = auto()
    KEYWORD_FOR = auto()
    KEYWORD_WHILE = auto()
    KEYWORD_DO = auto()
    KEYWORD_SWITCH = auto()
    KEYWORD_CASE = auto()
    KEYWORD_DEFAULT = auto()
    KEYWORD_BREAK = auto()
    KEYWORD_CONTINUE = auto()
    KEYWORD_RETURN = auto()
    KEYWORD_GOTO = auto()
    KEYWORD_NEW = auto()
    KEYWORD_DEL = auto()
    KEYWORD_SET = auto()
    KEYWORD_VERB = auto()
    KEYWORD_VAR = auto()
    KEYWORD_GLOBAL = auto()
    KEYWORD_STATIC = auto()
    KEYWORD_CONST = auto()
    KEYWORD_PROG = auto()
    KEYWORD_LIST = auto()
    KEYWORD_IN = auto()
    KEYWORD_AS = auto()
    KEYWORD_SPAWN = auto()
    KEYWORD_SLEEP = auto()
    KEYWORD_TRY = auto()
    KEYWORD_CATCH = auto()
    
    # Paths
    PATH_SEGMENT = auto()  # /atom, /datum, /proc, etc.
    
    # Operators
    OPERATOR = auto()
    
    # Preprocessor
    PREPROCESSOR = auto()
    PREPROCESSOR_ARG = auto()
    
    # Special
    COMMENT = auto()
    COMMENT_BLOCK = auto()
    NEWLINE = auto()
    INDENT = auto()
    DEDENT = auto()
    EOF = auto()
    
    # DM-specific
    CONTINUATION = auto()  # Line continuation with \


@dataclass
class Token:
    type: TokenType
    value: str
    line: int
    column: int
    raw: str = ""


# DM keywords mapping
DM_KEYWORDS = {
    "if": TokenType.KEYWORD_IF,
    "else": TokenType.KEYWORD_ELSE,
    "for": TokenType.KEYWORD_FOR,
    "while": TokenType.KEYWORD_WHILE,
    "do": TokenType.KEYWORD_DO,
    "switch": TokenType.KEYWORD_SWITCH,
    "case": TokenType.KEYWORD_CASE,
    "default": TokenType.KEYWORD_DEFAULT,
    "break": TokenType.KEYWORD_BREAK,
    "continue": TokenType.KEYWORD_CONTINUE,
    "return": TokenType.KEYWORD_RETURN,
    "goto": TokenType.KEYWORD_GOTO,
    "new": TokenType.KEYWORD_NEW,
    "del": TokenType.KEYWORD_DEL,
    "set": TokenType.KEYWORD_SET,
    "verb": TokenType.KEYWORD_VERB,
    "var": TokenType.KEYWORD_VAR,
    "global": TokenType.KEYWORD_GLOBAL,
    "static": TokenType.KEYWORD_STATIC,
    "const": TokenType.KEYWORD_CONST,
    "proc": TokenType.KEYWORD_PROG,
    "list": TokenType.KEYWORD_LIST,
    "in": TokenType.KEYWORD_IN,
    "as": TokenType.KEYWORD_AS,
    "spawn": TokenType.KEYWORD_SPAWN,
    "sleep": TokenType.KEYWORD_SLEEP,
    "try": TokenType.KEYWORD_TRY,
    "catch": TokenType.KEYWORD_CATCH,
}


class LexerError(Exception):
    def __init__(self, message: str, line: int, column: int):
        self.message = message
        self.line = line
        self.col = column
        super().__init__(f"[{line}:{column}] {message}")


class Lexer:
    """Tokenize DM source code into a stream of tokens."""

    def __init__(self, source: str, filename: str = "<unknown>"):
        self.source = source
        self.filename = filename
        self.pos = 0
        self.line = 1
        self.col = 1
        self.tokens: List[Token] = []
        self._token_start_col = 1
        
        # Preprocessor state
        self._in_preprocessor = False
    
    def _error(self, msg: str) -> LexerError:
        return LexerError(msg, self.line, self.col)
    
    def _peek(self, offset: int = 0) -> Optional[str]:
        idx = self.pos + offset
        return self.source[idx] if idx < len(self.source) else None
    
    def _advance(self) -> str:
        ch = self.source[self.pos]
        self.pos += 1
        if ch == '\n':
            self.line += 1
            self.col = 1
        else:
            self.col += 1
        return ch
    
    def _skip_whitespace(self) -> None:
        while self.pos < len(self.source):
            ch = self._peek()
            if ch in (' ', '\t', '\r'):
                self._advance()
            else:
                break
    
    def _read_while(self, predicate) -> str:
        result = []
        while self.pos < len(self.source) and predicate(self._peek()):
            result.append(self._advance())
        return ''.join(result)
    
    def _make_token(self, type_: TokenType, value: str, raw: Optional[str] = None) -> Token:
        return Token(
            type=type_,
            value=value,
            line=self.line,
            column=self._token_start_col,
            raw=raw or value,
        )
    
    def _handle_preprocessor(self) -> None:
        """Handle a preprocessor directive line."""
        # consume the # character (already consumed)
        directive = []
        while self.pos < len(self.source) and self._peek() in (' ', '\t'):
            self._advance()
        
        # Read directive name
        while self.pos < len(self.source) and (self._peek().isalnum() or self._peek() == '_'):
            directive.append(self._advance())
        
        directive_name = ''.join(directive)
        token = self._make_token(
            TokenType.PREPROCESSOR,
            f"#{directive_name}",
        )
        self.tokens.append(token)
        
        # Read rest of preprocessor line (arguments)
        args = self._read_line_rest()
        if args.strip():
            self.tokens.append(self._make_token(TokenType.PREPROCESSOR_ARG, args.rstrip('\r\n')))
    
    def _read_line_rest(self) -> str:
        """Read until end of line."""
        result = []
        while self.pos < len(self.source) and self._peek() not in ('\n', '\r'):
            result.append(self._advance())
        return ''.join(result)
    
    def _read_string(self, delimiter: str) -> str:
        """Read a string literal."""
        result = []
        while self.pos < len(self.source):
            ch = self._peek()
            if ch == '\\':
                result.append(self._advance())
                if self.pos < len(self.source):
                    result.append(self._advance())
            elif ch == '[':
                # String interpolation
                result.append(self._advance())
                depth = 1
                while depth > 0 and self.pos < len(self.source):
                    c = self._advance()
                    result.append(c)
                    if c == '[':
                        depth += 1
                    elif c == ']':
                        depth -= 1
            elif ch == delimiter:
                result.append(self._advance())
                break
            elif ch in ('\n', '\r'):
                break
            else:
                result.append(self._advance())
        return ''.join(result)
    
    def _read_dot_path(self) -> str:
        """Read a DM path like /atom/movable or /proc/say."""
        path = []
        # Already consumed the first /
        while self.pos < len(self.source):
            ch = self._peek()
            if ch.isalnum() or ch in ('/', '_', '-', '%', '$', '!'):
                path.append(self._advance())
            else:
                break
        return '/' + ''.join(path)
    
    def tokenize(self) -> List[Token]:
        """Tokenize the entire source."""
        while self.pos < len(self.source):
            self._token_start_col = self.col
            ch = self._peek()
            
            if ch is None:
                break
            
            # Handle newlines
            if ch == '\n':
                self.tokens.append(self._make_token(TokenType.NEWLINE, '\\n'))
                self._advance()
                continue
            
            if ch == '\r':
                # CRLF handling
                if self._peek(1) == '\n':
                    self._advance()  # skip \r
                self.tokens.append(self._make_token(TokenType.NEWLINE, '\\r\\n'))
                self._advance()
                continue
            
            # Skip whitespace (non-newline)
            if ch in (' ', '\t'):
                self._skip_whitespace()
                continue
            
            # Comments
            if ch == '/' and self._peek(1) == '/':
                # Line comment
                comment_text = '//' + self._read_line_rest()
                self.tokens.append(self._make_token(TokenType.COMMENT, comment_text))
                continue
            
            if ch == '/' and self._peek(1) == '*':
                # Block comment
                self._advance()  # /
                self._advance()  # *
                comment_text = '/*'
                depth = 1
                while depth > 0 and self.pos < len(self.source):
                    c = self._advance()
                    comment_text += c
                    if c == '/' and self._peek() == '*':
                        comment_text += self._advance()
                        depth += 1
                    elif c == '*' and self._peek() == '/':
                        comment_text += self._advance()
                        depth -= 1
                self.tokens.append(self._make_token(TokenType.COMMENT_BLOCK, comment_text))
                continue
            
            # Preprocessor
            if ch == '#' and self._is_start_of_line():
                self._advance()
                self._handle_preprocessor()
                continue
            
            # String literals
            if ch in ('"', "'"):
                delim = self._advance()
                string_content = self._read_string(delim)
                has_interpolation = '[' in string_content and ']' in string_content
                tok_type = TokenType.STRING_INTERPOLATED if has_interpolation else TokenType.STRING
                self.tokens.append(self._make_token(tok_type, delim + string_content))
                continue
            
            # Paths starting with /
            if ch == '/':
                nxt = self._peek(1)
                if nxt and (nxt.isalpha() or nxt == '/'):
                    self._advance()  # consume /
                    path = self._read_dot_path()
                    self.tokens.append(self._make_token(TokenType.PATH_SEGMENT, path))
                    continue
            
            # Numbers
            if ch.isdigit() or (ch == '.' and self._peek(1) and self._peek(1).isdigit()):
                num = self._read_while(lambda c: c.isdigit() or c == '.' or c in ('x', 'X', 'a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F'))
                self.tokens.append(self._make_token(TokenType.NUMBER, num))
                continue
            
            # Identifiers and keywords
            if ch.isalpha() or ch == '_':
                ident = self._read_while(lambda c: c.isalnum() or c == '_')
                # Check if it's a keyword
                token_type = DM_KEYWORDS.get(ident.lower(), TokenType.IDENTIFIER)
                self.tokens.append(self._make_token(token_type, ident))
                continue
            
            # Operators and punctuation
            op = ch
            self._advance()
            
            # Multi-char operators
            next_ch = self._peek() if self.pos < len(self.source) else ''
            # Compound assignment operators (+= -= *= /= %= &= |= ^= <<= >>=)
            if op in ('+', '-', '*', '/', '%', '&', '|', '^') and next_ch == '=':
                op += self._advance()
            elif op in ('<', '>') and next_ch == op:
                op += self._advance()
                if self._peek() == '=':
                    op += self._advance()
            elif op == '=' and next_ch == '=':
                op += self._advance()
            elif op == '!' and next_ch == '=':
                op += self._advance()
            elif op == '<' and next_ch == '=':
                op += self._advance()
            elif op == '>' and next_ch == '=':
                op += self._advance()
            elif op == '&' and next_ch == '&':
                op += self._advance()
            elif op == '|' and next_ch == '|':
                op += self._advance()
            elif op == '+' and next_ch == '+':
                op += self._advance()
            elif op == '-' and next_ch == '-':
                op += self._advance()
            elif op == '-' and next_ch == '>':
                op += self._advance()
            elif op == '.' and next_ch == '.':
                op += self._advance()
                if self._peek() == '.':
                    op += self._advance()
            
            if op in ('{', '}', '(', ')', '[', ']', ';', ':', ','):
                self.tokens.append(self._make_token(TokenType.PUNCTUATION, op))
            elif op == '\\' and (self._peek() in ('\n', '\r') or self.pos >= len(self.source)):
                # Line continuation
                self.tokens.append(self._make_token(TokenType.CONTINUATION, op))
            else:
                self.tokens.append(self._make_token(TokenType.OPERATOR, op))
        
        self.tokens.append(self._make_token(TokenType.EOF, ''))
        return self.tokens
    
    def _is_start_of_line(self) -> bool:
        """Check if the current position is at the start of a line."""
        if self.pos == 0:
            return True
        # Look backwards from current position, skipping whitespace
        idx = self.pos - 1
        while idx >= 0:
            c = self.source[idx]
            if c == '\n':
                return True
            if c not in (' ', '\t'):
                return False
            idx -= 1
        return True
