module uim.core.datatypes.boolean;

import uim.core;

char[] BOOL(bool value) { return cast(char[])((value) ? `true`:`false`); }

/**
 * Toggle boolean value (from true to false, from false to true)
 * Parameters:
 * value = value to toggle
 * 
 * Example:
 * auto b = true;
 * auto a = toggle(b); // a = false
*/
bool toggle(bool value) { return !value; }

/**
 * Translates boolean value to defined values
 * Parameters:
 * value = incoming boolean
 * ifTrue = result if value = true
 * ifFalse = result if value = false
 * 
 * Example:
 * auto b = true;
 * auto a = translate(b, "red", "green"); // a = "red"
 * or a = b.translate("red", "green"); // a = "red"
 * 
*/
T translate(T)(bool value, T ifTrue, T ifFalse) { return (value) ? ifTrue : ifFalse; }
bool translate(T)(T value, T ifTrue) { return (value == ifTrue); }

unittest {
	bool test = true;
	assert(toggle(test) == false, "Error in toggle(bool)");
	assert(toggle(toggle(test)) == true, "Error in toggle(bool) - 2");

	// test = true
	assert(translate(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
	assert(translate(false, "YES", "NO") == "NO", "Error in translate(bool, T, T) - 2");

	assert(translate("YES", "YES") == true, "Error in translate(T, T)");
	assert(translate("YES", "NO") == false, "Error in translate(T, T) - 2");
}