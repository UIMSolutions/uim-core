﻿/*****************************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG / Since 2022 Ozan Nurettin Süel (sicherheitsschmiede)      *
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.     *
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) * 
*	Documentation [DE]: https://www.sicherheitsschmiede.de/docus/uim-core/dataytypes/boolean                     *
*****************************************************************************************************/
module uim.core.datatypes.boolean;

@safe: 
import uim.core;

// char[] BOOL(bool toogleValue) { return cast(char[])((toogleValue) ? `true`:`false`); }

/// Toggle boolean value (from true to false, false to true) -> in this function it's !value
pure bool toggle(bool value) { 
	return !value; }
///
unittest {
	assert(toggle(true) == false, "Error in toggle(bool)");
	assert(toggle(toggle(true)) == true, "Error in toggle(bool)");
}

/// Translates boolean to defined values
pure T translate(T)(bool value, T ifTrue, T ifFalse) { 
	return (value) ? ifTrue : ifFalse; }
///
unittest {
	assert(translate(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
	assert(translate(false, "YES", "NO") == "NO", "Error in translate(bool, T, T)");
}

/// Translates boolean to defined values
pure T fromBool(T)(bool value, T ifTrue, T ifFalse) { 
	return (value) ? ifTrue : ifFalse; }
///
unittest {
	assert(fromBool(true, "YES", "NO") == "YES", "Error in fromBool(bool, T, T)");
	assert(fromBool(false, "YES", "NO") == "NO", "Error in fromBool(bool, T, T)");
	assert(true.fromBool("YES", "NO") == "YES", "Error in fromBool(bool, T, T)");
	assert(false.fromBool("YES", "NO") == "NO", "Error in fromBool(bool, T, T)");
}

/// Translates value to bool
pure bool toBool(T)(T value, T ifValue) { 
	return value == ifValue; }
///
unittest {
	assert(!toBool("YES", "NO"), "Error in toBool(T, T)");
	assert(toBool("YES", "YES") == true, "Error in toBool(bool, T, T)");
}