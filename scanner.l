/* Hayden Migliore
   CMSC 430 6980
   July 12th, 2019
   Scanner.l list of tokens and lexemes*/
   
/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
comment2	\/\/.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
real		([0-9]+)(\.?[0-9]+)([eE][-+]?[0-9]+)?
bool		true|false
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{real}		{ ECHO; yylval.value = atoi(yytext); return(REAL_LITERAL);}
{bool}		{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL);}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEREQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUB; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
if		{ ECHO; return(IF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
or		{ ECHO; return(OROP); }
rem		{ ECHO; yylval.oper = REM; return(REMOP); }
"**"		{ ECHO; yylval.oper = EXP; return(EXPOP); }
"=>"		{ ECHO; yylval.oper = ARROW; return(ARROWOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
