/***********************************************************************************************************************
*	Copyright: © 2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.containers.stringaa;

@safe:
import std.algorithm : startsWith, endsWith; 
import uim.core; 

/// Renames keys to prefix~key
STRINGAA addKeyPrefix(STRINGAA entries, string prefix) {
	STRINGAA results;
	foreach(key, value; entries) results[prefix~key] = value;
	return results;
}
version(test_uim_core) { unittest {
	assert(["a":"1"].addKeyPrefix("x") == ["xa":"1"]);
	assert(["a":"1", "b":"2"].addKeyPrefix("x").hasKey("xb"));
}}

/// Selects only entries, where key starts with prefix. Creates a new STRINGAA
STRINGAA allStartsWith(STRINGAA entries, string prefix) {  
	STRINGAA results;
	foreach(k, v; entries) if (k.startsWith(prefix)) results[k] = v;
	return results;
}
version(test_uim_core) { unittest {
	assert(allStartsWith(["preA":"a", "b":"b"], "pre") == ["preA":"a"]);
	assert(["preA":"a", "b":"b"].allStartsWith("pre") == ["preA":"a"]);
}}

/// Opposite of selectStartsWith: Selects only entries, where key starts not with prefix. Creates a new STRINGAA
STRINGAA allStartsNotWith(STRINGAA entries, string prefix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (!k.startsWith(prefix)) results[k] = v;
	return results;
}
version(test_uim_core) { unittest {
	assert(allStartsNotWith(["preA":"a", "b":"b"], "pre") == ["b":"b"]);
	assert(["preA":"a", "b":"b"].allStartsNotWith("pre") == ["b":"b"]);
}}


STRINGAA allEndsWith(STRINGAA entries, string postfix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (k.endsWith(postfix)) results[k] = v;
	return results;
}
version(test_uim_core) { unittest {
		/// TODO #test Add Tests
}}

STRINGAA allEndsNotWith(STRINGAA entries, string postfix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (!k.endsWith(postfix)) results[k] = v;
	return results;
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


STRINGAA filterByKeys(STRINGAA entries, string[] keys...) {
	return filterByKeys(entries, keys.dup);
}
STRINGAA filterByKeys(STRINGAA entries, string[] keys) {
	STRINGAA results;
	foreach(k; keys) if (k in entries) results[k] = entries[k];
	return results;
}
version(test_uim_core) { unittest {
		assert(["a":"1", "b":"2"].filterByKeys("a") == ["a":"1"]);
}}
STRINGAA notFilterByKeys(STRINGAA entries, string[] keys...) {
	return notFilterByKeys(entries, keys.dup);
}
STRINGAA notFilterByKeys(STRINGAA entries, string[] keys) {
	STRINGAA results = entries.dup;
	foreach(k; keys) if (k in entries) results.remove(k);
	return results;
}
version(test_uim_core) { unittest {
		assert(["a":"1", "b":"2"].notFilterByKeys("a") == ["b":"2"]);
}}

// Gets STRINGAA with values
STRINGAA filterByValues(STRINGAA entries, string[] values...) {
	return filterByValues(entries, values.dup);
}
STRINGAA filterByValues(STRINGAA entries, string[] values) {
	STRINGAA results;
	foreach(val; values) {
		foreach(key, v; entries) {
			if (v == val) results[key] = entries[key];
		}
	}
	return results;
}
version(test_uim_core) { unittest {
		assert(["a":"1", "b":"2"].filterByValues("1") == ["a":"1"]);
		assert(["a":"1", "b":"2"].filterByValues("0").empty);
}}

string toString(string[string] aa) {
	import std.string; 
	return "%s".format(aa);
}
version(test_uim_core) { unittest {
	/// Add Tests
}}

string aa2String(STRINGAA atts, string sep = "=") {
	string[] strings;
	foreach(k, v; atts) strings ~= k~sep~"\""~v~"\"";
	return strings.join(" ");
}
version(test_uim_core) { unittest {
	/// Add Tests
}}

string getValue(STRINGAA keyValues, string[] keys...) {
	foreach(k; keys) if (k in keyValues) return keyValues[k];
	return null;
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}

