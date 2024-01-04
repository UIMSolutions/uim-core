/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.mixins;

public {
	import uim.core.mixins.function_;
	import uim.core.mixins.phobos;
	import uim.core.mixins.properties;
}

template PropertyOverride(string dataType, string propertyName, string defaultValue = null) {
	const char[] PropertyOverride = "
    alias "~propertyName~" = super."~propertyName~";
	@property override "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
	@property override void "~propertyName~"("~dataType~" newValue) { _"~propertyName~" = newValue; }";
}

template MyPropertyString(string propertyName, string defaultValue = null) {
	const char[] MyProperty = "
	protected string _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected string _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
	auto "~propertyName~"Default() { return _default"~propertyName~"; }
	void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
	void "~propertyName~"Default(string v) { _default"~propertyName~" = v; }
	bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }

	@property string "~propertyName~"(this O)() { return _"~propertyName~"; }
	@property O "~propertyName~"(this O)(string newValue) { _"~propertyName~" = newValue; return cast(O)this; }";
}

template MyPropertyOverride(string dataType, string propertyName, string sourceName = "super") {
	const char[] MyPropertyOverride = "
    alias "~propertyName~" = "~sourceName~"."~propertyName~";
	@property "~dataType~" "~propertyName~"(this O)() { return _"~propertyName~"; }
	@property O "~propertyName~"(this O)("~dataType~" newValue) { _"~propertyName~" = newValue; return cast(O)this; }";
}

template BoolProperty(string propertyName, string defaultValue = null) {
	const char[] BoolProperty = "
protected bool _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
protected bool _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";

@property bool "~propertyName~"() { return _"~propertyName~"; }
@property O "~propertyName~"(this O)(bool value) { _"~propertyName~" = value; return cast(O)this; }

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default(bool value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }
";
}

template StringProperty(string propertyName, string defaultValue = null) {
	const char[] StringProperty = "
protected string _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
protected string _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";

@property string "~propertyName~"() { return _"~propertyName~"; }
@property O "~propertyName~"(this O)(string value) { _"~propertyName~" = value; return cast(O)this; }

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default(string value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }
";
}

template EnumProperty(string dataType, string propertyName, string defaultValue = null) {
	const char[] EnumProperty = "
protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~dataType~"."~defaultValue : "")~";
protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~dataType~"."~defaultValue : "")~";

@property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
@property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default("~dataType~" value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }
";
}
