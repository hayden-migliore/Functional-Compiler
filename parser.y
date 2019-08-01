/* Hayden Migliore
   CMSC 430 6980
   July 12th, 2019
   Parser.y basis for syntax analyzer*/

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;

%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP ARROWOP
%token ANDOP OROP

%token BEGIN_ BOOLEAN CASE ELSE END ENDCASE ENDIF ENDREDUCE FUNCTION INTEGER 
%token IF IS NOT OTHERS REAL REDUCE RETURNS THEN WHEN

%type <value> body statement_ statement reductions expression expression2 relation relation2 relation3 term
	factor primary
%type <oper> operator

%%

function:	
	function_header_ variables2 body {result = $3;} ;

function_header_:
	function_header |
	error ';' ;
	
function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' ;

parameters:
	parameter optional_parameter ;
	
optional_parameter:
	',' parameter |
	;

parameter:
	IDENTIFIER ':' type ;

variables2:
	variables optional_variable ;

variables:
	variable optional_variable |
	error ';' ;

optional_variable:
	variable |
	;	
	
variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2;} |
	CASE expression IS cases OTHERS ARROWOP statement_ ENDCASE {$$ = $2;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

cases:
	case optional_case ;
	
optional_case:
	case |
	;

case:
	WHEN INT_LITERAL ARROWOP statement_ ;
	
expression:
	expression ANDOP expression2 {$$ = $1 && $3;} |
	expression2 ;
	
expression2:
	expression2 OROP relation {$$ = $1 || $3;} |
	relation ;

relation:
	relation RELOP relation2 {$$ = evaluateRelational($1, $2, $3);} |
	relation2 ;
	
relation2:
	relation2 REMOP relation3 {$$ = evaluateArithmetic($1, $2, $3);} |
	relation3 ;
	
relation3:
	relation3 EXPOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	NOT expression {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |	
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
