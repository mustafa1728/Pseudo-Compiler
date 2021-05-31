# Pseudo-Compiler

An sml based project that parses, checks types and evaluates a limited-scope programming language.

Part of assignments for the course COL226: Programming Languages in second semester 2021, IIT Delhi.

## Problem Statements

The problem statements corresponding to these assignments can be found here: [assignment2](ProblemStatements/statement1.pdf) and [assignment3](ProblemStatements/statement1.pdf).

## Details of the compiler

The compiler was built to lex, parse, type-check and evaluate a language very similar to sml. The scope was constrained to consider only integer, boolean and string operations. 

1. Supports integer, boolean and string data types
2. Supports simple arithmetic (NEGATE, +, -, x) and boolean operations (AND, NOT, OR, XOR)
3. Suports if...then...else...fi type conditional statements
4. Supports let...in...end type declaration function
2. Supports simple one argument functions

## Instructions for use

Clone the repo, go into the src directory and then, `make run`.

More detailed instructions can be found inside the src directory [readme](src/README.md).
