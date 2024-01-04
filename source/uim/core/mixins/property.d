/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.mixins.property;

auto PROPERTYPREFIX(string dataType, string propertyName, string defaultValue = null) {
	return "
protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default("~dataType~" value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }";
}



// mixins for Template based properties

template TProperty(string dataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
	const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
	const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" = newValue;";
	
	const char[] TProperty = "
	protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
//	O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
//	auto "~propertyName~"Default() { return _default"~propertyName~"; }
//	O "~propertyName~"Default(this O)("~dataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
//	bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

	@property "~dataType~" "~propertyName~"(this O)() { "~getFkt~" }
	@property O "~propertyName~"(this O)("~dataType~" newValue) { "~setFkt~" return cast(O)this; }";
}

template TPropertyAA(string keyDataType, string valueDataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
	const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
	const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" = newValue;";
	const char[] aaDataType = valueDataType~"["~keyDataType~"]";
	
	const char[] TPropertyAA = "
	protected "~aaDataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected "~aaDataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
	O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
	auto "~propertyName~"Default() { return _default"~propertyName~"; }
	O "~propertyName~"Default(this O)("~aaDataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
	bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

	@property "~aaDataType~" "~propertyName~"(this O)() { "~getFkt~" }
	@property O "~propertyName~"(this O)("~aaDataType~" newValue) { "~setFkt~" return cast(O)this; }
	O "~propertyName~"(this O)("~keyDataType~" key, "~valueDataType~" value) { _"~propertyName~"[key] = value; return cast(O)this; }
	O "~propertyName~"Add(this O)("~aaDataType~" values) { foreach(k,v;values) _"~propertyName~"[k] = v; return cast(O)this; }";
}

// mixins for Extended Template based properties

template TXProperty_get(string dataType, string propertyName, string defaultValue = null, string get = null) {
	const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";

	const char[] TXProperty_get = "
	protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
	O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
	auto "~propertyName~"Default() { return _default"~propertyName~"; }
	O "~propertyName~"Default(this O)("~dataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
	bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

	@property "~dataType~" "~propertyName~"(this O)() { "~getFkt~" }";
}

template TXProperty(string dataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
	const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
	const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" ~= newValue;";
	
	const char[] TXProperty = "
	protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
	O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
	auto "~propertyName~"Default() { return _default"~propertyName~"; }
	O "~propertyName~"Default(this O)("~dataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
	bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

	@property "~dataType~" "~propertyName~"(this O)() { "~getFkt~" }
	@property O "~propertyName~"(this O)("~dataType~" newValue) { "~setFkt~" return cast(O)this; }";
}

version(test_uim_core) { unittest {

}}

