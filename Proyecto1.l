
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
#include <stdio.h>
#include <string.h>

/* Variables */
unsigned int contadorfila = 0;
unsigned int contadorcolumna = 0;

unsigned int contadorBLANK = 0;
unsigned int contadorNEWLINE = 0;

/* Contadores para archivos CSV */
int consecutivoReservadas = 0;
int consecutivoCadenas = 0;
int consecutivoOperadores = 0;
int consecutivoConstantes = 0;

/* Archivos CSV */
FILE *reservadasFile;
FILE *cadenasFile;
FILE *operadoresFile;
FILE *constantesFile;


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
		contadorfila++;
		contadorNEWLINE += yyleng;
		printf("\n%d Cambio de linea.\n", contadorNEWLINE);
		contadorNEWLINE = 0;
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
    printf("\nComentario: %s\n", comentario);
}

{BLANK}	{
		contadorBLANK += yyleng;
		printf("\nEspacio en blanco y/o tabulador: %d\n", contadorBLANK);
		contadorBLANK = 0;
	}

{PALABRARESERVADA}	{
    // Imprimir y almacenar en el archivo CSV para palabras reservadas
	printf("\nPalabra Reservada: %s\n", yytext);
	fprintf(reservadasFile, "%d,%s,1\n", ++consecutivoReservadas, yytext);
}

{SIMBOLO}	{
	printf("\nSimbolo: %s\n", yytext);
	fprintf(operadoresFile, "%d,%s,1\n", ++consecutivoOperadores, yytext);
}

{UNARYOPERATOR}	{
	printf("\nOperador Unario: %s\n", yytext);
	fprintf(operadoresFile, "%d,%s,1\n", ++consecutivoOperadores, yytext);
}

{MULTOPERATOR}	{
	printf("\nOperador Multiplicativo: %s\n", yytext);
	fprintf(operadoresFile, "%d,%s,1\n", ++consecutivoOperadores, yytext);
}

{ADDOPERATOR}	{
	printf("\nOperador Aditivo: %s\n", yytext);
	fprintf(operadoresFile, "%d,%s,1\n", ++consecutivoOperadores, yytext);
}

{RELOPERATOR}	{
	printf("\nOperador Relacional: %s\n", yytext);
	fprintf(operadoresFile, "%d,%s,1\n", ++consecutivoOperadores, yytext);
}

{IDENTIFICADOR}	{
	printf("\nIdentificador: %s\n", yytext);
}

{CONSTANTEENTERA}	{
	printf("\nConstante Entera: %s\n", yytext);
	fprintf(constantesFile, "%d,%s,1\n", ++consecutivoConstantes, yytext);
}

{CONSTANTEREAL}	{
	printf("\nConstante Real: %s\n", yytext);
	fprintf(constantesFile, "%d,%s,1\n", ++consecutivoConstantes, yytext);
}

{NOTACIONEXPONENCIAL}	{
	printf("\nNotacion Exponencial: %s\n", yytext);
	fprintf(constantesFile, "%d,%s,1\n", ++consecutivoConstantes, yytext);
}

{CADENA}	{
    // Imprimir y almacenar en el archivo CSV para cadenas de caracteres
	char* cadena = yytext + 1;  // Avanzar para omitir el primer carácter de apertura '
    cadena[strlen(cadena) - 1] = '\0';  // Eliminar el último carácter de cierre '
    printf("\nCadena de Caracteres: %s\n", cadena);
    fprintf(cadenasFile, "%d,%s,1\n", ++consecutivoCadenas, cadena);
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

	// Imprimir encabezados en archivos CSV
	fprintf(reservadasFile, "Consecutivo,Palabra Reservada,Repeticiones\n");
	fprintf(cadenasFile, "Consecutivo,Cadena,Repeticiones\n");
	fprintf(operadoresFile, "Consecutivo,Operador/Simbolo,Repeticiones\n");
	fprintf(constantesFile, "Consecutivo,Constante,Repeticiones\n");

	// Llamar a yylex para analizar el archivo
	yylex();

	// Cerrar archivos CSV
	fclose(reservadasFile);
	fclose(cadenasFile);
	fclose(operadoresFile);
	fclose(constantesFile);

	// Cerrar archivo de entrada
	fclose(yyin);

	return 0;
}
