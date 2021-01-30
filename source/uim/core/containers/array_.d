/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/containers/arry
************************************************************************************************/
module uim.core.containers.array_;

import uim.core;

/// Counts appearance of equal items
auto countsEquals(T)(in T[] baseArray...) {
	return countsEquals(baseArray, null);
}
unittest {
	assert(countsEquals(1) == [1:1uL]);
	assert(countsEquals(1, 1) == [1:2uL]);
	assert(countsEquals(1, 2) == [1:1U, 2:1UL]);
}

/// Counts the occourence of values in an array
auto countsEquals(T)(in T[] baseArray, in T[] validValues = null) {
	size_t[T] results;
	auto checkValues = (validValues ? baseArray.filters(validValues) : baseArray); 
	foreach(v; checkValues) {
		if (v in results) results[v]++;
		else results[v] = 1;
	}
	return results;
}
unittest {
	assert(countsEquals([1]) == [1:1uL]);
	assert(countsEquals([1, 1]) == [1:2uL]);
	assert(countsEquals([1, 2]) == [1:1uL, 2:1uL]);
	assert(countsEquals([1, 2], [1]) == [1:1uL]);
}

/// Creates a associative array with all positions of a value in an array
auto positions(T)(in T[] baseArray...) {
	size_t[][T] results = positions(baseArray, null);
	return results; }
unittest {
	assert(positions(1) == [1:[0UL]]);
	assert(positions(1, 1) == [1:[0UL, 1UL]]);
	assert(positions(1, 2) == [1:[0UL], 2:[1UL]]);
}

/// Creates a associative array with all positions of a value in an array
size_t[][T] positions(T)(in T[] baseArray, in T[] validValues = null) {
	size_t[][T] results;
	auto checkValues = (validValues ? baseArray.filters(validValues) : baseArray); 
	foreach(pos, v; checkValues) {
		if (v in results) results[v] ~= pos;
		else results[v] = [pos];
	}
	return results;
}
unittest {
	assert(positions([1]) == [1:[0UL]]);
	assert(positions([1, 1]) == [1:[0UL, 1UL]]);
	assert(positions([1, 2]) == [1:[0UL], 2:[1UL]]);
	assert(positions([1, 2], [1]) == [1:[0UL]]);
}

/// adding items into array
@safe T[] add(T)(in T[] baseArray, in T[] newItems...) {
	return add(baseArray, newItems);
}
unittest {
	assert([1,2,3].add(4) == [1,2,3,4]);
	assert([1,2,3].add(4,5) == [1,2,3,4,5]);
	assert([1.0,2.0,3.0].add(4.0,5.0) == [1.0,2.0,3.0,4.0,5.0]);
	assert(["1","2","3"].add("4","5") == ["1","2","3","4","5"]);
}

/// adding items into array
@safe T[] add(T)(in T[] baseArray, in T[] newItems) {
	T[] results = baseArray.dup;
	results ~= newItems;
	return results;
}
unittest {
	assert([1,2,3].add([4,5]) == [1,2,3,4,5]);
	assert([1.0,2.0,3.0].add([4.0,5.0]) == [1.0,2.0,3.0,4.0,5.0]);
	assert(["1","2","3"].add(["4","5"]) == ["1","2","3","4","5"]);
}

/// change positions
@safe void change(T)(ref T left, ref T right) {
	T buffer = left;
	left = right;
	right = buffer;
} 
/// Changing positions of elements in array
@safe T[] change(T)(T[] values, size_t firstPosition, size_t secondPosition) {
	if ((firstPosition >= values.length) || (secondPosition >= values.length) || (firstPosition == secondPosition)) return values;

	T[] results = values.dup;
	T buffer = results[firstPosition];
	results[firstPosition] = results[secondPosition];
	results[secondPosition] = buffer;
	return results;
} 
unittest{
	assert(change([1, 2, 3, 4], 1, 2) == [1, 3, 2, 4]);
	assert(change(["a", "b", "c", "d"], 3, 2) == ["a", "b", "d", "c"]);
	assert(change(["a", "b", "c", "d"], 1, 1) == ["a", "b", "c", "d"]);
	assert(change(["a", "b", "c", "d"], 1, 9) == ["a", "b", "c", "d"]);
}

// sub
@safe T[] sub(T)(T[] lhs, T rhs, bool multiple = false) {
	auto result = lhs.dup;
	if (multiple) { while(rhs.isIn(result)) result = result.sub(rhs); }
	else foreach(i, value; result) { 
		if (value == rhs) {
			result = result.remove(i);
			break;
		}
	}
	return result;
} 
unittest {
	assert([1, 2, 3].sub(2) == [1, 3]); 
	assert([1, 2, 3, 2].sub(2, true) == [1, 3]); 
}

// sub(T)(T[] lhs, T[] rhs, bool multiple = false)
@safe T[] sub(T)(T[] lhs, T[] rhs, bool multiple = false) {
	auto result = lhs.dup;
	foreach(v; rhs) lhs = lhs.sub(v, multiple);
	return lhs;
} 
unittest {
	assert([1, 2, 3].sub([2]) == [1, 3]); 
	assert([1, 2, 3, 2].sub([2], true) == [1, 3]); 
	assert([1, 2, 3, 2].sub([2, 3], true) == [1]); 
	assert([1, 2, 3, 2, 3].sub([2, 3], true) == [1]); 
}

// filters(T)(T[] lhs, T[] rhs, bool multiple = false)
@safe T[] filters(T)(T[] baseArray, T[] filterValues...) {
	return filters(baseArray, filterValues);
}
unittest {
	assert([1, 2, 3].filters(2) == [2]); 
	assert([1, 2, 3].filters() == []); 
	assert([1, 2, 3].filters(1, 2) == [1, 2]); 
}

@safe T[] filters(T)(T[] baseArray, T[] filterValues) {
	T[] results;
	foreach(v; baseArray) if (filterValues.has(v)) results ~= v;
	return results;
} 
unittest {
	assert([1, 2, 3].filters([2]) == [2]); 
	assert([1, 2, 3].filters([]) == []); 
}

@safe OUT[] castTo(OUT, IN)(IN[] values) {
	OUT[] results; results.length = values.length;
	foreach(i, value; value) result[i] = to!OUT(value);
	return results;
}

unittest {
	auto values = [1, 2, 3, 4]; 
	change(values[2], values[3]); 
	assert(values == [1, 2, 4, 3]);

	assert([1,2,3,4].change(1, 3) == [1, 4, 3, 2]);
}

bool has(T)(in T[] values, in T[] checkValues...) {
	return has(values, checkValues);
}
unittest {
	assert([1,2,3,4].has(1));
	assert(![1,2,3,4].has(5));
	assert([1,2,3,4].has(1, 2));
	assert(![1,2,3,4].has(5, 1));
}

bool has(T)(in T[] values, in T[] checkValues) {
	bool result = false;
	foreach (cv; checkValues) {		
		result = false;
		foreach (value; values) if (value == cv) result = true;		
		if (!result) return false; 
	}
	return result;
}
unittest {
	assert([1,2,3,4].has([1]));
	assert(![1,2,3,4].has([5]));
	assert([1,2,3,4].has([1, 2]));
	assert(![1,2,3,4].has([5, 1]));
}

size_t index(T)(T[] values, T value) {
	foreach (count, key; values) if (key == value) return count;		
	return -1;
}
unittest {
	assert([1,2,3,4].index(1) == 0);
	assert([1,2,3,4].index(0) == -1);
}

size_t[] indexes(T)(T[] values, T value) {
	size_t[] results;
	foreach (count, key; values) if (key == value) results ~= count;		
	return results;
}
unittest {
	assert([1,2,3,4].indexes(1) == [0]);
	assert([1,2,3,4].indexes(0) == null);
	assert([1,2,3,4,1].indexes(1) == [0,4]);
}

size_t[][T] indexes(T)(T[] values, T[] keys) {
	size_t[][T] results;
	foreach (key; keys) results[key] = indexes(values, key);		
	return results;
}
unittest {
	assert([1,2,3,4].indexes([1]) == [1:[0UL]]);
	assert([1,2,3,4,1].indexes([1]) == [1:[0UL, 4UL]]);
}