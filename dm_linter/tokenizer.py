import re
import os

DM_KEYWORDS = {
    'var', 'proc', 'verb', 'set', 'src', 'usr', 'args', 'world',
    'new', 'del', 'return', 'if', 'else', 'for', 'while', 'do',
    'switch', 'case', 'default', 'break', 'continue', 'goto',
    'try', 'catch', 'throw', 'spawn', 'sleep', 'loc', 'icon',
    'icon_state', 'name', 'desc', 'in', 'to', 'step', 'range',
    'view', 'oview', 'inrange', 'canreach', 'istype', 'ispath',
    'isnull', 'isfile', 'isnum', 'istext', 'isicon', 'islist',
    'ismob', 'isobj', 'isturf', 'isarea', 'pick', 'prob', 'rand',
    'round', 'floor', 'ceil', 'sqrt', 'abs', 'min', 'max', 'clamp',
    'length', 'copytext', 'findtext', 'lowertext', 'uppertext',
    'replacetext', 'splittext', 'jointext', 'json_encode', 'json_decode',
    'file2text', 'text2file', 'file', 'fcopy', 'fdel', 'flist',
    'mkdir', 'rmdir', 'shell', 'run', 'alert', 'input', 'fexists',
    'sortlist', 'reverse_list', 'shuffle_list', 'lentext', 'ascii2text',
    'text2ascii', 'copytext_char', 'findtext_char', 'lentext_char',
    'md5', 'sha1', 'sha256', 'ntohl', 'ntohs', 'htonl', 'htons',
    'load_resource', 'debug', 'winset', 'winget', 'winshow',
    'output', 'browse', 'browse_rsc', 'fopen', 'fclose', 'fwrite',
    'fread', 'feof', 'fseek', 'ftell', 'x', 'y', 'z',
    'ALL', 'NONE', 'EAST', 'WEST', 'NORTH', 'SOUTH',
    'NORTHEAST', 'NORTHWEST', 'SOUTHEAST', 'SOUTHWEST',
    'UP', 'DOWN', 'TOP', 'BOTTOM', 'LEFT', 'RIGHT',
}

TOKEN_SPEC = [
    ('COMMENT_BLOCK', r'/\*[\s\S]*?\*/'),
    ('COMMENT_LINE', r'//[^\n]*'),
    ('STRING', r'"(?:[^"\\]|\\.)*"'),
    ('MACRO_CONTINUE', r'\\\n'),
    ('NUMBER', r'\d+(?:\.\d+)?'),
    ('DOUBLECOLON', r'::'),
    ('COLON', r':'),
    ('EQUALS', r'=='),
    ('NOT_EQUALS', r'!='),
    ('LESS_EQUAL', r'<='),
    ('GREATER_EQUAL', r'>='),
    ('LSHIFT', r'<<'),
    ('RSHIFT', r'>>'),
    ('AND', r'&&'),
    ('OR', r'\|\|'),
    ('PLUS_PLUS', r'\+\+'),
    ('MINUS_MINUS', r'--'),
    ('PLUS', r'\+'),
    ('MINUS', r'-'),
    ('MULTIPLY', r'\*'),
    ('MODULO', r'%'),
    ('ASSIGN', r'='),
    ('BIT_AND', r'&'),
    ('BIT_OR', r'\|'),
    ('BIT_XOR', r'\^'),
    ('BIT_NOT', r'~'),
    ('NOT', r'!'),
    ('LESS', r'<'),
    ('GREATER', r'>'),
    ('SLASH', r'/'),
    ('DEREFERENCE', r'\.'),
    ('SEMICOLON', r';'),
    ('COMMA', r','),
    ('LPAREN', r'\('),
    ('RPAREN', r'\)'),
    ('LBRACE', r'\{'),
    ('RBRACE', r'\}'),
    ('LBRACKET', r'\['),
    ('RBRACKET', r'\]'),
    ('QUESTION', r'\?'),
    ('AT', r'@'),
    ('HASH', r'#'),
    ('DOLLAR', r'\$'),
    ('IDENTIFIER', r'[a-zA-Z_][a-zA-Z0-9_]*'),
    ('NEWLINE', r'\n'),
    ('WHITESPACE', r'[ \t]+'),
    ('OTHER', r'.'),
]

TOKEN_RE = re.compile('|'.join(f'(?P<{name}>{pattern})' for name, pattern in TOKEN_SPEC))


class Token:
    def __init__(self, type, value, line, column, filename=''):
        self.type = type
        self.value = value
        self.line = line
        self.column = column
        self.filename = filename

    def __repr__(self):
        return f'Token({self.type}, {self.value!r}, L{self.line}:{self.column})'


def tokenize(source_text, filename=''):
    tokens = []
    line = 1
    line_start = 0
    pos = 0

    for match in re.finditer(r'(?s).', source_text):
        pass

    for match in TOKEN_RE.finditer(source_text):
        kind = match.lastgroup
        value = match.group()
        start = match.start()
        col = start - line_start + 1

        if kind == 'NEWLINE':
            tokens.append(Token('NEWLINE', '\n', line, col, filename))
            line += 1
            line_start = match.end()
            continue
        elif kind == 'WHITESPACE':
            continue
        elif kind == 'COMMENT_BLOCK':
            comment_line = line
            comment_col = col
            for ch in value:
                if ch == '\n':
                    comment_line += 1
            tokens.append(Token('COMMENT_BLOCK', value, line, col, filename))
            line = comment_line
            line_start = source_text.rfind('\n', 0, match.end()) + 1 if '\n' in value[:match.end() - match.start()] else line_start + (match.end() - match.start())
            continue
        elif kind == 'COMMENT_LINE':
            tokens.append(Token('COMMENT_LINE', value, line, col, filename))
            continue
        elif kind == 'MACRO_CONTINUE':
            continue
        elif kind == 'IDENTIFIER' and value in DM_KEYWORDS:
            kind = 'KEYWORD'
        elif kind == 'OTHER':
            tokens.append(Token('ERROR', value, line, col, filename))
            continue

        tokens.append(Token(kind, value, line, col, filename))

    tokens.append(Token('EOF', '', line, 1, filename))
    return tokens
