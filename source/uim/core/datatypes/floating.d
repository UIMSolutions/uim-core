/***********************************************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.floating;

@safe: 
import uim.core;

T fuzzy(T)(T value, T minLimit, T maxLimit, T minFactor = 0, T maxFactor = 1) if (isFloatingPoint!T) {
  if (value < minLimit) return minFactor;
  if (value > maxLimit) return maxFactor;
  
  return minFactor + (maxFactor - minFactor)*(value - minLimit)/(maxLimit - minLimit);   
}
version(test_uim_core) { unittest {
	// TODO
}}

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
version(test_uim_core) { unittest {
  // writeln((1.01).toString);
//   assert((1.0).toString == "1.0");
//   assert((1.0).toString == "1.0");
//   assert((1.0).toString(10, "X") == "XXXXXXX1.0");
 }}