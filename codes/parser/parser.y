%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "table_symboles.h"
#include "table_funs.h"

#define MAX_INSTR 2048

#define LR 9
#define BP 10

// define all operators
enum {NOP, LOAD, STORE, ADD, SUB, AFC, JMP, JMPC, JMPI, OR, AND, INF, INFE, SUP, SUPE, EQU, NEG, PRI, MOV};

char* TAG[] = {"NOP", "LOAD", "STORE", "ADD", "SUB", "AFC", "JMP", "JMPC", "JMPI", "OR", "AND", "INF", "INFE", "SUP", "SUPE", "EQU", "NEG", "PRI", "MOV"};

extern int profondeur_courante;
void yyerror(char *s);

int instr[MAX_INSTR][4]; //tableau pour stocker les instructions
int instr_index = 0; //connaitre la taille du tableau

int num_arg = 0;

/*
Modifie la destination d'un jump (if et while)
*/
void set_dest_jump(int pos_inst, int dest) {
	instr[pos_inst][1] = dest;
}

/*
Ajout d'une instruction dans le tableau
*/
void add_instr(int op, int a, int b, int c) {
	if(instr_index < MAX_INSTR-1) {
		instr[instr_index][0] = op;
		instr[instr_index][1] = a;
		instr[instr_index][2] = b;
		instr[instr_index][3] = c;
		instr_index++;
	}
	else {
		yyerror("Nombre d'instructions maximum dépassé."); exit(1);
	}
}

/*
Ajout d'instructions dans le tableau pour les calculs
*/
int op_arithm(int op, int a, int b) {
	add_instr(LOAD, 1, a, 0);
	add_instr(LOAD, 0, b, 0);
	add_instr(op, 1, 0, 0);
	add_instr(STORE, a, 1, 0);
	removeVar();
	return a;
}

// Multiplication
int add_mul(int a, int b) {
	add_instr(LOAD, 0, a, 0);
	add_instr(MOV, 4, 0, 0); // sauvegarde de a pour les calculs
	add_instr(LOAD, 1, b, 0);
	add_instr(AFC, 2, 1, 0); // reg[2] = 1 pratique pour les calculs
	add_instr(MOV, 3, 1, 0);
	add_instr(INFE, 3, 2, 0);
	add_instr(JMPC, instr_index + 4, 3, 0);
	add_instr(ADD, 0, 4, 0);
	add_instr(SUB, 1, 2, 0);
	add_instr(JMP, instr_index - 5, 0, 0);
	add_instr(STORE, a, 0, 0);
	return a;
}

// Division
int add_div(int a, int b) {
	add_instr(AFC, 5, 1, 0); // temp = 1
	add_instr(AFC, 6, 1, 0); // pour le ++
	add_instr(MOV, 7, 5, 0);
	add_instr(LOAD, 0, a, 0);
	add_instr(LOAD, 1, b, 0);
	int c = add("_",TYPE_INT,IS_INIT,profondeur_courante);
	int d = add("_",TYPE_INT,IS_INIT,profondeur_courante);
	add_instr(STORE, c, 1, 0);
	add_instr(STORE, d, 7, 0);
	add_mul(c, d);
	add_instr(LOAD, 0, a, 0);
	add_instr(LOAD, 3, c, 0);
	add_instr(MOV, 8 , 3, 0); // sauvregarde pour test à la fin
	removeVar();removeVar();
	add_instr(SUPE, 3, 0, 0);
	add_instr(JMPC, instr_index + 3, 3, 0);
	add_instr(ADD, 5, 6, 0); // ++
	add_instr(JMP, instr_index - 22, 0, 0); // attention à bien bouger lui si on rajoute des lignes, prendre en comptes les add_mul !!!!!!!!!!	
	add_instr(INFE, 8, 0, 0); // si on a pas dépassé
	add_instr(JMPC, instr_index + 2, 8, 0);
	add_instr(SUB, 5, 6, 0);
	add_instr(STORE, a, 5, 0);
	return a;
}

/*
Affiche le tableau
*/
void affiche_instrs() {
	int i;
	printf("Instructions\n");
	for(i = 0; i < instr_index; i++) {
		printf("%d>\t%s\t%d\t%d\t%d\n", i, TAG[instr[i][0]], instr[i][1], instr[i][2], instr[i][3]);
	}
}

/*
Affiche le tableau dans un fichier
*/
void instrs_to_file(char *fileName) {
	int i;
	FILE* file = fopen(fileName, "w");
	for(i = 0; i < instr_index; i++) {
		fprintf(file,"%s\t%d\t%d\t%d\n", TAG[instr[i][0]], instr[i][1], instr[i][2], instr[i][3]);
	}
}

/*
Affiche le tableau dans un fichier en hexa
*/
void instrs_to_file_hex(char *fileName) {
	int i;
	FILE* file = fopen(fileName, "w");
	for(i = 0; i < instr_index; i++) {
		if(instr[i][0] == AFC || instr[i][0] == LOAD) { // if AFC or LOAD
			fprintf(file, "%02x%02x%04x\n", instr[i][0], instr[i][1], instr[i][2]);
		}
		else if(instr[i][0] == JMP) { // if JMP
				fprintf(file, "%02x%04x%02x\n", instr[i][0], instr[i][1], 0);
		}
		else if(instr[i][0] == STORE || instr[i][0] == JMPC) { // if STORE
				fprintf(file, "%02x%04x%02x\n", instr[i][0], instr[i][1], instr[i][2]);
		}
		else {
			fprintf(file, "%02x%02x%02x%02x\n", instr[i][0], instr[i][1], instr[i][2], instr[i][3]);
		}
	}
}

%}
%union { int nb; char var[16];}
%token tEGAL tPO tPF tMOINS tPLUS tSTAR tDIV tMOD tRETURN tPRINTF
%token tELSE tINT tOR tAND tVIR tPVIR tACO tACF
%token tEGEG tINF tINFEG tSUP tSUPEG
%token <nb> tNB tIF tWHILE
%token <var> tID tMAIN 
%start Prg
//Mettre en place les priorités, régler les conflits
%right tEGAL
%left tMAIN
%left tID
%left tAND tOR
%left tSUP tINF tSUPEG tINFEG tEGEG
%left tPLUS tMOINS
%left tSTAR tDIV tMOD
%left tPO tPF
%type <nb> E Invoc ParamsNext Params
%type <var> FunName
%%
Prg :		Fonction Prg | ;
Fonction :	tINT FunName {num_arg = 0;} tPO Args tPF { add_fun($2,instr_index,num_arg); } BodyReturn ;
FunName : 	tMAIN {strcpy($$, $1); printf("main at %d\n", instr_index); set_dest_jump(0, instr_index); /*sauter dans le main au début du prog*/ } | tID {strcpy($$, $1);};

Args :		Arg ListeArgs | { printf("Fin des args.\n"); };
ListeArgs :	tVIR Arg ListeArgs | { printf("Fin des args.\n"); };
Arg :		tINT tID {
				add($2,TYPE_INT,IS_INIT,profondeur_courante+1);
				num_arg++;
			};

BodyReturn :	tACO { profondeur_courante++; } Instrcs Return tACF { removeDepth(); profondeur_courante--; };
Body :			tACO { profondeur_courante++; } Instrcs tACF { removeDepth(); profondeur_courante--; };
Instrcs :		Instr Instrcs | ;
Instr :			Decl | If | While | Affect | Invoc tPVIR { removeVar(); } | Print ;

Return :	tRETURN E tPVIR {
				printf("Return\n");
				add_instr(LOAD, 0, $2, 0);
				removeVar(); // remove du E

				add_instr(JMPI, LR, 0, 0);
				removeVar(); // remove lr
			};

Decl :		tINT DeclX tPVIR ;
DeclX :		Decl1 | Decl1 tVIR DeclX;
Decl1 :		tID {
					if(check_if_exists_with_depth($1) == -1) {
							add($1,TYPE_INT,NOT_INIT,profondeur_courante);
					}
					else {
						fprintf(stderr, "La variable %s est déjà déclarée\n", $1); exit(1);
					}
				}
			| tID tEGAL E {
					removeVar();
					if(check_if_exists_with_depth($1) == -1) {
						int dst = add($1,TYPE_INT,IS_INIT,profondeur_courante);
					}
					else {
						fprintf(stderr, "La variable %s est déjà déclarée\n", $1); exit(1);
					}
				};

Affect :	tID tEGAL E tPVIR {
					removeVar();
					int adr;
					if((adr = check_if_exists($1)) != -1) {
						getWithIndex(adr)->init = IS_INIT;
						add_instr(LOAD, 0, $3, 0); //récupère le calcul de droite
						add_instr(STORE, adr, 0, 0); //stocke dans la variable souhaitee
					}
					else {
						fprintf(stderr, "La variable %s n'est pas déclarée\n",$1); exit(1);
					}
				};

Print : tPRINTF tPO E tPF tPVIR
	{
				add_instr(LOAD, 0, $3,0);
				add_instr(PRI, 0, 0, 0);
				removeVar(); // remove du E
	};

Invoc :		tID {
				if(check_if_fun_exists($1) != -1) {
					profondeur_courante++;
					//Sauvegarde de lr
					int adr = add("lr", TYPE_INT, IS_INIT, profondeur_courante);
					add_instr(STORE, adr, LR, 0);
				} else {
					fprintf(stderr, "La fonction %s n'existe pas\n",$1);
					exit(1);
				}
			} tPO Params tPF { if($4 != get_fun_with_name($1)->nb_params) {
					fprintf(stderr, "Nombre d'arguments incorrecte : %d != %d\n", $4, get_fun_with_name($1)->nb_params);
					exit(1);
				}
				printf("Invoc. de %s\n", $1);
				add_instr(AFC, 4, get_size() - $4, 0); // 4 : un registre qu'on utilise pas
				add_instr(ADD, BP, 4, 0);
				int adr = get_fun_with_name($1)->adr;
				add_instr(AFC, LR, instr_index + 2, 0); // nouveau lr
				add_instr(JMP, adr, 0, 0);
				add_instr(AFC, 4, get_size() - $4, 0);
				add_instr(SUB, BP, 4, 0);
				add_instr(LOAD, LR, indexof("lr"),0); // restaure de lr
				removeDepth();
				int dst = add("_",TYPE_INT,IS_INIT,profondeur_courante);
				add_instr(STORE, dst, 0, 0);
				$$ = dst;
				profondeur_courante--;
			};

Params :	Param { $$ = 1; } | Param tVIR ParamsNext { $$ = 1 + $3; } | { printf("Fin des params.\n"); $$ = 0; };
ParamsNext :	Param { $$ = 1; } | Param tVIR ParamsNext { $$ = 1 + $3; };
Param :		E ;

If :	tIF tPO E tPF {
				add_instr(LOAD, 0, $3, 0);
				add_instr(NEG, 0, 0, 0);
				add_instr(JMPC, -1, 0, 0);
				$1 = instr_index - 1; //modif la destination du JMP, save l'emplacement du JMP a modifier
			} Body {
				set_dest_jump($1, instr_index+1); // +1 car il faut aussi sauter le JMP ajouté juste après
				add_instr(JMP, -1, 0, 0);
				$1 = instr_index - 1;
				removeVar(); // remove du E
			} Else {
				set_dest_jump($1, instr_index); 
			};

Else : tELSE Body | ;

While : tWHILE tPO { $1 = instr_index; } E tPF {
				add_instr(LOAD, 0, $4, 0);
				add_instr(NEG, 0, 0, 0);
				add_instr(JMPC, -1, 0, 0);
				$4 = instr_index - 1;
			} Body {
				set_dest_jump($4, instr_index+1); // +1 car il faut aussi sauter le JMP ajouté juste après
				add_instr(JMP, $1, 0, 0);
				removeVar(); // remove du E
			};

E :	tPO E tPF { $$ = $2; }
	| tNB {
			add_instr(AFC, 0, $1, 0);
			int dst = add("_",TYPE_INT,IS_INIT,profondeur_courante);
			add_instr(STORE, dst, 0, 0);
			$$ = dst;
		}
	| tID {
			int adr;
			if((adr = check_if_exists($1)) != -1) {
				if(getWithIndex(adr)->init == IS_INIT) {
					add_instr(LOAD, 0, adr, 0);
					int dst = add("_",TYPE_INT,IS_INIT,profondeur_courante);
					add_instr(STORE, dst, 0, 0);
					$$ = dst;
				}
				else {
					fprintf(stderr, "La variable %s n'est pas initialisée\n", $1); exit(1); // ou pas exit
				}
			}
			else {
				fprintf(stderr, "La variable %s n'est pas déclarée\n", $1); exit(1);
			}
		}
	| Invoc {
			$$ = $1;
		}
	| E tPLUS E { $$ = op_arithm(ADD, $1, $3); }
	| E tMOINS E { $$ = op_arithm(SUB, $1, $3); }
	| E tSTAR E { $$ = add_mul($1, $3); }
	| E tDIV E { $$ = add_div($1, $3); }
	| E tOR E { $$ = op_arithm(OR, $1, $3); }
	| E tAND E { $$ = op_arithm(AND, $1, $3); }
	| E tMOD E {
			add_instr(LOAD, 0, $1, 0); 
			add_instr(LOAD, 1, $3, 0);
			add_instr(LOAD, 2, $1, 0);
			add_div(2, 1);
			add_mul(1, 2);
			add_instr(SUB, 0, 3, 0);
			$$ = $1;
		}
	| E tEGEG E { $$ = op_arithm(EQU, $1, $3); }
	| E tSUP E { $$ = op_arithm(SUP, $1, $3); }
	| E tINF E { $$ = op_arithm(INF, $1, $3); }
	| E tSUPEG E { $$ = op_arithm(SUPE, $1, $3); }
	| E tINFEG E { $$ = op_arithm(INFE, $1, $3); } ; 

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(void) {
	printf("Code\n"); // yydebug =1;
	add_instr(JMP,0,0,0);
	yyparse ();
	affiche_instrs();
	instrs_to_file("out");
	instrs_to_file_hex("out_hexa.hex");
	return 0;
}
