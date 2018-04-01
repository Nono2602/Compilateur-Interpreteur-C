%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

blancs [ \t\n]+ 
nb [0-9]+ 
id [a-z]([a-z]?[0-9]?_?)*

%%

{blancs} {}
{nb} {
	yylval.nb = atoi(yytext);
	return tNB;
}

"="	return tEGAL;
"-"	return tMOINS;
"+"	return tPLUS;
"*"	return tSTAR;
"%"	return tMOD;
"/"	return tDIV;
"("	return tPO;
")"	return tPF;
"if"	return tIF;
"else"	return tELSE;
"while"	return tWHILE;
"int"	return tINT;
"return" return tRETURN;
"printf" return tPRINTF;
"main" {
	strcpy(yylval.var, yytext);
	return tMAIN;
};
{id} {
	if(strlen(yytext) >= sizeof(yylval.var)-1) {
		fprintf(stderr,"Variable trop longue\n");
		exit(1);
	}
	strcpy(yylval.var, yytext);
	return tID;
}
"\|\|"	return tOR;
"=="	return tEGEG;
"&&"	return tAND;
","	return tVIR;
";"	return tPVIR;
"{"	return tACO;
"}"	return tACF;
">"	return tSUP;
"<"	return tINF;
">="	return tSUPEG;
"<="	return tINFEG;
