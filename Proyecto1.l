
/*
Desarrollar un escaner con Flex que reconozca los siguientes elementos:
1-	Debe reconocer e imprimir en la pantalla los comentarios en ambos estilos de Pascal { } y (* *).
2-	Reconocer las palabras reservadas, imprimirlas y almacenarlas en un archivo .csv. La primera columna es un consecutivo, la segunda es la palabra reservada y la tercera las veces que aparece.
program  begin uses unit interface implementation label const type  real integer longint word char boolean true false string packed array record end case otherwise of set  var forward external function procedure file goto if then	 
else repeat until while do for to downto with nil read readln write writeln in or div mod and not

3-	Imprimir las constantes de cadenas de caracteres y almacenarlas en un archivo .csv. La primera columna es un consecutivo, la segunda es la cadena de caracteres y la tercera las veces que aparece.
4-	Reconocer los operadores y simbolos de escritura, imprimirlos y almacenarlos en un archivo .csv. La primera columna es un consecutivo, la segunda es el operador o símbolo y la tercera las veces que aparece.
"@" "#" "<>" "<=" ">=" "+" "-" "*"         
"/" "<" ">" "^" ";" "=" "," "("         	  
")" "[" "]" ":" ":=" ".."
5-	Reconocer las constantes enteras y reales, con o sin signo, o en notación exponencial. Almacenarlas en un archivo .csv. La primera columna es un consecutivo, la segunda es la constante entera y la tercera las veces que aparece.
6-	Debe imprimir en la pantalla la fila y columna de cada uno de los tokens encontrados.
7-	Debe imprimir en pantalla la cantidad de espacios y tabuladores encontrados así como la fila y columna.
8-	Debe reconocer los elementos sin atender a caracteres mayúsculos o minúsculos
*/


%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h> 

/* Variables */
// Variables
unsigned int contadorC = 1;
unsigned int contadorF = 1;

unsigned int contadorBLANK = 0;

unsigned int contadorfila = 0;
unsigned int contadorcolumna = 0;

unsigned int contadorBLANK = 0;
unsigned int contadorNEWLINE = 0;

// Contadores para archivos CSV
int aparicionesReservadas = 0;
int aparicionesCadenas = 0;
int aparicionesOperadores = 0;
int aparicionesConstantes = 0;

// Archivos CSV
FILE *reservadasFile;
FILE *cadenasFile;
FILE *operadoresFile;
FILE *constantesFile;

// Reportes para CSV
typedef struct {
	char nombre[256];
	int repeticiones;
} Reporte;

Reporte reporteReservadas[1000];
Reporte reporteCadenas[1000];
Reporte reporteOperadores[1000];
Reporte reporteConstantes[1000];

/* Funciones */
// Método para añadir a reporte
void addToReport(Reporte* reporte, int& apariciones, char* yytext) {
    bool coincidencia = false;

    // Verificar si el término ya está en el arreglo para añadir una repetición
    for (int i = 0; i < apariciones; i++) {
        if (strcmp(reporte[i].nombre, yytext) == 0) {
            reporte[i].repeticiones++;
            coincidencia = true;
            break;
        }
    }

    // Si el término no está en el arreglo, agregarla
    if (!coincidencia) {
        strcpy(reporte[apariciones].nombre, yytext);
        reporte[apariciones].repeticiones = 1;
        apariciones++;
    }
}

void writeReportToFile(FILE* file, const Reporte* reporte, int apariciones) {
    fprintf(file, "Consecutivo,Palabra Reservada,Repeticiones\n");

    for (int i = 0; i < apariciones; i++) {
        fprintf(file, "%i,%s,%i\n", i + 1, reporte[i].nombre, reporte[i].repeticiones);
    }
}

%}

%option noyywrap
%option yylineno
%option outfile="Scanner.cpp"

/* DEFINICION DE TOKENS DE PASCAL-LISA */

/* Letras */
LETRA				[a-zA-Z]

/* Digitos */
DIGITOSINCERO		[1-9]
DIGITO 				[0-9]

/* Comentarios */
COMENTARIO 			\{[^}]*\}|\(\*[^*]*\*\)

/* Identificadores */
IDENTIFICADOR		{LETRA}({LETRA}|{DIGITO}|_)+

/* Tabuladores y Espacios en Blanco */
BLANK				[ \t]

/* Nueva Linea */
NEWLINE				\n

/* Cadenas de Caracteres */
CADENA				\'[^']*\'

/* Operadores */
UNARYOPERATOR		@|not
MULTOPERATOR		\*|\/|div|mod|and
ADDOPERATOR			\+|\-|or
RELOPERATOR			<|>|<=|>=|<>|=|in

/* Simbolos */
SIMBOLO				\(|\)|\[|\]|\,|\.|\:|\;|\^|\:=|\.\.

/* Palabras Reservadas */
PALABRARESERVADA	program|begin|uses|unit|interface|implementation|label|const|type|real|integer|longint|word|char|boolean|true|false|string|packed|array|record|end|case|otherwise|of|set|var|forward|external|function|procedure|file|goto|if|then|else|repeat|until|while|do|for|to|downto|with|nil|read|readln|write|writeln

/* Constantes */ 
CONSTANTEENTERA		[\+\-]?{DIGITOSINCERO}{DIGITO}*
CONSTANTEREAL		[\+\-]?{DIGITOSINCERO}{DIGITO}*\.{DIGITO}+([eE][\+\-]?{DIGITO}+)?
NOTACIONEXPONENCIAL	[\+\-]?{DIGITOSINCERO}{DIGITO}+([eE][\+\-]?{DIGITO}+)?

%%

{NEWLINE}	{
		printf("\n(%d,%d) Cambio de linea.\n", contadorF, contadorC);
		contadorC = 1;
		contadorF++;
	}	

{COMENTARIO}	{
    	char* comentario = yytext;  // Obtén el texto del comentario
		if (comentario[0] == '(' )
		{
			comentario++;
			comentario++;
    		comentario[strlen(comentario) - 2] = '\0';  // Elimina el último carácter de cierre '}' o '*'
		}
    	else
		{
			comentario++;  // Avanza para ignorar el primer carácter de apertura '{' o '('
    		comentario[strlen(comentario) - 1] = '\0';  // Elimina el último carácter de cierre '}' o '*'
		}
   		printf("\n(%d,%d) Comentario: %s\n", contadorF, contadorC, comentario);
		contadorC += yyleng;
	}

{BLANK}+	{
		contadorBLANK += yyleng;
		printf("\n(%d,%d) Espacio en blanco y/o tabulador: %d\n", contadorF, contadorC, contadorBLANK);
		contadorBLANK = 0;
		contadorC += yyleng;
	}

{PALABRARESERVADA}	{
	printf("\nPalabra Reservada: %s\n", yytext);
	addToReport(reporteReservadas, aparicionesReservadas, yytext);
}

{SIMBOLO}	{
	printf("\nSimbolo: %s\n", yytext);
	addToReport(reporteOperadores, aparicionesOperadores, yytext);
}

{UNARYOPERATOR}	{
	printf("\nOperador Unario: %s\n", yytext);
	addToReport(reporteOperadores, aparicionesOperadores, yytext);
}

{MULTOPERATOR}	{
	printf("\nOperador Multiplicativo: %s\n", yytext);
	addToReport(reporteOperadores, aparicionesOperadores, yytext);
}

{ADDOPERATOR}	{
	printf("\nOperador Aditivo: %s\n", yytext);
	addToReport(reporteOperadores, aparicionesOperadores, yytext);
}

{RELOPERATOR}	{
	printf("\nOperador Relacional: %s\n", yytext);
	addToReport(reporteOperadores, aparicionesOperadores, yytext);
}
=======
		printf("\n(%d,%d) Palabra Reservada: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{SIMBOLO}	{
		printf("\n(%d,%d) Simbolo: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{UNARYOPERATOR}	{
		printf("\n(%d,%d) Operador Unario: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{MULTOPERATOR}	{
		printf("\n(%d,%d) Operador Multiplicativo: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{ADDOPERATOR}	{
		printf("\n(%d,%d) Operador Aditivo: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{RELOPERATOR}	{
		printf("\n(%d,%d) Operador Relacional: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{IDENTIFICADOR}	{
		printf("\n(%d,%d) Identificador: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{CONSTANTEREAL}	{
		printf("\n(%d,%d) Constante Real: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{CONSTANTEENTERA}	{
	printf("\nConstante Entera: %s\n", yytext);
	addToReport(reporteConstantes, aparicionesConstantes, yytext);
}

{CONSTANTEREAL}	{
	printf("\nConstante Real: %s\n", yytext);
	addToReport(reporteConstantes, aparicionesConstantes, yytext);
}

{NOTACIONEXPONENCIAL}	{
	printf("\nNotacion Exponencial: %s\n", yytext);
	addToReport(reporteConstantes, aparicionesConstantes, yytext);
}

{CADENA}    {
    char* cadena = yytext + 1;
    cadena[strlen(cadena) - 1] = '\0';
	printf("\nCadena de Caracteres: %s\n", cadena);

	addToReport(reporteCadenas, aparicionesCadenas, cadena);
}
=======
		printf("\n(%d,%d) Constante Entera: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{NOTACIONEXPONENCIAL}	{
		printf("\n(%d,%d) Notacion Exponencial: %s\n", contadorF, contadorC, yytext);
		contadorC += yyleng;
	}

{CADENA}	{
		char* cadena = yytext;  // Obtén el texto de la cadena
    	cadena++;  // Avanza para ignorar el primer carácter de apertura '
    	cadena[strlen(cadena) - 1] = '\0';  // Elimina el último carácter de cierre '
    	printf("\n(%d,%d) Cadena de Caracteres: %s\n", contadorF, contadorC, cadena);
		contadorC += yyleng;
	}
%%

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		printf("Falta el archivo de entrada\n");
		return 1;
	}

	yyin = fopen(argv[1], "r");

	if (yyin == NULL)
	{
		printf("No se pudo abrir el archivo\n");
		return 1;
	}

	// Abrir archivos CSV para escritura
	reservadasFile = fopen("reservadas.csv", "w");
	cadenasFile = fopen("cadenas.csv", "w");
	operadoresFile = fopen("operadores.csv", "w");
	constantesFile = fopen("constantes.csv", "w");

	if (reservadasFile == NULL || cadenasFile == NULL || operadoresFile == NULL || constantesFile == NULL)
	{
		printf("Error al abrir archivos CSV para escritura\n");
		return 1;
	}

	// Llamar a yylex para analizar el archivo
	yylex();

	// Imprimir archivos CSV
	writeReportToFile(reservadasFile, reporteReservadas, aparicionesReservadas);
	writeReportToFile(cadenasFile, reporteCadenas, aparicionesCadenas);
	writeReportToFile(operadoresFile, reporteOperadores, aparicionesOperadores);
	writeReportToFile(constantesFile, reporteConstantes, aparicionesConstantes);

    // Cerrar archivos CSV
    fclose(reservadasFile);
    fclose(cadenasFile);
    fclose(operadoresFile);
    fclose(constantesFile);

    // Cerrar archivo de entrada
    fclose(yyin);

	return 0;
}
