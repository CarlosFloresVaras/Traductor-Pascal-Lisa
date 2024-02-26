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

unsigned int 

%}

%option noyywrap
%option yylineno
%option outfile="Scanner.cpp"

// DEFINICION DE TOKENS

// Letras 
LETRA				[a-zA-Z]

// Digitos
DIGITOSINCERO		[1-9]
DIGITO 				[0-9]

// Comentarios
COMENTARIO 			\{.*\}|\(\*.*\*\)

// Cadenas de Caracteres


// Operadores
UNARYOPERATOR		@|not
MULTOPERATOR		\*|\/|div|mod|and
ADDOPERATOR			\+|\-|or
RELOPERATOR			<|>|<=|>=|<>|=|in

// Simbolos
SIMBOLO				\(|\)|\[|\]|\{|\}|\,|\.|\:|\;|\^|\:=|\.\.

// Palabras Reservadas
PALABRARESERVADA	program|begin|uses|unit|interface|implementation|label|const|type|real|integer|longint|word|char|boolean|true|false|string|packed|array|record|end|case|otherwise|of|set|var|forward|external|function|procedure|file|goto|if|then|else|repeat|until|while|do|for|to|downto|with|nil|read|readln|write|writeln|in|or|div|mod|and|not

// Constantes
CONSTANTEENTERA		{DIGITOSINCERO}{DIGITO}*
CONSTANTEREAL		{DIGITOSINCERO}{DIGITO}*\.{DIGITO}+([eE][\+\-]?{DIGITO}+)?
NOTACIONEXPONENCIAL	{DIGITOSINCERO}{DIGITO}+([eE][\+\-]?{DIGITO}+)?


%%

{COMENT}	{
		printf("\nComentario: %s\n", yytext);
	}

// ALMACENAR EN UN ARCHIVO .CSV A PARTIR DE AQUI

{PALABRARESERVADA}	{
		printf("\nPalabra Reservada: %s\n", yytext);
	}

// Constantes de Cadenas de Caracteres

{SIMBOLO}	{
		printf("\nSimbolo: %s\n", yytext);
	}

{UNARYOPERATOR}	{
		printf("\nOperador Unario: %s\n", yytext);
	}

{MULTOPERATOR}	{
		printf("\nOperador Multiplicativo: %s\n", yytext);
	}

{ADDOPERATOR}	{
		printf("\nOperador Aditivo: %s\n", yytext);
	}

{RELOPERATOR}	{
		printf("\nOperador Relacional: %s\n", yytext);
	}

{CONSTANTEREAL}	{
		printf("\nConstante Real: %s\n", yytext);
	}

{CONSTANTEENTERA}	{
		printf("\nConstante Entera: %s\n", yytext);
	}

{NOTACIONEXPONENCIAL}	{
		printf("\nNotacion Exponencial: %s\n", yytext);
	}

%%

int main(int argc, char* argv[])
{
	if (argc > 1)
		{
			++argv;
		}
		else
		{
			yyin = stdin;
		}
	yylex();
}