#ifndef TABLE_SYMB_H
#define TABLE_SYMB_H

#define MAX_SIZE_VAR 16
#define MAX_SIZE_TABLE 1024

#define TYPE_INT 1

#define IS_INIT 1
#define NOT_INIT 0

typedef struct variable {
	char nom[MAX_SIZE_VAR];
	int type;
	char init;
	int profondeur;
} variable;

/**
 Empile la variable passé en paramètre
 Retourne l'index de la la variable ajoutée
**/
int add(char nom[MAX_SIZE_VAR], int type, char init, int profondeur);

/**
 Dépile la première variable de la pile
 Retourne la nouvelle taille de la pile, -1 si problème
**/
int removeVar();

/**
 Dépile les premières variables à la profondeur courante
 Retourne la nouvelle taille de la pile
**/
int removeDepth();

/**
 Retourne la variable demandée à partir de son index
**/
variable* getWithIndex(int index);

/**
 Retourne la variable demandée à partir de son nom
**/
variable* getWithName(char nom[MAX_SIZE_VAR]);

/**
 Retourne l'index de la variable demandée à partir de son nom, -1 si la variable n'existe pas
**/
int indexof(char nom[MAX_SIZE_VAR]);

/**
 Retourne l'adresse si la variable passée en paramèrtre existe, 0 sinon
**/
int check_if_exists(char nom[MAX_SIZE_VAR]);

/**
 Retourne l'adresse si la variable passée en paramèrtre existe dans la même profondeur, 0 sinon
**/
int check_if_exists_with_depth(char nom[MAX_SIZE_VAR]);

/**
 Affiche la table des symboles dans son état actuel
**/
void affiche_table();

/**
 Renvoie la taille de la table des symboles
**/
int get_size();

#endif
