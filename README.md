# Lexical Analysis

## To run a lex file:
---------------------
1) flex xyz.lex  
2) gcc lex.yy.c  
3) ./a.out input_file.txt  

## Run tagger

1) Make: Internet needed  
mv rasp3os.tar.gz rasp3os.tar  
tar xvf rasp3os.tar  

2) Run POS tagger  
cd rasp3os/tag  
../bin/x86_64_linux/label ~/nlp/assignment1/49960 B1 b C1 N t auxiliary_files/slb.trn d auxiliary_files/seclarge.lex j auxiliary_files/unkstats-seclarge m auxiliary_files/tags.map O512 > ~/nlp/49960.tag  


Reference for CLAWS2TAGS tagset:  
http://ucrel.lancs.ac.uk/claws2tags.html  

## Preprocessing before train

original file = x
1. Run tagger on x.sent. Output x.sent.tag  
2. Run morph.lex on x.sent.tag. Output x.sent.tag.morph  
3. Run final_doc_gen.lex on x.sent.tag.morph. Output   
   i)label.txt - For each "." label 0/1  
  ii)out.txt - formatted file x. Each word is now (word,pos). each "." is now (.,0/1). Other punctutation(p) is (p,p)  
4. Run naive(abbreviation ignored) tokenizer on x. Output x.token_naive  
5. Run tagger on x.token_naive. Output x.token_naive.tag  
6. Run morph.lex on x.token_naive.tag. Output x.token_naive.tag.morph  
7a. Rename label.txt label.txt.orig  
7. Run final_doc_gen.lex on x.token_naive.tag.morph. train.csv Output.csv created.  
8. Align feature vectors to labels  
