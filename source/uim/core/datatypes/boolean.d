/***********************************************************************************************
*	Copyright: © 2017-2020 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/dataytypes/boolean
************************************************************************************************/
module uim.core.datatypes.boolean;

import uim.core;

char[] BOOL(bool toogleValue) { return cast(char[])((toogleValue) ? `true`:`false`); }

/// Toggle boolean value (from true to false, from false to true)
@safe pure bool toggle(bool value) { 
	return !value; }
unittest {
	assert(toggle(true) == false, "Error in toggle(bool)");
	assert(toggle(toggle(true)) == true, "Error in toggle(bool) - 2");
}

/// Translates boolean to defined values
@safe T translate(T)(bool value, T ifTrue, T ifFalse) { 
	return (value) ? ifTrue : ifFalse; }
unittest {
	assert(translate(true, "YES", "NO") == "YES", "Error in translate(bool, T, T)");
	assert(translate(false, "YES", "NO") == "NO", "Error in translate(bool, T, T) - 2");
}