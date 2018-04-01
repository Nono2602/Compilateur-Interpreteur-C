#ifndef TABLE_FUNS_H
#define TABLE_FUNS_H

#define MAX_SIZE_FUN 16
#define MAX_NB_FUNS 128

typedef struct fun {
	char nom[MAX_SIZE_FUN];
	int adr;
	int nb_params;
} fun;

/**
 Empile la fonction passé en paramètre
 Retourne l'index de la fonction ajoutée
**/
int add_fun(char nom[MAX_SIZE_FUN], int adr, int nb_params);

/**
 Retourne la fonction demandée à partir de son index
**/
fun* get_fun_with_index(int index);

/**
 Retourne la fonction demandée à partir de son nom
**/
fun* get_fun_with_name(char nom[MAX_SIZE_FUN]);

/**
 Retourne l'index de la fonction demandée à partir de son nom, -1 si la variable n'existe pas
**/
int index_of_fun(char nom[MAX_SIZE_FUN]);

/**
 Retourne l'adresse si la fonction passée en paramètre existe, 0 sinon
**/
int check_if_fun_exists(char nom[MAX_SIZE_FUN]);

/**
 Affiche la table des fonctions dans son état actuel
**/
void affiche_table_funs();

#endif
