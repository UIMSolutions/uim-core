/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/dataytypes/string
************************************************************************************************/
module uim.core.datatypes.string_;

@safe:
import std.stdio; 
import std.string; 
import uim.core;

/// create a string with defined length and content
string fill(size_t length = 0, string txt = "0") {
  string result; 
	if (txt) {
		while (result.length < length) result ~= txt;
		result.length = length; // cut result to length
	}
  return result;
}
unittest {
  assert(fill(10, "0") == "0000000000");
  assert(fill(10, "TXT") == "TXTTXTTXTT");
}

string bind(string source, string[string] values, string limiter = "%") {
	import std.string; 
	string result = source;
	foreach(k, v; values) { result = result.replace(limiter~k~limiter, v); }
	return result;
}
unittest {
	/// TODO
}

bool endsWith(string str, string txt) {
	if (str.length == 0) return false;
	if (txt.length == 0) return false;
	return (lastIndexOf(str, txt) == str.length-1);
}
unittest {
	assert("ABC".endsWith("C"));	
	assert(!"".endsWith("C"));	
	assert(!"ABC".endsWith(""));	
}

bool has(string base, string[] values...)  { return has(base, values); }
bool has(string base, string[] values)  {
	foreach(value; values) if ((base.indexOf(value) >= 0) && (base.indexOf(value) < base.length)) return true;
	return false;
}
unittest {
  assert("One Two Three".has("One"));
  assert("One Two Three".has("Five", "Four", "Three"));
  assert(!"One Two Three".has("Five", "Four"));
}

bool has(string[] bases, string[] values...)  { return has(bases, values); }
bool has(string[] bases, string[] values)  {
	foreach(base; bases) if (base.has(values)) return true;
	return false;
}
unittest {
  assert(["One Two Three"].has("One"));
  assert(["One Two Three", "Eight Seven Six"].has("Five", "Four", "Six"));
  assert(!["One Two Three"].has("Five", "Four"));
}

/// remove all string values from a array of strings
string[] remove(string[] values, string[] removeValues...) {
	string[] results = values;
	foreach(removeValue; removeValues) {
		auto existingValues = results;
		results = null;
		foreach(value; existingValues) { if (value != removeValue) results ~= value; }
	}
	return results;
}
unittest{
	assert(remove(["a", "b", "c"], "b") == ["a", "c"]);
	assert(remove(["a", "b", "c", "b"], "b") == ["a", "c"]);

	assert(remove(["a", "b", "c"], "a", "b") == ["c"]);
	assert(remove(["a", "b", "c", "b"], "a", "b") == ["c"]);
}

/// Unique - Reduce duplicates in array
string[] unique(string[] values) {
	string[] results; results.length = values.length; size_t counter = 0;
	foreach(value; values) { if (!has(results, value)) { results[counter] = value; counter++; }}
	results.length = counter;
	return results;
}
unittest{
	assert(["a", "b", "c"].unique == ["a", "b", "c"]);
	assert(["a", "b", "c", "c"].unique == ["a", "b", "c"]);
}

size_t[string] countValues(string[] values) {
	size_t[string] results;
	foreach(v; values) {
		if (v in results) results[v] += 1; 
		else results[v] = 1;    
	}
	return results;
}
unittest {
	/// TODO
}


bool startsWith(string str, string txt) {
	if (str.length == 0) return false;
	if (txt.length == 0) return false;
	return (indexOf(str, txt) == 0);
}
unittest {
	assert("ABC".startsWith("A"));	
	assert(!"".startsWith("A"));	
	assert(!"ABC".startsWith(""));	
}

string toString(string[] values) {
	import std.string; 
	return "%s".format(values);
}

string quotes(string text, string leftAndRight) {
	return leftAndRight~text~leftAndRight;
}
string quotes(string text, string left, string right) {
	return left~text~right;
}

string[] toStrings(T...)(T tt){
	string[] results;
	foreach(t; tt) results ~= "%s".format(t);
	return results;
}
unittest {
	/// TODO
}

string indent(in string txt, int indent = 2) {	
	string result = txt;
	for(auto i = 0; i < indent; i++) result = " "~result;
	return result; 
}
unittest {
	assert(indent("Hallo") == "  Hallo");
	assert(indent("Hallo", 3) == "   Hallo");
}

size_t[] indexOfAll(string text, string searchTxt) {
	if (text.indexOf(searchTxt) == -1) return [];

	size_t[] results;
	size_t currentPos = 0;
	while((currentPos < text.length) && (currentPos >= 0)) {
		currentPos = text.indexOf(searchTxt, currentPos);
		if ((currentPos < text.length) && (currentPos >= 0)) {
			results ~= currentPos;
			currentPos++; 
		}
	}

	return results;
}
unittest {
}	
