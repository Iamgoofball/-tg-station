import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tokenizer import tokenize
from parser import Parser, DefineNode, ProcDefNode, VerbDefNode, VarDefNode, FileNode


def test_parse_define():
    src = '#define FOO 1\n'
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert len(tree.children) >= 0


def test_parse_proc():
    src = '''
/atom/proc/Test()
    return "ok"
'''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert tree is not None
    assert len(parser.errors) == 0, f"Parse errors: {parser.errors}"


def test_parse_empty():
    src = ''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert tree is not None


def test_parse_var_decl():
    src = 'var/x = 5\n'
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert tree is not None


def test_parse_if():
    src = '''
/proc/Test()
    if (x == 1)
        return x
'''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert len(parser.errors) == 0, f"Parse errors: {parser.errors}"


def test_braces():
    src = '''
/proc/Test()
    if (x)
    {
        x = 1
    }
    else
    {
        x = 2
    }
'''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert len(parser.errors) == 0, f"Parse errors: {parser.errors}"


def test_for_loop():
    src = '''
/proc/Test()
    for (var/i = 0, i < 10, i++)
        x += i
'''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert len(parser.errors) == 0, f"Parse errors: {parser.errors}"


def test_complex_dm():
    src = '''
#define FOO 1
#define BAR(x) (x * 2)

/atom/proc/Test()
    var/x = 5
    var/y = "hello"
    if (x > 3)
        return x
    return 0
'''
    tokens = tokenize(src)
    parser = Parser(tokens)
    tree = parser.parse()
    assert len(parser.errors) == 0, f"Parse errors: {parser.errors}"


if __name__ == '__main__':
    test_parse_define()
    test_parse_proc()
    test_parse_empty()
    test_parse_var_decl()
    test_parse_if()
    test_braces()
    test_for_loop()
    test_complex_dm()
    print('All parser tests passed!')
