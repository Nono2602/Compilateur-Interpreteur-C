#include "table_symboles.h"
#include <string.h>
#include <stdio.h>

int size = 0;
int profondeur_courante = 0;
variable table[MAX_SIZE_TABLE];

int add(char nom[MAX_SIZE_VAR], int type, char init, int profondeur) {
	strcpy(table[size].nom, nom);
	table[size].type = type;
	table[size].init = init;
	table[size].profondeur = profondeur;
	size++;
    return size-1;
}

int removeVar() {
	if(size > 0) {
		size--;
	}
	else {
		return -1;
	}
	return size;
}

int removeDepth() {
	int i;
	for(i = size-1; i >= 0; i--) {
		if(table[i].profondeur == profondeur_courante) {
			size--;
		}
		else {
			i = -1;
		}
	}
	return size;
}

variable* getWithIndex(int index) {
	if(index <= size) {
		return &(table[index]);
	}
}

variable* getWithName(char nom[MAX_SIZE_VAR]) {
	int i;	
	for(i = size-1; i > -1; i--) {
		if(strcmp(table[i].nom,nom) == 0) {
			return &(table[i]);
		}
	}
}

int indexof(char nom[MAX_SIZE_VAR]) {
	int i;	
	for(i = 0; i < size;i++) {
		if(strcmp(table[i].nom,nom) == 0) {
			return i;
		}
	}
    return -1;
}

int check_if_exists(char nom[MAX_SIZE_VAR]) {
	int adr;
	if((adr = indexof(nom)) != -1) {
		// elle est dans la table des symbole
		if(getWithIndex(adr)->profondeur <= profondeur_courante) {
			// elle est à la même profondeur			
			return adr;
		}
		else {
			return -1;
		}
	}
	else {
		return -1;
	}
}

int check_if_exists_with_depth(char nom[MAX_SIZE_VAR]) {
	int adr;
	if((adr = indexof(nom)) != -1) {
		// elle est dans la table des symbole
		if(getWithIndex(adr)->profondeur == profondeur_courante) {
			// elle est à la même profondeur			
			return adr;
		}
		else {
			return -1;
		}
	}
	else {
		return -1;
	}
}

void affiche_table() {
	int i;
	printf("Table des symboles\n");
	for(i = 0; i < size; i++) {
		printf("%s\t%d\t%d\t%d\n", table[i].nom, table[i].type, table[i].init, table[i].profondeur);
	}
}

int get_size() {
	return size;
}
