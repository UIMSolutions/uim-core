/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.datetime;

import uim.core;

enum startUNIX = DateTime(1970, 1, 1, 0, 0, 0);
@safe:

long toTimestamp(SysTime untilTime) {
	return (untilTime - cast(SysTime)startUNIX).total!"hnsecs"();
}

// Convert a timestamp in string format (long value) to SysTime
SysTime fromTimestamp(string aTimestamp) {
	return fromTimestamp(to!long(aTimestamp));
}

// Convert a timestamp (long value) to SysTime
SysTime fromTimestamp(long aTimestamp) {
	return (cast(SysTime)startUNIX + aTimestamp.hnsecs);
}

long toJSTimestamp(long jsTimestamp) {
	return (fromJSTimestamp(jsTimestamp) - cast(SysTime)startUNIX).total!"msecs"();
}
SysTime fromJSTimestamp(long jsTimestamp) {
	return (cast(SysTime)startUNIX + jsTimestamp.msecs);
}

// Current SysTime based on System Clock
auto now() {
	return Clock.currTime(); 
}
unittest {
	auto now1 = now; auto now2 = now;
	assert(now2 >= now1);
}

// Current DateTime based on System Clock
DateTime nowDateTime() {
	return cast(DateTime)now; 
}
unittest {
	auto dt1 = nowDateTime; auto dt2 = nowDateTime;
	assert(dt2 >= dt1);
}

/// convert time to region format using SysTime
string timeToDateString(size_t time, string regionFormat = "DE") {
	auto sysTime = SysTime(time);
	auto day = to!string(sysTime.day);
	auto mon = to!string(cast(int)sysTime.month);
	auto year = to!string(sysTime.year);
	auto hour = to!string(sysTime.hour);
	auto min = to!string(sysTime.minute);
	auto sec = to!string(sysTime.second);
	
	switch(regionFormat) {
		case "UK":
			return "%s/%s/%s - %s:%s:%s".format(day, mon, year, hour, min, sec);
		case "US":
			return "%s/%s/%s - %s:%s:%s".format(mon, day, year, hour, min, sec);
		default: 
			return "%s. %s. %s - %s:%s:%s".format(day, mon, year, hour, min, sec);
	}
}
version(test_uim_core) { unittest {
		
}}

/// Convert timestamp to DateTime 
string timestampToDateTimeDE(string timeStamp) { return timestampToDateTimeDE(to!size_t(timeStamp)); }
string timestampToDateTimeDE(size_t timeStamp) { return SysTime(timeStamp).toISOExtString.split(".")[0].replace("T", " "); }
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


/// Convert now to Javascript	
long nowForJs() {
	auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
	auto dTime = cast(DateTime)now();
	return (dTime - jsTime).total!"msecs";
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


/// Convert DateTime to Javascript
long datetimeForJs(string dt) {
	auto jsTime = DateTime(1970, 1, 1, 0, 0, 0);
	auto dTime = cast(DateTime)SysTime.fromISOExtString(dt);
	return (dTime-jsTime).total!"msecs";
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


/// Convert Javascript to dateTime
DateTime jsToDatetime(long jsTime) {
	auto result = DateTime(1970, 1, 1, 0, 0, 0)+msecs(jsTime);
	return cast(DateTime)result;
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}

/// Convert dateTime to german Date string 
string germanDate(long timestamp) {
		return germanDate(cast(DateTime)fromTimestamp(timestamp));
}
string germanDate(DateTime dt) {
	auto strDay = to!string(dt.day);
	if (strDay.length < 2) strDay = "0"~strDay;

	auto strMonth = to!string(cast(int)dt.month);
	if (strMonth.length < 2) strMonth = "0"~strMonth;

	auto strYear = to!string(dt.year); 
	return "%s.%s.%s".format(strDay, strMonth, strYear);
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


// Convert dateTime to ISO string
string isoDate(DateTime dt) {
	auto m = (cast(int)dt.month < 10 ? "0"~to!string(cast(int)dt.month) : to!string(cast(int)dt.month));
	auto d = (dt.day < 10 ? "0"~to!string(dt.day) : to!string(dt.day));
	return "%s-%s-%s".format(dt.year, m, d);
}
version(test_uim_core) { unittest {
		/// TODO Add Tests
}}


/// Convert dateTiem to german Date string 
string toYYYYMMDD(SysTime datetime, string separator = "") {
	return toYYYYMMDD(cast(DateTime)datetime, separator);
}
string toYYYYMMDD(DateTime datetime, string separator = "") {
	string[] results;
	results ~= to!string(datetime.year);
	results ~= (datetime.month < 10 ? "0" : "")~to!string(to!int(datetime.month));
	results ~= (datetime.day < 10 ? "0" : "")~to!string(datetime.day);
	return results.join(separator);
}
version(test_uim_core) { unittest {
	assert(DateTime(Date(1999, 7, 6)).toYYYYMMDD("-") == "1999-07-06");
}}