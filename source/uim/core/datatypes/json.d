/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.json;

import uim.core;

@safe:
// #region Properties
  string[] keys(Json anObject) {
    if (anObject.isNull) { 
      return null;
    }

    return anObject.byKeyValue.map!(kv => kv.key).array;
  }
// #endregion Properties

// #region Check json value
  bool isObject(Json aJson) {
    return aJson.type == Json.Type.object;
  }
  ///
  unittest {
    assert(parseJsonString(`{"a":"b"}`).isObject);
    assert(!parseJsonString(`["a", "b", "c"]`).isObject);
  }

  bool isArray(Json aJson) {
    return (aJson.type == Json.Type.array);
  }
  ///
  unittest {
    assert(parseJsonString(`["a", "b", "c"]`).isArray);
    assert(!parseJsonString(`{"a":"b"}`).isArray);
  }

  bool isBigInt(Json aJson) {
    return (aJson.type == Json.Type.bigInt);
  }
  ///
  unittest {
    assert(parseJsonString(`1000000000000000000000`).isBigInt);
    assert(!parseJsonString(`1`).isBigInt);
  }

  bool isBool(Json aJson) {
    return (aJson.type == Json.Type.bool_);
  }
  ///
  unittest {
    assert(parseJsonString(`true`).isBool);
    assert(parseJsonString(`false`).isBool);
    assert(!parseJsonString(`1`).isBool);
  }

  bool isFloat(Json aJson) {
    return (aJson.type == Json.Type.float_);
  }
  ///
  unittest {
    assert(parseJsonString(`1.1`).isFloat);
    assert(!parseJsonString(`1`).isFloat);
  }

  bool isInt(Json aJson) {
    return (aJson.type == Json.Type.int_);
  }
  ///
  unittest {
    assert(parseJsonString(`1`).isInt);
    assert(!parseJsonString(`1.1`).isInt);
  }

  bool isNull(Json aJson) {
    return aJson == Json(null);
  }

  unittest {
    assert(Json(null).isNull);
    assert(!Json.emptyObject.isNull);
    assert(!Json.emptyArray.isNull);
  }

  bool isString(Json aJson) {
    return (aJson.type == Json.Type.string);
  }

  unittest {
    assert(parseJsonString(`"a"`).isString);
    assert(!parseJsonString(`1.1`).isString);
  }

  bool isUndefined(Json aJson) {
    return (aJson.type == Json.Type.undefined);
  }

  unittest {
    // TODO running test assert(parseJsonString(`#12abc`).isUndefined);
    assert(!parseJsonString(`1.1`).isUndefined);
  }

  bool isEmpty(Json aJson) {
    return aJson == Json(null);

    // TODO add not null, but empty
  }
// #endregion

/// Checks if every key is in json object
bool hasAllKeys(Json aJson, string[] keys, bool deepSearch = false) {
  return keys
    .filter!(k => hasKey(aJson, k, deepSearch))
    .array.length == keys.length;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasAllKeys(["a", "c"]));
  assert(json.hasAllKeys(["a", "d"], true));
}

/// Check if Json has key
bool hasAnyKey(Json aJson, string[] keys, bool deepSearch = false) {
  foreach (key; keys) {
    if (hasKey(aJson, key, deepSearch)) {
      return true;
    }
  }

  return false;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasAnyKey(["a"]));
  assert(json.hasAnyKey(["d"], true));
}

/// Searching key in json, if depth = true also in subnodes  
bool hasKey(Json aJson, string key, bool deepSearch = false) {
  if (aJson.isObject) {
    foreach (kv; aJson.byKeyValue) {
      if (kv.key == key) {
        return true;
      }
      if (deepSearch) {
        auto result = kv.value.hasKey(key, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }
  
  if (deepSearch) {
    if (aJson.isArray) {
      for (size_t i = 0; i < aJson.length; i++) {
        const result = aJson[i].hasKey(key, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }
  return false;
}
///
version (test_uim_core) {
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
    assert(json.hasKey("a"));
    assert(json.hasKey("d", true));
  }
}

bool hasAllValues(Json aJson, Json[] values, bool deepSearch = false) {
  foreach (value; values)
    if (!hasValue(aJson, value, deepSearch)) {
      return false;
    }
  return true;
}
///
version (test_uim_core) {
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}], "i":"j"}`);
    assert(json.hasAllValues([Json("b"), Json("j")]));
    assert(json.hasAllValues([Json("h"), Json(1)], true));
  }
}

bool hasAnyValue(Json aJson, Json[] values, bool deepSearch = false) {
  foreach (value; values)
    if (hasValue(aJson, value, deepSearch)) {
      return true;
    }
  return false;
}
///
version (test_uim_core) {
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}], "i":"j"}`);
    assert(json.hasAllValues([Json("b"), Json("j")]));
    assert(json.hasAllValues([Json("h"), Json(1)], true));
  }
}

/// Searching for value in Json
bool hasValue(Json aJson, Json value, bool deepSearch = false) {
  if (aJson.isObject) {
    foreach (kv; aJson.byKeyValue) {
      if (kv.value == value) {
        return true;
      }
      if (deepSearch) {
        auto result = kv.value.hasValue(value, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }

  if (deepSearch) {
    if (aJson.isArray) {
      for (size_t i = 0; i < aJson.length; i++) {
        const result = aJson[i].hasValue(value, deepSearch);
        if (result) {
          return true;
        }
      }
    }
  }

  return false;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasValue(Json("b")));
  assert(json.hasValue(Json("h"), true));
  assert(!json.hasValue(Json("x")));
  assert(!json.hasValue(Json("y"), true));
}

/// Check if jsonPath exists
bool hasPath(Json aJson, string path) {
  if (!aJson.isObject) {
    return false;
  }

  auto items = path.split("/");
  if (items.length > 1) {
    return hasPath(aJson, items[1 .. $]);
  }
  return false;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasPath("/c/d"));
  assert(!json.hasPath("/x/y"));
}

/// Check if jsonPath items exists
bool hasPath(Json json, string[] pathItems) {
  // In Check
  if (!json.isObject) {
    return false;
  }

  // Body
  auto j = json;
  foreach (pathItem; pathItems) {
    if (pathItem in j) {
      if (pathItems.length > 1) {
        return hasPath(j[pathItem], pathItems[1 .. $]);
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
  return true;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasPath(["c", "d"]));
}

/// Reduce Json Object to keys (remove others)
Json reduceKeys(Json json, string[] keys) {
  if (json.isObject) {
    Json result = Json.emptyObject;
    keys
      .filter!(key => json.hasKey(key))
      .each!(key => result[key] = json[key]);

    return result;
  }
  return Json(null); // Not object or keys
}

version (test_uim_core) {
  unittest {
    writeln("test uim_core");
    // TODO 
  }
}

/// Remove keys from Json Object
Json removeKeys(Json json, string[] delKeys...) {
  return removeKeys(json, delKeys.dup);
}

Json removeKeys(Json aJson, string[] delKeys) {
  auto result = aJson;
  delKeys.each!(k => result.removeKey(k));
  return result;
}

version (test_uim_core) {
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
    assert(json.hasValue(Json("b")));
    assert(json.hasValue(Json("h"), true));
  }
}

/// Remove key from Json Object
Json removeKey(Json json, string aKey) {
  if (!json.isObject) {
    return json;
  }

  Json result = Json.emptyObject;
  json
    .byKeyValue
    .filter!(kv => kv.key != aKey)
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

version (test_uim_core) {
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
    assert(json.hasKey("a"));
    assert(!json.removeKey("a").hasKey("a"));

    json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
    assert(!json.hasKey("x"));
    assert(!json.removeKey("x").hasKey("x"));
    assert(json.removeKey("x").hasKey("a"));
  }
}

Json readJson(Json target, Json source, bool overwrite = true) {
  if (!target.isObject || !source.isObject) {
    return target;
  }

  auto result = target;
  foreach (kv; source.byKeyValue) {
    if (overwrite) {
      result[kv.key] = kv.value;
    } else {
      if (!result.hasKey(kv.key)) {
        result[kv.key] = kv.value;
      }
    }
  }

  return result;
}

/// Load existing json files in directories
Json[] loadJsonsFromDirectories(string[] dirNames) {
  Json[] results;
  foreach (dir; dirNames.filter!(a => a.exists))
    if (dir.exists)
      results ~= loadJsonsFromDirectory(dir);
  return results;
}

version (test_uim_core) {
  unittest {
    /// TODO Add Tests
  }
}

/// Load existing json file in directories
Json[] loadJsonsFromDirectory(string dirName) {
  // debug writeln("In loadJsonsFromDirectory("~dirName~")");
  // debug writeln("Found ", fileNames(dirName).length, " files");
  return loadJsons(fileNames(dirName, true));
}

version (test_uim_core) {
  unittest {
    /// TODO Add Tests
  }
}

Json[] loadJsons(string[] fileNames) {
  // debug writeln("Found ", fileNames.length, " names -> ", fileNames);
  return fileNames.map!(a => loadJson(a))
    .filter!(a => a != Json(null))
    .array;
}

version (test_uim_core) {
  unittest {
    /// TODO(John) Add Tests
  }
}

Json loadJson(string name) {
  // debug writeln("In loadJson("~name~")");
  // debug writeln(name, " exists? ", name.exists);
  return name.exists ? parseJsonString(readText(name)) : Json(null);
}

version (test_uim_core) {
  unittest {
    /// TODO Add Tests
  }
}

T minValue(T)(Json[] jsons, string key) {
  T result;
  foreach (j; jsons) { // find first value
    if (key !in j)
      continue;

    T value = j[key].get!T;
    result = value;
    break;
  } // found value

  foreach (j; jsons) { // compare values
    if (key !in j)
      continue;

    T value = j[key].get!T;
    if (value < result)
      result = value;
  }
  return result;
}

version (test_uim_core) {
  unittest {
    assert(minValue!string(
        [
        ["a": "5"].toJson,
        ["a": "2"].toJson,
        ["a": "1"].toJson,
        ["a": "4"].toJson
      ], "a") == "1");
  }
}

T maxValue(T)(Json[] jsons, string key) {
  T result;
  foreach (j; jsons) { // find first value
    if (key !in j)
      continue;

    T value = j[key].get!T;
    result = value;
    break;
  } // found value

  foreach (j; jsons) { // compare values
    if (key !in j)
      continue;

    T value = j[key].get!T;
    if (value > result)
      result = value;
  }
  return result;
}

version (test_uim_core) {
  unittest {
    assert(maxValue!string(
        [
        ["a": "5"].toJson,
        ["a": "2"].toJson,
        ["a": "1"].toJson,
        ["a": "4"].toJson
      ], "a") == "5");
  }
}

// #region toJson
  Json toJson(string[] someValues) {
    Json result = Json.emptyArray;
    someValues.each!(value => result ~= value);
    return result;
  }
  ///
  unittest {
    assert(["a", "b", "c"].toJson.length == 3);
    assert(["a", "b", "c"].toJson[0] == "a");
  }

  Json toJson(STRINGAA someKeyValues) {
    Json result = Json.emptyObject;
    someKeyValues.byKeyValue.each!(kv => result[kv.key] = kv.value);
    return result;
  }
  version (test_uim_core) {
    unittest {
      assert(["a": "1", "b": "2", "c": "3"].toJson.length == 3);
      assert(["a": "1", "b": "2", "c": "3"].toJson["a"] == "1");
    }
  }

  Json toJson(string aKey, string aValue) {
    Json result = Json.emptyObject;
    result[aKey] = aValue;
    return result;
  }

  version (test_uim_core) {
    unittest {
      assert(toJson("a", "3")["a"] == "3");
    }
  }

  Json toJson(string aKey, UUID aValue) {
    Json result = Json.emptyObject;
    result[aKey] = aValue.toString;
    return result;
  }

  unittest {
    auto id = randomUUID;
    assert(UUID(toJson("id", id)["id"].get!string) == id);
  }

  /// Special case for managing entities
  Json toJson(UUID id, size_t versionNumber = 0LU) {
    Json result = "id".toJson(id);
    if (versionNumber > 0) {
      result["versionNumber"] = versionNumber;
    }
    return result;
  }
  ///
  version (test_uim_core) {
    unittest {
      auto id = randomUUID;
      assert(toJson(id)["id"].get!string == id.toString);
      assert("versionNumber" !in toJson(id));
      assert(toJson(id, 1)["id"].get!string == id.toString);
      assert(toJson(id, 1)["versionNumber"].get!size_t == 1);
    }
  }
// #endregion toJson

Json mergeJsonObject(Json baseJson, Json mergeJson) {
  Json result;

  if (mergeJson.isEmpty || mergeJson.type != Json.Type.object) {
    return baseJson;
  }

  // TODO not finished
  return result;
}

// #region set()
Json set(T)(Json json, T[string] newValues) {
  if (!json.isObject) { return Json(null); }

  auto result = json;
  newValues.byKeyValue.each!(kv => result[kv.key] = kv.value);

  return result;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "x":"y"}`);
  assert(json.set(["a": "c"])["a"].get!string == "c");

  json = parseJsonString(`{"a":"b", "x":"y"}`);
  assert(json.set(["a": "c", "x": "z"])["x"].get!string == "z");
  assert(json.set(["a": "c", "x": "z"])["x"].get!string != "c");
}
// #endregion

// #region merge
/// Merge jsons objects to one
Json mergeJsons(Json[] jsons...) {
  return mergeJsons(jsons.dup, true);
}
/// Merge jsons objects in array to one
Json mergeJsons(Json[] jsons, bool overwrite = true) {
  Json result = Json.emptyObject;

  jsons
    .filter!(json => json.isObject)
    .each!(json => result = result.mergeJsonObjects(json, overwrite));

  return result;
}
///
/* unittest {
  auto json0 = parseJsonString(`{"a":"b", "c":{"d":1}}`);
  auto json1 = parseJsonString(`{"e":["f", {"g":"h"}]}`);
  auto mergeJson = mergeJsons(json0, json1);
  assert(mergeJson.hasKey("a") && mergeJson.hasKey("e"), mergeJson.toString);
} */ 

Json mergeJsonObjects(Json baseJson, Json mergeJson, bool overwrite = true) {
  Json result = Json.emptyObject;
  if (baseJson.isNull && !baseJson.isObject) {
    return result;
  }
  result = result.readJson(baseJson, overwrite);

  if (mergeJson.isNull && !mergeJson.isObject) {
    return result;
  }
  result = result.readJson(mergeJson, overwrite);
 
  // Out
  return result;
}

///
unittest {
  auto json0 = parseJsonString(`{"a":"b", "c":{"d":1}}`);
  auto json1 = parseJsonString(`{"e":["f", {"g":"h"}]}`);
  auto mergeJson = mergeJsonObjects(json0, json1);
  assert(mergeJson.hasKey("a") && mergeJson.hasKey("e"), mergeJson.toString);
}
// #endregion merge

Json jsonWithMinVersion(Json[] jsons...) {
  return jsonWithMinVersion(jsons.dup);
}

Json jsonWithMinVersion(Json[] jsons) {
  if (jsons.length == 0) { return Json(null); }

  auto result = jsons[0];

  if (jsons.length > 1) {
    jsons[1..$]
      .filter!(json => json.isObject && json.isSet("versionNumber"))
      .each!(json => result = json["versionNumber"].get!size_t < result["versionNumber"].get!size_t ? json : result);
  }

  return result;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber":1}`);
  auto json2 = parseJsonString(`{"versionNumber":2}`);

  auto json3 = parseJsonString(`{"versionNumber":3}`);

  assert(jsonWithMinVersion(json1, json2)["versionNumber"].get!size_t == 1);
  assert(jsonWithMinVersion([json1, json2])["versionNumber"].get!size_t == 1);

  assert(jsonWithMinVersion(json1, json3, json2)["versionNumber"].get!size_t == 1);
  assert(jsonWithMinVersion([json1, json3, json2])["versionNumber"].get!size_t == 1);

  assert(jsonWithMinVersion(json3, json3, json2)["versionNumber"].get!size_t == 2);
  assert(jsonWithMinVersion([json3, json3, json2])["versionNumber"].get!size_t == 2);
}

Json jsonWithMaxVersion(Json[] jsons...) {
  return jsonWithMaxVersion(jsons.dup);
}

Json jsonWithMaxVersion(Json[] jsons) {
  if (jsons.length == 0) { return Json(null); }

  auto result = jsons[0];

  if (jsons.length > 1) {
    jsons[1..$]
      .filter!(json => json.isObject && json.isSet("versionNumber"))
      .each!(json => result = json["versionNumber"].get!size_t > result["versionNumber"].get!size_t ? json : result);
  }

  return result;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber":1}`);
  auto json2 = parseJsonString(`{"versionNumber":2}`);
  auto json3 = parseJsonString(`{"versionNumber":3}`);

  assert(jsonWithMaxVersion(json1, json2)["versionNumber"].get!size_t == 2);
  assert(jsonWithMaxVersion([json1, json2])["versionNumber"].get!size_t == 2);

  assert(jsonWithMaxVersion(json1, json3, json2)["versionNumber"].get!size_t == 3);
  assert(jsonWithMaxVersion([json1, json3, json2])["versionNumber"].get!size_t == 3);

  assert(jsonWithMaxVersion(json3, json3, json2)["versionNumber"].get!size_t == 3);
  assert(jsonWithMaxVersion([json3, json3, json2])["versionNumber"].get!size_t == 3);
}

size_t maxVersionNumber(Json[] jsons...) {
  return maxVersionNumber(jsons.dup);
}

size_t maxVersionNumber(Json[] jsons) {
  if (jsons.length == 0) { return 0; }

  size_t result = 0;

  jsons
    .filter!(json => json.isObject && json.isSet("versionNumber"))
    .each!(json => result = json["versionNumber"].get!size_t > result ? json["versionNumber"].get!size_t : result);

  return result;
}
///
unittest {
  auto json1 = parseJsonString(`{"versionNumber":1}`);
  auto json2 = parseJsonString(`{"versionNumber":2}`);
  auto json3 = parseJsonString(`{"versionNumber":3}`);

  assert(maxVersionNumber(json1, json2) == 2);
  assert(maxVersionNumber([json1, json2]) == 2);

  assert(maxVersionNumber(json1, json3, json2) == 3);
  assert(maxVersionNumber([json1, json3, json2]) == 3);

  assert(maxVersionNumber(json3, json3, json2) == 3);
  assert(maxVersionNumber([json3, json3, json2]) == 3);
}