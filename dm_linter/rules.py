import os
import re
from tokenizer import tokenize, Token

DM_GLOBAL_PROCS = {
    'alert', 'input', 'pick', 'prob', 'rand', 'round', 'floor', 'ceil',
    'sqrt', 'abs', 'min', 'max', 'clamp', 'length', 'copytext', 'findtext',
    'lowertext', 'uppertext', 'replacetext', 'splittext', 'jointext',
    'json_encode', 'json_decode', 'file2text', 'text2file', 'file',
    'sortlist', 'reverse_list', 'shuffle_list', 'lentext',
    'text2ascii', 'ascii2text', 'copytext_char', 'findtext_char',
    'md5', 'sha1', 'sha256', 'ntohl', 'ntohs', 'htonl', 'htons',
    'fexists', 'fcopy', 'fdel', 'flist', 'mkdir', 'rmdir',
    'shell', 'run', 'winset', 'winget', 'winshow', 'output',
    'browse', 'browse_rsc', 'fopen', 'fclose', 'fwrite', 'fread',
    'feof', 'fseek', 'ftell', 'spawn', 'sleep', 'del', 'locate',
    'walk', 'walk_to', 'walk_towards', 'step', 'step_to', 'step_towards',
    'get_step', 'get_dist', 'in_range', 'oview', 'oviewers',
    'range', 'view', 'viewers', 'hearers', 'isleaving',
    'istype', 'ispath', 'isnull', 'isfile', 'isnum', 'istext',
    'isicon', 'islist', 'ismob', 'isobj', 'isturf', 'isarea',
    'hascall', 'call', 'typesof', 'subtypesof',
    'locate', 'sortlist', 'reverse_range', 'shuffle_list',
    'icon', 'icon_states', 'get_icon', 'rgb', 'gradient',
    'matrix', 'sound', 'animate', 'flick', 'transform',
    'image', 'add_overlay', 'cut_overlay', 'copy_overlay',
    'add_filter', 'remove_filter', 'add_atom_colour',
    'remove_atom_colour', 'animate_movement',
    'do_after', 'do_mob', 'COOLDOWN_START', 'COOLDOWN_FINISH',
    'TIMER_COOLDOWN_CHECK', 'TIMER_COOLDOWN_START',
}


class LintResult:
    def __init__(self, severity, message, filename, line, column):
        self.severity = severity
        self.message = message
        self.filename = filename
        self.line = line
        self.column = column

    def __repr__(self):
        prefix = 'ERROR' if self.severity == 'error' else 'WARN'
        return f'{self.filename}:L{self.line}:{self.column}: {prefix}: {self.message}'


class LinterConfig:
    def __init__(self):
        self.check_brace_balance = True
        self.check_paren_balance = True
        self.check_indentation = True
        self.check_long_lines = True
        self.max_line_length = 200
        self.check_undefined_vars = False
        self.check_missing_semicolons = False
        self.check_tabs_vs_spaces = True
        self.check_trailing_whitespace = True
        self.check_empty_blocks = True


def lint_file(source_text, filename, config=None):
    if config is None:
        config = LinterConfig()

    results = []
    tokens = tokenize(source_text, filename)

    lines = source_text.split('\n')

    results += check_brace_balance(tokens, filename)
    results += check_paren_balance(tokens, filename)
    results += check_proc_def_syntax(tokens, filename)
    results += check_preprocessor(tokens, filename)

    if config.check_trailing_whitespace:
        results += check_trailing_whitespace_lines(lines, filename)
    if config.check_tabs_vs_spaces:
        results += check_tabs(lines, filename)
    if config.check_long_lines:
        results += check_line_length(lines, config.max_line_length, filename)
    if config.check_empty_blocks:
        results += check_empty_braces(tokens, filename)

    results += check_common_mistakes(tokens, filename)
    results += check_var_declarations(tokens, filename)
    results += check_string_format(tokens, filename)

    return results


def check_brace_balance(tokens, filename):
    results = []
    depth = 0
    for tok in tokens:
        if tok.type == 'LBRACE':
            depth += 1
        elif tok.type == 'RBRACE':
            depth -= 1
            if depth < 0:
                results.append(LintResult('error', 'Unmatched closing brace', filename, tok.line, tok.column))
                depth = 0
    if depth > 0:
        results.append(LintResult('error', f'Unmatched opening brace (depth {depth})', filename, 1, 1))
    return results


def check_paren_balance(tokens, filename):
    results = []
    depth = 0
    for tok in tokens:
        if tok.type == 'LPAREN':
            depth += 1
        elif tok.type == 'RPAREN':
            depth -= 1
            if depth < 0:
                results.append(LintResult('error', 'Unmatched closing parenthesis', filename, tok.line, tok.column))
                depth = 0
    if depth > 0:
        results.append(LintResult('error', f'Unmatched opening parenthesis (depth {depth})', filename, 1, 1))
    return results


def check_proc_def_syntax(tokens, filename):
    results = []
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        if tok.type == 'IDENTIFIER' and tok.value == 'proc' and i + 1 < len(tokens):
            next_tok = tokens[i + 1]
            if next_tok.type == 'IDENTIFIER' and i + 2 < len(tokens):
                name_tok = next_tok
                maybe_paren = tokens[i + 2]
                if maybe_paren.type != 'LPAREN':
                    results.append(LintResult(
                        'error', f"Proc '{name_tok.value}' defined without parentheses", filename, name_tok.line, name_tok.column
                    ))
        i += 1
    return results


def check_preprocessor(tokens, filename):
    results = []
    if_stack = []

    for i, tok in enumerate(tokens):
        if tok.type == 'HASH' and i + 1 < len(tokens):
            next_tok = tokens[i + 1]
            if next_tok.type == 'IDENTIFIER':
                if next_tok.value == 'if' or next_tok.value == 'ifdef' or next_tok.value == 'ifndef':
                    if_stack.append(next_tok.value)
                elif next_tok.value == 'else' or next_tok.value == 'elif':
                    if not if_stack:
                        results.append(LintResult('error', f"#else/#elif without matching #if/#ifdef/#ifndef", filename, tok.line, tok.column))
                elif next_tok.value == 'endif':
                    if not if_stack:
                        results.append(LintResult('error', f"#endif without matching #if/#ifdef/#ifndef", filename, tok.line, tok.column))
                    else:
                        if_stack.pop()

    return results


def check_trailing_whitespace_lines(lines, filename):
    results = []
    for i, line in enumerate(lines):
        if line.rstrip('\n') != line.rstrip('\n').rstrip(' \t') and line.strip():
            results.append(LintResult('warn', 'Trailing whitespace', filename, i + 1, len(line.rstrip('\n')) - len(line.rstrip('\n').rstrip(' \t')) + 1))
    return results


def check_tabs(lines, filename):
    results = []
    for i, line in enumerate(lines):
        for j, ch in enumerate(line):
            if ch == '\t':
                break
    return results


def check_line_length(lines, max_len, filename):
    results = []
    for i, line in enumerate(lines):
        stripped = line.rstrip('\n')
        if len(stripped) > max_len:
            results.append(LintResult('warn', f'Line too long ({len(stripped)} > {max_len})', filename, i + 1, max_len))
    return results


def check_empty_braces(tokens, filename):
    results = []
    for i, tok in enumerate(tokens):
        if tok.type == 'LBRACE' and i + 1 < len(tokens):
            next_tok = tokens[i + 1]
            if next_tok.type == 'RBRACE':
                results.append(LintResult('warn', 'Empty block {}', filename, tok.line, tok.column))
    return results


def check_common_mistakes(tokens, filename):
    results = []
    for tok in tokens:
        if tok.type == 'STRING' or tok.type == 'STRING_MACRO':
            val = tok.value
            if val.count('"') % 2 != 0:
                pass
            embedded_newline = val.count('\n') > 0
            if embedded_newline:
                pass
    return results


def check_var_declarations(tokens, filename):
    results = []
    for i, tok in enumerate(tokens):
        if tok.type == 'IDENTIFIER' and tok.value == 'var' and i + 1 < len(tokens):
            next_type = tokens[i + 1].type
            if next_type not in ('IDENTIFIER', 'KEYWORD', 'PATH_SEP'):
                results.append(LintResult(
                    'warn', f"'var' without variable name at line {tok.line}", filename, tok.line, tok.column
                ))
    return results


def check_string_format(tokens, filename):
    results = []
    for tok in tokens:
        if tok.type == 'STRING' or tok.type == 'STRING_MACRO':
            val = tok.value
            if val == '""':
                continue
    return results


def lint_file_standalone(filename, config=None):
    try:
        with open(filename, 'r', encoding='utf-8', errors='replace') as f:
            source = f.read()
    except Exception as e:
        return [LintResult('error', f'Cannot read file: {e}', filename, 0, 0)]
    return lint_file(source, filename, config)


def find_dm_files(root_dir):
    dm_files = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for fname in filenames:
            if fname.endswith('.dm'):
                full_path = os.path.join(dirpath, fname)
                dm_files.append(full_path)
    return sorted(dm_files)
