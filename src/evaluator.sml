structure EVALUATOR  = struct
  open AST

  fun evalExp(e:exp, env:environment):value =
      case e of
  	      NumExp i            => IntVal i
        | VarExp s            => envLookup (s, env)
        | BinExp (b, e1, e2)  => evalBinExp(b, e1, e2, env)
        | LetExp(ValDecl(x, e1), e2)  =>
            	let
          	    val v1 = evalExp (e1, env)
          	  in
          	    evalExp(e2, envAdd (x, v1, env))
              end
        | BoolExp x => BoolVal x
        | IfThenElseExp( e1 , e2 , e3 ) => 
        (
            case (evalExp(e1, env), evalExp(e2, env), evalExp(e3, env))  of
              (BoolVal b1, BoolVal i1, BoolVal i2) => if b1 then BoolVal i1 else BoolVal i2
            | (BoolVal b1, IntVal i1, IntVal i2) => if b1 then IntVal i1 else IntVal i2
            | _ => raise Fail "Error: if-then-else-fi Evaluation "
        )
        | UniExp ( u , e1 )        => 
        (
          case (u, evalExp(e1, env))  of
              (Not, BoolVal i1) => BoolVal (not i1)
            | (Neg, IntVal i1)  => IntVal (~i1)
            | _ => raise Fail "Error: Uni-expression Evaluation "
        )
        | AppExp(e1, e2) => 
        (
        case (e1, e2) of 
            (FnExp (x, t1, t2, e), FnExp (x2, t21, t22, e2)) => 
                IntVal 0
            | (FnExp (x, t1, t2, e), _) => 
                let 
                    val new_env = envAdd(x, evalExp(e2, env), env)
                in
                    evalExp(e1, new_env)
                end
            | (_, FnExp (x, t1, t2, e)) => 
                let 
                    val new_env = envAdd(x, evalExp(e1, env), env)
                in
                    evalExp(e2, new_env)
                end
            | (VarExp s  , _) =>
            (
                StringVal "<The Function Return Value>"
            )
            
            
            | (_, _) => IntVal 100
        )
        | FnExp (x, t1, t2, e) =>  FunDecVal(FnTy(t1, t2), x, e)
        | FunExp (_, x, t1, t2, e) =>  FunDecVal(FnTy(t1, t2), x, e)
        | UniStatement ( _ , e1 )  => Answer( [evalExp(e1,env)] )
        | MultiStatement (e1 , e2) =>
        (
              case ( evalExp(e1, env), evalExp(e2, env) )  of
                (Answer v1 , Answer v2) => 
                  let
                      fun append ([], ys) = ys
                      |   append([x], ys) = x::ys
                      |   append(x::xs, ys) = x::append(xs, ys)
                  in
                      Answer(append(v2, v1))
                  end
              | _  =>  raise Fail "Error: MultiStatement Evaluation "
        )

  and

      evalBinExp(b:binop, e1:exp, e2:exp, env:environment):value =
      case (b, evalExp(e1, env), evalExp(e2, env))  of
          (Add, IntVal i1, IntVal i2) => IntVal (i1+i2)
        |   (Sub, IntVal i1, IntVal i2) => IntVal (i1-i2)
        |   (Mul, IntVal i1, IntVal i2) => IntVal (i1*i2)
        |   (Eq, IntVal i1, IntVal i2)  => BoolVal (i1 = i2)
        |   (Less, IntVal i1, IntVal i2)  => BoolVal (i1 < i2)
        |   (Great, IntVal i1, IntVal i2)  => BoolVal (i1 > i2)
        |   (And, BoolVal i1, BoolVal i2)  => BoolVal (i1 andalso i2)
        |   (Or, BoolVal i1, BoolVal i2)  => BoolVal (i1 orelse i2)
        |   (Xor, BoolVal i1, BoolVal i2)  => BoolVal (if (i1 = i2 )then false else true)
        |   (Eq, BoolVal i1, BoolVal i2)  => BoolVal (i1 = i2)
        |   (Implies, BoolVal i1, BoolVal i2)  => BoolVal (if (i1 andalso (not i2)) then false else true)
        |   (Eq, StringVal s1, StringVal s2) => BoolVal (s1 = s2)
        |   (ASSIGN, IntVal i1, IntVal i2) => BoolVal(i1 = i2)
        |   _  => raise Fail "Error: Binary expression Evaluation "
        

  fun valTostring(v: value):string = 
        case v of IntVal(i) => "(Integer value) "^Int.toString(i)
            | StringVal(s) => "(String value) "^s
            | BoolVal(b) => 
                let 
                    val s = 
                        if b = true then 
                            "TRUE" 
                        else
                            "FALSE" 
                in 
                    "(Boolean Value) "^s
                end
            | FunVal(t, v) => valTostring(v)^" returned by (Function) of type "^Typing.typeToString(t)
            | FunDecVal(t, _, _) => "(Function) of type "^Typing.typeToString(t)
            | Answer([]) => "The answer of the expression is: "
            | Answer([x]) => "The answer of the expression is: "^valTostring(x)
            | Answer(x::xs) => valTostring(Answer(xs))^"; "^valTostring(x)

end
