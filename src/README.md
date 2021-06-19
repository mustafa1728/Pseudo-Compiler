# Instructions for Use

### Building 
~~~ 
make 
~~~
This will compile the code and generate files as done by the bool.lexer, bool.yacc and load-bool.sml.

After running this, the sml-nj editor will open. Run the command 

~~~
use "loader.sml";
~~~
This will define functions parseString and assignment3 that take as input a string.

### Example usage 1:
~~~
compileFile("T1");
~~~
Output: 

~~~
The input program is: 
3 MINUS 2 PLUS 3 TIMES 2;
let X = 1 in
    if X EQUALS 2 then 3 else 4 fi
end;

The Lexer Output is: 
[NUM "3", MINUS "MINUS", NUM "2", PLUS "PLUS", NUM "3", TIMES "TIMES", NUM "2", TERM ";", LET "let", ID "X", ASSIGN "=", NUM "1", IN "in", IF "if", ID "X", 
EQUALS "EQUALS", NUM "2", THEN "then", NUM "3", ELSE "else", NUM "4", FI "fi", END "end", TERM ";"]

The Parser output is: 
[NUM (3), RULE FORMULA : NUM , MINUS (MINUS), NUM (2), RULE FORMULA : NUM , RULE FORMULA ::== FORMULA MINUS FORMULA , PLUS (PLUS), NUM (3), RULE FORMULA : NUM ,
TIMES (TIMES), NUM (2), RULE FORMULA : NUM , RULE FORMULA ::== FORMULA TIMES FORMULA , RULE FORMULA ::== FORMULA PLUS FORMULA , TERM (;), RULE RULE STATEMENT::== 
FORMULA TERM , LET (LET), ID (X), ASSIGN (=), NUM (1), RULE FORMULA : NUM ,  RULE RULE DECL :DECL : ID ASSIGN FORMULA , IN (IN), IF (IF), ID (X), RULE FORMULA : 
ID , EQUALS (EQUALS), NUM (2), RULE FORMULA : NUM , RULE FORMULA ::== FORMULA EQUALS FORMULA , THEN (THEN), NUM (3), RULE FORMULA : NUM , ELSE (ELSE), NUM (4), 
RULE FORMULA : NUM , FI (FI), RULE FORMULA ::== IF FORMULA THEN FORMULA ELSE FORMULA FI , END (END), RULE FORMULA ::== LET DECL IN FORMULA END , TERM (;), RULE 
RULE STATEMENT::== STATEMENT FORMULA  TERM ]

The type checking output is:
The expression is of type: Integer; Integer

The Evaluator output is:
The answer of the expression is: (Integer value) 7; (Integer value) 4

val it = Answer [IntVal 4,IntVal 7] : AST.value
~~~

### Example usage 2:
~~~
compileFile("T2");
~~~

Output: 
~~~ 
The input program is: 
if 3 GREATERTHAN 2
    then let X = TRUE in
        X AND NOT X
        end
    else TRUE
fi;
let
    f = fn (x:int) : int => x PLUS 1
in
    (f 3)
end;

The Lexer Output is: 
[IF "if", NUM "3", GREATERTHAN "GREATERTHAN", NUM "2", THEN "then", LET "let", ID "X", ASSIGN "=", CONST "TRUE", IN "in", ID "X", AND "AND", NOT "NOT", ID "X", 
END "end", ELSE "else", CONST "TRUE", FI "fi", TERM ";", LET "let", ID "f", ASSIGN "=", FN "fn", LPAREN "(", ID "x", COLON ":", INT "int", RPAREN ")", COLON ":", 
INT "int", DARROW "=>", ID "x", PLUS "PLUS", NUM "1", IN "in", LPAREN "(", ID "f", NUM "3", RPAREN ")", END "end", TERM ";"]

The Parser output is: 
[IF (IF), NUM (3), RULE FORMULA : NUM , GREATERTHAN (GREATERTHAN), NUM (2), RULE FORMULA : NUM , RULE FORMULA ::== FORMULA GREATERTHAN FORMULA , THEN (THEN), LET 
(LET), ID (X), ASSIGN (=), CONST (TRUE), RULE FORMULA : CONST ,  RULE RULE DECL :DECL : ID ASSIGN FORMULA , IN (IN), ID (X), RULE FORMULA : ID , AND (AND), NOT 
(NOT), ID (X), RULE FORMULA : ID , RULE FORMULA ::== NOT FORMULA , RULE FORMULA ::== FORMULA AND FORMULA , END (END), RULE FORMULA ::== LET DECL IN FORMULA END , 
ELSE (ELSE), CONST (TRUE), RULE FORMULA : CONST , FI (FI), RULE FORMULA ::== IF FORMULA THEN FORMULA ELSE FORMULA FI , TERM (;), RULE RULE STATEMENT::== FORMULA 
TERM , LET (LET), ID (f), ASSIGN (=), RULE fn,  RULE RULE DECL :DECL : ID ASSIGN FORMULA , IN (IN), RULE APP, END (END), RULE FORMULA ::== LET DECL IN FORMULA 
END , TERM (;), RULE RULE STATEMENT::== STATEMENT FORMULA  TERM ]

The type checking output is:
The expression is of type: Boolean; Integer

The Evaluator output is:
The answer of the expression is: (Boolean Value) FALSE; (String value) <The Function Return Value>

val it = Answer [StringVal "<The Function Return Value>",BoolVal false]
  : AST.value
~~~ 

### Cleaning

~~~ 
make clean
~~~
This will remove the generated files, leaving only the main files.

