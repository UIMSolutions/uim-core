﻿/***********************************************************************************************************************
*	Copyright: © 2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core;

mixin(ImportPhobos!());

public import vibe.d;

public import uim.core.classes;
public import uim.core.containers;
public import uim.core.datatypes;
public import uim.core.dlang;
public import uim.core.io;
public import uim.core.mixins;
public import uim.core.web;
public import uim.core.tests;

@safe:
alias STRINGAA = string[string];
alias INTAA = int[int];
alias DOUBLEAA = double[double];

/+  +/
T toggle(T, S)(S value) if (isBoolean!S) { return !S; }
T toggle(T, S)(S value, T defValue = 1, T zeroValue = 0) if (isNumeric!S) { 
	return (value != zeroValue 
		? zeroValue 
		: defValue);
}

/+ toggle between values +/
T toggle(T)(T value, T value0, T value1) { return (value == value0) ? value1 : value0; }

/+ +/
/// select values in array
// get all values in array are equal to value
T[] eqValues(T)(T value, T[] values) {
	return values
		.filter!(v => value == v)
		.array;
} 
// get all values in array are not equal to value
T[] neqValues(T)(T checkValue, T[] values) {
	return values
		.filter!(v => checkValue != v)
		.array;
} 

// get all values in array are greater then value
T[]  gtValues(T)(T value, T[] values) if (isNumeric!T) {
	return values
		.filter!(v => value > v)
		.array;
} 
// get all values in array are greater equal value
T[] geValues(T)(T value, T[] values) if (isNumeric!T) {
	return values
		.filter!(v => value >= v)
		.array;
} 
// get all values in array are less then value
T[] ltValues(T)(T value, T[] values) if (isNumeric!T) {
	return values
		.filter!(v => value < v)
		.array;
} 
// get all values in array are less equal value
T[] leValues(T)(T value, T[] values) if (isNumeric!T) {
	return values
		.filter!(v => value <= v)
		.array;
} 

/// compare values in array
// all values in array are equal to value
bool eqAll(T)(T value, T[] values) {
	foreach(v; values) if (value == v) continue; else return false;
	return true;
} 
// all values in array are not equal to value
bool neqAll(T)(T value, T[] values) {
	foreach(v; values) if (value != v) continue; else return false;
	return true;
} 
// all values in array are greater then value
bool gtAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value > v) continue; else return false;
	return true;
} 
// all values in array are greater equal value
bool geAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value >= v) continue; else return false;
	return true;
} 
// all values in array are less then value
bool ltAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value < v) continue; else return false;
	return true;
} 
// all values in array are less equal value
bool leAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value <= v) continue; else return false;
	return true;
} 

bool equal(T)(T[] leftCells, T[] rightCells) {
	if (leftCells.length == rightCells.length) {
		foreach(i; 0..leftCells.length) 
			if (leftCells[i] != rightCells[i]) { return false; }
		return true;
	}
	return false;  }


T limit(T)(T value, T left, T right) if (isNumeric!T) {
	T result = value;
	if (left < right) {
	if (result > right) result = right; 
	if (result < left) result = left; 
	}
	else {
		if (result > left) result = left; 
		if (result < right) result = right; 
	}
	return result;
} 

T[2] arrayLimits(T, S)(T from, T to, S[] values) if (isNumeric!T) { return arrayLimits(from, to, 0, values.length); } 
T[2] arrayLimits(T)(T from, T to, T left, T right) if (isNumeric!T) {
	T[2] result;
	result[0] = limit(from, left, right-1);
	result[1] = limit(to, left, right);
	return result;
} 

string[] stringAA2Array(string[string] values, string sep = ":") {
	string[] results;
	foreach(k, v; values) results ~= k~sep~v;
	return results;
}  

template CascadeNotNull(alias A) {
	const bool CascadeNotNull = (A) ? true : false; 
}

template CascadeNotNull(alias A, alias B) {
	const bool CascadeNotNull = (A) ? (CascadeNotNull!(A.B)) : false; 
}

template CascadeNotNull(alias A, alias B, alias C) {
	const bool CascadeNotNull = (CascadeNotNull!(A, B)) ? (CascadeNotNull!(A.B, C)) : false; 
}

template CascadeNotNull(alias A, alias B, alias C, alias D) {
	const bool CascadeNotNull = (CascadeNotNull!(A, B, C)) ? (CascadeNotNull!(A.B.C, D)) : false; 
}

version(test_uim_core) { unittest {
	assert(stringAA2Array(["A":"B", "C":"D"], "/")==["A/B", "C/D"]);
}}

void debugFunctionCall(string text) {
/* 	debug writeln(StyledString(text)
		.setForeground(AnsiColor.black)
		.setBackground(AnsiColor.yellow)); */
	debug writeln(text);
}

void debugMethodCall(string text) {
/* 	debug writeln(StyledString(text)
		.setForeground(AnsiColor.black)
		.setBackground(AnsiColor.white)); */
	debug writeln(text);
}