/* Sentence segmenter implementation of Flex */
%{
	#include<stdio.h>
	#include<math.h>	
%}

/* Whitespace */
WS 			[ \t\n\r\f]

/* Abbreviation */
ABBR	(Mr.|Mrs.|[Ll]"td."|[Jj]"an."|[Ff]"eb."|[Mm]"ar."|[Aa]"pr."|[Jj]"un."|[Jj]"ul."|[Aa]"ug."|[Ss]"ep"[t]?"."|[Oo]"ct."|[Nn]"ov."|[Dd]"ec."|"Co."|"Corp."|"Inc."|[Cc]"f."|[Ee]"g."|[Ee]"tc."|[Ee]"x."|[Ii]"e."|[Vv]"iz."|[Vv]"s."|[Pp]"."[Oo]"."("BOX."|"Box.")?)
NAME_ABBR	[A-Z]"\."{WS}*([A-Z]"\."{WS}*)*[A-Za-z]+

/* Upper case */
UPPER 		[A-Z]
NUMBER 		[0-9]

/* Brackets */
LEFTBRKT	[\[{(]
RTBRKT		[\]})]

/* Quotes */
QTSTART		\"|`|``|&quot;|''
QTEND		\"|&quot;|''

/* Ellipsis */
ELLIPSIS 	\.{3,}

/* Bullet */
BULLET 		"*"

/* Sentence start,end marker */
TRAIL_START	{LEFTBRKT}|{QTSTART}|{BULLET}
TRAIL_END	{RTBRKT}|{QTEND}
ENDMARKER	[?!\.]|{ELLIPSIS}

%option noyywrap
%s new_sentence new_token

%%
{ENDMARKER}{TRAIL_END}*/{WS}+{TRAIL_START}*({UPPER}|{NUMBER})	{BEGIN(new_sentence); auxFn();}
<new_sentence,new_token>{WS}
{WS}	{auxFn(); BEGIN(new_token);}
{ABBR} |
{NAME_ABBR} |
.		{ECHO; BEGIN(INITIAL);}
%%

int auxFn(){
	ECHO;
	if(YYSTATE==new_sentence){printf("\n^");}
}

int main(int argc,char **argv){
	++argv;
	--argc;
	if(argc>0)
		yyin=fopen(argv[0],"r");
	else
		yyin=stdin;
	BEGIN(new_sentence);
	yylex();
	fclose(yyin);
}
