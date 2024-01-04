/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
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
