structure BoolLrVals = BoolLrValsFun(structure Token = LrParser.Token)
structure BoolLex = BoolLexFun(structure Tokens = BoolLrVals.Tokens);
structure BoolParser =
	Join(structure LrParser = LrParser
     	       structure ParserData = BoolLrVals.ParserData
     	       structure Lex = BoolLex)

fun invoke lexstream =
    	     	let fun print_error (s,pos:int,_) =
		    	TextIO.output(TextIO.stdOut, "Error, line " ^ (Int.toString pos) ^ "," ^ s ^ "\n")
		in
		    BoolParser.parse(0,lexstream,print_error,())
		end

fun stringToLexer str =
    let val done = ref false
    	val lexer=  BoolParser.makeLexer (fn _ => if (!done) then "" else (done:=true;str))
    in
	lexer
    end

fun parse (lexer) =
    let val dummyEOF = BoolLrVals.Tokens.EOF(0,0)
    	val (result, lexer) = invoke lexer
	val (nextToken, lexer) = BoolParser.Stream.get lexer
    in
        if BoolParser.sameToken(nextToken, dummyEOF) then result
 	else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
    end

val parseString = parse o stringToLexer

fun compileFile (file) = 
    let
        val In = TextIO.openIn(file)
        val s = TextIO.inputAll(In)
        val _ = (print("\nThe input program is: \n" ^ s ^ "\n"))
        val p = parseString(s)
        fun printType(p) = 
            let
                val typ = Typing.getType(p, []);
            in
                (print("\nThe type checking output is:\n"),
                print(Typing.typeToString(typ)))
            end;
        fun getVal(p) = 
            let 
                val value = EVALUATOR.evalExp(p, []);
            in    
                (print("\n\nThe Evaluator output is:\n"),
                value)
            end;

        val _ = printType(p)
        val (_, answer) = getVal(p)
        val _ = (print(EVALUATOR.valTostring(answer)^"\n\n"));
        val _ = TextIO.closeIn(In)
    in
        answer
    end;
