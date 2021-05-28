all:
	$(info After this, please run 'use "loader.sml";' in sml)
	@ml-lex bool.lex 
	@ml-yacc bool.yacc 
	rlwrap sml
clean:
	rm bool.lex.sml
	rm bool.yacc.desc
	rm bool.yacc.sig
	rm bool.yacc.sml