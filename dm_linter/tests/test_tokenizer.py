import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tokenizer import tokenize


def test_simple_define():
    tokens = tokenize('#define FOO 1\n')
    types = [t.type for t in tokens]
    assert 'HASH' in types, f"Expected HASH token, got {types}"
    assert 'IDENTIFIER' in types, f"Expected IDENTIFIER, got {types}"


def test_proc_definition():
    src = '''
/atom/proc/Hello()
    return "hello"
'''
    tokens = tokenize(src)
    types = [t.type for t in tokens]
    assert 'PATH_SEP' in types
    assert any(t.value == 'proc' for t in tokens)


def test_if_statement():
    src = '''
if (x == 1)
    return 1
'''
    tokens = tokenize(src)
    assert any(t.value == 'if' for t in tokens)


def test_string():
    src = 'var/x = "hello world"'
    tokens = tokenize(src)
    assert any('STRING' in t.type for t in tokens), f"No STRING token in {[t.type for t in tokens]}"


def test_comment_line():
    src = '// this is a comment\n'
    tokens = tokenize(src)
    assert any(t.type == 'COMMENT_LINE' for t in tokens), f"No COMMENT_LINE in {[t.type for t in tokens]}"


def test_comment_block():
    src = '/* multi\nline\ncomment */'
    tokens = tokenize(src)
    assert any(t.type == 'COMMENT_BLOCK' for t in tokens), f"No COMMENT_BLOCK in {[t.type for t in tokens]}"


def test_number():
    src = '42 3.14'
    tokens = tokenize(src)
    numbers = [t for t in tokens if t.type == 'NUMBER']
    assert len(numbers) >= 2, f"Expected 2 numbers, got {[t.value for t in numbers]}"


def test_operators():
    src = '== != <= >= && || ++ -- << >>'
    tokens = tokenize(src)
    token_types = [t.type for t in tokens]
    expected = ['EQUALS', 'NOT_EQUALS', 'LESS_EQUAL', 'GREATER_EQUAL',
                'AND', 'OR', 'PLUS_PLUS', 'MINUS_MINUS', 'LSHIFT', 'RSHIFT']
    for exp in expected:
        assert exp in token_types, f"Missing {exp} in {token_types}"


def test_path_segments():
    src = '/obj/item/weapon'
    tokens = tokenize(src)
    path_seps = [t for t in tokens if t.type == 'PATH_SEP']
    assert len(path_seps) >= 3, f"Expected 3+ PATH_SEP, got {len(path_seps)}"


def test_verb_definition():
    src = '''
/mob/verb/Say(msg as text)
    world << msg
'''
    tokens = tokenize(src)
    assert any(t.value == 'verb' for t in tokens), f"No 'verb' in tokens"


def test_error_char():
    src = '`'
    tokens = tokenize(src)
    assert any(t.type == 'ERROR' for t in tokens), "Expected ERROR token for backtick"


if __name__ == '__main__':
    test_simple_define()
    test_proc_definition()
    test_if_statement()
    test_string()
    test_comment_line()
    test_comment_block()
    test_number()
    test_operators()
    test_path_segments()
    test_verb_definition()
    test_error_char()
    print('All tokenizer tests passed!')
