%{
#include <stdlib.h>
#include <stdio.h>

unsigned int lineas = 1;


%}

%option noyywrap
%option yylineno
%option outfile="Scanner.cpp"


%%
		
.	{
		printf("\nReferencia encontrada: %s\n", yytext);
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