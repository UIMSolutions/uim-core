/***********************************************************************************************************************
	Copyright: © 2017-2023 Ozan Nurettin Süel (sicherheitsschmiede)                              
	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                          
***********************************************************************************************************************/
module uim.core.containers.aa;

@safe:
import uim.core;

enum SORTED = true;
enum NOTSORTED = false;

/// get keys of an associative array
/// sorted = false (default) returns an unsorted array, sorted = true returns a sorted array
K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
	K[] results = aa.keys;
	if (sorted) return results.sort.array;
	return results;
}
///
unittest {
	// getKeys(aa) == aa.keys; getKeys(aa, true) == aa.keys.sort.array	

	// Using scalars
	assert([1:4, 2:5, 3:6].getKeys(true) == [1, 2, 3]);
	assert([1:"4", 2:"5", 3:"6"].getKeys(true) == [1, 2, 3]);
	assert(["1":4, "2":5, "3":6].getKeys(true) == ["1", "2", "3"]);
	assert(["1":"4", "2":"5", "3":"6"].getKeys(true) == ["1", "2", "3"]);
	
	// Using objects
	class Test {}
	auto a = new Test;
	auto b = new Test;
	auto c = new Test;
	assert([1:a, 2:b, 3:c].getKeys(true) == [1, 2, 3]);
}

/// get values of an associative array - currently not working für objects
V[] getValues(K, V)(V[K] aa, bool sorted = NOTSORTED) {
	V[] results;
	foreach(k, v; aa) results ~= v;
	if (sorted) return results.sort.array;
	return results;
}
version(test_uim_core) { unittest {
	assert([1:4, 2:5, 3:6].getValues(SORTED) == [4, 5, 6]);
	assert([1:"4", 2:"5", 3:"6"].getValues(SORTED) == ["4", "5", "6"]);
	assert(["1":4, "2":5, "3":6].getValues(SORTED) == [4, 5, 6]);
	assert(["1":"4", "2":"5", "3":"6"].getValues(SORTED) == ["4", "5", "6"]);
}}

// Add Items from array
T[S] add(T, S)(T[S] baseItems, T[S] addItems) {
	T[S] results = baseItems.dup;
	foreach(k, v; addItems) results[k] = v;
	return results;
}
version(test_uim_core) { unittest {
		assert([1:"b", 2:"d"].add([3:"f"]) == [1:"b", 2:"d", 3:"f"]);
		assert(["a":"b", "c":"d"].add(["e":"f"]) == ["a":"b", "c":"d", "e":"f"]);
		assert(["a":"b", "c":"d"].add(["e":"f"]).add(["g":"h"]) == ["a":"b", "c":"d", "e":"f", "g":"h"]);
}}

/// remove subItems from baseItems if key and value of item are equal
T[S] sub(T, S)(T[S] baseItems, T[S] subItems) {
	T[S] results = baseItems.dup;
	foreach(k, v; subItems) 
		if ((k in results) && (results[k] == v)) results.remove(k);
	return results;
}
version(test_uim_core) { unittest {
	 	assert([1:"4", 2:"5", 3:"6"].sub([1:"5", 2:"5", 3:"6"]) == [1:"4"]);
}}

/// remove subItems from baseItems if key exists
T[S] subKeys(T, S)(T[S] baseItems, S[] subItems...) {
	return subKeys(baseItems, subItems);
}
version(test_uim_core) { unittest {
 		assert([1:"4", 2:"5", 3:"6"].subKeys(2, 3) == [1:"4"]);
}}

/// remove subItems from baseItems if key exists
T[S] subKeys(T, S)(T[S] baseItems, S[] subItems) {
	T[S] results = baseItems.dup;
	foreach(key; subItems) results.remove(key);
	return results;
}
version(test_uim_core) { unittest {
	 	assert([1:"4", 2:"5", 3:"6"].subKeys([2, 3]) == [1:"4"]);
}}

/// remove subItems from baseItems if key exists
T[S] subKeys(T, S)(T[S] baseItems, T[S] subItems) {
	T[S] results = baseItems.dup;
	foreach(k, v; subItems) results.remove(k);
	return results;
}
version(test_uim_core) { unittest {
	 	assert([1:"4", 2:"5", 3:"6"].subKeys([2:"x", 3:"y"]) == [1:"4"]);
}}

/// remove subItems from baseItems if value exists
T[S] subValues(T, S)(T[S] baseItems, T[S] subItems) {
	T[S] results = baseItems.dup;
	foreach(k, v; subItems) {
		foreach(kk, vv; baseItems) if (v == vv) results.remove(kk);
	}
	return results;
}
version(test_uim_core) { unittest {
 	assert([1:"4", 2:"5", 3:"6"].subValues([2:"5", 3:"6"]) == [1:"4"]);
 	assert([7:"4", 8:"5", 9:"6"].subValues([2:"5", 3:"6"]) == [7:"4"]);
 	assert([7:"4", 8:"5", 9:"6"].subValues([2:"2", 3:"2"]) != [7:"4"]);

 	assert([1:4, 2:5, 3:6].subValues([2:5, 3:6]) == [1:4]);
 	assert([7:4, 8:5, 9:6].subValues([2:5, 3:6]) == [7:4]);
 	assert([7:4, 8:5, 9:6].subValues([2:2, 3:2]) != [7:4]);
}}

pure size_t[T] indexAA(T)(T[] values, size_t startPos = 0) {
	size_t[T] results;
	foreach(i, value; values) results[value] = i + startPos;
	return results;
}
version(test_uim_core) { unittest {
		assert(["a", "b", "c"].indexAA == ["a":0UL, "b":1UL, "c":2UL]);
		assert(["a", "b", "c"].indexAA(1) == ["a":1UL, "b":2UL, "c":3UL]);
}}

pure size_t[T] indexAAReverse(T)(T[] values, size_t startPos = 0) {
	size_t[T] results;
	foreach(i, value; values) results[i + startPos] = value;
	return results;
}
version(test_uim_core) { unittest {
		// Add Test
}}

bool hasKey(T, S)(T[S] base, S key) { return (key in base) ? true : false; }
bool hasKeys(T, S)(T[S] base, S[] keys...) { return base.hasKeys(keys); }
bool hasKeys(T, S)(T[S] base, S[] keys) { bool result; foreach(key; keys) if (key !in base) return false; return true; }
version(test_uim_core) { unittest {
	assert(["a":"b", "c":"d"].hasKey("a"));
	assert(["a":"b", "c":"d"].hasKeys("a"));
	assert(["a":"b", "c":"d"].hasKeys("a", "c"));
	assert(["a":"b", "c":"d"].hasKeys(["a"]));
	assert(["a":"b", "c":"d"].hasKeys(["a", "c"]));
}}

bool hasValue(T, S)(T[S] base, S value...) { foreach(v; base.getValues) if (v == value) return true; return false; }
bool hasValues(T, S)(T[S] base, S[] values...) { return base.hasValues(values); }
bool hasValues(T, S)(T[S] base, S[] values) { foreach(value; values) if (!base.hasValue(value)) return false; return true; }
version(test_uim_core) { unittest {
	assert(["a":"b", "c":"d"].hasValue("b"));
	assert(["a":"b", "c":"d"].hasValues("b"));
	assert(["a":"b", "c":"d"].hasValues("b", "d"));
	assert(["a":"b", "c":"d"].hasValues(["b"]));
	assert(["a":"b", "c":"d"].hasValues(["b", "d"]));
}}

pure string toJSONString(T)(T[string] values, bool sorted = NOTSORTED) {
	string[] result; 

	foreach(k; values.getKeys(sorted)) result ~= `"%s":%s`.format(k, values[k]);

	return "{"~result.join(",")~"}";
}
version(test_uim_core) { unittest {
		assert(["a":1, "b":2].toJSONString(SORTED) == `{"a":1,"b":2}`);
}}

pure string toHTML(T)(T[string] values, bool sorted = NOTSORTED) {
	string[] results; 
	foreach(k; values.getKeys(sorted)) {
		results ~= `%s="%s"`.format(k, values[k]);
	}
	return results.join(" ");
}
version(test_uim_core) { unittest {
		assert(["a":1, "b":2].toHTML(SORTED) == `a="1" b="2"`);
}}

pure string toSqlUpdate(T)(T[string] values, bool sorted = NOTSORTED) {
	string[] results; 
	foreach(k; values.getKeys(sorted)) results ~= `%s=%s`.format(k, values[k]);
	return results.join(",");
}
version(test_uim_core) { unittest {
		assert(["a":1, "b":2].toSqlUpdate(SORTED) == `a=1,b=2`);
}}

/// Checks if key exists and has values
pure bool isValue(T, S)(T[S] base, S key, T value) {
	if (key in base) {
		return (base[key] == value);
	} 
	return false;
}
version(test_uim_core) { unittest {
		assert(["a":1, "b":2].isValue("a", 1));
		assert(!["a":2, "b":2].isValue("a", 1));
		assert(["a":1, "b":1].isValue("a", 1));
		assert(!["a":2, "b":1].isValue("a", 1));
		assert(["a":1, "b":2].isValue("b", 2));
}}

// Checks if values exist in base
pure bool isValues(T, S)(T[S] base, T[S] values) {
	foreach(k; values.getKeys) {
		if (k !in base) return false;
		if (base[k] != values[k]) return false;
	}
	return true;
}
version(test_uim_core) { unittest {
	assert(["a":1, "b":2].isValues(["a":1, "b":2]));
	assert(!["a":1, "b":2].isValues(["a":1, "b":3]));
	assert(!["a":1, "b":2].isValues(["a":1, "c":2]));
}}

V[K] merge(K, V)(V[K] sourceValues, V[K] mergeValues) {
	auto result = sourceValues.dup;

	foreach(k, v; mergeValues) {
		result[k] = v;
	}

	return result;
}