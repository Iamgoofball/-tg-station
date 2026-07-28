"""
Tests for dm-linter - DreamMaker (.dm) source code linter.
"""

import os
import sys
import tempfile
import unittest

# Add parent to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from dm_linter.lexer import Lexer, TokenType
from dm_linter.parser import Parser, NodeType
from dm_linter.linter import lint_source
from dm_linter.rules import Severity


SAMPLE_DM = """
// Sample DM file for testing
#define TEST_MACRO 1

/atom/movable/proc/test_proc()
    var/test_var = 1
    if(test_var == 1)
        return test_var

/datum/test_datum
    var/name = "test"

/datum/test_datum/proc/hello()
    world << "Hello!"
"""


class TestLexer(unittest.TestCase):
    """Test the DM lexer."""

    def test_tokenize_basic(self):
        lexer = Lexer("var/x = 5", "test.dm")
        tokens = lexer.tokenize()
        types = [t.type for t in tokens]
        self.assertIn(TokenType.KEYWORD_VAR, types)

    def test_tokenize_string(self):
        lexer = Lexer('var/x = "hello"', "test.dm")
        tokens = lexer.tokenize()
        types = [(t.type, t.value) for t in tokens]
        self.assertTrue(any(t[0] == TokenType.STRING for t in types))

    def test_tokenize_path(self):
        lexer = Lexer("/atom/movable/proc/test()", "test.dm")
        tokens = lexer.tokenize()
        path_tokens = [t for t in tokens if t.type == TokenType.PATH_SEGMENT]
        self.assertTrue(len(path_tokens) >= 1)

    def test_tokenize_preprocessor(self):
        source = "#define FOO 1\n#define BAR(x) x"
        lexer = Lexer(source, "test.dm")
        tokens = lexer.tokenize()
        pp_tokens = [t for t in tokens if t.type == TokenType.PREPROCESSOR]
        self.assertEqual(len(pp_tokens), 2)

    def test_tokenize_comments(self):
        source = "// line comment\n/* block comment */"
        lexer = Lexer(source, "test.dm")
        tokens = lexer.tokenize()
        comment_tokens = [t for t in tokens if t.type in (TokenType.COMMENT, TokenType.COMMENT_BLOCK)]
        self.assertEqual(len(comment_tokens), 2)

    def test_keywords(self):
        lexer = Lexer("if else for while switch case break continue return new del", "test.dm")
        tokens = lexer.tokenize()
        keyword_types = {
            TokenType.KEYWORD_IF, TokenType.KEYWORD_ELSE, TokenType.KEYWORD_FOR,
            TokenType.KEYWORD_WHILE, TokenType.KEYWORD_SWITCH, TokenType.KEYWORD_CASE,
            TokenType.KEYWORD_BREAK, TokenType.KEYWORD_CONTINUE, TokenType.KEYWORD_RETURN,
            TokenType.KEYWORD_NEW, TokenType.KEYWORD_DEL,
        }
        found = {t.type for t in tokens}
        for kt in keyword_types:
            self.assertIn(kt, found, f"Keyword token {kt} not found")

    def test_operators(self):
        lexer = Lexer("== != <= >= && || ++ -- += -= . ->", "test.dm")
        tokens = lexer.tokenize()
        op_tokens = [t for t in tokens if t.type == TokenType.OPERATOR]
        op_values = [t.value for t in op_tokens]
        for op in ('==', '!=', '<=', '>=', '&&', '||', '++', '--', '+=', '-=', '.', '->'):
            self.assertIn(op, op_values, f"Operator '{op}' not tokenized")


class TestParser(unittest.TestCase):
    """Test the DM parser."""

    def setUp(self):
        lexer = Lexer(SAMPLE_DM, "test.dm")
        tokens = lexer.tokenize()
        self.parser = Parser(tokens)

    def test_parse_program(self):
        ast = self.parser.parse()
        self.assertEqual(ast.type, NodeType.PROGRAM)
        self.assertTrue(len(ast.children) > 0)

    def test_parse_preprocessor(self):
        ast = self.parser.parse()
        pp_nodes = []

        def find_pp(node):
            if node.type == NodeType.PREPROCESSOR_DIRECTIVE:
                pp_nodes.append(node)
            for c in node.children:
                find_pp(c)
        find_pp(ast)
        self.assertTrue(len(pp_nodes) > 0)

    def test_parse_path(self):
        ast = self.parser.parse()
        path_nodes = []

        def find_paths(node):
            if node.type == NodeType.PATH_SEGMENT:
                path_nodes.append(node)
            for c in node.children:
                find_paths(c)
        find_paths(ast)
        path_values = [n.value for n in path_nodes]
        self.assertTrue(any('/atom' in p for p in path_values))


class TestLinter(unittest.TestCase):
    """Test the linter end-to-end."""

    def test_lint_clean_file(self):
        clean_source = "// Simple clean file\nvar/x = 1\n"
        results, error = lint_source(clean_source, "clean.dm")
        self.assertIsNone(error)

    def test_lint_trailing_whitespace(self):
        source = "var/x = 1   \nvar/y = 2\n"
        results, error = lint_source(source, "test.dm")
        has_trailing = any(r.rule_id == "trailing-whitespace" for r in results)
        self.assertTrue(has_trailing)

    def test_lint_long_line(self):
        source = "var/x = '" + ('a' * 250) + "'\n"
        results, error = lint_source(source, "test.dm")
        has_long_line = any(r.rule_id == "line-length" for r in results)
        self.assertTrue(has_long_line)

    def test_lint_mixed_indent(self):
        source = "\t    var/x = 1\n"
        results, error = lint_source(source, "test.dm")
        has_mixed = any(r.rule_id == "mixed-indent" for r in results)
        self.assertTrue(has_mixed)


class TestIntegration(unittest.TestCase):
    """Integration tests with sample DM files."""

    def test_real_dm_snippet(self):
        source = """
/datum/example
    var/counter = 0

/datum/example/proc/increment()
    counter++
    if(counter > 10)
        return counter
    return null
"""
        results, error = lint_source(source, "example.dm")
        self.assertIsNone(error)

    def test_real_dm_definition(self):
        source = """
#define PRIORITY_HIGH 1
#define PRIORITY_LOW 2

/world/proc/startup()
    set waitfor = FALSE
    world << "Starting up..."
    . = initialize()
"""
        results, error = lint_source(source, "startup.dm")
        self.assertIsNone(error)


if __name__ == '__main__':
    unittest.main()
