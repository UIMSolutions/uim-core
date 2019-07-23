module uim.core.datatypes.datetime;

import uim.core;
import std.datetime;

auto now() {
	return Clock.currTime();
}
DateTime nowDateTime() {
	return cast(DateTime)Clock.currTime();
}

string timeToDateString(long time) {
	auto day = to!string(SysTime(time).day);
	auto mon = to!string(cast(int)SysTime(time).month);
	auto year = to!string(SysTime(time).year);
	auto hour = to!string(SysTime(time).hour);
	auto min = to!string(SysTime(time).minute);
	
	return "%s. %s. %s - %s:%s".format(day, mon, year, hour, min);
}

string timestampToDateTimeDE(string timeStamp) { return timestampToDateTimeDE(to!size_t(timeStamp)); }
string timestampToDateTimeDE(size_t timeStamp) { return SysTime(timeStamp).toISOExtString.split(".")[0].replace("T", " "); }

//dur!"msecs"(142).total!"msecs" == 142

//01.01.1970 00:00:00 UTC
	
long nowForJs() {
	auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
	auto dTime = cast(DateTime)now();
	return (dTime - jsTime).total!"msecs";
}
long datetimeForJs(string dt) {
	auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
	auto dTime = cast(DateTime)SysTime.fromISOExtString(dt);
	return (dTime-jsTime).total!"msecs";
}

DateTime jsToDatetime(long jsTime) {
	auto result = DateTime(1970, 1, 1, 0, 0, 0)+msecs(jsTime);
	return cast(DateTime)result;
}
string germanDate(DateTime dt) {
	return "%s. %s. %s".format(dt.day, cast(int)dt.month, dt.year);
}
string isoDate(DateTime dt) {
	auto m = (cast(int)dt.month < 10 ? "0"~to!string(cast(int)dt.month) : to!string(cast(int)dt.month));
	auto d = (dt.day < 10 ? "0"~to!string(dt.day) : to!string(dt.day));
	return "%s-%s-%s".format(dt.year, m, d);
}