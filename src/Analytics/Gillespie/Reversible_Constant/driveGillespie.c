/*** Allard Lab lclemens@uci.edu                   ***/

#define TWISTER genrand_real3()
#define NMAX       400
#define NTMAX      1e9
#define NTADAPT    20000
#define NTCHECK    200000
#define DCHIMIN    1e-4
#define NBINS      100
#define PI         3.14159265359
#define INF        1e14
#define ISITEMAX   9
#define STATEMAX   1000000000
#define ITMAX      1e9
#define NTOPPATHS  50
#define TIME       0
#define TALKATIVE  1

#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include "twister.c"


/*******************************************************************************/
//  GLOBAL VARIABLES
/*******************************************************************************/

char matrixName[1000];
FILE *ratesFile;
long iseed;

char outputName[1000];
FILE *outputFile;

char summaryOutputName[1000];
FILE *summaryOutputFile;

char timeOutputName[1000];
FILE *timeOutputFile;



double timeTotal,randTime[ISITEMAX],timeStep,timeSum;
double timeArray[STATEMAX];
int currentState,iy,it,iterations, stepCount;


double rateMatrix[STATEMAX][ISITEMAX],rateMatrix1[STATEMAX][ISITEMAX],rateMatrix2[STATEMAX][ISITEMAX];
int i,j,k;
int iSiteTotal,newState;

int sizeOfRateMatrix;
int totalBound[STATEMAX];
int verbose, summaryOn;

double reverseRate;

/*******************************************************************************/
//  INCLUDES
/*******************************************************************************/

#include "binaryConversion.c"
#include "outputGillespie.c"
#include "runGillespie.c"


/*******************************************************************************/
//  MAIN
/*******************************************************************************/

// arguments: listName, dimension, nBar, N, dt
int main( int argc, char *argv[] )
{

    printf("This program is starting.\n");
    
    if(argv[1]) // matrixName
        strcpy(matrixName1, argv[1]);
    if (TALKATIVE) printf("This is argument 1: %s\n", matrixName1);
    
    
    if(argv[2]) // matrixName
        strcpy(matrixName2, argv[2]);
    if (TALKATIVE) printf("This is argument 2: %s\n", matrixName2);
    
    if(argv[3]) //iSiteTotal
        iSiteTotal = atoi(argv[3]);
    if (TALKATIVE) printf("This is argument 3: %d\n", iSiteTotal);
    
    if(argv[4]) //total number of iterations
        iterations = atoi(argv[4]);
    if (TALKATIVE) printf("This is argument 4: %d\n", iterations);
    
    if(argv[5]) //total number of iterations
        reverseRate = atoi(argv[5]);
    if (TALKATIVE) printf("This is argument 5: %d\n", reverseRate);
    
    if(argv[6]) //output file name
        strcpy(outputName, argv[6]);
    if (TALKATIVE) printf("This is argument 6: %s\n", outputName);
    
    if(argv[7]) //output file name
    {
        strcpy(summaryOutputName, argv[7]);
    if (TALKATIVE) printf("This is argument 7: %s\n", summaryOutputName);
        summaryOn = 1;
    }
    else
    {
        summaryOn = 0;
    if (TALKATIVE) printf("No summary file will be created.\n");
    }


    
	iseed = RanInitReturnIseed(0);
	
	runGillespie();

	return 0;
	
} // finished main
