module uim.core.containers.aa;

import uim.core;

K[] getKeys(K, V)(V[K] aa, bool sorted = false) {
	K[] results;
	foreach(k, v; aa) results ~= k;
	if (sorted) results = results.sort.array;
	return results;
}
V[] getValues(K, V)(V[K] aa, bool sorted = false) {
	V[] results;
	foreach(k, v; aa) results ~= v;
	if (sorted) results = results.sort.array;
	return results;
}

void add(T, S)(ref T[S] lhs, T[S] rhs) {
	foreach(k, v; rhs) lhs[k] = v;
}

auto toIndexAA(T)(T[] values) {
	size_t[T] result;
	foreach(i, value; values) result[value] = i;
	return result;
}

auto toAAIndex(T)(T[] values) {
	T[size_t] result;
	foreach(i, value; values) result[i] = value;
	return result;
}

auto toIndexesAA(T)(T[] values) {
	size_t[][T] result;
	foreach(i, value; values) {
		if (value !in result) result[value] = [];
		result[value] ~= i;
	}
	return result;
}

string toJS(string[string] values, bool sorted = false) {
	string[] result; 
	if (sorted) 
		foreach(k; values.keys.sort) result ~= k~":"~values[k];
	else 
		foreach(k,v; values) result ~= k~":"~v;
	return result.join(",");
}
string toJSON(string[string] values, bool sorted = false) {
	string[] result; 

	if (sorted) foreach(k; values.keys.sort) result ~= `"%s":"%s"`.format(k, values[k]);
	else foreach(k,v; values) result ~= `"%s":"%s"`.format(k, v);

	return result.join(",");
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

string toSqlUpdate(string[string] values, bool sorted = false) {
	string[] results; 
	if (sorted) 
		foreach(k; values.keys.sort) results ~= `%s='%s'`.format(k, values[k]);
	else 
		foreach(k,v; values) results ~= `%s='%s'`.format(k, v);
	return results.join(",");
}
