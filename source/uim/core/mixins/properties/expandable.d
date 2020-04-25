module uim.core.mixins.properties.expandable;

import std.string;

template XString(string name) {
	const char[] XString = "
	string _"~name~";
	auto "~name~"() { return _"~name~"; }
	O "~name~"(this O)(string[] addValues...) { foreach(v; addValues) _"~name~" ~= v; return cast(O)this; }
	O clear"~name.capitalize~"(this O)() { _"~name~" = null; return cast(O)this; }	
	";
}
unittest {
	class Test { mixin(XString!"a"); }
	assert((new Test).a("x").a == "x");
	assert((new Test).a("x").a("x").a == "xx");
	assert((new Test).a("x", "x").a == "xx");
	assert((new Test).a("x").clearA.a == "");
}

template XStringArray(string name) {
	const char[] XStringArray = "
	string[] _"~name~";
	auto "~name~"() { return _"~name~"; }
	O "~name~"(this O)(string[] addValues...) { foreach(v; addValues) _"~name~" ~= v; return cast(O)this; }
	O "~name~"(this O)(string[] addValues) { foreach(v; addValues) _"~name~" ~= v; return cast(O)this; }
	O remove"~name.capitalize~"(this O)(string name) { auto _"~name~" = null; return cast(O)this; }	
	O clear"~name.capitalize~"(this O)() { _"~name~" = null; return cast(O)this; }	
	";
}
unittest {
	class Test { mixin(XStringArray!"a"); }
	assert((new Test).a("x").a == ["x"]);
	assert((new Test).a("x").a("x").a == ["x", "x"]);
	assert((new Test).a("x", "x").a == ["x", "x"]);
	assert((new Test).a("x").clearA.a == null);
}

template XStringAA(string name) {
	const char[] XStringAA = "
	string[string] _"~name~";
	auto "~name~"() { return _"~name~"; }
	O "~name~"(this O)(string key, string value) { _"~name~"[key] = value; return cast(O)this; }
	O "~name~"(this O)(string[string] addValues) { foreach(kv; addValues.byKeyValue) _"~name~"[kv.key] = kv.value; return cast(O)this; }
	O clear"~name.capitalize~"(this O)() { _"~name~" = null; return cast(O)this; }	
	";
}
unittest {
	class Test { mixin(XStringAA!"a"); }
	assert((new Test).a(["a":"x"]).a == ["a":"x"]);
	assert((new Test).a("a", "x").a == ["a":"x"]);
	assert((new Test).a("a", "x").clearA.a == null);
}

template XPropertyAA(string datatype, string name) {
	const char[] Name = capitalize(name);
	const char[] XPropertyAA = `
	`~datatype~`[string] _`~name~`; 
	auto `~name~`() { return _`~name~`; }
	O clear`~Name~`(this O)() { _`~name~` = _`~name~`.clear; return cast(O)this; }
	O remove`~Name~`(this O)(string name) { _`~name~`.remove(name); return cast(O)this; }
	O `~name~`(this O)(string name, `~datatype~` value) { _`~name~`[name] = value; return cast(O)this; }
	O `~name~`(this O)(`~datatype~`[string] values) { foreach(kv; values.byKeyValue) _`~name~`[kv.key] = kv.value; return cast(O)this; }`;
}

template XPropertyArray(string datatype, string name) {
	const char[] Name = capitalize(name);
	const char[] XPropertyArray = `
	`~datatype~`[] _`~name~`; 
	auto `~name~`() { return _`~name~`; }
	O clear`~Name~`(this O)() { _`~name~` = null; return cast(O)this; }
	O remove`~Name~`(this O)(string[] values...) { foreach(value; values) if (value.index(_`~name~`) != -1) _`~name~`.remove(value.index(_`~name~`)); return cast(O)this; }
	O remove`~Name~`(this O)(string[] values) { foreach(value; values) if (value.index(_`~name~`) != -1) _`~name~`.remove(value.index(_`~name~`)); return cast(O)this; }
	O `~name~`(this O)(string addValue) { _`~name~` = _`~name~`.add(addValue, true); return cast(O)this; }
	O `~name~`(this O)(string[] values) { _`~name~` = _`~name~`.add(values, true); return cast(O)this; }`;
}

template XPropertyString(string datatype, string name) {
	const char[] Name = capitalize(name);
	const char[] XPropertyString = `
	`~datatype~` _`~name~`; 
	auto `~name~`() { return _`~name~`; }
	O clear`~Name~`(this O)() { _`~name~` = ""; return cast(O)this; }
	O `~name~`(this O)(`~datatype~` value) { _`~name~` ~= value; return cast(O)this; }`;
}