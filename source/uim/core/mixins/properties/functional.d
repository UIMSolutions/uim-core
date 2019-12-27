module uim.core.mixins.properties.functional;

import std.string;

/// mixin for boolean properties
template OBool(string name, string defaultValue = null, bool get = true, bool set = true) {
    const char[] OBool = `
    protected bool _`~name~`; 
    @safe @property bool `~name~`() { return _`~name~`; }; 
    @safe @property void `~name~`(bool new`~name~`) { _`~name~` = new`~name~`; };     
    `;
} 

/// mixin for string properties
template OString(string name) {
    const char[] OString = `
    protected string _`~name~`; 
    @safe @property string `~name~`() { return _`~name~`; }; 
    @safe @property void `~name~`(string new`~name~`) { _`~name~` = new`~name~`; };     
    `;
} 

template OString(string propertyName, string defaultValue = null, bool get = true, bool set = true) {
	const char[] OString = "
	protected string _"~propertyName~";
	@safe @property auto "~propertyName~"() { return _"~propertyName~"; }
	@safe @property O "~propertyName~"(this O)(string newValue) { _"~propertyName~"=newValue; return cast(O)this; }
  ";
}

template OStringAA(string propertyName, string defaultValue = null, bool get = true, bool set = true) {
	const char[] OStringAA = "
	protected string[string] _"~propertyName~";
	@property auto "~propertyName~"() { return _"~propertyName~"; }
	@property O "~propertyName~"(this O)(string[string] newValue) { _"~propertyName~"=newValue; return cast(O)this; }
  ";
}