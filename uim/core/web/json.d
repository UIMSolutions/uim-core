/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.web.json;

import uim.core;

@safe:
/// Convert a boolean to a JsonValue
string toJSONValue(T)(T value) if (isBoolean!T) {
  return (value) ? "true" : "false";
}

unittest {
  assert(true.toJSONValue == "true");
  assert(false.toJSONValue == "false");
  assert(true.toJSONValue != "false");
  assert(false.toJSONValue != "true");
}

/// Convert a numeric to a JsonValue
string toJSONValue(T)(T value) if ((std.traits.isNumeric!T) && (!isBoolean!T)) {
  return "%s".format(value);
}

unittest {
  assert(0.toJSONValue == "0");
  assert(100.toJSONValue == "100");
  assert(100.toJSONValue != "0");

  assert((1.1).toJSONValue == "1.1");
  assert((100.1).toJSONValue == "100.1");
}

/// Convert a string to a JsonValue
string toJSONValue(string value) {
  return "\"" ~ value ~ "\"";
}

unittest {
  assert("Test".toJSONValue == `"Test"`);
}

/// Convert keypair to a JsonValue
string toJSONObjectItem(T)(string key, T value) {
  return "\"%s\":%s".format(key, value.toJSONValue);
}

version (test_uim_core) {
  unittest {
    assert(toJSONObjectItem("name", true) == `"name":true`);
    assert(toJSONObjectItem("name", 100) == `"name":100`);
    assert(toJSONObjectItem("name", "value") == `"name":"value"`);
  }
}
