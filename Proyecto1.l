
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
unsigned int contadorC = 1;
unsigned int contadorF = 1;

unsigned int contadorBLANK = 0;

/* Funciones */

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

	yylex();

	fclose(yyin);

	return 0;
}
