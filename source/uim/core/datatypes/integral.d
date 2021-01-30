/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/dataytypes/integral
************************************************************************************************/
module uim.core.datatypes.integral;

import uim.core;

/// convert integral values to string with defined length
string toString(T)(T value, size_t length = 0, string fillTxt = "0") if (isIntegral!T) {
  string result = fill(length, fillTxt);
  
  import std.conv;
  string convert = to!string(value);
  if (convert.length < length) {
    result = result[0..$-convert.length] ~ convert;
  }
  else result = convert;  

  return result;
}
unittest {
  assert(1.toString == "1");
  assert(1.toString == "1");
  assert(1.toString(10, "X") == "XXXXXXXXX1");
}

/// limits the value on the min or max 
@safe T limits(T)(T value, T minLimit, T maxLimit) if (isIntegral!T) 
  in(minLimit < maxLimit, "minLimit should not be equal or greater then maxLimit")
  do {
    T result = value;
    
    if (minLimit > result) result = minLimit;
    if (result > maxLimit) result = maxLimit;
    
    return result;
  }
unittest {
  assert(10.limit(2, 8) == 8);
  assert(10.limit(12, 13) == 12);
  assert(10.limit(13, 13) > 0);
  assert(10.limit(14, 13) > 0);
}

/// transform value minOld/maxOld to newMin/newMax 
@safe T transform(T)(T value, T minOld, T maxOld, T newMin, T newMax) if (isIntegral!T) 
  in((value >= minOld) && (value <= maxOld), "value should be between minOld and maxOld")
  in(minOld < maxOld, "minOld should not be equal or greater then maxOld")
  in(newMin != newMax, "newMin should not equal to newMax")
  in(newMin < newMax, "newMin should not be equl or greater then newMax")
  do {
    T deltaOld = maxOld - minOld;
    T deltaNew = newMax - newMin;
    T result = to!T(newMin + (deltaNew*((100*(value - minOld)) / deltaOld))/100);
    
    return result;
  }
unittest {
  assert(8.transform(0, 10, 0, 100) == 80);
  assert(80.transform(0, 100, 0, 10) == 8);
}

@safe pure bool isLess(T)(T base, T[] values...) {
  foreach(value;values) if (value <= base) return false;
  return true;  
}
unittest {
  assert(8.isLess(10, 100));
  assert(!80.isLess(10, 100));
}

@safe pure bool isGreater(T)(T base, T[] values...) {
  foreach(value; values) if (value >= base) return false;
  return true; // base is always greater
}
unittest {
  assert(800.isGreater(10, 100));
  assert(!80.isGreater(10, 100));
}

