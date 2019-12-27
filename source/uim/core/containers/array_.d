module uim.core.containers.array_;

import uim.core;

// Check if rhs exists in lhs
@safe bool has(T)(T[] lhs, T rhs) {
	// return lhs.canFind(rhs);
	foreach(item; lhs) if (item == rhs) return true;
	return false;
}
unittest {
	assert([1, 2, 3].has(1));
	assert(![1, 2, 3].has(4));
}

// Add item in array
@safe T[] add(T)(T[] lhs, T rhs, bool unique = false) {
	auto result = lhs.dup;	
	if (unique) { if (!result.has(rhs)) result~=rhs; }
	else result ~= rhs;

	return result;
}
unittest {
	assert([1,2,3].add(4) == [1,2,3,4]);
	assert([1,2,3].add(3) == [1,2,3,3]);
	assert([1,2,3].add(3,true) == [1,2,3]);
}

// Add items in array
@safe T[] add(T)(T[] lhs, T[] rhs, bool unique = false) {
	foreach(r; rhs) lhs = add(lhs, r, unique);
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
	if (multiple) { while(result.has(rhs)) result = result.sub(rhs); }
	else foreach(i, value; result) { 
		if (value == rhs) {
			result = result.remove(i);
			break;
		}
	}
	return result;
} 
@safe T[] sub(T)(T[] lhs, T[] rhs, bool multiple = false) {
	foreach(v; rhs) lhs.sub(v, multiple);
	return lhs;
} 
unittest {
	assert([1, 2, 3].sub(2) == [1, 3]); 
}

//T[] sort(T)(T[] values, bool asc = true) {
//	T[] newValues;
//	foreach(v; values) if (v != value) newValues ~= v;
//	return newValues;
//} 

OUT[] castTo(OUT, IN)(IN[] values) {
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