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

@safe auto positionsAA(T)(T[] values) {
	size_t[][T] results;
	foreach(i, value; values) {
		if (value !in results) results[value] = [];
		results[value] ~= i;
	}
	return results;
}
unittest {
	assert(["a", "b", "c", "a"].positionsAA == ["a":[0UL, 3UL], "b":[1UL], "c":[2UL]]);
}

@safe pure string toJSONString(T)(T[string] values, bool sorted = false) {
	string[] result; 

	foreach(k; values.getKeys(sorted)) result ~= `"%s":%s`.format(k, values[k]);

	return "{"~result.join(",")~"}";
}
unittest {
	assert(["a":1, "b":2].toJSONString(SORTED) == `{"a":1,"b":2}`);
}

@safe pure string toHTML(T)(T[string] values, bool sorted = false) {
	string[] results; 
	foreach(k; values.getKeys(sorted)) {
		results ~= `%s="%s"`.format(k, values[k]);
	}
	return results.join(" ");
}
unittest {
	assert(["a":1, "b":2].toHTML(SORTED) == `a="1" b="2"`);
}

@safe pure string toSqlUpdate(T)(T[string] values, bool sorted = false) {
	string[] results; 
	foreach(k; values.getKeys(sorted)) results ~= `%s=%s`.format(k, values[k]);
	return results.join(",");
}
unittest {
	assert(["a":1, "b":2].toSqlUpdate(SORTED) == `a=1,b=2`);
}
