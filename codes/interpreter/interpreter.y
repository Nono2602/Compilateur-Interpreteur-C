%{
#include <stdlib.h>
#include <stdio.h>

#define MAX_INSTR 1024
#define TAILLE_MEM 1024
#define NB_REG 11

#define LR 9
#define BP 10

#define TRUE 1
#define FALSE 0

#define PRINTF //

enum {NOP, LOAD, STORE, ADD, SUB, AFC, JMP, JMPC, JMPI, OR, AND, INF, INFE, SUP, SUPE, EQU, NEG, PRI, MOV};

char* TAG[] = {"NOP", "LOAD", "STORE", "ADD", "SUB", "AFC", "JMP", "JMPC", "JMPI", "OR", "AND", "INF", "INFE", "SUP", "SUPE", "EQU", "NEG", "PRI", "MOV"};

int instr[MAX_INSTR][4];
int IP = 0; // pointeur d'instruction
int instr_index = 0;

int reg[NB_REG];
int mem[TAILLE_MEM];

void yyerror(char *s);

void add_instr(int op, int a, int b, int c) {
	if(instr_index < MAX_INSTR-1) {
		instr[instr_index][0] = op;
		instr[instr_index][1] = a;
		instr[instr_index][2] = b;
		instr[instr_index][3] = c;
		instr_index++;
	}
	else {
		printf("Nombre d'instructions maximum dépassé."); exit(1);
	}
}

void afficher_registres() {
	int i;
	printf("Registres :\n");
	for(i = 0; i < NB_REG; i++) {
		printf("r%d\t%d\n",i,reg[i]);
	}
}

void afficher_memoire() {
	int i;
	printf("  Mémoire :\n  ");
	for(i = 0; i < 16; i++) {
		if (i % 16 == 0) {
			printf("\n  ");
		}
		printf("m%02d:%02d  ",i,mem[i]);
	}
	printf("\n");
}

void interprete_instrs() {
	reg[LR] = instr_index;
	reg[BP] = 0;
	while(IP < instr_index) {
		int a = instr[IP][1];
		int b = instr[IP][2];
		int c = instr[IP][3];
		int d = reg[BP];

		PRINTF("IP=%d   (LR=%d)  (BP=%d)\n", IP, reg[LR], reg[BP]);
		//afficher_memoire();
		switch (instr[IP][0]) {
			case NOP :
				// rien
				IP = IP + 1;
			break;
			case LOAD :
				reg[a] = mem[b + d];
				IP = IP + 1;
			break;
			case STORE :
				mem[a + d] = reg[b];
				IP = IP + 1;
			break;
			case ADD :
				reg[a] = reg[a] + reg[b];
				IP = IP + 1;
			break;
			case SUB :
				reg[a] = reg[a] - reg[b];
				IP = IP + 1;
			break;
			case NEG :
				reg[a] = !reg[a];
				IP = IP + 1;
			break;
			case AFC :
				reg[a] = b;
				IP = IP + 1;
			break;
			case JMP :
				IP = a;
			break;
			case JMPC :
				if(reg[b] == TRUE) {
					IP = a;
				} else {
					IP = IP + 1;
				}
			break;
			case JMPI :
				IP = reg[a];
			break;
			case OR :
				if(reg[a] || reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case AND :
				if(reg[a] && reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case INF :
				if(reg[a] < reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case INFE :
				if(reg[a] <= reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case SUP :
				if(reg[a] > reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case SUPE :
				if(reg[a] >= reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case EQU :
				if(reg[a] == reg[b]) {
					reg[a] = TRUE;
				} else {
					reg[a] = FALSE;
				}
				IP = IP + 1;
			break;
			case PRI :
				printf("HERE : %d\n", reg[a]);
				IP = IP + 1;
			break;
			case MOV :
				reg[a] = reg[b];
				IP = IP + 1;
			break;
		}
	}
}
%}
%union { int nb; char var[16]; }
%token tNOP tLOAD tSTORE tADD tSUB tAFC tJMP tJMPC tJMPI tOR tAND tINF tINFE tSUP tSUPE tEQU tNEG tPRI tMOV
%token <nb> tNB
%start Prg
%%

Prg : Instrs;
Instrs : Instr Instrs | ;
Instr : 
	tNOP tNB tNB tNB { add_instr(NOP, $2, $3, $4); }
	| tLOAD tNB tNB tNB { add_instr(LOAD, $2, $3, $4); }
	| tSTORE tNB tNB tNB { add_instr(STORE, $2, $3, $4); }
	| tADD tNB tNB tNB { add_instr(ADD, $2, $3, $4);}
	| tSUB tNB tNB tNB { add_instr(SUB, $2, $3, $4); }
	| tAFC tNB tNB tNB { add_instr(AFC, $2, $3, $4); }
	| tJMP tNB tNB tNB { add_instr(JMP, $2, $3, $4); }
	| tJMPC tNB tNB tNB { add_instr(JMPC, $2, $3, $4); }
	| tJMPI tNB tNB tNB { add_instr(JMPI, $2, $3, $4); }
	| tOR tNB tNB tNB { add_instr(OR, $2, $3, $4); }
	| tAND tNB tNB tNB { add_instr(AND, $2, $3, $4); }
	| tINF tNB tNB tNB { add_instr(INF, $2, $3, $4); }
	| tINFE tNB tNB tNB { add_instr(INFE, $2, $3, $4); }
	| tSUP tNB tNB tNB { add_instr(SUP, $2, $3, $4); }
	| tSUPE tNB tNB tNB { add_instr(SUPE, $2, $3, $4); }
	| tNEG tNB tNB tNB { add_instr(NEG, $2, $3, $4); }
	| tEQU tNB tNB tNB { add_instr(EQU, $2, $3, $4); }
	| tPRI tNB tNB tNB { add_instr(PRI, $2, $3, $4); }
	| tMOV tNB tNB tNB { add_instr(MOV, $2, $3, $4); } ;

%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(void) {
	printf("Code\n"); // yydebug =1;
	yyparse ();
	interprete_instrs();
	return 0;
}


