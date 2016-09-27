/* Tokenizer implementation of Flex */

%{
	#include<stdio.h>
	#include<math.h>
%}

DIGIT	[0-9]
ID 		[[:alpha:]]+[[:alnum:]_\$']*
WS		[ \t\n\r]+
SYM		[\.\?!,:;\"\-<>\(\)]
MULT_HYPHEN	[\-]{2,}
MAIL	[a-zA-Z0-9]+"@"[a-zA-Z]+".co"[a-z.]*[a-z]
ABBR	(Mr.|Mrs.|[Ll]"td."|[Jj]"an."|[Ff]"eb."|[Mm]"ar."|[Aa]"pr."|[Jj]"un."|[Jj]"ul."|[Aa]"ug."|[Ss]"ep"[t]?"."|[Oo]"ct."|[Nn]"ov."|[Dd]"ec."|"Co."|"Corp."|"Inc."|[Cc]"f."|[Ee]"g."|[Ee]"tc."|[Ee]"x."|[Ii]"e."|[Vv]"iz."|[Vv]"s.")
NOMCOMP	[a-zA-Z]+"-"[a-zA-Z]+
NAME_ABBR	[A-Z]"\."[[:space:]]*([A-Z]"\.")?[[:space:]]*[A-Za-z]+
CURRENCY  "$"{DIGIT}+("\."{DIGIT}+)?

%option noyywrap

%%
{DIGIT}+	 		|
	/*{DIGIT}*"."{DIGIT}+	|*/
{SYM}				|
	/* {MAIL}				|*/
	/*{ABBR}				|*/
{NOMCOMP}			|
	/*{NAME_ABBR}			|*/
{ID}   				{ECHO;printf("\n");}
	/*{CURRENCY}			{ECHO;printf("\n");}*/
{WS}				|
{MULT_HYPHEN}		
%%

int main(int argc,char **argv){
	++argv;
	--argc;
	if(argc>0)
		yyin=fopen(argv[0],"r");
	else
		yyin=stdin;
	yylex();
	fclose(yyin);
}