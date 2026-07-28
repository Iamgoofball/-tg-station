"""
dm-linter: Parser for DreamMaker (.dm) source code.

Parses token streams into an AST with understanding of DM structure:
  - Path definitions (/atom/movable, /datum/proc/...)
  - Variable declarations (var/name = value)
  - Procedure definitions (/proc/name)
  - Control flow (if/else/for/while/switch)
  - Preprocessor directives (#define, #include, etc.)
"""

from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Optional, Union

from .lexer import Token, TokenType, Lexer


class NodeType(Enum):
    PROGRAM = auto()
    PREPROCESSOR_DIRECTIVE = auto()
    PATH_DEFINITION = auto()
    PROC_DEFINITION = auto()
    VERB_DEFINITION = auto()
    VAR_DECLARATION = auto()
    GLOBAL_VAR = auto()
    ASSIGNMENT = auto()
    IF_STATEMENT = auto()
    FOR_STATEMENT = auto()
    WHILE_STATEMENT = auto()
    DO_STATEMENT = auto()
    SWITCH_STATEMENT = auto()
    CASE_CLAUSE = auto()
    BLOCK = auto()
    EXPRESSION = auto()
    FUNCTION_CALL = auto()
    BINARY_OP = auto()
    UNARY_OP = auto()
    LITERAL = auto()
    IDENTIFIER = auto()
    RETURN_STATEMENT = auto()
    BREAK_STATEMENT = auto()
    CONTINUE_STATEMENT = auto()
    GOTO_STATEMENT = auto()
    SET_STATEMENT = auto()
    SPAWN_STATEMENT = auto()
    TRY_CATCH = auto()
    NEW_EXPRESSION = auto()
    LIST_LITERAL = auto()
    PATH_SEGMENT = auto()
    STRING_INTERPOLATION = auto()
    MEMBER_ACCESS = auto()
    INDEX_EXPRESSION = auto()
    ARGUMENT_LIST = auto()
    PARAMETER_LIST = auto()
    LABEL = auto()
    CONTINUATION = auto()


@dataclass
class ASTNode:
    type: NodeType
    value: str = ""
    children: List['ASTNode'] = field(default_factory=list)
    line: int = 0
    column: int = 0
    extra: dict = field(default_factory=dict)


class ParseError(Exception):
    def __init__(self, message: str, token: Optional[Token] = None):
        if token:
            super().__init__(f"[{token.line}:{token.column}] {message}")
        else:
            super().__init__(message)


class Parser:
    """Parse DM tokens into an AST."""
    
    def __init__(self, tokens: List[Token]):
        self.tokens = tokens
        self.pos = 0
        self.current_token: Optional[Token] = None
        self._advance()
    
    def _advance(self) -> Token:
        self.current_token = self.tokens[self.pos]
        self.pos += 1
        return self.current_token
    
    def _peek(self, offset: int = 0) -> Optional[Token]:
        idx = self.pos + offset
        return self.tokens[idx] if idx < len(self.tokens) else None
    
    def _expect(self, *types: TokenType) -> Token:
        tok = self.current_token
        if tok.type not in types:
            expected = " or ".join(t.__name__ if hasattr(t, '__name__') else str(t) for t in types)
            raise ParseError(f"Expected {expected}, got {tok.type} ('{tok.value}')", tok)
        self._advance()
        return tok
    
    def _skip_newlines(self) -> None:
        while self.current_token.type == TokenType.NEWLINE:
            self._advance()
    
    def _make_node(self, type_: NodeType, token: Optional[Token] = None, value: str = "") -> ASTNode:
        if token:
            return ASTNode(type=type_, value=value or token.value, line=token.line, column=token.column)
        return ASTNode(type=type_, value=value, line=0, column=0)
    
    def parse(self) -> ASTNode:
        """Parse the entire token stream into a program AST."""
        program = self._make_node(NodeType.PROGRAM)
        
        while self.current_token.type != TokenType.EOF:
            self._skip_newlines()
            if self.current_token.type == TokenType.EOF:
                break
            stmt = self._parse_statement()
            if stmt:
                program.children.append(stmt)
        
        return program
    
    def _parse_statement(self) -> Optional[ASTNode]:
        """Parse a single statement."""
        tok = self.current_token
        
        # Preprocessor directives
        if tok.type == TokenType.PREPROCESSOR:
            return self._parse_preprocessor()
        
        # Block start
        if tok.type == TokenType.PUNCTUATION and tok.value == '{':
            return self._parse_block()
        
        # Path definitions (/atom, /datum/proc/...)
        if tok.type == TokenType.PATH_SEGMENT:
            return self._parse_path_definition()
        
        # Var declarations
        if tok.type == TokenType.KEYWORD_VAR:
            return self._parse_var_declaration()
        
        # Static/global/const var declarations
        if tok.type in (TokenType.KEYWORD_STATIC, TokenType.KEYWORD_GLOBAL, TokenType.KEYWORD_CONST):
            return self._parse_qualified_var()
        
        # Control flow
        if tok.type == TokenType.KEYWORD_IF:
            return self._parse_if_statement()
        if tok.type == TokenType.KEYWORD_FOR:
            return self._parse_for_statement()
        if tok.type == TokenType.KEYWORD_WHILE:
            return self._parse_while_statement()
        if tok.type == TokenType.KEYWORD_DO:
            return self._parse_do_statement()
        if tok.type == TokenType.KEYWORD_SWITCH:
            return self._parse_switch_statement()
        if tok.type == TokenType.KEYWORD_RETURN:
            return self._parse_return()
        if tok.type == TokenType.KEYWORD_BREAK:
            node = self._make_node(NodeType.BREAK_STATEMENT, tok)
            self._advance()
            return node
        if tok.type == TokenType.KEYWORD_CONTINUE:
            node = self._make_node(NodeType.CONTINUE_STATEMENT, tok)
            self._advance()
            return node
        if tok.type == TokenType.KEYWORD_GOTO:
            return self._parse_goto()
        if tok.type == TokenType.KEYWORD_SET:
            return self._parse_set_statement()
        if tok.type == TokenType.KEYWORD_SPAWN:
            return self._parse_spawn()
        if tok.type == TokenType.KEYWORD_TRY:
            return self._parse_try_catch()
        if tok.type == TokenType.KEYWORD_NEW:
            return self._parse_new_expression()
        
        # Label (identifier followed by :)
        if tok.type == TokenType.IDENTIFIER:
            next_tok = self._peek()
            if next_tok and next_tok.type == TokenType.PUNCTUATION and next_tok.value == ':':
                self._advance()  # consume identifier
                self._advance()  # consume :
                return self._make_node(NodeType.LABEL, tok)
        
        # Expression statement
        expr = self._parse_expression()
        if expr:
            return expr
        
        # Skip unexpected tokens to recover
        self._advance()
        return None
    
    def _parse_preprocessor(self) -> ASTNode:
        """Parse #directive [args]"""
        tok = self.current_token
        node = self._make_node(NodeType.PREPROCESSOR_DIRECTIVE, tok)
        self._advance()  # consume PREPROCESSOR
        
        if self.current_token.type == TokenType.PREPROCESSOR_ARG:
            node.value += ' ' + self.current_token.value
            self._advance()
        
        return node
    
    def _parse_block(self) -> ASTNode:
        """Parse { statement* }"""
        node = self._make_node(NodeType.BLOCK)
        self._expect(TokenType.PUNCTUATION)  # {
        
        depth = 1
        while depth > 0 and self.current_token.type != TokenType.EOF:
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '{':
                depth += 1
                node.children.append(self._make_node(NodeType.BLOCK))
                self._advance()
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '}':
                depth -= 1
                self._advance()
            else:
                stmt = self._parse_statement()
                if stmt:
                    node.children.append(stmt)
        
        return node
    
    def _parse_path_definition(self) -> ASTNode:
        """Parse /type/proc/name() or /type/var/name or /type definitions."""
        tok = self.current_token
        node = self._make_node(NodeType.PATH_SEGMENT, tok)
        self._advance()  # consume PATH_SEGMENT
        
        # Check for /proc/name() - procedure definition
        if '/proc/' in node.value:
            # This is a proc definition
            proc_node = self._make_node(NodeType.PROC_DEFINITION, tok)
            proc_node.children.append(node)
            
            # Parse parameter list if present
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '(':
                proc_node.children.append(self._parse_argument_list(is_definition=True))
            
            # Parse set statements (if any before the body)
            self._skip_newlines()
            self._skip_whitespace_tokens()
            
            # Parse body
            self._skip_newlines()
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '{':
                proc_node.children.append(self._parse_block())
            
            return proc_node
        
        # Check for /verb/name - verb definition
        if '/verb/' in node.value:
            verb_node = self._make_node(NodeType.VERB_DEFINITION, tok)
            verb_node.children.append(node)
            self._skip_newlines()
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '{':
                verb_node.children.append(self._parse_block())
            return verb_node
        
        # Regular path definition with body
        self._skip_newlines()
        if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '{':
            node.children.append(self._parse_block())
        
        return node
    
    def _parse_var_declaration(self) -> ASTNode:
        """Parse var/name = expr"""
        tok = self.current_token
        node = self._make_node(NodeType.VAR_DECLARATION, tok)
        self._advance()  # consume 'var'
        
        # var/... or var/name
        if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '/':
            self._advance()  # consume /
            # Read variable name
            name_tok = self._expect(TokenType.IDENTIFIER)
            var_name_node = self._make_node(NodeType.IDENTIFIER, name_tok)
            node.children.append(var_name_node)
            
            # Optional type annotation: var/name as type
            if self.current_token.type == TokenType.KEYWORD_AS:
                self._advance()
                type_node = self._make_node(NodeType.IDENTIFIER, self._expect(TokenType.IDENTIFIER))
                node.children.append(type_node)
            
            # Optional initializer: = expr
            if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '=':
                self._advance()
                val = self._parse_expression()
                if val:
                    node.children.append(val)
        
        return node
    
    def _parse_qualified_var(self) -> ASTNode:
        """Parse static/global/const var/name = expr"""
        qualifier = self.current_token
        node_type = NodeType.GLOBAL_VAR if qualifier.type == TokenType.KEYWORD_GLOBAL else NodeType.VAR_DECLARATION
        node = self._make_node(node_type, qualifier)
        self._advance()
        
        if self.current_token.type == TokenType.KEYWORD_VAR:
            var_part = self._parse_var_declaration()
            node.children = var_part.children
        else:
            name_tok = self._expect(TokenType.IDENTIFIER)
            node.children.append(self._make_node(NodeType.IDENTIFIER, name_tok))
            if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '=':
                self._advance()
                val = self._parse_expression()
                if val:
                    node.children.append(val)
        
        return node
    
    def _parse_if_statement(self) -> ASTNode:
        """Parse if (condition) body [else body]"""
        node = self._make_node(NodeType.IF_STATEMENT)
        self._advance()  # consume 'if'
        self._skip_newlines()
        
        # Condition in parentheses
        self._expect(TokenType.PUNCTUATION)  # (
        cond = self._parse_expression()
        node.children.append(cond)
        self._expect(TokenType.PUNCTUATION)  # )
        
        # Body
        self._skip_newlines()
        body = self._parse_block_or_single_stmt()
        node.children.append(body)
        
        # Optional else
        self._skip_newlines()
        if self.current_token.type == TokenType.KEYWORD_ELSE:
            self._advance()
            self._skip_newlines()
            else_body = self._parse_block_or_single_stmt()
            node.children.append(else_body)
        
        return node
    
    def _parse_for_statement(self) -> ASTNode:
        """Parse for (init; condition; increment) body"""
        node = self._make_node(NodeType.FOR_STATEMENT)
        self._advance()  # consume 'for'
        self._skip_newlines()
        self._expect(TokenType.PUNCTUATION)  # (
        # for (var/item in list)
        init = self._parse_expression()
        node.children.append(init)
        self._expect(TokenType.PUNCTUATION)  # )
        self._skip_newlines()
        body = self._parse_block_or_single_stmt()
        node.children.append(body)
        return node
    
    def _parse_while_statement(self) -> ASTNode:
        """Parse while (condition) body"""
        node = self._make_node(NodeType.WHILE_STATEMENT)
        self._advance()
        self._skip_newlines()
        self._expect(TokenType.PUNCTUATION)
        cond = self._parse_expression()
        node.children.append(cond)
        self._expect(TokenType.PUNCTUATION)
        self._skip_newlines()
        node.children.append(self._parse_block_or_single_stmt())
        return node
    
    def _parse_do_statement(self) -> ASTNode:
        """Parse do body while (condition)"""
        node = self._make_node(NodeType.DO_STATEMENT)
        self._advance()
        self._skip_newlines()
        node.children.append(self._parse_block_or_single_stmt())
        self._skip_newlines()
        self._expect(TokenType.KEYWORD_WHILE)
        self._expect(TokenType.PUNCTUATION)
        node.children.append(self._parse_expression())
        self._expect(TokenType.PUNCTUATION)
        return node
    
    def _parse_switch_statement(self) -> ASTNode:
        """Parse switch (expr) { case ... }"""
        node = self._make_node(NodeType.SWITCH_STATEMENT)
        self._advance()
        self._skip_newlines()
        self._expect(TokenType.PUNCTUATION)
        node.children.append(self._parse_expression())
        self._expect(TokenType.PUNCTUATION)
        self._skip_newlines()
        
        self._expect(TokenType.PUNCTUATION)  # {
        while self.current_token.type != TokenType.EOF:
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '}':
                self._advance()
                break
            if self.current_token.type == TokenType.KEYWORD_CASE:
                case_node = self._make_node(NodeType.CASE_CLAUSE)
                self._advance()
                val = self._parse_expression()
                case_node.children.append(val)
                if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ':':
                    self._advance()
                # Parse case body
                while self.current_token.type not in (TokenType.EOF, TokenType.KEYWORD_CASE, TokenType.KEYWORD_DEFAULT):
                    if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '}':
                        break
                    stmt = self._parse_statement()
                    if stmt:
                        case_node.children.append(stmt)
                node.children.append(case_node)
            elif self.current_token.type == TokenType.KEYWORD_DEFAULT:
                default_node = self._make_node(NodeType.CASE_CLAUSE, value="default")
                self._advance()
                if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ':':
                    self._advance()
                while self.current_token.type not in (TokenType.EOF, TokenType.KEYWORD_CASE, TokenType.KEYWORD_DEFAULT):
                    if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '}':
                        break
                    stmt = self._parse_statement()
                    if stmt:
                        default_node.children.append(stmt)
                node.children.append(default_node)
            else:
                self._advance()
        
        return node
    
    def _parse_return(self) -> ASTNode:
        """Parse return [expr]"""
        node = self._make_node(NodeType.RETURN_STATEMENT)
        self._advance()  # consume 'return'
        if self.current_token.type not in (TokenType.NEWLINE, TokenType.PUNCTUATION, TokenType.EOF):
            if not (self.current_token.type == TokenType.PUNCTUATION and self.current_token.value in ('}', ')')):
                val = self._parse_expression()
                if val:
                    node.children.append(val)
        return node
    
    def _parse_goto(self) -> ASTNode:
        """Parse goto label"""
        node = self._make_node(NodeType.GOTO_STATEMENT)
        self._advance()
        label_tok = self._expect(TokenType.IDENTIFIER)
        node.children.append(self._make_node(NodeType.IDENTIFIER, label_tok))
        return node
    
    def _parse_set_statement(self) -> ASTNode:
        """Parse set category = value"""
        node = self._make_node(NodeType.SET_STATEMENT)
        self._advance()
        
        while self.current_token.type != TokenType.NEWLINE and self.current_token.type != TokenType.EOF:
            name_tok = self.current_token
            self._advance()
            name_node = self._make_node(NodeType.IDENTIFIER, name_tok)
            
            if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '=':
                self._advance()
                val = self._parse_expression()
                node.children.append(name_node)
                if val:
                    node.children.append(val)
            else:
                node.children.append(name_node)
        
        return node
    
    def _parse_spawn(self) -> ASTNode:
        """Parse spawn(delay) body"""
        node = self._make_node(NodeType.SPAWN_STATEMENT)
        self._advance()
        self._skip_newlines()
        if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '(':
            self._advance()
            delay = self._parse_expression()
            node.children.append(delay)
            self._expect(TokenType.PUNCTUATION)  # )
        self._skip_newlines()
        node.children.append(self._parse_block_or_single_stmt())
        return node
    
    def _parse_try_catch(self) -> ASTNode:
        """Parse try body catch(ex) body"""
        node = self._make_node(NodeType.TRY_CATCH)
        self._advance()
        self._skip_newlines()
        node.children.append(self._parse_block_or_single_stmt())
        self._skip_newlines()
        if self.current_token.type == TokenType.KEYWORD_CATCH:
            self._advance()
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '(':
                catch_node = self._make_node(NodeType.BLOCK)
                self._advance()
                ex_tok = self.current_token
                if ex_tok.type == TokenType.IDENTIFIER:
                    catch_node.children.append(self._make_node(NodeType.IDENTIFIER, ex_tok))
                    self._advance()
                self._expect(TokenType.PUNCTUATION)  # )
                self._skip_newlines()
                catch_node.children.append(self._parse_block_or_single_stmt())
                node.children.append(catch_node)
        return node
    
    def _parse_new_expression(self) -> ASTNode:
        """Parse new Type(args)"""
        node = self._make_node(NodeType.NEW_EXPRESSION)
        self._advance()
        if self.current_token.type == TokenType.PATH_SEGMENT:
            path_node = self._make_node(NodeType.PATH_SEGMENT, self.current_token)
            self._advance()
            node.children.append(path_node)
        if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '(':
            node.children.append(self._parse_argument_list())
        return node
    
    def _parse_block_or_single_stmt(self) -> ASTNode:
        """Parse either a block { ... } or a single statement."""
        if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '{':
            return self._parse_block()
        return self._parse_expression() or self._make_node(NodeType.BLOCK)
    
    def _parse_expression(self) -> Optional[ASTNode]:
        """Parse an expression."""
        return self._parse_assignment()
    
    def _parse_assignment(self) -> Optional[ASTNode]:
        """Parse assignment or ternary."""
        left = self._parse_logical_or()
        if left is None:
            return None
        
        # Assignment operators
        if self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '<<=', '>>='):
            op = self.current_token.value
            self._advance()
            right = self._parse_assignment()
            assign_node = self._make_node(NodeType.ASSIGNMENT, value=op)
            assign_node.children = [left, right] if right else [left]
            return assign_node
        
        # Ternary
        if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '?':
            self._advance()
            true_branch = self._parse_expression()
            self._expect(TokenType.OPERATOR)  # :
            false_branch = self._parse_expression()
            ternary_node = self._make_node(NodeType.EXPRESSION, value='?:')
            ternary_node.children = [left, true_branch, false_branch]
            return ternary_node
        
        return left
    
    def _parse_logical_or(self) -> Optional[ASTNode]:
        """Parse ||"""
        left = self._parse_logical_and()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value == '||':
            op = self.current_token.value
            self._advance()
            right = self._parse_logical_and()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right] if right else [left]
            left = node
        return left
    
    def _parse_logical_and(self) -> Optional[ASTNode]:
        """Parse &&"""
        left = self._parse_bit_or()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value == '&&':
            op = self.current_token.value
            self._advance()
            right = self._parse_bit_or()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right] if right else [left]
            left = node
        return left
    
    def _parse_bit_or(self) -> Optional[ASTNode]:
        """Parse |"""
        left = self._parse_bit_xor()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value == '|':
            self._advance()
            right = self._parse_bit_xor()
            node = self._make_node(NodeType.BINARY_OP, value='|')
            node.children = [left, right]
            left = node
        return left
    
    def _parse_bit_xor(self) -> Optional[ASTNode]:
        """Parse ^"""
        left = self._parse_bit_and()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value == '^':
            self._advance()
            right = self._parse_bit_and()
            node = self._make_node(NodeType.BINARY_OP, value='^')
            node.children = [left, right]
            left = node
        return left
    
    def _parse_bit_and(self) -> Optional[ASTNode]:
        """Parse &"""
        left = self._parse_equality()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value == '&':
            self._advance()
            right = self._parse_equality()
            node = self._make_node(NodeType.BINARY_OP, value='&')
            node.children = [left, right]
            left = node
        return left
    
    def _parse_equality(self) -> Optional[ASTNode]:
        """Parse == != """
        left = self._parse_relational()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('==', '!='):
            op = self.current_token.value
            self._advance()
            right = self._parse_relational()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right]
            left = node
        return left
    
    def _parse_relational(self) -> Optional[ASTNode]:
        """Parse < > <= >= in"""
        left = self._parse_additive()
        while (self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('<', '>', '<=', '>=')) or \
              self.current_token.type == TokenType.KEYWORD_IN:
            if self.current_token.type == TokenType.KEYWORD_IN:
                op = 'in'
                self._advance()
            else:
                op = self.current_token.value
                self._advance()
            right = self._parse_additive()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right]
            left = node
        return left
    
    def _parse_additive(self) -> Optional[ASTNode]:
        """Parse + -"""
        left = self._parse_multiplicative()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('+', '-'):
            op = self.current_token.value
            self._advance()
            right = self._parse_multiplicative()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right]
            left = node
        return left
    
    def _parse_multiplicative(self) -> Optional[ASTNode]:
        """Parse * / %"""
        left = self._parse_unary()
        while self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('*', '/', '%'):
            op = self.current_token.value
            self._advance()
            right = self._parse_unary()
            node = self._make_node(NodeType.BINARY_OP, value=op)
            node.children = [left, right]
            left = node
        return left
    
    def _parse_unary(self) -> Optional[ASTNode]:
        """Parse ! - ++ --"""
        if self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('!', '-', '~', '++', '--', '+'):
            op = self.current_token.value
            self._advance()
            operand = self._parse_unary()
            node = self._make_node(NodeType.UNARY_OP, value=op)
            node.children = [operand] if operand else []
            return node
        return self._parse_postfix()
    
    def _parse_postfix(self) -> Optional[ASTNode]:
        """Parse primary followed by . [] () ++ --"""
        left = self._parse_primary()
        if left is None:
            return None
        
        while True:
            # Member access: .name or ://verb
            if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '.':
                self._advance()
                member = self._parse_primary()
                access = self._make_node(NodeType.MEMBER_ACCESS)
                access.children = [left, member] if member else [left]
                left = access
            # : operator for verb access
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ':':
                self._advance()
                member = self._parse_primary()
                access = self._make_node(NodeType.MEMBER_ACCESS, value=':')
                access.children = [left, member] if member else [left]
                left = access
            # Function call
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '(':
                args = self._parse_argument_list()
                call = self._make_node(NodeType.FUNCTION_CALL)
                call.children = [left, args]
                left = call
            # Index
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == '[':
                self._advance()
                index_expr = self._parse_expression()
                self._expect(TokenType.PUNCTUATION)  # ]
                index_node = self._make_node(NodeType.INDEX_EXPRESSION)
                index_node.children = [left, index_expr] if index_expr else [left]
                left = index_node
            # Postfix ++/--
            elif self.current_token.type == TokenType.OPERATOR and self.current_token.value in ('++', '--'):
                op = self.current_token.value
                self._advance()
                post = self._make_node(NodeType.UNARY_OP, value=op)
                post.children = [left]
                left = post
            else:
                break
        
        return left
    
    def _parse_primary(self) -> Optional[ASTNode]:
        """Parse primary expressions: literals, identifiers, parens, etc."""
        tok = self.current_token
        
        # Skip newlines in expression context
        self._skip_newlines()
        tok = self.current_token
        
        # String literal
        if tok.type in (TokenType.STRING, TokenType.STRING_INTERPOLATED):
            self._advance()
            return self._make_node(NodeType.LITERAL, tok)
        
        # Number literal
        if tok.type == TokenType.NUMBER:
            self._advance()
            return self._make_node(NodeType.LITERAL, tok)
        
        # Identifier
        if tok.type == TokenType.IDENTIFIER:
            self._advance()
            return self._make_node(NodeType.IDENTIFIER, tok)
        
        # Path segment
        if tok.type == TokenType.PATH_SEGMENT:
            self._advance()
            return self._make_node(NodeType.PATH_SEGMENT, tok)
        
        # Parenthesized expression
        if tok.type == TokenType.PUNCTUATION and tok.value == '(':
            self._advance()
            expr = self._parse_expression()
            self._expect(TokenType.PUNCTUATION)  # )
            if expr:
                return expr
            return self._make_node(NodeType.EXPRESSION)
        
        # List literal
        if tok.type == TokenType.PUNCTUATION and tok.value == '[':
            return self._parse_list_literal()
        
        # Keywords that can be used as values
        if tok.type in (TokenType.KEYWORD_LIST, TokenType.KEYWORD_NEW):
            if tok.type == TokenType.KEYWORD_LIST:
                self._advance()
                return self._make_node(NodeType.LITERAL, value="list")
            return self._parse_new_expression()
        
        # Null/Src/usr - special identifiers
        if tok.value.lower() in ('null', 'src', 'usr', 'true', 'false'):
            self._advance()
            return self._make_node(NodeType.IDENTIFIER, tok)
        
        return None
    
    def _parse_argument_list(self, is_definition: bool = False) -> ASTNode:
        """Parse (arg1, arg2, ...)"""
        node = self._make_node(NodeType.ARGUMENT_LIST)
        self._expect(TokenType.PUNCTUATION)  # (
        
        while self.current_token.type != TokenType.EOF:
            self._skip_newlines()
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ')':
                self._advance()
                break
            
            if is_definition:
                # Parameter with optional default
                param_name = self._expect(TokenType.IDENTIFIER)
                param_node = self._make_node(NodeType.IDENTIFIER, param_name)
                if self.current_token.type == TokenType.OPERATOR and self.current_token.value == '=':
                    self._advance()
                    default_val = self._parse_expression()
                    param_node.children.append(default_val)
                node.children.append(param_node)
            else:
                expr = self._parse_expression()
                if expr:
                    node.children.append(expr)
            
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ',':
                self._advance()
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ')':
                continue
            else:
                break
        
        if not (self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ')'):
            # Try to find closing paren
            while self.current_token.type != TokenType.EOF:
                if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ')':
                    self._advance()
                    break
                self._advance()
        
        return node
    
    def _parse_list_literal(self) -> ASTNode:
        """Parse list(arg1, arg2, ...) or [arg1, arg2, ...]"""
        node = self._make_node(NodeType.LIST_LITERAL)
        self._advance()  # consume [
        
        while self.current_token.type != TokenType.EOF:
            self._skip_newlines()
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ']':
                self._advance()
                break
            
            expr = self._parse_expression()
            if expr:
                node.children.append(expr)
            
            if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ',':
                self._advance()
            elif self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ']':
                continue
            else:
                break
        
        if self.current_token.type == TokenType.PUNCTUATION and self.current_token.value == ']':
            self._advance()
        
        return node
    
    def _skip_whitespace_tokens(self) -> None:
        """Skip whitespace-only token positions."""
        pass  # Whitespace is already skipped by lexer
