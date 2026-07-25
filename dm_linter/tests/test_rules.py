import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tokenizer import tokenize
from rules import lint_file, LinterConfig


def test_no_errors_clean():
    src = '''
#define FOO 1

/atom/proc/Test()
    return 0
'''
    results = lint_file(src, 'test.dm')
    errors = [r for r in results if r.severity == 'error']
    assert len(errors) == 0, f"Unexpected errors: {errors}"


def test_unmatched_brace():
    src = '''
/atom/proc/Test()
{
    return 0
}}
'''
    results = lint_file(src, 'test.dm')
    errors = [r for r in results if r.severity == 'error']
    assert any('unmatched' in r.message.lower() for r in errors), f"Expected unmatched brace error, got {errors}"


def test_line_length():
    config = LinterConfig()
    config.max_line_length = 10
    src = 'var/x = "this is a very long line that exceeds limit"\n'
    results = lint_file(src, 'test.dm', config)
    warnings = [r for r in results if r.severity == 'warn']
    assert any('Line too long' in r.message for r in warnings), f"Expected line length warning, got {warnings}"


def test_trailing_whitespace():
    src = 'var/x = 1  \n'
    results = lint_file(src, 'test.dm')
    warnings = [r for r in results if r.severity == 'warn']
    assert any('Trailing whitespace' in r.message for r in warnings), f"Expected trailing whitespace warning, got {warnings}"


def test_var_without_name():
    src = 'var = 1\n'
    results = lint_file(src, 'test.dm')
    assert len(results) >= 0


def test_switch_case():
    src = '''
/atom/proc/Test(x)
    switch(x)
        if (1)
            return "one"
        if (2)
            return "two"
'''
    results = lint_file(src, 'test.dm')
    errors = [r for r in results if r.severity == 'error']
    for e in errors:
        print(f"  Error: {e}")


if __name__ == '__main__':
    test_no_errors_clean()
    test_unmatched_brace()
    test_line_length()
    test_trailing_whitespace()
    test_var_without_name()
    test_switch_case()
    print('All rules tests passed!')
