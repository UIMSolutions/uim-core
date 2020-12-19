/***********************************************************************************************
*	Copyright: © 2017-2020 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/web/json
************************************************************************************************/
module uim.core.web.json;

import uim.core;

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
	return "\""~value~"\"";
}
unittest {
	assert("Test".toJSONValue == `"Test"`);
}

/// Convert keypair to a JsonValue
string toJSONObjectItem(T)(string key, T value) {
	return "\"%s\":%s".format(key, value.toJSONValue);
}
unittest {
	assert(toJSONObjectItem("name", true) == `"name":true`);
	assert(toJSONObjectItem("name", 100) == `"name":100`);
	assert(toJSONObjectItem("name", "value") == `"name":"value"`);
}
