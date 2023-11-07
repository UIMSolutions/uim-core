/***********************************************************************************************************************
*	Copyright: © 2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
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
version(test_uim_core) { unittest {
  assert(fill(10, "0") == "0000000000");
  assert(fill(10, "TXT") == "TXTTXTTXTT");
}}

string bind(string source, string[string] values, string limiter = "%") {
	import std.string; 
	string result = source;
	foreach(k, v; values) { result = result.replace(limiter~k~limiter, v); }
	return result;
}
version(test_uim_core) { unittest {
	/// TODO
}}

bool endsWith(string str, string txt) {
	if (str.length == 0) { return false; }
	if (txt.length == 0) { return false; }
	return (lastIndexOf(str, txt) == str.length-1);
}
version(test_uim_core) { unittest {
	assert("ABC".endsWith("C"));	
	assert(!"".endsWith("C"));	
	assert(!"ABC".endsWith(""));	
}}

/* bool has(string base, string[] values...)  { return has(base, values); }
bool has(string base, string[] values)  {
	foreach(value; values) if ((base.indexOf(value) >= 0) && (base.indexOf(value) < base.length)) { return true; }
	return false;
}
version(test_uim_core) { unittest {
  assert("One Two Three".has("One"));
  assert("One Two Three".has("Five", "Four", "Three"));
  assert(!"One Two Three".has("Five", "Four"));
}

bool has(string[] bases, string[] values...)  { return has(bases, values); }
bool has(string[] bases, string[] values)  {
	foreach(base; bases) if (base.has(values)) { return true; }
	return false;
}
version(test_uim_core) { unittest {
  assert(["One Two Three"].has("One"));
  assert(["One Two Three", "Eight Seven Six"].has("Five", "Four", "Six"));
  assert(!["One Two Three"].has("Five", "Four"));
}}
 */
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
version(test_uim_core) { unittest {
	assert(remove(["a", "b", "c"], "b") == ["a", "c"]);
	assert(remove(["a", "b", "c", "b"], "b") == ["a", "c"]);

	assert(remove(["a", "b", "c"], "a", "b") == ["c"]);
	assert(remove(["a", "b", "c", "b"], "a", "b") == ["c"]);
}}

/// Unique - Reduce duplicates in array
string[] unique(string[] values) {
	string[] results; results.length = values.length; size_t counter = 0;
	foreach(value; values) { if (!results.hasValue(value)) { results[counter] = value; counter++; }}
	results.length = counter;
	return results;
}
version(test_uim_core) { unittest {
	assert(["a", "b", "c"].unique == ["a", "b", "c"]);
	assert(["a", "b", "c", "c"].unique == ["a", "b", "c"]);
}}

size_t[string] countValues(string[] values) {
	size_t[string] results;
	values.each!(value => results[value] = value in results ? results[value] + 1 : 1);    
	
	return results;
}
version(test_uim_core) { unittest {
	/// TODO
}}


bool startsWith(string str, string txt) {
	if (str.length == 0) { return false; }
	if (txt.length == 0) { return false; }
	return (indexOf(str, txt) == 0);
}
version(test_uim_core) { unittest {
	assert("ABC".startsWith("A"));	
	assert(!"".startsWith("A"));	
	assert(!"ABC".startsWith(""));	
}}

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
version(test_uim_core) { unittest {
	/// TODO
}}

string indent(in string txt, int indent = 2) {	
	string result = txt;
	for(auto i = 0; i < indent; i++) result = " "~result;
	return result; 
}
version(test_uim_core) { unittest {
	assert(indent("Hallo") == "  Hallo");
	assert(indent("Hallo", 3) == "   Hallo");
}}

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
version(test_uim_core) { unittest {
}}

// subString() - returns a part of a string.
// aText - String value
// startPos - Required. Specifies where to start in the string. Starting with 0 (first letter)
// -- A positive number - Start at a specified position in the string
// -- A negative number - Start at a specified position from the end of the string
// -- 0 - Start at the first character in string
string subString(string aText, long startPos) {
	if (startPos == 0) return aText;

	if (startPos > 0) {
		if (startPos >= aText.length) { return null; }
		return aText[startPos..$];
	}
	else { // startPos < 0
		if (-startPos >= aText.length) { return null; }	
		return aText[0..$+startPos];
	}
}
version(test_uim_core) { unittest {
	assert("This is a test".subString(4) == " is a test");
	assert("This is a test".subString(-4) == "This is a ");
}}

// same like subString(), with additional parameter length
// length	- Specifies the length of the returned string. Default is to the end of the string.
// A positive number - The length to be returned from the start parameter
// Negative number - The length to be returned from the end of the string
// If the length parameter is 0, NULL, or FALSE - it return an empty string
string subString(string aText, size_t startPos, long aLength) {
	auto myText = subString(aText, startPos);
	if (aLength > 0) {
		return myText.length >= aLength ? myText[0..aLength] : null;
	}
	else { // aLength < 0
		return myText.length >= -aLength ? myText[$+aLength..$] : null;
	} 
}
version(test_uim_core) { unittest {
	assert("0123456789".subString(4, 2) == "45");
	assert("0123456789".subString(-4, 2) == "01");
	assert("0123456789".subString(-4, -2) == "45");
}}

string capitalizeWords(string aText) {
	auto words = aText.split(" ");
	return words.map!(w => w.capitalize).array.join(" "); 
}
version(test_uim_core) { unittest {
	assert("this is a test".capitalizeWords == "This Is A Test");
	assert("this  is  a  test".capitalizeWords == "This  Is  A  Test");
}}

size_t[string] countWords(string aText) {
	size_t[string] results;

	foreach(word; aText.split(" ")) {
		if (word !in results) { results[word] = 0; }
 		results[word]++;
 	}

	return results;
}
unittest {
	assert(countWords("this is a test")["this"] == 1);
}

string repeat(string text, size_t times) {
	auto result = "";
	for(auto i = 0; i < times; i++) {
		result ~= text;
	}
	return result;
}
version(test_uim_core) { unittest {
	assert(repeat("bla", 0) == "");
	assert(repeat("bla", 2) == "blabla");
}}


