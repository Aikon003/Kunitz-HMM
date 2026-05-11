#!/bin/bash

hmmbuild kunitz.hmm fasta.seq
hmmsearch --max --noali --tblout positive_kunitz -Z 1000 kunitz.hmm ./Uniprot/Positive.fasta
hmmsearch --max --noali --tblout negative_kunitz -Z 1000 kunitz.hmm ./Uniprot/Negative.fasta
grep -v '^#' positive_kunitz | awk '{print $1"\t"$8"\t1"}' > positive_kunitz.match
grep -v '^#' negative_kunitz | awk '{print $1"\t"$8"\t0"}' > negative_kunitz.match
grep ">" ./Uniprot/Negative.fasta | awk '{print $1}' | tr -d ">" | sort > negative_kunitz.ids
awk '{print $1}' negative_kunitz.match | sort > negative_kunitz_match.ids
comm -23 <(sort negative_kunitz.ids) <(sort negative_kunitz_match.ids) | awk '{print $1"\t100\t0"}' > negative_kunitz.nonmatch
cat negative_kunitz.match negative_kunitz.nonmatch | sort -R > negative_kunitz.tot.match
grep -v -F -f <(cut -d',' -f1 ./uniprot_id_train.txt | sed 's/^/sp|/; s/$/|/') positive_kunitz.match > ./positive_filtered.match
head -n 199 positive_filtered.match > kunitz_set_1.txt
tail -n 199 positive_filtered.match > kunitz_set_2.txt
head -n 287115 negative_kunitz.tot.match >> kunitz_set_1.txt
tail -n 287115 negative_kunitz.tot.match >> kunitz_set_2.txt
for i in $(seq 1 15); do python3 performance.py kunitz_set_1.txt 1e-$i; done > kunitz_set_1.results
for i in $(seq 1 15); do python3 performance.py kunitz_set_2.txt 1e-$i; done > kunitz_set_2.results