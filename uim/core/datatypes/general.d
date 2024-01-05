/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.general;

import uim.core;

size_t indexIn(T)(T value, T[] values) {
  foreach (i, ref v; values)
    if (v == value)
      return i;
  return -1;
}

version (test_uim_core) {
  unittest {
    assert(2.indexIn([1, 2, 3, 4]) == 1);
    assert(20.indexIn([1, 2, 3, 4]) == -1);
    assert((2.1).indexIn([1.5, 2.1, 3.3, 4.6]) == 1);
    assert((20.1).indexIn([1.5, 2.1, 3.3, 4.6]) == -1);
  }
}

bool isIn(T)(T value, T[] values) {
  foreach (i, ref v; values)
    if (v == value) {
      return true;
    }
  return false;
}

version (test_uim_core) {
  unittest {
    assert(2.isIn([1, 2, 3, 4]));
    assert(!20.isIn([1, 2, 3, 4]));
    assert((2.1).isIn([1.5, 2.1, 3.3, 4.6]));
    assert(!(20.1).isIn([1.5, 2.1, 3.3, 4.6]));
  }
}

bool has(T)(T[] values, T value) if (!isSomeString!T) {
  foreach (i, ref v; values)
    if (v == value) {
      return true;
    }
  return false;
}

version (test_uim_core) {
  unittest {
    assert([1, 2, 3, 4].has(2));
    assert(![1, 2, 3, 4].has(20));
  }
}

size_t[] indexIn(T)(T[] checkValues, T[] values) {
  size_t[] results;
  foreach (ref v; checkValues)
    results ~= indexIn(v, values);
  return results;
}

version (test_uim_core) {
  unittest {
    assert([2, 3].indexIn([1, 2, 3, 4]) == [1, 2]);
    assert([20].indexIn([1, 2, 3, 4]) == [-1]);
  }
}

size_t[] positionsIn(T)(T value, T[] values) {
  size_t[] results;
  foreach (i, ref v; values)
    if (v == value)
      results ~= i;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(2.positionsIn([1, 2, 3, 2]) == [1, 3]);
    assert(20.positionsIn([1, 2, 3, 4]) == []);
    assert((2.1).positionsIn([1.5, 2.1, 3.3, 2.1]) == [1, 3]);
    assert((20.1).positionsIn([1.5, 2.1, 3.3, 4.6]) == []);
  }
}

/// Copies rightValues to leftValues   
V[K] copyFrom(V, K)(V[K] leftValues, V[K] rightValues) { // right will overright left
  V[K] results = leftValues.dup;
  foreach (k, v; rightValues)
    results[k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "b"].copyFrom(["c": "d"]) == ["a": "b", "c": "d"]);
  }
}

/// Concat rightValues to leftValues   
V[K] concatPrefixInValues(V, K)(V[K] leftValues, V preValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[k] = preValue ~ v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "b"].concatPrefixInValues("abc") == ["a": "abcb"]);
    assert(["a": [1, 2, 3]].concatPrefixInValues([0]) == ["a": [0, 1, 2, 3]]);
  }
}

/// Concat rightValues to leftValues   
V[K] concatPostfixInValues(V, K)(V[K] leftValues, V postValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[k] = v ~ postValue;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "b"].concatPostfixInValues("abc") == ["a": "babc"]);
    assert(["a": [1, 2, 3]].concatPostfixInValues([4]) == ["a": [1, 2, 3, 4]]);
  }
}

/// Concat rightValues to leftValues   
V[K] concatPrefixInKeys(V, K)(V[K] leftValues, V preValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[preValue ~ k] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "b"].concatPrefixInKeys("abc") == ["abca": "b"]);
  }
}

/// Concat rightValues to leftValues   
V[K] concatPostfixInKeys(V, K)(V[K] leftValues, V postValue) { // right will overright left
  V[K] results;
  foreach (k, v; leftValues)
    results[k ~ postValue] = v;
  return results;
}

version (test_uim_core) {
  unittest {
    assert(["a": "b"].concatPostfixInKeys("abc") == ["aabc": "b"]);
  }
}
