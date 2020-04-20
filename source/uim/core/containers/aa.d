module uim.core.containers.aa;

import uim.core;

enum SORTED = true;

/***********************************
 * get (sorted) keys of an associative array
 * 
 * 1st Parameter = aa
 * 2nd Parameter = sorting on/off (default: true)
 * 
 * Alternative: aa.keys.sort
 */
@safe K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
	K[] results;
	foreach(k, v; aa) results ~= k;
	if (sorted) results = results.sort.array;
	return results;
}
unittest {
	/// TODO
}

/***********************************
 * get (sorted) values of an associative array
 * 
 * 1st Parameter = aa
 * 2nd Parameter = sorting on/off (default: true)
 * 
 * Alternative: aa.values.sort
 */
@safe V[] getValues(K, V)(V[K] aa, bool sorted = false) {
	V[] results;
	foreach(k, v; aa) results ~= v;
	if (sorted) results = results.sort.array;
	return results;
}
unittest {
	/// TODO
}

/***********************************
 * add
 */
@safe void add(T, S)(ref T[S] lhs, T[S] rhs) {
	foreach(k, v; rhs) lhs[k] = v;
}
unittest {
	/// TODO
}



/***********************************
 * toIndexAA
 */
@safe auto toIndexAA(T)(T[] values) {
	size_t[T] result;
	foreach(i, value; values) result[value] = i;
	return result;
}
unittest {
	/// TODO
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

@safe string toJS(T)(T[] values, bool sorted = false) {
  string[] result;
	if (sorted) 
    foreach(v; values.sort) result ~= to!string(v);
  else 
    foreach(v; values) result ~= to!string(v);
  return "["~result.join(",")~"]";
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

string toSqlUpdate(string[string] values, bool sorted = false) {
	string[] results; 
	if (sorted) 
		foreach(k; values.keys.sort) results ~= `%s='%s'`.format(k, values[k]);
	else 
		foreach(k,v; values) results ~= `%s='%s'`.format(k, v);
	return results.join(",");
}
unittest {
	/// TODO
}
