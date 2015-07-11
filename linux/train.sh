#!/bin/sh

g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result line.cpp -o line -lgsl -lm -lgslcblas
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result reconstruct.cpp -o reconstruct
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result normalize.cpp -o normalize
g++ -lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result concatenate.cpp -o concatenate

mkdir $4/$3
./reconstruct -train $1 -output $4/$3/$2 -depth 2 -k-max 1000
./line -train $4/$3/$2 -output $4/$3/vec_1st_wo_norm.txt -binary 0 -size $3 -order 1 -negative 5 -samples 10000 -threads 40
./line -train $4/$3/$2 -output $4/$3/vec_2nd_wo_norm.txt -binary 0 -size $3 -order 2 -negative 5 -samples 10000 -threads 40
./normalize -input $4/$3/vec_1st_wo_norm.txt -output $4/$3/vec_1st.txt -binary 0
./normalize -input $4/$3/vec_2nd_wo_norm.txt -output $4/$3/vec_2nd.txt -binary 0
./concatenate -input1 $4/$3/vec_1st.txt -input2 $4/$3/vec_2nd.txt -output $4/$3/vec_all.txt -binary 0

