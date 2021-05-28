structure AST = struct

    type id = string

    datatype binop = 
        Add | Sub | Mul | Eq | Xor | Less | Great | And | Or | Implies | ASSIGN

    datatype uniop = Not | Negate

    datatype term = Term

    datatype typ = IntTy
                | BoolTy
                | StrTy
                | FnTy of typ * typ
                | TupTy of typ list

    datatype decl = ValDecl of id * exp

    and   exp =   NumExp of int
                | StringExp of string
                | VarExp of id
                | BinExp of binop * exp * exp
                | LetExp of decl * exp
                | BoolExp of bool
                | IfThenElseExp of exp * exp * exp
                | UniExp of uniop * exp
                | UniStatement of term * exp
                | MultiStatement of exp * exp
                | AppExp of exp * exp
                | FnExp of id * typ * typ * exp
                | FunExp of id * id * typ * typ * exp




    datatype value =  IntVal of int
                    | StringVal of string
                    | BoolVal of bool
                    | FunVal of typ * value
                    | FunDecVal of typ * id * exp
                    | Answer of value list


    type environment = (id * value) list


    fun envAdd (var:id, v:value, env:environment) =
        (var,v)::env

    fun envLookup (var:id, env:environment) =
        case List.find(fn (x, _) => x = var) env of
                           SOME (x, v)   => v
                        |   NONE => raise Fail ("Environment lookup error | variable "^var^" not defined")

end
