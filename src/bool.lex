structure Tokens = Tokens

    type pos = int
    type svalue = Tokens.svalue
    type ('a,'b) token = ('a,'b) Tokens.token
    type lexresult = (svalue, pos) token

    
    val pos = ref 0
    val col = ref 0
    val store = ref ""
    val eof = 
        let 
            fun no_tail ([]) = []
              | no_tail([x]) = []
              | no_tail(x::ls) = x::no_tail(ls)
        in 
            fn () => ( print ("\nThe Lexer Output is: \n["^implode(no_tail(no_tail(explode(!store))))^"]\n"); store := "" ; col :=0; Tokens.EOF(!pos, !col) )
        end;

    fun attach (store, s1 , s2) = (store := (!store)^ s1 ^ " \"" ^ s2 ^ "\", ");


%%

%header (functor BoolLexFun(structure Tokens:Bool_TOKENS));

alpha=[A-Za-z];
numerals=[0-9];

ws = [\ \t];


%%

[\n|\r\n]=>     (
                    pos := !pos + 1; 
                    col := 0; 
                    lex()
                );

{ws}+    =>     (
                    col := !col + size yytext;  
                    lex()
                );

"if"    =>     (
                    col := !col + size yytext; 
                    attach (store, "IF", yytext );
                    Tokens.IF(!pos,!col)
                );
"then"    =>     (
                    col := !col + size yytext; 
                    attach (store, "THEN", yytext );
                    Tokens.THEN(!pos,!col)
                );
"else"    =>     (
                    col := !col + size yytext; 
                    attach (store, "ELSE", yytext );
                    Tokens.ELSE(!pos,!col)
                );
"fi"      =>    (
                    col := !col + size yytext; 
                    attach (store, "FI", yytext );
                    Tokens.FI(!pos,!col)
                );
"AND"    =>     (
                    col := !col + size yytext; 
                    attach (store, "AND", yytext );
                    Tokens.AND(!pos,!col)
                );

"NOT"    =>     (
                    col := !col + size yytext; 
                    attach (store, "NOT", yytext ); 
                    Tokens.NOT(!pos,!col)
                );

"TRUE"   =>     (
                    col := !col + size yytext; 
                    attach (store, "CONST", yytext ); 
                    Tokens.CONST(true,!pos,!col)
                );

"FALSE"  =>     (
                    col := !col + size yytext; 
                    attach (store, "CONST", yytext ); 
                    Tokens.CONST(false,!pos,!col)
                );

"XOR"    =>     (
                    col := !col + size yytext; 
                    attach (store, "XOR", yytext ) ; 
                    Tokens.XOR(!pos,!col)
                );

"("      =>     (
                    col := !col + size yytext; 
                    attach (store, "LPAREN", yytext ) ; 
                    Tokens.LPAREN(!pos,!col)
                );

";"      =>     (   
                    col := !col + size yytext; 
                    attach (store, "TERM", yytext ) ; 
                    Tokens.TERM(!pos,!col)
                );

")"      =>     (
                    col := !col + size yytext; 
                    attach (store, "RPAREN", yytext ) ; 
                    Tokens.RPAREN(!pos,!col)
                );

"OR"     =>    (
                    col := !col + size yytext; 
                    attach (store, "OR", yytext ); 
                    Tokens.OR(!pos,!col)
                );

"EQUALS" =>     (
                    col := !col + size yytext; 
                    attach (store, "EQUALS", yytext ); 
                    Tokens.EQUALS(!pos,!col)
                );

"IMPLIES" =>    (
                    col := !col + size yytext; 
                    attach (store, "IMPLIES", yytext ); 
                    Tokens.IMPLIES(!pos,!col)
                );
"let"     =>    (
                    col := !col + size yytext; 
                    attach (store, "LET", yytext ); 
                    Tokens.LET(!pos,!col)
                );

"in"      =>    (
                    col := !col + size yytext; 
                    attach (store, "IN", yytext ); 
                    Tokens.IN(!pos,!col)
                );

"end"     =>    (
                    col := !col + size yytext; 
                    attach (store, "END", yytext ); 
                    Tokens.END(!pos,!col)
                );

"="       =>    (
                    col := !col + size yytext; 
                    attach (store, "ASSIGN", yytext ) ; 
                    Tokens.ASSIGN(!pos,!col)
                );
"PLUS"    =>    (
                    col := !col + size yytext; 
                    attach (store, "PLUS", yytext ) ; 
                    Tokens.PLUS(!pos,!col)
                );
"MINUS"   =>    (
                    col := !col + size yytext; 
                    attach (store, "MINUS", yytext ) ; 
                    Tokens.MINUS(!pos,!col)
                );
"TIMES"   =>    (
                    col := !col + size yytext; 
                    attach (store, "TIMES", yytext );
                    Tokens.TIMES(!pos,!col)
                );
"NEGATE"  =>    (
                    col := !col + size yytext; 
                    attach (store, "NEGATE", yytext );
                    Tokens.NEGATE(!pos,!col)
                );
"LESSTHAN"    =>(
                    col := !col + size yytext; 
                    attach (store, "LESSTHAN", yytext ); 
                    Tokens.LESSTHAN(!pos,!col)
                );
"GREATERTHAN" =>(
                    col := !col + size yytext; 
                    attach (store, "GREATERTHAN", yytext ); 
                    Tokens.GREATERTHAN(!pos,!col)
                );

"fn"      =>    (
                    col := !col + size yytext; 
                    attach (store, "FN", yytext ) ; 
                    Tokens.FN(!pos,!col)
                );

"fun"     =>    (
                    col := !col + size yytext; 
                    attach (store, "FUN", yytext ) ; 
                    Tokens.FUN(!pos,!col)
                );

"int"     =>    (
                    col := !col + size yytext; 
                    attach (store, "INT", yytext ) ; 
                    Tokens.INT(!pos,!col)
                );
"bool"    =>    (
                    col := !col + size yytext; 
                    attach (store, "BOOL", yytext );
                    Tokens.BOOL(!pos,!col)
                );
":"       =>    (
                    col := !col + size yytext; 
                    attach (store, "COLON", yytext ) ; 
                    Tokens.COLON(!pos,!col)
                );
"->"      =>    (
                    col := !col + size yytext; 
                    attach (store, "ARROW", yytext ) ; 
                    Tokens.ARROW(!pos,!col)
                );

"=>"      =>    (
                    col := !col + size yytext; 
                    attach (store, "DARROW", yytext ) ; 
                    Tokens.DARROW(!pos,!col)
                );

","       =>    (
                    col := !col + size yytext; 
                    attach (store, "COMMA", yytext ) ; 
                    Tokens.COMMA(!pos,!col)
                );

{alpha}+ =>     (
                    col := !col + size yytext;
                    attach (store, "ID", yytext ); 
                    Tokens.ID(yytext,!pos,!col)
                );
{numerals}+ => (
                    col := !col + size yytext;
                    attach (store, "NUM", yytext );
                    Tokens.NUM(List.foldl (fn (a,r) => ord(a) - ord(#"0") + 10*r) 0 (explode yytext),!pos, !pos)
                );

.        =>     (
                    col := !col + size yytext;
                    TextIO.output(TextIO.stdOut,"Unknown token:" ^ Int.toString(!pos) ^ ":" ^ Int.toString(!col) ^ ":" ^ yytext ^ ".\n");
                    lex()
                );
