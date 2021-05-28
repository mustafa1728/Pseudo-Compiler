(* User  declarations *)

fun tail ([]) = []
  | tail([x]) = []
  | tail(x::xs) = x::tail(xs)

fun first( ( x , _ ) ) = x

fun second ( ( _ , x ) ) = x

%%
(* required declarations *)
%name Bool

%term
	ID of string | 
	CONST of bool | 
	TRUE      |  
	FALSE     | 

	TERM      | 
	EOF       | 
	RPAREN    | 
	LPAREN    | 

	IF        | 
	THEN      |   
	ELSE      | 
	FI 		  | 

	AND       | 
	OR        | 
	XOR       | 
	NOT       |
	IMPLIES   |  
	EQUALS    |

	ASSIGN 	  | 
	
	LET 	  | 
	IN 		  | 
	END 	  | 

	PLUS 	  | 
	MINUS 	  | 
	NEGATE 	  | 
	TIMES 	  | 
	GREATERTHAN | 
	LESSTHAN  | 
	NUM of int|

	FN 		  | 	
	FUN 	  | 
	ARROW 	  | 
	DARROW 	  | 
	COLON 	  | 
	COMMA 	  | 
	INT 	  | 
	BOOL


%nonterm  
	START of AST.exp 				| 
	STATEMENT of string * AST.exp 	| 
	FORMULA of string * AST.exp 	| 
	DECL of string * AST.decl 		|
	Type of string * AST.typ

%pos int

(*optional declarations *)

%eop EOF
%noshift EOF

(* %header  *)

%nonassoc ASSIGN
%nonassoc DARROW
%nonassoc GREATERTHAN LESSTHAN

%right ARROW
%right IF THEN ELSE
%right IMPLIES
%left OR AND XOR EQUALS
%right NOT

%left PLUS MINUS
%left TIMES
%right NEGATE


%start START

%verbose

%%

START: STATEMENT 
	(print ( "\nThe Parser output is: \n[" ^ implode( tail ( tail ( explode ( first (STATEMENT) ) ) ) ) ^ "]\n" ); second (STATEMENT) )


STATEMENT : STATEMENT FORMULA  TERM 
	( (first(STATEMENT) ^ first(FORMULA) ^  "TERM (;), " ^ "RULE RULE STATEMENT::== STATEMENT FORMULA  TERM , " , AST.MultiStatement( second(STATEMENT) , AST.UniStatement(AST.Term , second(FORMULA)) ) ) )
| FORMULA TERM 
	( (first(FORMULA) ^ "TERM (;), " ^ "RULE RULE STATEMENT::== FORMULA TERM , " , AST.UniStatement(AST.Term , second(FORMULA) ) )  )



DECL : ID ASSIGN FORMULA 
	( ("ID (" ^ ID ^ "), " ^ "ASSIGN (=), " ^ first(FORMULA) ^ " RULE RULE DECL :DECL : ID ASSIGN FORMULA , " , AST.ValDecl(ID, second(FORMULA) ) ) )
    



FORMULA : IF FORMULA THEN FORMULA ELSE FORMULA FI 
	( ("IF (IF), " ^ first(FORMULA1) ^ "THEN (THEN), "^ first(FORMULA2) ^ "ELSE (ELSE), " ^ first(FORMULA3) ^ "FI (FI), " ^ "RULE FORMULA ::== IF FORMULA THEN FORMULA ELSE FORMULA FI , " , AST.IfThenElseExp( second(FORMULA1) ,second(FORMULA2) ,second(FORMULA3) ) ) )
| FORMULA OR FORMULA 
	( (first(FORMULA1) ^ "OR (OR), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA OR FORMULA , ", AST.BinExp( AST.Or,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA AND FORMULA 
	( (first(FORMULA1) ^ "AND (AND), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA AND FORMULA , ", AST.BinExp( AST.And,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA EQUALS FORMULA 
	( (first(FORMULA1) ^ "EQUALS (EQUALS), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA EQUALS FORMULA , ", AST.BinExp( AST.Eq,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA XOR FORMULA 
	( (first(FORMULA1) ^ "XOR (XOR), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA XOR FORMULA , ", AST.BinExp( AST.Xor,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA IMPLIES FORMULA 
	( (first(FORMULA1) ^ "IMPLIES (IMPLIES), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA IMPLIES FORMULA , ", AST.BinExp( AST.Implies,second(FORMULA1),second(FORMULA2) ) ) )
| LPAREN FORMULA RPAREN 
	( ("LPAREN \"(\" , " ^ first(FORMULA) ^ "RPAREN \")\" , RULE FORMULA ::== LPAREN FORMULA RPAREN , ", second(FORMULA) ) )
| NOT FORMULA 
	( ("NOT (NOT), " ^ first(FORMULA) ^ "RULE FORMULA ::== NOT FORMULA , ", AST.UniExp( AST.Not,second(FORMULA) ) ) )
| FORMULA PLUS FORMULA 
	( (first(FORMULA1) ^ "PLUS (PLUS), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA PLUS FORMULA , ", AST.BinExp(AST.Add,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA MINUS FORMULA 
	( (first(FORMULA1) ^ "MINUS (MINUS), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA MINUS FORMULA , ", AST.BinExp(AST.Sub,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA TIMES FORMULA 
	( (first(FORMULA1) ^ "TIMES (TIMES), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA TIMES FORMULA , ", AST.BinExp(AST.Mul,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA LESSTHAN FORMULA 
	( (first(FORMULA1) ^ "LESSTHAN (LESSTHAN), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA LESSTHAN FORMULA , ", AST.BinExp(AST.Less,second(FORMULA1),second(FORMULA2) ) ) )
| FORMULA GREATERTHAN FORMULA 
	( (first(FORMULA1) ^ "GREATERTHAN (GREATERTHAN), " ^ first(FORMULA2) ^ "RULE FORMULA ::== FORMULA GREATERTHAN FORMULA , ", AST.BinExp(AST.Great,second(FORMULA1),second(FORMULA2) ) ) )
| NEGATE FORMULA 
	( ("NEGATE (NEGATE), " ^ first(FORMULA) ^ "RULE FORMULA ::== NEGATE FORMULA , ", AST.UniExp( AST.Negate,second(FORMULA) ) ) )
| LET DECL IN FORMULA END 
	( ("LET (LET), " ^ first(DECL) ^ "IN (IN), "^ first(FORMULA) ^ "END (END), " ^ "RULE FORMULA ::== LET DECL IN FORMULA END , " , AST.LetExp(second(DECL),second(FORMULA)) ) )
| ID 
	( ( "ID (" ^ ID ^ "), " ^ "RULE FORMULA : ID , " , AST.VarExp(ID) ) )
| NUM 
	( ( "NUM (" ^ (if ( NUM < 0 ) then "-"^Int.toString(~NUM) else Int.toString(NUM)) ^ "), " ^ "RULE FORMULA : NUM , " , AST.NumExp(NUM) ) )
| CONST 
	( ( "CONST (" ^ (if (CONST) then "TRUE" else "FALSE") ^ "), " ^ "RULE FORMULA : CONST , " , AST.BoolExp(CONST) ) )
| FN LPAREN ID COLON Type RPAREN COLON Type DARROW FORMULA 
	("RULE fn, ",(AST.FnExp(ID,second(Type1),second(Type2), second(FORMULA) ) ))
| FUN ID LPAREN ID COLON Type RPAREN COLON Type DARROW FORMULA 
	("RULE fun, ",(AST.FunExp(ID1, ID2,second(Type1) , second(Type2), second(FORMULA) ) ))
| LPAREN FORMULA FORMULA RPAREN 
	( ("RULE APP, ",AST.AppExp (second(FORMULA1) , second(FORMULA2) ) ) )




Type : Type ARROW Type ( ( first(Type1) ^ "ARROW \"->\", " ^ first(Type2) ^ "RULE Type ::== Type ARROW Type , ", AST.FnTy( second(Type1) , second(Type2) ) ) )
(*  | Type TIMES Type ( ( first(Type1) ^ "TIMES \"*\", " ^ first(Type2) ^ "RULE Type ::== Type TIMES Type , ", AST.TupTy( second(Type1) , second(Type2) ) ) ) *)
  | INT ( ( "INT_TYPE " ^ "RULE Type : INT , "  ,AST.IntTy)  )
  | BOOL ( ( "BOOL_TYPE " ^ "RULE Type : BOOL , "  ,AST.BoolTy)  )
  | LPAREN Type RPAREN ( ( "LPAREN \"(\", " ^ first(Type) ^ "RPAREN \")\", " ^ "RULE Type ::== LPAREN Type RPAREN , ", second(Type) ) )
