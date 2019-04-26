module uim.core.datatypes.boolean;

import uim.core;

char[] BOOL(bool value) { return cast(char[])((value) ? `true`:`false`); }

bool toggle(bool value) { return !value; }
T translate(T)(bool value, T ifTrue, T ifFalse) { return (value) ? ifTrue : ifFalse; }
bool translate(T)(T value, T ifTrue) { return (value == ifTrue); }

unittest {
	writeln("Testing ", __MODULE__); 

	bool test = true;
	assert(toggle(test) == false, "Error in toggle(bool)");
	assert(toggle(toggle(test)) == true, "Error in toggle(bool) - 2");

	// test = true
	assert(translate(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
	assert(translate(false, "YES", "NO") == "NO", "Error in translate(bool, T, T) - 2");

	assert(translate("YES", "YES") == true, "Error in translate(T, T)");
	assert(translate("YES", "NO") == false, "Error in translate(T, T) - 2");
}