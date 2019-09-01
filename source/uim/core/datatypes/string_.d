module uim.core.datatypes.string_;

import std.stdio; 
import std.string; 
import uim.core;

@safe string bind(string source, string[string] values, string limiter = "%") {
	import std.string; 
	string result = source;
	foreach(k, v; values) { result = result.replace(limiter~k~limiter, v); }
	return result;
}

// values.has(searchValue) : true | false
@safe bool has(string value, string txt) { return (indexOf(value, txt) > -1); }  
@safe bool has(string[] values, string searchValue) {
	foreach(value; values) if (value == searchValue) return true;
	return false;
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

@safe string[] unique(string[] values) {
	string[] results;
	foreach(value; values) { if (!results.has(value)) results ~= value; }
	return results;
}

@safe size_t[string] countValues(string[] values) {
	size_t[string] results;
	foreach(v; values) {
		if (v in results) results[v] += 1; 
		else results[v] = 1;    
	}
	return results;
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
	
}