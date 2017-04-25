module uim.core;

public import std.stdio;
public import std.string;
public import std.array;
public import std.algorithm;
public import std.traits;

public import uim.core.boolean;
public import uim.core.integer;
public import uim.core.double_;
public import uim.core.string_;
public import uim.core.stringaa;
public import uim.core.array_;
public import uim.core.file;
public import uim.core.json;

alias STRINGAA = string[string];
alias INTAA = int[int];
alias DOUBLEAA = double[double];

template Shortcut(string oldName, string newName, string oldParameters = "", string newParameters = "") {
	const char[] Shortcut = "
    auto "~newName~"("~newParameters~") { return new "~oldName~"("~oldParameters~"); }";
}

auto PROPERTYPREFIX(string dataType, string propertyName, string defaultValue = null) {
	return "
protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default("~dataType~" value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }";
}

template PropertyGet(string dataType, string propertyName, string defaultValue = null) {
	const char[] Property = PROPERTYPREFIX(dataType, propertyName, defaultValue) ~"
@property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }";
}

template PropertySet(string dataType, string propertyName, string defaultValue = null) {
	const char[] Property = PROPERTYPREFIX(dataType, propertyName, defaultValue) ~"
@property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; return cast(O)this; }";
}

template Property(string dataType, string propertyName, string defaultValue = null) {
	const char[] Property = "
	protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
	
	auto "~propertyName~"Default() { return _default"~propertyName~"; }
	void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
	void "~propertyName~"Default("~dataType~" value) { _default"~propertyName~" = value; }
	bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }

	@property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }
	@property void "~propertyName~"("~dataType~" value) { _"~propertyName~" = value; }";
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
/+  +/
T toggle(T, S)(S value) if (isBoolean!S) { return !S; }
T toggle(T, S)(S value, T defValue = 1, T zeroValue = 0) if (isNumeric!S) { 
	if (value != zeroValue) return zeroValue;
	return defValue;
}

/+ toggle between values +/
T toggle(T)(T value, T value0, T value1) { return (value == value0) ? value1 : value0; }

/+ +/
/// select values in array
// get all values in array are equal to value
T[] eqValues(T)(T value, T[] values) {
	T[] result;
	foreach(v; values) if (value == v) result ~= v;
	return result;
} 
// get all values in array are not equal to value
T[] neqValues(T)(T value, T[] values) {
	T[] result;
	foreach(v; values) if (value != v) result ~= v;
	return result;
} 
// get all values in array are greater then value
T[]  gtValues(T)(T value, T[] values) if (isNumeric!T) {
	T[] result;
	foreach(v; values) if (value > v) result ~= v;
	return result;
} 
// get all values in array are greater equal value
T[] geValues(T)(T value, T[] values) if (isNumeric!T) {
	T[] result;
	foreach(v; values) if (value >= v) result ~= v;
	return result;
} 
// get all values in array are less then value
T[] ltValues(T)(T value, T[] values) if (isNumeric!T) {
	T[] result;
	foreach(v; values) if (value < v) result ~= v;
	return result;
} 
// get all values in array are less equal value
T[] leValues(T)(T value, T[] values) if (isNumeric!T) {
	T[] result;
	foreach(v; values) if (value <= v) result ~= v;
	return result;
} 

/// compare values in array
// all values in array are equal to value
bool eqAll(T)(T value, T[] values) {
	foreach(v; values) if (value == v) continue; else return false;
	return true;
} 
// all values in array are not equal to value
bool neqAll(T)(T value, T[] values) {
	foreach(v; values) if (value != v) continue; else return false;
	return true;
} 
// all values in array are greater then value
bool gtAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value > v) continue; else return false;
	return true;
} 
// all values in array are greater equal value
bool geAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value >= v) continue; else return false;
	return true;
} 
// all values in array are less then value
bool ltAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value < v) continue; else return false;
	return true;
} 
// all values in array are less equal value
bool leAll(T)(T value, T[] values) if (isNumeric!T) {
	foreach(v; values) if (value <= v) continue; else return false;
	return true;
} 

bool equal(T)(T[] leftCells, T[] rightCells) {
	if (leftCells.length == rightCells.length) {
		foreach(i; 0..leftCells.length) 
			if (leftCells[i] != rightCells[i]) return false;
		return true;
	}
	return false;  }


T limit(T)(T value, T left, T right) if (isNumeric!T) {
	T result = value;
	if (left < right) {
	if (result > right) result = right; 
	if (result < left) result = left; 
	}
	else {
		if (result > left) result = left; 
		if (result < right) result = right; 
	}
	return result;
} 

T[2] arrayLimits(T, S)(T from, T to, S[] values) if (isNumeric!T) { return arrayLimits(from, to, 0, values.length); } 
T[2] arrayLimits(T)(T from, T to, T left, T right) if (isNumeric!T) {
	T[2] result;
	result[0] = limit(from, left, right-1);
	result[1] = limit(to, left, right);
	return result;
} 

string[] stringAA2Array(string[string] values, string sep = ":") {
	string[] results;
	foreach(k, v; values) results ~= k~sep~v;
	return results;
}  

unittest {
	writeln("Testing ", __MODULE__);

	writeln("stringAA2Array(string[string] values)", stringAA2Array(["A":"B", "C":"D"], "/"));
}
