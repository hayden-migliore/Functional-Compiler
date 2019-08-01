/* Hayden Migliore
   CMSC 430 6980
   July 12th, 2019
   Values.cc */

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateRelational(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case EQUAL:
			result = left == right;
			break;
		case NOTEQUAL:
			result = left /= right;
			break;
		case LESSEQUAL:
			result = left <= right;
			break;
		case GREATEREQUAL:
			result = left >= right;
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case SUB:
			result = left - right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case REM:
			result = left % right;
			break;
		case EXP:
			result = pow(left * 1.0, right * 1.0); //* 1.0 convert int to double
			break;
		case ARROW:
			left = right;
			result = left;
			break;
	}
	return result;
}

