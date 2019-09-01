module uim.core.containers.stringaa;

import std.algorithm : startsWith, endsWith; 
import uim.core; 

alias StringAA = string[string];

StringAA addKeyPrefix(StringAA entries, string prefix) {
	StringAA results;
	foreach(k, v; entries) results[prefix~k] = v;
	return results;
}

StringAA concat(StringAA left, StringAA right) {  // right will overright left
	StringAA results = left.dup;
	foreach(k, v; right) results[k] = v;
	return results;
}

StringAA startsWith(StringAA entries, string prefix) {  // right will overright left
	StringAA results;
	foreach(k, v; entries) if (k.startsWith(prefix)) results[k] = v;
	return results;
}

StringAA startsNotWith(StringAA entries, string prefix) {  // right will overright left
	StringAA results;
	foreach(k, v; entries) if (!k.startsWith(prefix)) results[k] = v;
	return results;
}

StringAA endsWith(StringAA entries, string postfix) {  // right will overright left
	StringAA results;
	foreach(k, v; entries) if (k.endsWith(postfix)) results[k] = v;
	return results;
}

StringAA endsNotWith(StringAA entries, string postfix) {  // right will overright left
	StringAA results;
	foreach(k, v; entries) if (!k.endsWith(postfix)) results[k] = v;
	return results;
}

StringAA selectKeys(StringAA entries, string[] keys) {
	StringAA results;
	foreach(k; keys) if (k in entries) results[k] = entries[k];
	return results;
}

StringAA selectNotKeys(StringAA entries, string[] keys) {
	StringAA results = entries.dup;
	foreach(k; keys) if (k in entries) results.remove(k);
	return results;
}

StringAA selectValues(StringAA entries, string[] values) {
	StringAA results;
	foreach(val; values) {
		foreach(k, v; entries) {
			if (v == val) results[k] = entries[k];
		}
	}
	return results;
}

bool isIn(string value, string[] values) {
	foreach(v; values) if (v == value) return true;
	return false;
}
bool has(string[] values, string value) {
	foreach(v; values) if (v == value) return true;
	return false;
}
//StringAA selectNotKeys(StringAA entries, string[] values) {
//	StringAA results = entries.dup;
//	foreach(v; values) {
//		if (k in entries) results.remove(k);
//	}
//	return results;
//}

string toString(string[string] aa) {
	import std.string; 
	return "%s".format(aa);
}
//string stripTags(string txt, string[] tags = null, bool lowerAndUpper = false) {
//if (tags) {
//foreach(tag; tags) {
//}
//}
//else {
//while () {
//}
//}
//}

string toHTML(STRINGAA aa, string sep = "=", string rightQuotes = "\"", string leftQuotes = "") {
	string[] strings;
	foreach(k, v; aa) strings ~= leftQuotes~k~leftQuotes~sep~rightQuotes~v~rightQuotes;
	return strings.join(" ");
}

string aa2String(STRINGAA atts, string sep = "=") {
	string[] strings;
	foreach(k, v; atts) strings ~= k~sep~"\""~v~"\"";
	return strings.join(" ");
}
//string toString(STRINGAA atts) {
//	string[] strings;
//	foreach(k, v; atts) strings ~= k~"=\""~v~"\"";
//	return strings.join(" ");
//}

unittest {
	
}