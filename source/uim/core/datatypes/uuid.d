/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.uuid;

import uim.core;

@safe:
enum NULLID = "00000000-0000-0000-0000-000000000000";
enum NULLUUID = UUID(NULLID);

auto isNull(UUID id) {
  return (NULLUUID == id);
}

bool isUUID(string uuid, bool stripInput = true) {
  import std.meta;

  alias skipSeq = AliasSeq!(8, 13, 18, 23);
  alias byteSeq = AliasSeq!(0, 2, 4, 6, 9, 11, 14, 16, 19, 21, 24, 26, 28, 30, 32, 34);
  import std.conv : to, parse;

  auto u = uuid;
  if (stripInput)
    u = u.strip;
  if (u.length < 36) {
    return false;
  } // "Insufficient Input"
  if (u.length > 36) {
    return false;
  } // "Input is too long, need exactly 36 characters";

  static immutable skipInd = [skipSeq];
  foreach (pos; skipInd)
    if (u[pos] != '-') {
      return false;
    } // Expected '-'

  foreach (i, p; byteSeq) {
    enum uint s = 'a' - 10 - '0';
    uint h = u[p];
    uint l = u[p + 1];
    if (h < '0') {
      return false;
    }
    if (l < '0') {
      return false;
    }
    if (h > '9') {
      h |= 0x20; //poorman's tolower
      if (h < 'a') {
        return false;
      }
      if (h > 'f') {
        return false;
      }
      h -= s;
    }
    if (l > '9') {
      l |= 0x20; //poorman's tolower
      if (l < 'a') {
        return false;
      }
      if (l > 'f') {
        return false;
      }
      l -= s;
    }
    h -= '0';
    l -= '0';
  }
  return true;
}

version (test_uim_core) {
  unittest {
    assert(isUUID(randomUUID.toString));
    assert(!isUUID(randomUUID.toString[0 .. 4]));
  }
}

string[] toString(UUID[] ids) {
  auto result = new string[ids.length];
  foreach (i, id; ids)
    result[i] = id.toString;
  return result;
}

version (test_uim_core) {
  unittest {
    /// TODO
  }
}

Json toJson(UUID id) {
  return Json(id.toString);
}

/// TODO
/* Json toJson(UUID[] ids) {
	return Json(ids.map!(id => id.toString).array);
}
 */
string[] toStringCompact(UUID[] ids) {
  auto result = new string[ids.length];
  foreach (i, id; ids)
    result[i] = id.toStringCompact;
  return result;
}

string toStringCompact(UUID id) {
  return id.toString.replace("_", "");
}

version (test_uim_core) {
  unittest {
    /// TODO
  }
}

UUID[] toUUID(string[] ids) {
  auto result = new UUID[ids.length];
  foreach (i, id; ids)
    result[i] = toUUID(id);
  return result;
}

UUID toUUID(string id) {
  import std.string;

  // TODO strip quotes
  // if ((id.indexOf("'") == 0) || (id.indexOf(`"`) == 0)) 

  return UUID(id.strip);
}

version (test_uim_core) {
  unittest {
    /// TODO
  }
}
