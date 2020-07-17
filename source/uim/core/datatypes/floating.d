module uim.core.datatypes.floating;

import uim.core;

@safe T fuzzy(T)(T value, T minLimit, T maxLimit, T minFactor = 0, T maxFactor = 1) if (isFloatingPoint!T) {
  if (value < minLimit) return minFactor;
  if (value > maxLimit) return maxFactor;
  
  return minFactor + (maxFactor - minFactor)*(value - minLimit)/(maxLimit - minLimit);   
}
unittest {
	
}

string toString(T)(T value, size_t length = 0, string fillTxt = "0") if (isFloatingPoint!T) {
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
  // writeln((1.01).toString);
//   assert((1.0).toString == "1.0");
//   assert((1.0).toString == "1.0");
//   assert((1.0).toString(10, "X") == "XXXXXXX1.0");
 }