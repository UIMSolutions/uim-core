/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/containers/STRINGAA
************************************************************************************************/
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
unittest {
	assert(["a":"1"].addKeyPrefix("x") == ["xa":"1"]);
	assert(["a":"1", "b":"2"].addKeyPrefix("x").hasKey("xb"));
}

/// Selects only entries, where key starts with prefix. Creates a new STRINGAA
STRINGAA allStartsWith(STRINGAA entries, string prefix) {  
	STRINGAA results;
	foreach(k, v; entries) if (k.startsWith(prefix)) results[k] = v;
	return results;
}
unittest {
	assert(allStartsWith(["preA":"a", "b":"b"], "pre") == ["preA":"a"]);
	assert(["preA":"a", "b":"b"].allStartsWith("pre") == ["preA":"a"]);
}

/// Opposite of selectStartsWith: Selects only entries, where key starts not with prefix. Creates a new STRINGAA
STRINGAA allStartsNotWith(STRINGAA entries, string prefix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (!k.startsWith(prefix)) results[k] = v;
	return results;
}
unittest {
	assert(allStartsNotWith(["preA":"a", "b":"b"], "pre") == ["b":"b"]);
	assert(["preA":"a", "b":"b"].allStartsNotWith("pre") == ["b":"b"]);
}


STRINGAA allEndsWith(STRINGAA entries, string postfix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (k.endsWith(postfix)) results[k] = v;
	return results;
}
unittest {
	version(test_uim_core) {
		/// TODO #test Add Tests
}}

STRINGAA allEndsNotWith(STRINGAA entries, string postfix) {  // right will overright left
	STRINGAA results;
	foreach(k, v; entries) if (!k.endsWith(postfix)) results[k] = v;
	return results;
}
unittest {
	version(test_uim_core) {
		/// TODO Add Tests
}}


STRINGAA withKeys(STRINGAA entries, string[] keys...) {
	return withKeys(entries, keys);
}
STRINGAA withKeys(STRINGAA entries, string[] keys) {
	STRINGAA results;
	foreach(k; keys) if (k in entries) results[k] = entries[k];
	return results;
}
unittest {
	version(test_uim_core) {
		assert(["a":"1", "b":"2"].withKeys("a") == ["a":"1"]);
	}
}
STRINGAA notWithKeys(STRINGAA entries, string[] keys...) {
	return notWithKeys(entries, keys);
}
STRINGAA notWithKeys(STRINGAA entries, string[] keys) {
	STRINGAA results = entries.dup;
	foreach(k; keys) if (k in entries) results.remove(k);
	return results;
}
unittest {
	version(test_uim_core) {
		assert(["a":"1", "b":"2"].notWithKeys("a") == ["b":"2"]);
	}
}

// Gets STRINGAA with values
STRINGAA withValues(STRINGAA entries, string[] values...) {
	return withValues(entries, values);
}
STRINGAA withValues(STRINGAA entries, string[] values) {
	STRINGAA results;
	foreach(val; values) {
		foreach(key, v; entries) {
			if (v == val) results[key] = entries[key];
		}
	}
	return results;
}
unittest {
	version(test_uim_core) {
		assert(["a":"1", "b":"2"].withValues("1") == ["a":"1"]);
		assert(["a":"1", "b":"2"].withValues("0").empty);
}}

string toString(string[string] aa) {
	import std.string; 
	return "%s".format(aa);
}
unittest {
	version(test_uim_core) {
	/// Add Tests
}}

string aa2String(STRINGAA atts, string sep = "=") {
	string[] strings;
	foreach(k, v; atts) strings ~= k~sep~"\""~v~"\"";
	return strings.join(" ");
}
unittest {
	version(test_uim_core) {
	/// Add Tests
}}

string getValue(STRINGAA keyValues, string[] keys...) {
	foreach(k; keys) if (k in keyValues) return keyValues[k];
	return null;
}
unittest {
	version(test_uim_core) {
		/// TODO Add Tests
}}

