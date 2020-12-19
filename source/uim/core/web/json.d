module uim.core.web.json;

import uim.core;

string toJSON(T)(T value) if (isBoolean!T) {
	return (value) ? "true" : "false"; 
}

string toJSON(T)(T value) if ((std.traits.isNumeric!T) && (!isBoolean!T)) {
	return "%s".format(value);
}

string toJSON(string value) {
	return "\""~value~"\"";
}

string toJSON(T)(string key, T value) {
	return "\"%s\":%s".format(key, value.toJSON);
}

unittest {
	assert(true.toJSON == "true");
	assert(false.toJSON == "false");
	assert(true.toJSON != "false");
	assert(false.toJSON != "true");

	assert(0.toJSON == "0");
	assert(100.toJSON == "100");
	assert(100.toJSON != "0");
}