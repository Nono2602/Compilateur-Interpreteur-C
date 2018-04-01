#include "table_funs.h"
#include <string.h>
#include <stdio.h>

int nb_funs = 0;
fun table_funs[MAX_NB_FUNS];

int add_fun(char nom[MAX_SIZE_FUN], int adr, int nb_params) {
	strcpy(table_funs[nb_funs].nom, nom);
	table_funs[nb_funs].adr = adr;
	table_funs[nb_funs].nb_params = nb_params;
	nb_funs++;
    return nb_funs-1;
}

fun* get_fun_with_index(int index) {
	if(index <= nb_funs) {
		return &table_funs[index];
	}
}

fun* get_fun_with_name(char nom[MAX_SIZE_FUN]) {
	int i;	
	for(i = nb_funs-1; i > -1; i--) {
		if(strcmp(table_funs[i].nom,nom) == 0) {
			return &table_funs[i];
		}
	}
}

int index_of_fun(char nom[MAX_SIZE_FUN]) {
	int i;	
	for(i = 0; i < nb_funs;i++) {
		if(strcmp(table_funs[i].nom,nom) == 0) {
			return i;
		}
	}
    return -1;
}

int check_if_fun_exists(char nom[MAX_SIZE_FUN]) {
	int adr;
	if((adr = index_of_fun(nom)) != -1) {
		return adr;
	}
	else {
		return -1;
	}
}

void affiche_table_funs() {
	int i;
	printf("Table des fonctions\n");
	for(i = 0; i < nb_funs; i++) {
		printf("%s\t%d\t%d\n", table_funs[i].nom, table_funs[i].adr, table_funs[i].nb_params);
	}
}
