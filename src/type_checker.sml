structure Typing = struct
    open AST

    fun first(x, y) = x

    fun typeToString(t:typ):string = 
        case t of IntTy => "Integer"
            | BoolTy => "Boolean"
            | StrTy => "String"
            | FnTy (t1, t2) => "function ("^typeToString(t1)^" -> "^typeToString(t2)^")"
            | TupTy([]) => "The expression is of type: "
            | TupTy([x]) => "The expression is of type: "^typeToString(x)
            | TupTy(x::xs) => typeToString(TupTy(xs))^"; "^typeToString(x)

    type typEnv = (id * typ ) list

    fun typEnvLookup (var :id , env :typEnv) : typ =
        case List.find( fn (x, _ ) => x = var ) env of
          SOME (_,v) => v
          | NONE => raise Fail ("Error: Variable "^var^" is not typed" )

    fun typEnvAdd (var :id, t:typ , env :typEnv): typEnv =
      (var , t ) :: env

    fun getTypeEnv (e :exp , env: typEnv)=
    case e of
      NumExp _ => (IntTy, env)
      | BinExp ( operation , e1 , e2 ) =>
      (
        case ( operation , first(getTypeEnv(e1, env)), first(getTypeEnv(e2, env)))  of
              (And, BoolTy, BoolTy)  => (BoolTy, env)
          |   (Or, BoolTy, BoolTy)  => (BoolTy, env)
          |   (Xor, BoolTy, BoolTy)  => (BoolTy, env)
          |   (Implies,BoolTy,BoolTy)  => (BoolTy, env)
          |   (Eq, BoolTy,BoolTy ) => (BoolTy, env)
          |   (Add, IntTy,IntTy ) => (IntTy, env)
          |   (Sub, IntTy,IntTy ) => (IntTy, env)
          |   (Mul, IntTy,IntTy ) => (IntTy, env)
          |   (Eq, IntTy,IntTy ) => (BoolTy, env)
          |   (Less, IntTy,IntTy ) => (BoolTy, env)
          |   (Great, IntTy,IntTy ) => (BoolTy, env)
          |   (ASSIGN, t1, t2) =>
                    if t1 <> t1 then
                        raise Fail "Error: types mismatch in Assigning"
                    else (BoolTy, env)
          |   (a, b, c)  => raise Fail ("Error: types mismatch in Binary Exp "^typeToString(b)^" and "^typeToString(c))
      )
      | MultiStatement ( e1 , e2 ) =>
          (
            let 
                val (t1, env1) = getTypeEnv(e1, env);
                val (t2, env2) = getTypeEnv(e2, env1);
                fun append ([], ys) = ys
                |   append([x], ys) = x::ys
                |   append(x::xs, ys) = x::append(xs, ys)
            in
              case ( t1, t2 )  of
              (TupTy v1 , TupTy v2) => 
                      (TupTy(append(v2, v1)), env2)
              | _  => raise Fail "Error: argument type mismatch "
            end
          )
      | UniStatement ( _ , e ) => 
          let 
            val (t, env1) = getTypeEnv (e , env)
          in
            (TupTy ( [t] ), env1)
          end
      | UniExp ( _ , e ) => getTypeEnv (e,env)
      | BoolExp x => (BoolTy, env)
      | VarExp x => (typEnvLookup (x, env), env)
      | AppExp (e1 , e2 ) =>
        ( case(first(getTypeEnv(e1 , env )), first(getTypeEnv(e2, env)) ) of
          ( FnTy (t1 , t2 ), t3 ) =>
          if  t1 = t3
            then ( t2 , env)
            else raise Fail ("Application argument type mismatch "^typeToString(t1)^" and "^typeToString(t3))
          | ( t3, FnTy (t1 , t2 ) ) =>
          if  t1 = t3
            then (FnTy (t1 , t2 ), env)
            else raise Fail ("Application argument type mismatch "^typeToString(t1)^" and "^typeToString(t3))
          | ( t1 , t2 ) => raise Fail ("Error: Function was expected. Got: "^typeToString(t1)^" and "^typeToString(t2))
        )
      | IfThenElseExp (e1 , e2 , e3 ) =>
        (
          let
            val t1 = first(getTypeEnv(e1,env))
            val t2 = first(getTypeEnv(e2,env))
            val t3 = first(getTypeEnv(e3,env))
          in
            if t1 <> BoolTy then 
                raise Fail "Error: Condition of If command is not of BoolTyp"
            else
              if t2 <> t3 then 
                raise Fail "Error: Branches of IF have different types"
              else (t2, env)
            end
          )
        | LetExp(ValDecl(x, e1), e2) => 
          ( 
            let
                val new_env = typEnvAdd(x, first(getTypeEnv(e1,env)),env)
            in
                (first(getTypeEnv(e2, new_env)), env)
            end
          )
        | FunExp (fname , x1 , t1, t2 , e) =>
        (
          let
              val env1 = typEnvAdd(x1,t1,env)
              val env2 = typEnvAdd(fname,t2,env1)
              val (eTyp, env3) = getTypeEnv (e, env2)
            in
              case (t2, eTyp) of
              (BoolTy, IntTy) => raise Fail ("Error: Mismatch in declared type and actual types: "^typeToString(eTyp)^" and "^typeToString(t2))
              | (IntTy, BoolTy) => raise Fail ("Error: Mismatch in declared type and actual types: "^typeToString(eTyp)^" and "^typeToString(t2))
              | (_, _)=> (FnTy (t1 , t2), env3)
            end
          )
        | FnExp (x , t1 , t2 , e) =>
            let 
              val (t, env_new) = getTypeEnv (e,typEnvAdd(x,t1,env))
            in
              (FnTy (t1 , t), env_new)
            end

    fun getType(e :exp , env: typEnv): typ =
        first(getTypeEnv(e, env))
end
