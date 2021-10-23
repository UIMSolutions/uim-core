


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
class DBException : Exception

{

 	this () { super("Unknown Error.");	}

	this (string msg, uint _code, string _sql)

  {

		super(msg~" ("~to!string(_code)~"), SQL: \""~_sql~"\"");

    code = _code;

    sql = _sql;

  }

  uint code;

  string sql;

}

struct Variables(Database)

{

  Database database;

  string table;

  private strstr values;

  bool isSet(string name)

  {

    if (name in values)

      return true;

    else

      return (database.queryValue("select count(*) from "~table~" where name='"~name~"'") != "0");

  }

  string get(T:string)(string name)

  {

    if (!(name in values))

    {

      auto s = database.queryValue("select value from "~table~" where name='"~name~"'");

      if (s is null)

        return null;

      else

      {

        values[name] = s;

      }

    }

    return values[name];

  }

  T get(T)(string name)

  {

    auto s = get!string(name);

    return (s is null)?T.init:unserialize!T(s);

  }

  void set(T:string)(string name, string value)

  {

    values[name] = value;

    database.query("replace "~table~" set name='"~name~"', value="~database.quote(value));

  }

  void set(T)(string name, T value)

  {

    set!string(name,serialize!(T)(value));

  }

  void unset(string name)

  {

    database.query("delete from "~table~" where name='"~name~"'");

    values.remove(name);

  }

  alias set!ulong  setInt;

  alias set!string setStr;

  alias get!ulong  getInt;

  alias get!string getStr;

}
