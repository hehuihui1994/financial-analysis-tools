#ifndef LDA_ESTIMATE_H
#define LDA_ESTIMATE_H

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <float.h>
#include <string.h>

#include "lda.h"
#include "lda-data.h"
#include "lda-inference.h"
#include "lda-model.h"
#include "lda-alpha.h"
#include "utils.h"
#include "cokus.h"

int LAG = 5;

float EM_CONVERGED;
int EM_MAX_ITER;
int ESTIMATE_ALPHA;
double INITIAL_ALPHA;
int NTOPICS;

double citing_doc_e_step(citing_document* doc,
                  double* gamma,
                  double** phi,
		  double** var_phi, 	 
                  lda_model* model,
                  lda_suffstats* ss);

double cited_docs_e_step(cited_document * cited_docs, 
                         lda_model *model, 
                         lda_suffstats *ss);

void save_gamma(char* filename,
                double** gamma,
                int num_docs,
                int num_topics);

void run_em(char* start,
            char* directory,
            corpus* corpus);

void infer_new_corpus(char* model_root, char* directory, corpus* corpus);

void read_settings(char* filename);

void infer(char* model_root,
           char* save,
           corpus* corpus);

void predict(char* model_root, 
	     char* save,
	     corpus* corpus);

#endif


