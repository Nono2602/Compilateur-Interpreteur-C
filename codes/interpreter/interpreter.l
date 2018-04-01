%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

blancs [ \t\n]+ 
nb [0-9]+ 

%%

{blancs} {}
{nb} {
	yylval.nb = atoi(yytext);
	return tNB;
}

"NOP"	return tNOP;
"LOAD"	return tLOAD;
"STORE"	return tSTORE;
"ADD"	return tADD;
"SUB"	return tSUB;
"AFC"	return tAFC;
"JMP"	return tJMP;
"JMPC"	return tJMPC;
"JMPI"	return tJMPI;
"OR"	return tOR;
"AND"	return tAND;
"INF"	return tINF;
"INFE"	return tINFE;
"SUP"	return tSUP;
"SUPE"	return tSUPE;
"EQU"	return tEQU;
"NEG"	return tNEG;
"PRI"	return tPRI;
"MOV"	return tMOV;
