# Makefile for MEMSAT-SVM, MEMSAT3 and SVM_CLASSIFY

CC=gcc
CPP=g++
LD=gcc
CFLAGS=-O3
LIBS=-lm
GUNZIP=gunzip

.PHONY: models

all: models memsat-svm svm_classify globmem mem_pred nnsat 

clean:
	rm -f bin/memsat-svm
	rm -f bin/svm_classify
	rm -f src/svm_classify.o
	rm -f src/svm_common.o
	rm -f bin/globmem
	rm -f bin/mem_pred
	rm -f bin/nnsat

models: 
	${GUNZIP} models/MEMSAT-SVM_STOICH.model.gz
	${GUNZIP} models/MEMSAT-SVM_w15_PL.model.gz
	${GUNZIP} models/MEMSAT-SVM_w27_RE.model.gz
	${GUNZIP} models/MEMSAT-SVM_w27_SP.model.gz
	${GUNZIP} models/MEMSAT-SVM_w33_GM.model.gz
	${GUNZIP} models/MEMSAT-SVM_w33_HL.model.gz
	${GUNZIP} models/MEMSAT-SVM_w35_IO.model.gz

memsat-svm: src/memsat-svm.cpp
	$(CPP) -Wall src/memsat-svm.cpp -o bin/memsat-svm 

svm_common.o: src/svm_common.c src/svm_common.h src/kernel.h
	$(GCC) -c $(CFLAGS) src/svm_common.c -o src/svm_common.o 

svm_classify.o: svm_classify.c svm_common.h kernel.h
	$(GCC) -c $(CFLAGS) src/svm_classify.c -o src/svm_classify.o

svm_classify: src/svm_classify.o src/svm_common.o 
	$(LD) $(CFLAGS) src/svm_classify.o src/svm_common.o -o bin/svm_classify $(LIBS)

globmem: src/globmem.c src/globmem_net.h
	$(CC) $(CFLAGS) src/globmem.c $(LIBS) -o bin/globmem

mem_pred: src/mem_pred.c src/sigmem_net.h
	$(CC) $(CFLAGS) src/mem_pred.c $(LIBS) -o bin/mem_pred

nnsat: src/nnsat.c
	$(CC) $(CFLAGS) src/nnsat.c $(LIBS) -o bin/nnsat








