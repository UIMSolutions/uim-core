module uim.core.containers.aa;

import uim.core;

enum SORTED = true;

/***********************************
 * get (sorted) keys of an associative array
 * 
 * 1st Parameter = aa
 * 2nd Parameter = sorting on/off (default: false)
 * 
 * Alternative: aa.keys.sort
 */
@safe pure K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
	K[] results;
	foreach(k, v; aa) results ~= k;
	if (sorted) results = results.sort.array;
	return results;
}
unittest {
	assert([1:1, 2:2, 3:3].getKeys(SORTED) == [1, 2, 3]);
	assert([1:"1", 2:"2", 3:"3"].getKeys(SORTED) == [1, 2, 3]);
	assert(["1":1, "2":2, "3":3].getKeys(SORTED) == ["1", "2", "3"]);
	assert(["1":"1", "2":"2", "3":"3"].getKeys(SORTED) == ["1", "2", "3"]);
}

/***********************************
 * get (sorted) values of an associative array
 * 
 * 1st Parameter = aa
 * 2nd Parameter = sorting on/off (default: false)
 * 
 * Alternative: aa.values.sort
 */
@safe pure V[] getValues(K, V)(V[K] aa, bool sorted = false) {
	V[] results;
	foreach(k, v; aa) results ~= v;
	if (sorted) results = results.sort.array;
	return results;
}
unittest {
	assert([1:1, 2:2, 3:3].getValues(SORTED) == [1, 2, 3]);
	assert([1:"1", 2:"2", 3:"3"].getValues(SORTED) == ["1", "2", "3"]);
	assert(["1":1, "2":2, "3":3].getValues(SORTED) == [1, 2, 3]);
	assert(["1":"1", "2":"2", "3":"3"].getValues(SORTED) == ["1", "2", "3"]);
}

/***********************************
 * add
 */
@safe pure T[S] add(T, S)(T[S] lhs, T[S] rhs) {
	T[S] results = lhs.dup;
	foreach(k, v; rhs) results[k] = v;
	return results;
}
unittest {
	assert([1:"b", 2:"d"].add([3:"f"]) == [1:"b", 2:"d", 3:"f"]);
	assert(["a":"b", "c":"d"].add(["e":"f"]) == ["a":"b", "c":"d", "e":"f"]);
	assert(["a":"b", "c":"d"].add(["e":"f"]).add(["g":"h"]) == ["a":"b", "c":"d", "e":"f", "g":"h"]);
}

/***********************************
 * toIndexAA
 */
@safe pure size_t[T] indexAA(T)(T[] values, size_t startPos = 0) {
	size_t[T] results;
	foreach(i, value; values) results[value] = i + startPos;
	return results;
}
unittest {
	assert(["a", "b", "c"].indexAA == ["a":0UL, "b":1UL, "c":2UL]);
	assert(["a", "b", "c"].indexAA(1) == ["a":1UL, "b":2UL, "c":3UL]);
}

@safe auto toAAIndex(T)(T[] values) {
	T[size_t] result;
	foreach(i, value; values) result[i] = value;
	return result;
}
unittest {
	/// TODO
}

@safe auto toIndexesAA(T)(T[] values) {
	size_t[][T] result;
	foreach(i, value; values) {
		if (value !in result) result[value] = [];
		result[value] ~= i;
	}
	return result;
}
unittest {
	/// TODO
}

@safe string toJS(T)(T[string] values, bool sorted = false) {
	string[] result; 
	string[] keys;
	foreach(key, value; values) keys ~= key;
	if (sorted) keys = keys.sort.array;

	foreach(k; keys) {
		auto key = k;
		if (k.indexOf("-") >= 0) key = "'%s'".format(k);
		result ~= `%s:%s`.format(key, values[k]);
	}
	return "{"~result.join(",")~"}";
}
unittest {
	/// TODO
}

@safe string toJSON(string[string] values, bool sorted = false) {
	string[] result; 

	if (sorted) foreach(k; values.getKeys(sorted)) result ~= `"%s":"%s"`.format(k, values[k]);
	else foreach(k,v; values) result ~= `"%s":"%s"`.format(k, v);

	return result.join(",");
}
unittest {
	/// TODO
}

string toHTML(string[string] values, bool sorted = false) {
	string result; 
	if (sorted) {
		foreach(k; values.keys.sort) {
			auto value = values[k];
			if (k == value) result ~= ` `~k;
			else result ~= ` %s="%s"`.format(k, value);
		}
	}
	else foreach(k,v; values) {
		if (k == v) result ~= ` `~k;
		else result ~= ` %s="%s"`.format(k, v);
	}
	return result;
}
unittest {
	/// TODO
}

@safe string toSqlUpdate(string[string] values, bool sorted = false) {
	string[] results; 
	if (sorted) 
		foreach(k; values.toKeys.sort) results ~= `%s='%s'`.format(k, values[k]);
	else 
		foreach(k,v; values) results ~= `%s='%s'`.format(k, v);
	return results.join(",");
}
unittest {
	/// TODO
}

@safe K[] toKeys(K,V)(V[K] values) {
	K[] results;
	foreach(k, v; values) results ~= k;
	return results;
}
unittest {
	assert(["a":"b"].toKeys == ["a"]);
}

@safe V[] toValues(K,V)(V[K] values) {
	V[] results;

	foreach(k, v; values) results ~= v;

	return results;
}
unittest {
	assert(["a":"b"].toValues == ["b"]);
}
