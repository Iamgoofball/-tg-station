class ASTNode:
    pass

class FileNode(ASTNode):
    def __init__(self):
        self.children = []
        self.filename = ''

class DefineNode(ASTNode):
    def __init__(self, name, params, value, line, col):
        self.name = name
        self.params = params
        self.value = value
        self.line = line
        self.col = col

class IncludeNode(ASTNode):
    def __init__(self, path, line, col):
        self.path = path
        self.line = line
        self.col = col

class ProcDefNode(ASTNode):
    def __init__(self, path, name, params, line, col):
        self.path = path
        self.name = name
        self.params = params
        self.body = []
        self.line = line
        self.col = col

class VerbDefNode(ASTNode):
    def __init__(self, path, name, params, line, col):
        self.path = path
        self.name = name
        self.params = params
        self.body = []
        self.settings = {}
        self.line = line
        self.col = col

class VarDefNode(ASTNode):
    def __init__(self, name, var_type, value, line, col):
        self.name = name
        self.var_type = var_type
        self.value = value
        self.line = line
        self.col = col

class IfNode(ASTNode):
    def __init__(self, condition, line, col):
        self.condition = condition
        self.body = []
        self.else_body = []
        self.line = line
        self.col = col

class ForNode(ASTNode):
    def __init__(self, init, condition, increment, line, col):
        self.init = init
        self.condition = condition
        self.increment = increment
        self.body = []
        self.line = line
        self.col = col

class WhileNode(ASTNode):
    def __init__(self, condition, line, col):
        self.condition = condition
        self.body = []
        self.line = line
        self.col = col

class SwitchNode(ASTNode):
    def __init__(self, value, line, col):
        self.value = value
        self.cases = []
        self.line = line
        self.col = col

class ReturnNode(ASTNode):
    def __init__(self, value, line, col):
        self.value = value
        self.line = line
        self.col = col

class SetNode(ASTNode):
    def __init__(self, directive, value, line, col):
        self.directive = directive
        self.value = value
        self.line = line
        self.col = col

class CallNode(ASTNode):
    def __init__(self, target, args, line, col):
        self.target = target
        self.args = args
        self.line = line
        self.col = col

class IdentifierNode(ASTNode):
    def __init__(self, name, line, col):
        self.name = name
        self.line = line
        self.col = col

class StringNode(ASTNode):
    def __init__(self, value, line, col):
        self.value = value
        self.line = line
        self.col = col

class NumberNode(ASTNode):
    def __init__(self, value, line, col):
        self.value = value
        self.line = line
        self.col = col

class BinaryOpNode(ASTNode):
    def __init__(self, op, left, right, line, col):
        self.op = op
        self.left = left
        self.right = right
        self.line = line
        self.col = col

class UnaryOpNode(ASTNode):
    def __init__(self, op, operand, line, col):
        self.op = op
        self.operand = operand
        self.line = line
        self.col = col

class PathNode(ASTNode):
    def __init__(self, segments, line, col):
        self.segments = segments
        self.line = line
        self.col = col

class VarRefNode(ASTNode):
    def __init__(self, name, line, col):
        self.name = name
        self.line = line
        self.col = col

class AssignNode(ASTNode):
    def __init__(self, target, value, op, line, col):
        self.target = target
        self.value = value
        self.op = op
        self.line = line
        self.col = col

class NewNode(ASTNode):
    def __init__(self, path, args, line, col):
        self.path = path
        self.args = args
        self.line = line
        self.col = col

class DelNode(ASTNode):
    def __init__(self, target, line, col):
        self.target = target
        self.line = line
        self.col = col

class ListLiteralNode(ASTNode):
    def __init__(self, elements, line, col):
        self.elements = elements
        self.line = line
        self.col = col

class IndexNode(ASTNode):
    def __init__(self, target, index, line, col):
        self.target = target
        self.index = index
        self.line = line
        self.col = col

class PropertyNode(ASTNode):
    def __init__(self, target, prop, line, col):
        self.target = target
        self.prop = prop
        self.line = line
        self.col = col


class PreprocessorState:
    def __init__(self):
        self.defines = {}
        self.in_if_block = True
        self.if_stack = []
        self.skipping = False
        self.skip_depth = 0


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0
        self.errors = []
        self.filename = tokens[0].filename if tokens else ''
        self.preprocessor = PreprocessorState()

    def peek(self, offset=0):
        idx = self.pos + offset
        if idx < len(self.tokens):
            return self.tokens[idx]
        return None

    def advance(self):
        token = self.tokens[self.pos]
        self.pos += 1
        return token

    def expect(self, *types):
        token = self.peek()
        if token and token.type in types:
            return self.advance()
        if token:
            self.errors.append(f"Expected {types} at L{token.line}:{token.column}, got {token.type} ({token.value!r})")
        else:
            self.errors.append(f"Expected {types} but reached end of file")
        return None

    def skip_newlines(self):
        while self.peek() and self.peek().type == 'NEWLINE':
            self.advance()

    def parse(self):
        node = FileNode()
        node.filename = self.filename
        while self.pos < len(self.tokens) - 1:
            stmt = self.parse_statement()
            if stmt:
                node.children.append(stmt)
        return node

    def parse_statement(self):
        self.skip_newlines()
        token = self.peek()
        if not token or token.type == 'EOF':
            return None

        if token.type == 'HASH':
            return self.parse_preprocessor()
        elif token.type == 'SLASH':
            return self.parse_path_def()
        elif token.type == 'IDENTIFIER' or token.type == 'KEYWORD':
            next_tok = self.peek(1)
            if not next_tok:
                return self.parse_expression_statement()
            if token.value == 'var' and next_tok.type in ('SLASH', 'IDENTIFIER'):
                return self.parse_var_declaration()
            elif token.value == 'set' and next_tok.type == 'IDENTIFIER':
                return self.parse_set_statement()
            elif token.value == 'new' and next_tok.type in ('SLASH', 'IDENTIFIER'):
                return self.parse_new_expression()
            elif token.value == 'del':
                return self.parse_del_statement()
            elif token.value == 'return':
                return self.parse_return_statement()
            elif token.value == 'if':
                return self.parse_if_statement()
            elif token.value == 'for':
                return self.parse_for_statement()
            elif token.value == 'while':
                return self.parse_while_statement()
            elif token.value == 'switch':
                return self.parse_switch_statement()
            elif token.value == 'do':
                return self.parse_do_while_statement()
            elif token.value == 'try':
                return self.parse_try_statement()
            elif token.value == 'spawn':
                return self.parse_spawn_statement()
            elif token.value == 'continue' or token.value == 'break':
                kw = self.advance().value
                return IdentifierNode(kw, token.line, token.column)
            elif token.value == 'var' and next_tok.type == 'KEYWORD' and next_tok.value == 'var':
                return self.parse_var_declaration()
            else:
                return self.parse_expression_statement()
        elif token.type == 'LBRACE':
            return self.parse_block()
        elif token.type == 'COMMENT_BLOCK' or token.type == 'COMMENT_LINE':
            self.advance()
            return None
        else:
            return self.parse_expression_statement()

    def parse_preprocessor(self):
        hash_tok = self.advance()
        directive_tok = self.peek()

        if not directive_tok or directive_tok.type != 'IDENTIFIER':
            return None

        directive = self.advance().value

        if directive == 'define':
            return self.parse_define()
        elif directive == 'include':
            return self.parse_include()
        elif directive == 'ifdef' or directive == 'ifndef' or directive == 'if':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        elif directive == 'else' or directive == 'elif':
            return None
        elif directive == 'endif':
            return None
        elif directive == 'undef':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        elif directive == 'pragma':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        elif directive == 'error':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        elif directive == 'warning':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        elif directive == 'warn':
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None
        else:
            while self.peek() and self.peek().type != 'NEWLINE' and self.peek().type != 'EOF':
                self.advance()
            return None

    def parse_define(self):
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0

        name_tok = self.peek()
        if not name_tok or name_tok.type not in ('IDENTIFIER', 'KEYWORD'):
            return None
        name = self.advance().value

        params = None
        if self.peek() and self.peek().type == 'LPAREN':
            self.advance()
            params = []
            while self.peek() and self.peek().type != 'RPAREN':
                if self.peek().type == 'COMMA':
                    self.advance()
                    continue
                if self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                    params.append(self.advance().value)
                else:
                    break
            if self.peek() and self.peek().type == 'RPAREN':
                self.advance()

        value_end = self.pos
        while value_end < len(self.tokens):
            t = self.tokens[value_end]
            if t.type == 'NEWLINE' or t.type == 'EOF':
                break
            value_end += 1

        value_tokens = self.tokens[self.pos:value_end]
        self.pos = value_end

        return DefineNode(name, params, value_tokens, line, col)

    def parse_include(self):
        token = self.peek()
        line = token.line if token else 0
        col = token.column if token else 0
        path = ''
        if self.peek() and self.peek().type in ('STRING', 'IDENTIFIER'):
            path = self.advance().value
        return IncludeNode(path, line, col)

    def parse_path_def(self):
        line = self.peek().line
        col = self.peek().column
        segments = []

        while self.peek() and self.peek().type == 'SLASH':
            self.advance()
            if self.peek() and self.peek().type == 'IDENTIFIER':
                segments.append(self.advance().value)
            elif self.peek() and self.peek().type == 'KEYWORD':
                segments.append(self.advance().value)
            elif self.peek() and self.peek().type == 'MULTIPLY':
                segments.append('*')
                self.advance()
            else:
                break

        if not segments:
            return PathNode([], line, col)

        self.skip_newlines()

        if not self.peek() or self.peek().type in ('NEWLINE', 'EOF', 'RBRACE'):
            return PathNode(segments, line, col)

        proc_or_verb = None
        if self.peek() and self.peek().type == 'IDENTIFIER':
            proc_or_verb = self.advance().value

        if proc_or_verb and proc_or_verb in ('proc', 'verb'):
            return self.parse_proc_verb_def(segments, proc_or_verb, line, col)

        if proc_or_verb == 'var':
            return self.parse_var_declaration_at_path(segments, line, col)

        return PathNode(segments, line, col)

    def parse_var_declaration_at_path(self, segments, line, col):
        name_tok = self.peek()
        if not name_tok or name_tok.type not in ('IDENTIFIER', 'KEYWORD'):
            return PathNode(segments, line, col)
        name = self.advance().value

        var_type = None
        if self.peek() and self.peek().type == 'SLASH':
            self.advance()
            if self.peek():
                var_type = self.advance().value

        value = None
        if self.peek() and self.peek().type == 'ASSIGN':
            self.advance()
            value = self.parse_expression()

        return VarDefNode(f"{'/'.join(segments)}/{name}", var_type, value, line, col)

    def parse_proc_verb_def(self, segments, kind, line, col):
        name_tok = self.peek()
        if not name_tok or name_tok.type not in ('IDENTIFIER', 'KEYWORD'):
            return PathNode(segments, line, col)
        name = self.advance().value

        params = []
        if self.peek() and self.peek().type == 'LPAREN':
            self.advance()
            params = self.parse_parameter_list()
            self.expect('RPAREN')

        self.skip_newlines()

        if kind == 'verb':
            node = VerbDefNode(segments, name, params, line, col)
        else:
            node = ProcDefNode(segments, name, params, line, col)

        if self.peek() and self.peek().type == 'LBRACE':
            self.advance()
            while self.peek() and self.peek().type != 'RBRACE':
                stmt = self.parse_statement()
                if stmt:
                    node.body.append(stmt)
                if not self.peek():
                    break
                if self.peek().type == 'EOF':
                    break
            if self.peek() and self.peek().type == 'RBRACE':
                self.advance()

        return node

    def parse_parameter_list(self):
        params = []
        while self.peek() and self.peek().type != 'RPAREN' and self.peek().type != 'EOF':
            if self.peek().type == 'COMMA':
                self.advance()
                continue
            if self.peek().type == 'NEWLINE':
                self.advance()
                continue

            if self.peek().value == 'var':
                self.advance()

            if self.peek() and self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                name = self.advance().value
                default = None
                if self.peek() and self.peek().type == 'ASSIGN':
                    self.advance()
                    default = self.parse_expression()
                params.append((name, default))
            else:
                break
        return params

    def parse_var_declaration(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0

        var_type = None
        if self.peek() and self.peek().type == 'SLASH':
            self.advance()
            if self.peek():
                var_type = self.advance().value

        name_tok = self.peek()
        if not name_tok or name_tok.type not in ('IDENTIFIER', 'KEYWORD'):
            return None
        name = self.advance().value

        if var_type == 'var':
            var_type = None

        value = None
        if self.peek() and self.peek().type == 'ASSIGN':
            self.advance()
            value = self.parse_expression()

        return VarDefNode(name, var_type, value, line, col)

    def parse_block(self):
        self.advance()
        stmts = []
        while self.peek() and self.peek().type != 'RBRACE':
            stmt = self.parse_statement()
            if stmt:
                stmts.append(stmt)
            if not self.peek():
                break
            if self.peek().type == 'EOF':
                break
        if self.peek() and self.peek().type == 'RBRACE':
            self.advance()
        return stmts

    def parse_if_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        self.expect('LPAREN')
        condition = self.parse_expression()
        self.expect('RPAREN')
        self.skip_newlines()

        node = IfNode(condition, line, col)
        if self.peek() and self.peek().type == 'LBRACE':
            node.body = self.parse_block()
        else:
            stmt = self.parse_statement()
            if stmt:
                node.body = [stmt]

        self.skip_newlines()
        if self.peek() and self.peek().value == 'else':
            self.advance()
            self.skip_newlines()
            if self.peek() and self.peek().value == 'if':
                node.else_body = [self.parse_if_statement()]
            elif self.peek() and self.peek().type == 'LBRACE':
                node.else_body = self.parse_block()
            else:
                stmt = self.parse_statement()
                if stmt:
                    node.else_body = [stmt]

        return node

    def parse_for_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        self.expect('LPAREN')

        depth = 1
        parts = []
        current_part = []
        paren_depth = 0

        while self.peek() and self.peek().type != 'EOF':
            tok = self.peek()
            if tok.type == 'LPAREN':
                paren_depth += 1
                current_part.append(self.advance())
            elif tok.type == 'RPAREN':
                paren_depth -= 1
                if paren_depth < 0:
                    self.advance()
                    break
                current_part.append(self.advance())
            elif tok.type == 'COMMA' and paren_depth == 0:
                self.advance()
                parts.append(current_part)
                current_part = []
            else:
                current_part.append(self.advance())

        if current_part:
            parts.append(current_part)

        saved_pos = self.pos
        self.pos = 0
        saved_tokens = self.tokens
        init = None
        condition = None
        increment = None

        if len(parts) >= 1 and parts[0]:
            self.tokens = parts[0]
            self.pos = 0
            init = self.parse_expression()
        if len(parts) >= 2 and parts[1]:
            self.tokens = parts[1]
            self.pos = 0
            condition = self.parse_expression()
        if len(parts) >= 3 and parts[2]:
            self.tokens = parts[2]
            self.pos = 0
            increment = self.parse_expression()

        self.tokens = saved_tokens
        self.pos = saved_pos
        self.skip_newlines()

        node = ForNode(init, condition, increment, line, col)
        if self.peek() and self.peek().type == 'LBRACE':
            node.body = self.parse_block()
        else:
            stmt = self.parse_statement()
            if stmt:
                node.body = [stmt]
        return node

    def parse_while_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        self.expect('LPAREN')
        condition = self.parse_expression()
        self.expect('RPAREN')
        self.skip_newlines()

        node = WhileNode(condition, line, col)
        if self.peek() and self.peek().type == 'LBRACE':
            node.body = self.parse_block()
        else:
            stmt = self.parse_statement()
            if stmt:
                node.body = [stmt]
        return node

    def parse_do_while_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        self.skip_newlines()
        if self.peek() and self.peek().type == 'LBRACE':
            body = self.parse_block()
        else:
            stmt = self.parse_statement()
            body = [stmt] if stmt else []
        self.skip_newlines()
        if self.peek() and self.peek().value == 'while':
            self.advance()
            self.expect('LPAREN')
            condition = self.parse_expression()
            self.expect('RPAREN')
        return WhileNode(condition if 'condition' in dir() else None, line, col)

    def parse_switch_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        self.expect('LPAREN')
        value = self.parse_expression()
        self.expect('RPAREN')
        self.skip_newlines()

        node = SwitchNode(value, line, col)
        if self.peek() and self.peek().type == 'LBRACE':
            self.advance()
            while self.peek() and self.peek().type != 'RBRACE':
                if self.peek().value == 'case':
                    self.advance()
                    case_value = self.parse_expression()
                    self.skip_newlines()
                    node.cases.append(('case', case_value, []))
                elif self.peek().value == 'default':
                    self.advance()
                    node.cases.append(('default', None, []))
                else:
                    stmt = self.parse_statement()
                    if stmt and node.cases:
                        node.cases[-1][2].append(stmt)
                if not self.peek():
                    break
            if self.peek() and self.peek().type == 'RBRACE':
                self.advance()
        return node

    def parse_set_statement(self):
        self.advance()
        directive = None
        value = None

        if self.peek() and self.peek().type == 'IDENTIFIER':
            directive = self.advance().value
            if self.peek() and self.peek().type == 'ASSIGN':
                self.advance()
                if self.peek() and self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                    value = self.advance().value
                elif self.peek() and self.peek().type == 'STRING':
                    value = self.advance().value

        return SetNode(directive, value, self.peek().line if self.peek() else 0, self.peek().column if self.peek() else 0)

    def parse_return_statement(self):
        self.advance()
        token = self.peek()
        value = None
        if token and token.type not in ('NEWLINE', 'EOF', 'RBRACE', 'SEMICOLON'):
            value = self.parse_expression()
        return ReturnNode(value, token.line if token else 0, token.column if token else 0)

    def parse_try_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        body = self.parse_block() if self.peek() and self.peek().type == 'LBRACE' else []
        return body

    def parse_spawn_statement(self):
        self.advance()
        line = self.peek().line if self.peek() else 0
        col = self.peek().column if self.peek() else 0
        paren = False
        if self.peek() and self.peek().type == 'LPAREN':
            paren = True
            self.advance()
        delay = self.parse_expression() if self.peek() and self.peek().type not in ('NEWLINE', 'EOF') else None
        if paren:
            self.expect('RPAREN')
        self.skip_newlines()
        if self.peek() and self.peek().type == 'LBRACE':
            body = self.parse_block()
        else:
            stmt = self.parse_statement()
            body = [stmt] if stmt else []
        return body

    def parse_expression_statement(self):
        expr = self.parse_expression()
        return expr

    def parse_new_expression(self):
        self.advance()
        token = self.peek()
        if token and token.type == 'LPAREN':
            self.advance()
            args = []
            while self.peek() and self.peek().type != 'RPAREN':
                args.append(self.parse_expression())
                if self.peek() and self.peek().type == 'COMMA':
                    self.advance()
                self.skip_newlines()
            self.expect('RPAREN')
            return NewNode(None, args, token.line, token.column)
        if token and token.type in ('SLASH', 'IDENTIFIER', 'KEYWORD'):
            return NewNode(self.parse_expression(), [], token.line, token.column)
        return NewNode(None, [], token.line if token else 0, token.column if token else 0)

    def parse_del_statement(self):
        self.advance()
        target = self.parse_expression()
        return DelNode(target, target.line if hasattr(target, 'line') else 0, target.column if hasattr(target, 'column') else 0)

    def parse_expression(self):
        return self.parse_assignment()

    def parse_assignment(self):
        left = self.parse_ternary()
        if self.peek() and self.peek().type == 'ASSIGN':
            self.advance()
            value = self.parse_assignment()
            return AssignNode(left, value, '=', left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        if self.peek() and self.peek().type in ('PLUS', 'MINUS', 'MULTIPLY', 'DIVIDE', 'MODULO'):
            op = self.peek()
            if self.peek(1) and self.peek(1).type == 'ASSIGN':
                self.advance()
                self.advance()
                value = self.parse_assignment()
                return AssignNode(left, value, op.value + '=', left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        if self.peek() and self.peek().type == 'QUESTION':
            self.advance()
            true_val = self.parse_expression()
            if self.peek() and self.peek().type == 'COLON':
                self.advance()
                false_val = self.parse_expression()
                return BinaryOpNode('?:', left, [true_val, false_val], left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_ternary(self):
        return self.parse_logical_or()

    def parse_logical_or(self):
        left = self.parse_logical_and()
        while self.peek() and self.peek().type == 'OR':
            op = self.advance()
            right = self.parse_logical_and()
            left = BinaryOpNode('||', left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_logical_and(self):
        left = self.parse_bitwise_or()
        while self.peek() and self.peek().type == 'AND':
            op = self.advance()
            right = self.parse_bitwise_or()
            left = BinaryOpNode('&&', left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_bitwise_or(self):
        left = self.parse_bitwise_xor()
        while self.peek() and self.peek().type == 'BIT_OR':
            op = self.advance()
            right = self.parse_bitwise_xor()
            left = BinaryOpNode('|', left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_bitwise_xor(self):
        left = self.parse_bitwise_and()
        while self.peek() and self.peek().type == 'BIT_XOR':
            op = self.advance()
            right = self.parse_bitwise_and()
            left = BinaryOpNode('^', left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_bitwise_and(self):
        left = self.parse_equality()
        while self.peek() and self.peek().type == 'BIT_AND':
            op = self.advance()
            right = self.parse_equality()
            left = BinaryOpNode('&', left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_equality(self):
        left = self.parse_comparison()
        while self.peek() and self.peek().type in ('EQUALS', 'NOT_EQUALS'):
            op = self.advance()
            right = self.parse_comparison()
            left = BinaryOpNode(op.value, left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_comparison(self):
        left = self.parse_shift()
        while self.peek() and self.peek().type in ('LESS', 'GREATER', 'LESS_EQUAL', 'GREATER_EQUAL'):
            op = self.advance()
            right = self.parse_shift()
            left = BinaryOpNode(op.value, left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_shift(self):
        left = self.parse_term()
        while self.peek() and self.peek().type in ('LSHIFT', 'RSHIFT'):
            op = self.advance()
            right = self.parse_term()
            left = BinaryOpNode(op.value, left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_term(self):
        left = self.parse_factor()
        while self.peek() and self.peek().type in ('PLUS', 'MINUS'):
            op = self.advance()
            right = self.parse_factor()
            left = BinaryOpNode(op.value, left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_factor(self):
        left = self.parse_unary()
        while self.peek() and self.peek().type in ('MULTIPLY', 'SLASH', 'MODULO'):
            op = self.advance()
            right = self.parse_unary()
            left = BinaryOpNode(op.value, left, right, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_unary(self):
        token = self.peek()
        if not token:
            return None
        if token.type in ('MINUS', 'NOT', 'BIT_NOT', 'PLUS_PLUS', 'MINUS_MINUS'):
            op = self.advance()
            operand = self.parse_unary()
            return UnaryOpNode(op.value, operand, token.line, token.column)
        if token.value == 'return':
            return self.parse_return_statement()
        return self.parse_postfix()

    def parse_postfix(self):
        left = self.parse_primary()
        while self.peek() and self.peek().type in ('LPAREN', 'LBRACKET', 'DEREFERENCE', 'COLON', 'DOUBLECOLON', 'PLUS_PLUS', 'MINUS_MINUS'):
            if self.peek().type == 'LPAREN':
                self.advance()
                args = []
                while self.peek() and self.peek().type != 'RPAREN':
                    args.append(self.parse_expression())
                    if self.peek() and self.peek().type == 'COMMA':
                        self.advance()
                    self.skip_newlines()
                self.expect('RPAREN')
                left = CallNode(left, args, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
            elif self.peek().type == 'LBRACKET':
                self.advance()
                index = self.parse_expression()
                self.expect('RBRACKET')
                left = IndexNode(left, index, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
            elif self.peek().type == 'DEREFERENCE':
                self.advance()
                if self.peek() and self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                    prop = self.advance()
                    left = PropertyNode(left, IdentifierNode(prop.value, prop.line, prop.column), left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
            elif self.peek().type == 'COLON':
                self.advance()
                if self.peek() and self.peek().type == 'COLON':
                    self.advance()
                    if self.peek() and self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                        prop = self.advance()
                        left = PropertyNode(left, IdentifierNode(prop.value, prop.line, prop.column), left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
            elif self.peek().type in ('PLUS_PLUS', 'MINUS_MINUS'):
                op = self.advance()
                left = UnaryOpNode(op.value, left, left.line if hasattr(left, 'line') else 0, left.column if hasattr(left, 'column') else 0)
        return left

    def parse_primary(self):
        token = self.peek()
        if not token:
            return None

        if token.type == 'NUMBER':
            self.advance()
            return NumberNode(token.value, token.line, token.column)
        elif token.type == 'STRING':
            self.advance()
            return StringNode(token.value, token.line, token.column)
        elif token.value == '(':
            self.advance()
            expr = self.parse_expression()
            if self.peek() and self.peek().type == 'RPAREN':
                self.advance()
            return expr
        elif token.value == 'new':
            return self.parse_new_expression()
        elif token.value == 'list':
            self.advance()
            elements = []
            if self.peek() and self.peek().type == 'LPAREN':
                self.advance()
                while self.peek() and self.peek().type != 'RPAREN':
                    elements.append(self.parse_expression())
                    if self.peek() and self.peek().type == 'COMMA':
                        self.advance()
                    self.skip_newlines()
                self.expect('RPAREN')
            return ListLiteralNode(elements, token.line, token.column)
        elif token.type == 'SLASH':
            return self.parse_path_expr()
        elif token.type == 'LBRACKET':
            self.advance()
            expr = self.parse_expression()
            self.expect('RBRACKET')
            return expr
        elif token.type == 'IDENTIFIER' or token.type == 'KEYWORD':
            self.advance()
            return IdentifierNode(token.value, token.line, token.column)
        else:
            self.advance()
            return IdentifierNode(token.value, token.line, token.column)

    def parse_path_expr(self):
        token = self.peek()
        segments = ['/']
        self.advance()

        while self.peek() and self.peek().type == 'IDENTIFIER':
            segments.append(self.advance().value)
            if self.peek() and self.peek().type == 'SLASH':
                self.advance()
                segments[-1] = segments[-1] + '/'

        path_str = ''.join(segments)
        return IdentifierNode(path_str, token.line if token else 0, token.column if token else 0)

    def parse_path_type(self):
        token = self.peek()
        if not token or token.type != 'SLASH':
            return None
        path_tokens = []
        while self.peek() and self.peek().type == 'SLASH':
            path_tokens.append(self.advance())
            if self.peek() and self.peek().type in ('IDENTIFIER', 'KEYWORD'):
                path_tokens.append(self.advance())
            else:
                break
        return path_tokens
