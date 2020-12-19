/***********************************************************************************************
*	Copyright: © 2017-2020 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/mixins/function
************************************************************************************************/
module uim.core.mixins.function_;

template OFunction(string fName, string fParameters, string fBody) {
	const char[] TFunction = "
    void "~fName~"("~fParameters~") {"~fBody~" }";
}

template TFunction(string fName, string fParameters, string fBody) {
	const char[] TFunction = "
    O "~fName~"(this O)("~fParameters~") {"~fBody~" return cast(O)this; }";
}

auto tFunc(string fName, string[][] functions) {
	char[] x;
	if (functions.length == 1) return "O "~fName~"(this O)("~functions[0][0]~") {"~functions[0][1]~" return cast(O)this; }";
	if (functions.length > 1) return "O "~fName~"(this O)("~functions[0][0]~") {"~functions[0][1]~" return cast(O)this; }"~tFunc(fName, functions[1..$]);
	return ""; 
}

template TFunction(string fName, string[][] functions) {
	const char[] TFunction = tFunc(fName, functions);
}
