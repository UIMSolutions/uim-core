module uim.core.containers.array_;

import uim.core;

size_t[T] indexing(T)(T[] values) {
	size_t[T] results;
	foreach(i, v; values) results[v] = i;
	return results;
}
unittest {
// assert(indexing([1]) == [1U:1]);
}
// Add item in array
@safe auto add(T)(T[] lhs, T rhs, bool unique = false) {
	if (unique) { if (!lhs.has(rhs)) lhs~=rhs; }
	else lhs ~= rhs;
	return lhs;
}
unittest {
	assert([1,2,3].add(4) == [1,2,3,4]);
	assert([1,2,3].add(3) == [1,2,3,3]);
	assert([1,2,3].add(3,true) == [1,2,3]);
}

// Add items in array
@safe auto add(T)(T[] lhs, T[] rhs, bool unique = false) {
	foreach(r; rhs) lhs = lhs.add(r, unique);
	return lhs;
}
unittest {
	assert([1,2,3].add([4,5]) == [1,2,3,4,5]);
	assert([1,2,3].add([3,4]) == [1,2,3,3,4]);
	assert([1,2,3].add([3,4],true) == [1,2,3,4]);
}

/// change positions
@safe void change(T)(ref T left, ref T right) {
	T buffer = left;
	left = right;
	right = buffer;
} 
/**
 * Changing positions of elements in array
 * 
 * Parameters:
 * values = Array
 * firstPosition, secondPosition = positions of elements
 */
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

//T[] sort(T)(T[] values, bool asc = true) {
//	T[] newValues;
//	foreach(v; values) if (v != value) newValues ~= v;
//	return newValues;
//} 

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

bool has(T)(T[] values, T value) {
	foreach (key; values) if (key == value) return true;		
	return false;
}
unittest {
	assert([1,2,3,4].has(1));
	assert(![1,2,3,4].has(5));
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