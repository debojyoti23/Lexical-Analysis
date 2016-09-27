/* Sentence segmenter implementation of Flex */
%{
	#include<stdio.h>
	#include<math.h>
	#include<string.h>
	#define N 16	//15 POS and 1 for capitalization
	FILE *fp,*f_train;
	int num_dots=0;
	int last_token_vec[N];
	int term_flag=0;
%}

TOKEN [[:alnum:]\"\(\)\.\$<>@]+
POS ("N"|"CUR"|"V"|"CNJ"|"PPS"|"ADJ"|"AT"|"DET"|"NUM"|"PRN"|"NOT"|"TO"|"INT"|"ADV"|"X")
DELIM [,:;!\?]

%option noyywrap
%x seen_dot

%%
(": "{TOKEN}"+"{POS}) {auxFn();}
"."$ {BEGIN(seen_dot);num_dots++;term_flag=1;}
<seen_dot>"^" {printf("(. 1)\n");fputs("1\n",fp);BEGIN(INITIAL);}
<seen_dot>"." {printf("(. 0)\n");fputs("0\n",fp);fill_with_zero();num_dots++;}
<seen_dot>.+ {printf("(. 0)\n");fputs("0\n",fp);yyless(0);BEGIN(INITIAL);}
<seen_dot>"\n"
.
"\n"
%%

int fill_with_zero(){
	// For consecutive zeros e.g. Ellipsis, Training vector is zero vector
	int i;
	for(i=0;i<2*N;i++){
		fputs("0 ",f_train);
	}
	fputs("\n",f_train);
}

int auxFn(){
	int i,offset=0,isCap=0,flag=0;
	int tagVec[N];
	for(i=0;i<N;i++) tagVec[i]=0;
	char stem[50],tag[5];

	// set last bit
	if(yytext[2]>='A' && yytext[2]<='Z')tagVec[N-1]=1;

	for(i=2;yytext[i]!='+';i++){
		stem[offset++]=yytext[i];
		if(yytext[i]=='.'){fputs("0\n",fp);num_dots++;flag=1;}
	}
	i++;
	stem[offset]='\0';
	offset=0;
	while(i<yyleng){
		tag[offset++]=yytext[i];
		i++;
	}
	tag[offset]='\0';
	printf("(%s %s)\n",stem,tag);
	if(strcmp("N",tag)==0)tagVec[0]=1;
	else if(strcmp("CUR",tag)==0)tagVec[1]=1;
	else if(strcmp("V",tag)==0)tagVec[2]=1;
	else if(strcmp("CNJ",tag)==0)tagVec[3]=1;
	else if(strcmp("PPS",tag)==0)tagVec[4]=1;
	else if(strcmp("ADJ",tag)==0)tagVec[5]=1;
	else if(strcmp("AT",tag)==0)tagVec[6]=1;
	else if(strcmp("DET",tag)==0)tagVec[7]=1;
	else if(strcmp("NUM",tag)==0)tagVec[8]=1;
	else if(strcmp("PRN",tag)==0)tagVec[9]=1;
	else if(strcmp("NOT",tag)==0)tagVec[10]=1;
	else if(strcmp("TO",tag)==0)tagVec[11]=1;
	else if(strcmp("INT",tag)==0)tagVec[12]=1;
	else if(strcmp("ADV",tag)==0)tagVec[13]=1;
	else if(strcmp("X",tag)==0)tagVec[14]=1;
	if(term_flag){
		for(i=0;i<N;i++){
			if(last_token_vec[i]==1)
				fputs("1 ",f_train);
			else
				fputs("0 ",f_train);
		}		
		for(i=0;i<N;i++){
			if(tagVec[i]==1)
				fputs("1 ",f_train);
			else
				fputs("0 ",f_train);
		}
		fputs("\n",f_train);
		term_flag=0;
	}
	for(i=0;i<N;i++)
		last_token_vec[i]=tagVec[i];
}

int main(int argc,char **argv){
	++argv;
	--argc;
	if(argc>0)
		yyin=fopen(argv[0],"r");
	else
		yyin=stdin;
	fp=fopen("label.csv.tmp","w+");
	f_train = fopen("train.csv.tmp","w+");
	yylex();
	fclose(yyin);
	fclose(fp);
}
