/* Morphological Analyser implementation of Flex */
%{
	#include<stdio.h>
	#include<math.h>	
%}

ELLIPSIS 	\.{3,}
TOKEN1 [[:alnum:]\"\(\)<>@]
TOKEN ({TOKEN1}|{ELLIPSIS})+
ALF [A-Za-z]
PUNCT [\.,;:\?!\"]
VOWEL [aeiou]
DIGIT [0-9]
INTEGER {DIGIT}+
FLOAT {DIGIT}*"."{DIGIT}+
NUMBER {INTEGER}|{FLOAT}
CONSNT [bcdfghjklmnpqrstvwxyz]
MODAL "am"|"is"|"are"|"may"|"might"|"can"|"shall"|"will"|"should"|"would"|"could"|"be"
MARKER \^
%option noyywrap
%x verb noun other

/* Parsing POS tagged input file, POS tagset used CLAWS2TAGS. Format token_postag */
%%
	/* Delimiter */
^{PUNCT}/"_"{PUNCT}  {ECHO;}
{PUNCT}/"_"	{printf("\n");ECHO;printf("\n");}
	/* Noun */
{TOKEN}/{PUNCT}?"_"NN {ECHO;printf(" : %s+N+Nt",yytext);}
("$")?{NUMBER}/{PUNCT}?"_"NNU {ECHO;printf(" : %s+CUR",yytext);}	//Change
{TOKEN}/{PUNCT}?"_"NN.?1 {ECHO;printf(" : %s+N+Sg",yytext);}
{TOKEN}/{PUNCT}?"_"NP.?1 {ECHO;printf(" : %s+N+Sg",yytext);}
{TOKEN}/{PUNCT}?"_"NN.?2 {BEGIN(noun);yyless(0);}
{TOKEN}/{PUNCT}?"_"NP.?2 {BEGIN(noun);yyless(0);}
	/* verbs */
{TOKEN}/{PUNCT}?"_"VV0 {ECHO;printf(" : %s+V",yytext);}
{TOKEN}/{PUNCT}?"_"VVG |
{TOKEN}/{PUNCT}?"_"VVD |
{TOKEN}/{PUNCT}?"_"VVZ |
{TOKEN}/{PUNCT}?"_"VVN {BEGIN(verb);yyless(0);}
	/* Conjunction */
{TOKEN}/{PUNCT}?"_"[BC].+ {ECHO;printf(" : %s+CNJ",yytext);}
	/* Preposition */
{TOKEN}/{PUNCT}?"_"I.+ {ECHO;printf(" : %s+PPS",yytext);}
	/* Adjective */
{TOKEN}/{PUNCT}?"_"J.+ {ECHO;printf(" : %s+ADJ",yytext);}
	/* Article */
{TOKEN}/{PUNCT}?"_"A.+ {ECHO;printf(" : %s+AT",yytext);}
	/* Determiner */
{TOKEN}/{PUNCT}?"_"D.+ {ECHO;printf(" : %s+DET",yytext);}
	/* Number */
{NUMBER}/{PUNCT}?"_"M.+ {ECHO;printf(" : %s+NUM",yytext);}	//Change
	/* Pronoun */
{TOKEN}/{PUNCT}?"_"P.+ {ECHO;printf(" : %s+PRN",yytext);}
	/* Not */
{TOKEN}/{PUNCT}?"_"XX {ECHO;printf(" : %s+NOT",yytext);}
	/* To */
{TOKEN}/{PUNCT}?"_"TO {ECHO;printf(" : %s+TO",yytext);}
	/* Interjection */
{TOKEN}/{PUNCT}?"_"UH {ECHO;printf(" : %s+INT",yytext);}
	/* Adverb */
{TOKEN}/{PUNCT}?"_"R.+ {ECHO;printf(" : %s+ADV",yytext);}
	/* Default */
{TOKEN}/{PUNCT}?"_" {printf("%s : ",yytext);ECHO;printf("+X");}
{TOKEN}{PUNCT}{TOKEN}{PUNCT}?({TOKEN}{PUNCT}?)?/"_" {printf("%s : ",yytext);ECHO;printf("+X");}	//Change

<noun>{ALF}+ies {printf("%s : ",yytext);yyleng-=3;ECHO;printf("y+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+ives {printf("%s : ",yytext);yyleng-=3;ECHO;printf("fe+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+ves {printf("%s : ",yytext);yyleng-=3;ECHO;printf("f+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+ces {printf("%s : ",yytext);yyleng-=1;ECHO;printf("+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+sses {printf("%s : ",yytext);yyleng-=2;ECHO;printf("+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+i{ALF}es {printf("%s : ",yytext);yyleng-=1;ECHO;printf("+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+es {printf("%s : ",yytext);yyleng-=2;ECHO;printf("+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+s {printf("%s : ",yytext);yyleng-=1;ECHO;printf("+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+ia {printf("%s : ",yytext);yyleng-=1;ECHO;printf("um+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+i {printf("%s : ",yytext);yyleng-=1;ECHO;printf("us+N+Pl");BEGIN(INITIAL);}
<noun>{ALF}+ {printf("%s : ",yytext);ECHO;printf("+N+Pl");BEGIN(INITIAL);}	/* deer */
<verb>{ALF}+oes {printf("%s : ",yytext);yyleng-=2;ECHO;printf("+V+1P+Sg");BEGIN(INITIAL);} /* goes */
<verb>{ALF}+(sh|ch|tch|x|z|ss)es {printf("%s : ",yytext);yyleng-=2;ECHO;printf("+V+1P+Sg");BEGIN(INITIAL);} /* watches */
<verb>{ALF}+ies {printf("%s : ",yytext);if(yyleng==4){yyleng-=1;ECHO;printf("+V+1P+Sg");}else{yyleng-=3;ECHO;printf("y+V+1P+Sg");}BEGIN(INITIAL);} /* lies,cries */
<verb>{ALF}+s {printf("%s : ",yytext);yyleng-=1;ECHO;printf("+V+1P+Sg");BEGIN(INITIAL);} /* likes,hits */
<verb>{ALF}+ied {printf("%s : ",yytext);if(yyleng==4){yyleng-=1;ECHO;printf("+V+Past");}else{yyleng-=3;ECHO;printf("y+V+Past");}BEGIN(INITIAL);} /* died,tried */
<verb>{ALF}+{CONSNT}{2}ed {char c1 = *(yytext+yyleng-3); char c2=*(yytext+yyleng-4); if(c1==c2){printf("%s : ",yytext);yyleng-=3;ECHO;printf("+V+Past");BEGIN(INITIAL);}else REJECT;} /* banned,damned */
<verb>{ALF}+(yed|xed|tched|mned|oo{CONSNT}ed) {printf("%s : ",yytext);yyleng-=2;ECHO;printf("+V+Past");BEGIN(INITIAL);} /* Despatched,conveyed,damned */
<verb>{ALF}+d {printf("%s : ",yytext);yyleng-=1;ECHO;printf("+V+Past");BEGIN(INITIAL);} /* liked,breathed */
<verb>{ALF}+{VOWEL}{CONSNT}{2}ing {char c1 = *(yytext+yyleng-4); char c2=*(yytext+yyleng-5); if(c1==c2){printf("%s : ",yytext);yyleng-=4;ECHO;printf("+V+PresPart");BEGIN(INITIAL);}else REJECT;} /* begging */
<verb>{ALF}+ing {printf("%s : ",yytext);yyleng-=3;ECHO;printf("+V+PresPart");BEGIN(INITIAL);} /* hunting */
<verb>{ALF}+ {printf("%s : %s+V+Irr+Past",yytext,yytext);BEGIN(INITIAL);}
{MARKER} {ECHO;printf("\n");}
.
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
