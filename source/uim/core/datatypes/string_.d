module uim.core.datatypes.string_;

import std.stdio; 
import std.string; 
import uim.core;

/**
 * fill - create a string with defined length and content
 */
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

/**********************************************************************
 * /// TODO
 **********************************************************************/
@safe string bind(string source, string[string] values, string limiter = "%") {
	import std.string; 
	string result = source;
	foreach(k, v; values) { result = result.replace(limiter~k~limiter, v); }
	return result;
}
unittest {
	/// TODO
}


/**********************************************************************
 * /// TODO
 **********************************************************************/
@safe bool endsWith(string str, string txt) {
	if (str.length == 0) return false;
	if (txt.length == 0) return false;
	return (lastIndexOf(str, txt) == str.length-1);
}
unittest {
	assert("ABC".endsWith("C"));	
	assert(!"".endsWith("C"));	
	assert(!"ABC".endsWith(""));	
}

// values.has(searchValue) : true | false
// @safe bool has(string value, string searchText) { return (indexOf(value, searchText) != -1); }  
// @safe bool has(string[] values, string searchText) { return (indexOf(value, searchText) != -1); }  

/**********************************************************************
 * /// TODO
 **********************************************************************/
@safe bool has(string base, string[] values...)  { return has(base, values); }
@safe bool has(string base, string[] values)  {
	foreach(value; values) if ((base.indexOf(value) >= 0) && (base.indexOf(value) < base.length)) return true;
	return false;
}
@safe unittest {
  assert("One Two Three".has("One"));
  assert("One Two Three".has("Five", "Four", "Three"));
  assert(!"One Two Three".has("Five", "Four"));
}

/**********************************************************************
 * /// TODO
 **********************************************************************/
@safe bool has(string[] bases, string[] values...)  { return has(bases, values); }
@safe bool has(string[] bases, string[] values)  {
	foreach(base; bases) if (base.has(values)) return true;
	return false;
}
@safe unittest {
  assert(["One Two Three"].has("One"));
  assert(["One Two Three", "Eight Seven Six"].has("Five", "Four", "Six"));
  assert(!["One Two Three"].has("Five", "Four"));
}

/**
 * remove all string values from a array of strings
 * 
 * Parameters:
 * values = string array
 * removeValues = values which should be removed
 */
@safe string[] remove(string[] values, string[] removeValues...) {
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
@safe string[] unique(string[] values) {
	string[] results; results.length = values.length; size_t counter = 0;
	foreach(value; values) { if (!has(results, value)) { results[counter] = value; counter++; }}
	results.length = counter;
	return results;
}
unittest{
	assert(["a", "b", "c"].unique == ["a", "b", "c"]);
	assert(["a", "b", "c", "c"].unique == ["a", "b", "c"]);
}

@safe size_t[string] countValues(string[] values) {
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


@safe bool startsWith(string str, string txt) {
	if (str.length == 0) return false;
	if (txt.length == 0) return false;
	return (indexOf(str, txt) == 0);
}
unittest {
	assert("ABC".startsWith("A"));	
	assert(!"".startsWith("A"));	
	assert(!"ABC".startsWith(""));	
}

@safe string toString(string[] values) {
	import std.string; 
	return "%s".format(values);
}

@safe string quotes(string text, string leftAndRight) {
	return leftAndRight~text~leftAndRight;
}
@safe string quotes(string text, string left, string right) {
	return left~text~right;
}

@safe string[] toStrings(T...)(T tt){
	string[] results;
	foreach(t; tt) results ~= "%s".format(t);
	return results;
}
unittest {
	/// TODO
}

@safe string indent(in string txt, int indent = 2) {	
	string result = txt;
	for(auto i = 0; i < indent; i++) result = " "~result;
	return result; 
}
unittest {
	assert(indent("Hallo") == "  Hallo");
	assert(indent("Hallo", 3) == "   Hallo");
}

size_t[] indexOfAll(string text, string searchTxt) {
	writeln(text.indexOf(searchTxt));
	if (text.indexOf(searchTxt) == -1) return [];

	size_t[] results;
	size_t currentPos = 0;
	while((currentPos < text.length) && (currentPos >= 0)) {
		currentPos = text.indexOf(searchTxt, currentPos);
		write(currentPos, "\t");
		if ((currentPos < text.length) && (currentPos >= 0)) {
			results ~= currentPos;
			currentPos++; 
		}
	}

	return results;
}
unittest {
	//writeln("< < < <");
	//writeln("< < < <".indexOfAll("<"));
	//writeln("< < < <".indexOfAll(" "));
}	
