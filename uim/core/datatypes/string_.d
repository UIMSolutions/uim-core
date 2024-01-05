/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.string_;

import uim.core;

@safe:

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

string bind(string source, STRINGAA values, string limiter = "%") {
	import std.string; 
	string result = source;
	foreach(k, v; values) { result = result.replace(limiter~k~limiter, v); }
	return result;
}
version(test_uim_core) { unittest {
	/// TODO
}}

bool endsWith(string str, string txt) {
	if (str.length == 0) { 
      return false; 
    }
	if (txt.length == 0) { 
      return false; 
    }
	return (lastIndexOf(str, txt) == str.length-1);
}
version(test_uim_core) { unittest {
	assert("ABC".endsWith("C"));	
	assert(!"".endsWith("C"));	
	assert(!"ABC".endsWith(""));	
}}

// #region has


  bool hasValues(string[] bases, string[] values...)  { 
    return hasValues(bases, values.dup); 
  }
  bool hasValues(string[] bases, string[] values)  {
    foreach(base; bases) if (base.hasValues(values)) { return true; }
    return false;
  }
  unittest {
    assert(["One Two Three"].hasValues("One"));
    assert(["One Two Three", "Eight Seven Six"].hasValues("Five", "Four", "Six"));
    assert(!["One Two Three"].hasValues("Five", "Four"));
  }

  bool hasValues(string base, string[] values...)  { 
    return hasValues(base, values.dup); 
  }

  bool hasValues(string base, string[] values)  {
    foreach(value; values) if ((base.hasValue(value))) { return true; }
    return false;
  }
  unittest {
    assert("One Two Three".hasValues("One"));
    assert("One Two Three".hasValues("Five", "Four", "Three"));
    assert(!"One Two Three".hasValues("Five", "Four"));
  }

  bool hasValue(string base, string aValue)  {
    return ((base.indexOf(aValue) >= 0) && (base.indexOf(aValue) < base.length));
  }
// #endregion has

// #region remove
  pure string[] removeValues(string[] values, string[] removingValues...) {
    return removeValues(values, removingValues.dup);
  }

  pure string[] removeValues(string[] values, string[] removingValues) {
    string[] results = values;
    removingValues
      .each!(value => results = results.removeValue(value));

    return results;
  }
  version(test_uim_core) { unittest {
    assert(removeValues(["a", "b", "c"], "b") == ["a", "c"]);
    assert(removeValues(["a", "b", "c", "b"], "b") == ["a", "c"]);

    assert(removeValues(["a", "b", "c"], "a", "b") == ["c"]);
    assert(removeValues(["a", "b", "c", "b"], "a", "b") == ["c"]);
  }}

  pure string[] removeValue(string[] values, string removeValue) {
    string[] results = values
      .filter!(value => value != removeValue)
      .array;

    return results;
  }
   unittest {
    assert(removeValue(["a", "b", "c"], "b") == ["a", "c"]);
    assert(removeValue(["a", "b", "c", "b"], "b") == ["a", "c"]);
  }
// #endregion remove

/// Unique - Reduce duplicates in array
string[] unique(string[] someValues) {
  STRINGAA results; 
	foreach(value; someValues) { results[value] = value; }
	return results.keys.array;
}
version(test_uim_core) { unittest {
	assert(["a", "b", "c"].unique == ["a", "b", "c"]);
	assert(["a", "b", "c", "c"].unique == ["a", "b", "c"]);
}}

bool startsWith(string str, string txt) {
	if (str.length == 0) { 
      return false; 
    }
	if (txt.length == 0) { 
      return false; 
    }
	return (indexOf(str, txt) == 0);
}
version(test_uim_core) { unittest {
	assert("ABC".startsWith("A"));	
	assert(!"".startsWith("A"));	
	assert(!"ABC".startsWith(""));	
}}

string toString(string[] values) {
	return "%s".format(values);
}

string quotes(string text, string leftAndRight) {
	return leftAndRight~text~leftAndRight;
}
string quotes(string text, string left, string right) {
	return left~text~right;
}

/* 
string[] toStrings(T...)(T someValues...){
	string[] results;
	results = someValues.map!(value => "%s".format(value)).array;
	return results;
}
unittest {
	debug writeln(toStrings(1, 2));
	debug writeln(toStrings(1, "a"));
}
*/ 

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
		return startPos >= aText.length ? null : aText[startPos..$];
	}
	else { // startPos < 0
		return -startPos >= aText.length ? null : aText[0..$+startPos];
	}
}
unittest {
	assert("This is a test".subString(4) == " is a test");
	assert("This is a test".subString(-4) == "This is a ");
}

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
unittest {
	assert("0123456789".subString(4, 2) == "45");
	assert("0123456789".subString(-4, 2) == "01");
	assert("0123456789".subString(-4, -2) == "45");
}

string capitalizeWords(string aText) {
	auto words = aText.split(" ");
	return words.map!(w => w.capitalize).array.join(" "); 
}
version(test_uim_core) { unittest {
	assert("this is a test".capitalizeWords == "This Is A Test");
	assert("this  is  a  test".capitalizeWords == "This  Is  A  Test");
}}

size_t[string] countWords(string aText, bool caseSensitive = true) {
	size_t[string] results;

  // TODO missing caseSensitive = false
	aText
    .split(" ")
    .each!(word => results[word] = word in results ? results[word] + 1 : 1);

	return results;
}
unittest {
	// assert(countWords("This is a test")["this"] == 0);
	assert(countWords("this is a test")["this"] == 1);
	assert(countWords("this is a this")["this"] == 2);
}

string repeat(string text, size_t times) {
	auto result = "";
	for(auto i = 0; i < times; i++) {
		result ~= text;
	}
	return result;
}
unittest {
	assert(repeat("bla", 0) == "");
	assert(repeat("bla", 2) == "blabla");
}


