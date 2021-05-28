# COL226 Assignment3

#### Mustafa Chasmai 2019CS10341 

### Instructions for Use
~~~ 
make 
~~~
This will compile the code and generate files as done by the bool.lexer, bool.yacc and load-bool.sml.

After running this, the sml-nj editor will open. Run the command 

~~~
use "loader.sml";
~~~
This will define functions parseString and assignment3 that take as input a string.

Example usage:
1. 
~~~
assignment3("let x = 2 in x PLUS 2 end;");
~~~
Output: 

The Lexer Output is: 
[LET "let", ID "x", ASSIGN "=", NUM "2", IN "in", ID "x", PLUS "PLUS", NUM "2", END "end", TERM ";"]

The Parser output is: 
[LET (LET), ID (x), ASSIGN (=), NUM (2), RULE FORMULA : NUM ,  RULE RULE DECL :DECL : ID ASSIGN FORMULA , IN (IN), ID (x), RULE FORMULA : ID , PLUS (PLUS), NUM (2), RULE FORMULA : NUM , RULE FORMULA ::== FORMULA PLUS FORMULA , END (END), RULE FORMULA ::== LET DECL IN FORMULA END , TERM (;), RULE RULE STATEMENT::== FORMULA TERM ]

The type checking output is:
The expression is of type:  Integer

The Evaluator output is:
The answer of the expression is:  Integer value 4
val it = Answer [IntVal 4] : AST.value


2. 
~~~
val parsed_exp = parseString("TRUE AND TRUE;");
EVALUATOR.evalExp(parsed_exp, []);
Typing.getType(parsed_exp, []);
~~~

Output: 

The Lexer Output is: 
[CONST "TRUE", AND "AND", CONST "TRUE", TERM ";"]

The Parser output is: 
[CONST (TRUE), RULE FORMULA : CONST , AND (AND), CONST (TRUE), RULE FORMULA : CONST , RULE FORMULA ::== FORMULA AND FORMULA , TERM (;), RULE RULE STATEMENT::== FORMULA TERM ]
val parsed_exp = UniStatement (Term,BinExp (And,BoolExp true,BoolExp true))
  : BoolParser.result

val it = Answer [BoolVal true] : AST.value

val it = TupTy [BoolTy] : AST.typ


~~~ 
make clean
~~~
This will remove the generated files, leaving only the main files.

