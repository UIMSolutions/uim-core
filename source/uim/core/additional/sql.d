


module uim.core.additionals.date;
@safe:
import uim.core;

/*

 * If the database is using a different timezone than the system, you will

 * need to supply its timezone, otherwise you can use the defaults.

 */

Date toDate(string sqlDate)



  Date t;

  return t.fromISOExtString(sqlDate);

}

string toSqlDate(Date date)

{

  return date.toISOExtString();

}

DateTime toDateTime(string sqlTime)

{

  DateTime t;

  return t.fromISOExtString(sqlTime.replaceFirst(" ", "T"));

}

SysTime toSysTime(string sqlTime, immutable TimeZone tz = null)

{

  return SysTime(toDateTime(sqlTime),tz);

}

string toSqlTime(DateTime time)

{

  return time.toISOExtString().replaceFirst("T", " ");

}

string toSqlTime(SysTime time, immutable TimeZone tz = null)

{

  if (tz is null)

    return time.toLocalTime().toISOExtString().replaceFirst("T", " ");

  else

    return time.toOtherTZ(tz).toISOExtString().replaceFirst("T", " ");

}
