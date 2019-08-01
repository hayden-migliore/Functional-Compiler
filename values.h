/* Hayden Migliore
   CMSC 430 6980
   July 12th, 2019
   Values.h */

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, GREATER, EQUAL, NOTEQUAL, LESSEQUAL, GREATEREQUAL, ADD, SUB, MULTIPLY, DIVIDE, REM, EXP, ARROW};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);

