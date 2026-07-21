#ifndef LUA54_DM_CORE
#define LUA54_DM_CORE

/datum/lua54_nil

/datum/lua54_bool
    var/value = 0
    New(v)
        value = v ? 1 : 0

/datum/lua54_return
    var/list/values
    New(list/v)
        values = v || list()

/datum/lua54_break

/datum/lua54_error
    var/message = ""
    New(msg)
        message = "[msg]"

/datum/lua54_token
    var/tok_type = ""
    var/value = null
    var/line = 1
    var/col = 1
    New(t, v, l, c)
        tok_type = t
        value = v
        line = l
        col = c

/datum/lua54_env
    var/list/scope_vars
    var/datum/lua54_env/parent
    var/datum/lua54/state

    New(datum/lua54/S, datum/lua54_env/P = null)
        state = S
        parent = P
        scope_vars = list()

    proc/HasLocal(name)
        return (name in scope_vars)

    proc/Define(name, value)
        if(isnull(value)) value = state.Nil()
        scope_vars[name] = value
        return value

    proc/Get(name)
        if(name in scope_vars)
            return scope_vars[name]
        if(parent)
            return parent.Get(name)
        if(state && state.globals && (name in state.globals))
            return state.globals[name]
        return state.Nil()

    proc/Set(name, value)
        if(isnull(value)) value = state.Nil()
        if(name in scope_vars)
            scope_vars[name] = value
            return value
        if(parent)
            if(parent.HasDeep(name))
                return parent.Set(name, value)
        state.globals[name] = value
        return value

    proc/HasDeep(name)
        if(name in scope_vars) return 1
        if(parent) return parent.HasDeep(name)
        return 0

/datum/lua54_table
    var/list/map
    var/list/keymap
    var/datum/lua54_table/metatable
    var/datum/lua54/state

    New(datum/lua54/S)
        state = S
        map = list()
        keymap = list()

    proc/KeyId(key)
        if(isnull(key) || istype(key, /datum/lua54_nil))
            return null
        if(istext(key))
            return "s:[key]"
        if(isnum(key))
            return "n:[key]"
        if(istype(key, /datum/lua54_bool))
            var/datum/lua54_bool/B = key
            return "b:[B.value]"
        return "o:\ref[key]"

    proc/RawGet(key)
        var/id = KeyId(key)
        if(!id) return state.Nil()
        if(id in map)
            return map[id]
        return state.Nil()

    proc/RawSet(key, value)
        var/id = KeyId(key)
        if(!id)
            state.Throw("table index is nil")
            return state.Nil()
        if(isnull(value) || istype(value, /datum/lua54_nil))
            map -= id
            keymap -= id
        else
            map[id] = value
            keymap[id] = key
        return value

    proc/Length()
        var/i = 1
        while(1)
            var/v = RawGet(i)
            if(istype(v, /datum/lua54_nil))
                return i - 1
            i++

    proc/Keys()
        var/list/out = list()
        for(var/id in keymap)
            out += keymap[id]
        return out

/datum/lua54_function
    var/datum/lua54/state
    proc/Call(datum/lua54/S, list/call_args)
        return list(S.Nil())

/datum/lua54_native_function
    parent_type = /datum/lua54_function
    var/name = ""
    New(n)
        name = n

    Call(datum/lua54/S, list/call_args)
        switch(name)
            if("print")
                var/list/parts = list()
                for(var/v in call_args)
                    parts += S.ToString(v)
                world << jointext(parts, "\t")
                return list(S.Nil())
            if("type")
                if(!call_args || !length(call_args)) return list("nil")
                return list(S.TypeName(call_args[1]))
            if("tostring")
                if(!call_args || !length(call_args)) return list("nil")
                return list(S.ToString(call_args[1]))
            if("tonumber")
                if(!call_args || !length(call_args)) return list(S.Nil())
                var/v = call_args[1]
                if(isnum(v)) return list(v)
                if(istext(v))
                    var/n = text2num(v)
                    if("[n]" == "") return list(S.Nil())
                    return list(n)
                return list(S.Nil())
            if("assert")
                if(!call_args || !length(call_args) || !S.Truthy(call_args[1]))
                    var/msg = "assertion failed!"
                    if(call_args && length(call_args) >= 2) msg = S.ToString(call_args[2])
                    S.Throw(msg)
                return call_args
            if("error")
                var/msg2 = "error"
                if(call_args && length(call_args)) msg2 = S.ToString(call_args[1])
                S.Throw(msg2)
            if("rawget")
                if(length(call_args) < 2 || !istype(call_args[1], /datum/lua54_table)) return list(S.Nil())
                var/datum/lua54_table/T = call_args[1]
                return list(T.RawGet(call_args[2]))
            if("rawset")
                if(length(call_args) < 3 || !istype(call_args[1], /datum/lua54_table)) S.Throw("bad argument #1 to rawset (table expected)")
                var/datum/lua54_table/T2 = call_args[1]
                T2.RawSet(call_args[2], call_args[3])
                return list(T2)
            if("setmetatable")
                if(length(call_args) < 2 || !istype(call_args[1], /datum/lua54_table)) S.Throw("bad argument #1 to setmetatable (table expected)")
                var/datum/lua54_table/T3 = call_args[1]
                if(!istype(call_args[2], /datum/lua54_table) && !istype(call_args[2], /datum/lua54_nil)) S.Throw("bad argument #2 to setmetatable (nil or table expected)")
                T3.metatable = istype(call_args[2], /datum/lua54_table) ? call_args[2] : null
                return list(T3)
            if("getmetatable")
                if(length(call_args) < 1 || !istype(call_args[1], /datum/lua54_table)) return list(S.Nil())
                var/datum/lua54_table/T4 = call_args[1]
                return list(T4.metatable || S.Nil())
            if("next")
                if(length(call_args) < 1 || !istype(call_args[1], /datum/lua54_table)) S.Throw("bad argument #1 to next (table expected)")
                var/datum/lua54_table/T5 = call_args[1]
                var/after = length(call_args) >= 2 ? call_args[2] : S.Nil()
                var/list/ks = T5.Keys()
                var/start = 1
                if(!istype(after, /datum/lua54_nil))
                    start = 0
                    for(var/i = 1, i <= length(ks), i++)
                        if(S.RawEqual(ks[i], after))
                            start = i + 1
                            break
                    if(!start) return list(S.Nil())
                if(start <= length(ks))
                    var/k = ks[start]
                    return list(k, T5.RawGet(k))
                return list(S.Nil())
            if("pairs")
                // Minimal pairs: returns next, table, nil. Generic-for is not implemented in this core.
                return list(S.globals["next"], length(call_args) ? call_args[1] : S.Nil(), S.Nil())
            if("ipairs")
                S.Throw("ipairs requires generic for support; not implemented in this core")
        return list(S.Nil())

/datum/lua54_closure
    parent_type = /datum/lua54_function
    var/list/params
    var/vararg = 0
    var/list/body
    var/datum/lua54_env/env

    New(list/p, va, list/b, datum/lua54_env/e)
        params = p || list()
        vararg = va
        body = b || list()
        env = e

    Call(datum/lua54/S, list/call_args)
        var/datum/lua54_env/E = new(S, env)
        for(var/i = 1, i <= length(params), i++)
            E.Define(params[i], (call_args && i <= length(call_args)) ? call_args[i] : S.Nil())
        var/list/extra = list()
        if(call_args && length(call_args) > length(params))
            for(var/j = length(params) + 1, j <= length(call_args), j++) extra += call_args[j]
        E.Define("...", extra)
        var/r = S.ExecBlock(body, E)
        if(istype(r, /datum/lua54_return))
            var/datum/lua54_return/R = r
            return R.values
        if(istype(r, /datum/lua54_error))
            return list(r)
        return list(S.Nil())

/datum/lua54_lexer
    var/text = ""
    var/pos = 1
    var/line = 1
    var/col = 1
    var/list/tokens
    var/datum/lua54/state

    New(datum/lua54/S, source)
        state = S
        text = source || ""
        tokens = list()

    proc/Len()
        return length(text)

    proc/Peek(offset = 0)
        var/i = pos + offset
        if(i > Len()) return ""
        return copytext(text, i, i + 1)

    proc/Take()
        var/c = Peek()
        if(c == "") return ""
        pos++
        if(c == "\n")
            line++
            col = 1
        else
            col++
        return c

    proc/Add(t, v = null, l = 0, c = 0)
        tokens += new /datum/lua54_token(t, isnull(v) ? t : v, l || line, c || col)

    proc/IsSpace(c)
        return c == " " || c == "\t" || c == ascii2text(13) || c == "\n"

    proc/IsDigit(c)
        return c >= "0" && c <= "9"

    proc/IsAlpha(c)
        return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "_"

    proc/IsAlnum(c)
        return IsAlpha(c) || IsDigit(c)

    proc/Lex()
        while(pos <= Len())
            var/c = Peek()
            if(IsSpace(c))
                Take()
                continue
            var/sl = line
            var/sc = col
            if(c == "-" && Peek(1) == "-")
                Take(); Take()
                if(Peek() == ascii2text(91) && Peek(1) == ascii2text(91))
                    Take(); Take()
                    while(pos <= Len())
                        if(Peek() == ascii2text(93) && Peek(1) == ascii2text(93))
                            Take(); Take(); break
                        Take()
                else
                    while(pos <= Len() && Peek() != "\n") Take()
                continue
            if(IsAlpha(c))
                var/s = ""
                while(IsAlnum(Peek())) s += Take()
                switch(s)
                    if("and","break","do","else","elseif","end","false","for","function","goto","if","in","local","nil","not","or","repeat","return","then","true","until","while")
                        Add(s, s, sl, sc)
                    else
                        Add("name", s, sl, sc)
                continue
            if(IsDigit(c) || (c == "." && IsDigit(Peek(1))))
                var/num = ""
                if(c == "0" && (Peek(1) == "x" || Peek(1) == "X"))
                    num += Take(); num += Take()
                    while(IsDigit(Peek()) || (Peek() >= "a" && Peek() <= "f") || (Peek() >= "A" && Peek() <= "F")) num += Take()
                    Add("number", text2num(num), sl, sc)
                else
                    while(IsDigit(Peek())) num += Take()
                    if(Peek() == "." && Peek(1) != ".")
                        num += Take()
                        while(IsDigit(Peek())) num += Take()
                    if(Peek() == "e" || Peek() == "E")
                        num += Take()
                        if(Peek() == "+" || Peek() == "-") num += Take()
                        while(IsDigit(Peek())) num += Take()
                    Add("number", text2num(num), sl, sc)
                continue
            if(c == "\"" || c == "'")
                var/q = Take()
                var/s2 = ""
                while(pos <= Len() && Peek() != q)
                    var/ch = Take()
                    if(ch == "\\")
                        var/e = Take()
                        switch(e)
                            if("n") s2 += "\n"
                            if("t") s2 += "\t"
                            if("r") s2 += ascii2text(13)
                            if("\\") s2 += "\\"
                            if("\"") s2 += "\""
                            if("'") s2 += "'"
                            else s2 += e
                    else
                        s2 += ch
                if(Peek() == q) Take()
                else state.Throw("unfinished string near line [sl]")
                Add("string", s2, sl, sc)
                continue
            if(c == ascii2text(91) && Peek(1) == ascii2text(91))
                Take(); Take()
                var/ls = ""
                while(pos <= Len())
                    if(Peek() == ascii2text(93) && Peek(1) == ascii2text(93))
                        Take(); Take(); break
                    ls += Take()
                Add("string", ls, sl, sc)
                continue
            var/two = "[c][Peek(1)]"
            var/three = "[c][Peek(1)][Peek(2)]"
            if(three == "...")
                Take(); Take(); Take(); Add("...", "...", sl, sc); continue
            if(two in list("==","~=","<=",">=","//","<<",">>","..","::"))
                Take(); Take(); Add(two, two, sl, sc); continue
            Take()
            Add(c, c, sl, sc)
        Add("eof", "eof", line, col)
        return tokens

/datum/lua54_parser
    var/list/tokens
    var/i = 1
    var/datum/lua54/state

    New(datum/lua54/S, list/T)
        state = S
        tokens = T

    proc/Tok(offset = 0)
        var/j = i + offset
        if(j < 1) j = 1
        if(j > length(tokens)) return tokens[length(tokens)]
        return tokens[j]

    proc/Type(offset = 0)
        var/datum/lua54_token/T = Tok(offset)
        return T.tok_type

    proc/Value(offset = 0)
        var/datum/lua54_token/T = Tok(offset)
        return T.value

    proc/At(t)
        return Type() == t

    proc/Take(t = null)
        var/datum/lua54_token/T = Tok()
        if(t && T.tok_type != t)
            state.Throw("expected '[t]' near '[T.value]' at line [T.line]")
        i++
        return T

    proc/Accept(t)
        if(At(t))
            return Take(t)
        return null

    proc/Parse()
        var/list/body = ParseBlock(list("eof"))
        Take("eof")
        return body

    proc/ParseBlock(list/stoppers)
        var/list/body = list()
        while(!(Type() in stoppers))
            if(At("eof")) break
            body += list(ParseStatement())
        return body

    proc/ParseStatement()
        if(Accept(";")) return list("kind"="nop")
        if(Accept("break")) return list("kind"="break")
        if(Accept("return"))
            var/list/exps = list()
            if(!(Type() in list("end","else","elseif","until","eof",";")))
                exps = ParseExpList()
            Accept(";")
            return list("kind"="return", "exps"=exps)
        if(Accept("local"))
            if(Accept("function"))
                var/name = Take("name").value
                var/fn = ParseFunctionBody()
                return list("kind"="local", "names"=list(name), "exps"=list(fn))
            var/list/names = list(Take("name").value)
            while(Accept(",")) names += Take("name").value
            var/list/exps2 = list()
            if(Accept("=")) exps2 = ParseExpList()
            return list("kind"="local", "names"=names, "exps"=exps2)
        if(Accept("function"))
            var/prefix = Take("name").value
            var/varnode = list("kind"="var", "name"=prefix)
            while(Accept("."))
                varnode = list("kind"="index", "table"=varnode, "key"=list("kind"="string", "value"=Take("name").value))
            var/method = null
            if(Accept(":")) method = Take("name").value
            var/fbody = ParseFunctionBody(method)
            if(method)
                varnode = list("kind"="index", "table"=varnode, "key"=list("kind"="string", "value"=method))
            return list("kind"="assign", "vars"=list(varnode), "exps"=list(fbody))
        if(Accept("if"))
            var/list/clauses = list()
            var/cond = ParseExpr()
            Take("then")
            var/list/b = ParseBlock(list("elseif","else","end"))
            clauses += list(list("cond"=cond, "body"=b))
            while(Accept("elseif"))
                var/ec = ParseExpr()
                Take("then")
                var/list/eb = ParseBlock(list("elseif","else","end"))
                clauses += list(list("cond"=ec, "body"=eb))
            var/list/elsebody = null
            if(Accept("else")) elsebody = ParseBlock(list("end"))
            Take("end")
            return list("kind"="if", "clauses"=clauses, "else"=elsebody)
        if(Accept("while"))
            var/wcond = ParseExpr()
            Take("do")
            var/list/wbody = ParseBlock(list("end"))
            Take("end")
            return list("kind"="while", "cond"=wcond, "body"=wbody)
        if(Accept("repeat"))
            var/list/rbody = ParseBlock(list("until"))
            Take("until")
            var/rcond = ParseExpr()
            return list("kind"="repeat", "body"=rbody, "cond"=rcond)
        if(Accept("for"))
            var/fname = Take("name").value
            if(Accept("="))
                var/init = ParseExpr(); Take(",")
                var/limit = ParseExpr()
                var/step = null
                if(Accept(",")) step = ParseExpr()
                Take("do")
                var/list/fb = ParseBlock(list("end"))
                Take("end")
                return list("kind"="fornum", "name"=fname, "init"=init, "limit"=limit, "step"=step, "body"=fb)
            state.Throw("generic for is not implemented in this core")
        var/first = ParsePrefixExpr()
        if(first["kind"] == "call")
            return list("kind"="callstat", "call"=first)
        var/list/var_nodes = list(first)
        while(Accept(",")) var_nodes += list(ParsePrefixExpr())
        Take("=")
        return list("kind"="assign", "vars"=var_nodes, "exps"=ParseExpList())

    proc/ParseExpList()
        var/list/exps = list(ParseExpr())
        while(Accept(",")) exps += list(ParseExpr())
        return exps

    proc/BinPrec(op)
        switch(op)
            if("or") return 1
            if("and") return 2
            if("<",">","<=",">=","~=","==") return 3
            if("|") return 4
            if("~") return 5
            if("&") return 6
            if("<<", ">>") return 7
            if("..") return 8
            if("+", "-") return 9
            if("*", "/", "//", "%") return 10
            if("^") return 12
        return 0

    proc/RightAssoc(op)
        return op == "^" || op == ".."

    proc/ParseExpr(minp = 1)
        var/left = ParseUnary()
        while(1)
            var/op = Type()
            var/p = BinPrec(op)
            if(p < minp || !p) break
            Take()
            var/nextmin = p + (RightAssoc(op) ? 0 : 1)
            var/right = ParseExpr(nextmin)
            left = list("kind"="bin", "op"=op, "a"=left, "b"=right)
        return left

    proc/ParseUnary()
        if(Type() in list("not", "-", "~", "#"))
            var/op = Take().tok_type
            return list("kind"="un", "op"=op, "a"=ParseUnary())
        return ParseSimpleExpr()

    proc/ParseSimpleExpr()
        if(Accept("nil")) return list("kind"="nil")
        if(Accept("false")) return list("kind"="bool", "value"=0)
        if(Accept("true")) return list("kind"="bool", "value"=1)
        if(At("number")) return list("kind"="number", "value"=Take("number").value)
        if(At("string")) return list("kind"="string", "value"=Take("string").value)
        if(Accept("...")) return list("kind"="vararg")
        if(Accept("function")) return ParseFunctionBody()
        if(Accept("{")) return ParseTableConstructor()
        return ParsePrefixExpr()

    proc/ParseTableConstructor()
        var/list/fields = list()
        if(!Accept("}"))
            while(1)
                if(Accept(ascii2text(91)))
                    var/k = ParseExpr(); Take(ascii2text(93)); Take("=")
                    fields += list(list("key"=k, "value"=ParseExpr()))
                else if(At("name") && Type(1) == "=")
                    var/n = Take("name").value; Take("=")
                    fields += list(list("key"=list("kind"="string", "value"=n), "value"=ParseExpr()))
                else
                    fields += list(list("key"=null, "value"=ParseExpr()))
                if(Accept(",") || Accept(";"))
                    if(At("}")) break
                    continue
                break
            Take("}")
        return list("kind"="table", "fields"=fields)

    proc/ParsePrefixExpr()
        var/node
        if(At("name"))
            node = list("kind"="var", "name"=Take("name").value)
        else if(Accept("("))
            node = ParseExpr()
            Take(")")
        else
            state.Throw("unexpected token '[Value()]'")
            node = list("kind"="nil")
        while(1)
            if(Accept("."))
                node = list("kind"="index", "table"=node, "key"=list("kind"="string", "value"=Take("name").value))
                continue
            if(Accept(ascii2text(91)))
                var/key = ParseExpr(); Take(ascii2text(93))
                node = list("kind"="index", "table"=node, "key"=key)
                continue
            if(Accept(":"))
                var/m = Take("name").value
                var/list/call_args = ParseArgs()
                node = list("kind"="call", "func"=list("kind"="index", "table"=node, "key"=list("kind"="string", "value"=m)), "args"=call_args, "self"=node)
                continue
            if(Type() in list("(", "{", "string"))
                node = list("kind"="call", "func"=node, "args"=ParseArgs(), "self"=null)
                continue
            break
        return node

    proc/ParseArgs()
        var/list/call_args = list()
        if(Accept("("))
            if(!Accept(")"))
                call_args = ParseExpList()
                Take(")")
            return call_args
        if(At("string")) return list(list("kind"="string", "value"=Take("string").value))
        if(Accept("{"))
            i--
            return list(ParseTableConstructor())
        state.Throw("function arguments expected")
        return call_args

    proc/ParseFunctionBody(method = null)
        Take("(")
        var/list/params = list()
        var/vararg = 0
        if(method) params += "self"
        if(!Accept(")"))
            while(1)
                if(Accept("..."))
                    vararg = 1
                    break
                params += Take("name").value
                if(!Accept(",")) break
            Take(")")
        var/list/body = ParseBlock(list("end"))
        Take("end")
        return list("kind"="function", "params"=params, "vararg"=vararg, "body"=body)

/datum/lua54
    var/datum/lua54_nil/_nil
    var/datum/lua54_bool/_true
    var/datum/lua54_bool/_false
    var/list/globals
    var/last_error = null

    New()
        _nil = new
        _true = new(1)
        _false = new(0)
        globals = list()
        InstallBase()

    proc/Nil()
        return _nil

    proc/Bool(v)
        return v ? _true : _false

    proc/InstallBase()
        globals["_G"] = null
        globals["print"] = new /datum/lua54_native_function("print")
        globals["type"] = new /datum/lua54_native_function("type")
        globals["tostring"] = new /datum/lua54_native_function("tostring")
        globals["tonumber"] = new /datum/lua54_native_function("tonumber")
        globals["assert"] = new /datum/lua54_native_function("assert")
        globals["error"] = new /datum/lua54_native_function("error")
        globals["rawget"] = new /datum/lua54_native_function("rawget")
        globals["rawset"] = new /datum/lua54_native_function("rawset")
        globals["setmetatable"] = new /datum/lua54_native_function("setmetatable")
        globals["getmetatable"] = new /datum/lua54_native_function("getmetatable")
        globals["next"] = new /datum/lua54_native_function("next")
        globals["pairs"] = new /datum/lua54_native_function("pairs")
        globals["ipairs"] = new /datum/lua54_native_function("ipairs")
        var/datum/lua54_table/G = new(src)
        for(var/k in globals)
            if(!isnull(globals[k])) G.RawSet(k, globals[k])
        globals["_G"] = G

    proc/Throw(msg)
        last_error = "[msg]"
        CRASH("Lua error: [msg]")

    proc/Run(source)
        last_error = null
        var/datum/lua54_lexer/L = new(src, source)
        var/list/toks = L.Lex()
        var/datum/lua54_parser/P = new(src, toks)
        var/list/body = P.Parse()
        var/datum/lua54_env/E = new(src, null)
        var/r = ExecBlock(body, E)
        if(istype(r, /datum/lua54_return))
            var/datum/lua54_return/R = r
            return R.values
        return list(Nil())

    proc/Load(source)
        var/datum/lua54_lexer/L = new(src, source)
        var/list/toks = L.Lex()
        var/datum/lua54_parser/P = new(src, toks)
        var/list/body = P.Parse()
        var/datum/lua54_env/E = new(src, null)
        return new /datum/lua54_closure(list(), 1, body, E)

    proc/ExecBlock(list/body, datum/lua54_env/E)
        for(var/list/st in body)
            var/r = ExecStatement(st, E)
            if(istype(r, /datum/lua54_return) || istype(r, /datum/lua54_break) || istype(r, /datum/lua54_error))
                return r
        return null

    proc/ExecStatement(list/st, datum/lua54_env/E)
        switch(st["kind"])
            if("nop") return null
            if("break") return new /datum/lua54_break
            if("return")
                return new /datum/lua54_return(EvalExpList(st["exps"], E))
            if("local")
                var/list/names = st["names"]
                var/list/vals = EvalExpList(st["exps"], E)
                for(var/i = 1, i <= length(names), i++)
                    E.Define(names[i], (i <= length(vals)) ? vals[i] : Nil())
                return null
            if("assign")
                var/list/var_nodes2 = st["vars"]
                var/list/vals2 = EvalExpList(st["exps"], E)
                for(var/j = 1, j <= length(var_nodes2), j++)
                    Assign(var_nodes2[j], (j <= length(vals2)) ? vals2[j] : Nil(), E)
                return null
            if("callstat")
                Eval(st["call"], E)
                return null
            if("if")
                var/list/clauses = st["clauses"]
                for(var/list/cl in clauses)
                    if(Truthy(Eval(cl["cond"], E)))
                        return ExecBlock(cl["body"], new /datum/lua54_env(src, E))
                if(st["else"])
                    return ExecBlock(st["else"], new /datum/lua54_env(src, E))
                return null
            if("while")
                while(Truthy(Eval(st["cond"], E)))
                    var/r = ExecBlock(st["body"], new /datum/lua54_env(src, E))
                    if(istype(r, /datum/lua54_break)) break
                    if(r) return r
                return null
            if("repeat")
                while(1)
                    var/r2 = ExecBlock(st["body"], new /datum/lua54_env(src, E))
                    if(istype(r2, /datum/lua54_break)) break
                    if(r2) return r2
                    if(Truthy(Eval(st["cond"], E))) break
                return null
            if("fornum")
                var/a = Num(Eval(st["init"], E))
                var/b = Num(Eval(st["limit"], E))
                var/step = st["step"] ? Num(Eval(st["step"], E)) : 1
                var/datum/lua54_env/FE = new(src, E)
                if(step == 0) Throw("'for' step is zero")
                if(step > 0)
                    for(var/x = a, x <= b, x += step)
                        FE.Define(st["name"], x)
                        var/fr = ExecBlock(st["body"], FE)
                        if(istype(fr, /datum/lua54_break)) break
                        if(fr) return fr
                else
                    for(var/y = a, y >= b, y += step)
                        FE.Define(st["name"], y)
                        var/fr2 = ExecBlock(st["body"], FE)
                        if(istype(fr2, /datum/lua54_break)) break
                        if(fr2) return fr2
                return null
        var/sk = st["kind"]
        Throw("unknown statement kind [sk]")

    proc/EvalExpList(list/exps, datum/lua54_env/E)
        var/list/out = list()
        if(!exps) return out
        for(var/i = 1, i <= length(exps), i++)
            var/list/ex = exps[i]
            var/v = Eval(ex, E, i == length(exps))
            if(islist(v) && v["__multi"])
                for(var/j = 1, j <= length(v), j++)
                    if(j != "__multi") out += v[j]
            else
                out += v
        return out

    proc/Eval(list/ex, datum/lua54_env/E, allow_multi = 0)
        switch(ex["kind"])
            if("nil") return Nil()
            if("bool") return Bool(ex["value"])
            if("number") return ex["value"]
            if("string") return ex["value"]
            if("var") return E.Get(ex["name"])
            if("vararg")
                var/v = E.Get("...")
                if(islist(v))
                    if(allow_multi)
                        v["__multi"] = 1
                        return v
                    return length(v) ? v[1] : Nil()
                return Nil()
            if("function")
                return new /datum/lua54_closure(ex["params"], ex["vararg"], ex["body"], E)
            if("table")
                var/datum/lua54_table/T = new(src)
                var/arrayi = 1
                var/list/fields = ex["fields"]
                for(var/list/f in fields)
                    var/key = f["key"] ? Eval(f["key"], E) : arrayi++
                    var/value = Eval(f["value"], E)
                    T.RawSet(key, value)
                return T
            if("index")
                return Index(Eval(ex["table"], E), Eval(ex["key"], E))
            if("call")
                var/list/vals = CallExpr(ex, E)
                if(allow_multi)
                    vals["__multi"] = 1
                    return vals
                return length(vals) ? vals[1] : Nil()
            if("un")
                var/a = Eval(ex["a"], E)
                switch(ex["op"])
                    if("not") return Bool(!Truthy(a))
                    if("-") return -Num(a)
                    if("#")
                        if(istext(a)) return length(a)
                        if(istype(a, /datum/lua54_table))
                            var/datum/lua54_table/T2 = a
                            return T2.Length()
                        Throw("attempt to get length of a [TypeName(a)] value")
                    if("~") return ~round(Num(a))
            if("bin")
                return EvalBin(ex, E)
        var/ek = ex["kind"]
        Throw("unknown expression kind [ek]")
        return Nil()

    proc/EvalBin(list/ex, datum/lua54_env/E)
        var/op = ex["op"]
        if(op == "and")
            var/av = Eval(ex["a"], E)
            return Truthy(av) ? Eval(ex["b"], E) : av
        if(op == "or")
            var/av2 = Eval(ex["a"], E)
            return Truthy(av2) ? av2 : Eval(ex["b"], E)
        var/a = Eval(ex["a"], E)
        var/b = Eval(ex["b"], E)
        switch(op)
            if("+") return Num(a) + Num(b)
            if("-") return Num(a) - Num(b)
            if("*") return Num(a) * Num(b)
            if("/") return Num(a) / Num(b)
            if("//") return round(Num(a) / Num(b) - 0.5)
            if("%") return Num(a) % Num(b)
            if("^") return Num(a) ** Num(b)
            if("..") return ToString(a) + ToString(b)
            if("==") return Bool(RawEqual(a, b))
            if("~=") return Bool(!RawEqual(a, b))
            if("<") return Bool(Compare(a, b, "<"))
            if(">") return Bool(Compare(a, b, ">"))
            if("<=") return Bool(Compare(a, b, "<="))
            if(">=") return Bool(Compare(a, b, ">="))
            if("&") return round(Num(a)) & round(Num(b))
            if("|") return round(Num(a)) | round(Num(b))
            if("~") return round(Num(a)) ^ round(Num(b))
            if("<<") return round(Num(a)) << round(Num(b))
            if(">>") return round(Num(a)) >> round(Num(b))
        Throw("unknown binary operator [op]")

    proc/Assign(list/varnode, value, datum/lua54_env/E)
        switch(varnode["kind"])
            if("var")
                return E.Set(varnode["name"], value)
            if("index")
                var/t = Eval(varnode["table"], E)
                var/k = Eval(varnode["key"], E)
                return NewIndex(t, k, value)
        Throw("assignment target expected")

    proc/Index(t, k)
        if(istype(t, /datum/lua54_table))
            var/datum/lua54_table/T = t
            var/v = T.RawGet(k)
            if(!istype(v, /datum/lua54_nil)) return v
            if(T.metatable)
                var/mm = T.metatable.RawGet("__index")
                if(istype(mm, /datum/lua54_function))
                    var/list/r = CallValue(mm, list(t, k))
                    return length(r) ? r[1] : Nil()
                if(istype(mm, /datum/lua54_table))
                    return Index(mm, k)
            return Nil()
        Throw("attempt to index a [TypeName(t)] value")

    proc/NewIndex(t, k, v)
        if(istype(t, /datum/lua54_table))
            var/datum/lua54_table/T = t
            var/old = T.RawGet(k)
            if(istype(old, /datum/lua54_nil) && T.metatable)
                var/mm = T.metatable.RawGet("__newindex")
                if(istype(mm, /datum/lua54_function))
                    CallValue(mm, list(t, k, v))
                    return v
                if(istype(mm, /datum/lua54_table))
                    return NewIndex(mm, k, v)
            return T.RawSet(k, v)
        Throw("attempt to index a [TypeName(t)] value")

    proc/CallExpr(list/ex, datum/lua54_env/E)
        var/f = Eval(ex["func"], E)
        var/list/call_args = list()
        if(ex["self"]) call_args += Eval(ex["self"], E)
        var/list/aex = ex["args"]
        for(var/i = 1, i <= length(aex), i++)
            var/v = Eval(aex[i], E, i == length(aex))
            if(islist(v) && v["__multi"])
                for(var/j = 1, j <= length(v), j++) if(j != "__multi") call_args += v[j]
            else call_args += v
        return CallValue(f, call_args)

    proc/CallValue(f, list/call_args)
        if(istype(f, /datum/lua54_function))
            var/datum/lua54_function/F = f
            return F.Call(src, call_args || list())
        if(istype(f, /datum/lua54_table))
            var/datum/lua54_table/T = f
            if(T.metatable)
                var/mm = T.metatable.RawGet("__call")
                if(istype(mm, /datum/lua54_function))
                    var/list/a = list(f)
                    for(var/x in call_args) a += x
                    return CallValue(mm, a)
        Throw("attempt to call a [TypeName(f)] value")
        return list(Nil())

    proc/Truthy(v)
        if(isnull(v) || istype(v, /datum/lua54_nil)) return 0
        if(istype(v, /datum/lua54_bool))
            var/datum/lua54_bool/B = v
            return B.value ? 1 : 0
        return 1

    proc/TypeName(v)
        if(isnull(v) || istype(v, /datum/lua54_nil)) return "nil"
        if(istype(v, /datum/lua54_bool)) return "boolean"
        if(isnum(v)) return "number"
        if(istext(v)) return "string"
        if(istype(v, /datum/lua54_table)) return "table"
        if(istype(v, /datum/lua54_function)) return "function"
        return "userdata"

    proc/ToString(v)
        if(isnull(v) || istype(v, /datum/lua54_nil)) return "nil"
        if(istype(v, /datum/lua54_bool))
            var/datum/lua54_bool/B = v
            return B.value ? "true" : "false"
        if(isnum(v) || istext(v)) return "[v]"
        if(istype(v, /datum/lua54_table)) return "table: \ref[v]"
        if(istype(v, /datum/lua54_function)) return "function: \ref[v]"
        return "userdata: \ref[v]"

    proc/Num(v)
        if(isnum(v)) return v
        if(istext(v))
            var/n = text2num(v)
            return n
        Throw("attempt to perform arithmetic on a [TypeName(v)] value")
        return 0

    proc/RawEqual(a, b)
        if(istype(a, /datum/lua54_nil) && istype(b, /datum/lua54_nil)) return 1
        if(istype(a, /datum/lua54_bool) && istype(b, /datum/lua54_bool))
            var/datum/lua54_bool/A = a
            var/datum/lua54_bool/B = b
            return A.value == B.value
        if(isnum(a) && isnum(b)) return a == b
        if(istext(a) && istext(b)) return a == b
        return a == b

    proc/Compare(a, b, op)
        if(isnum(a) && isnum(b))
            switch(op)
                if("<") return a < b
                if(">") return a > b
                if("<=") return a <= b
                if(">=") return a >= b
        if(istext(a) && istext(b))
            switch(op)
                if("<") return a < b
                if(">") return a > b
                if("<=") return a <= b
                if(">=") return a >= b
        Throw("attempt to compare [TypeName(a)] with [TypeName(b)]")

#endif
