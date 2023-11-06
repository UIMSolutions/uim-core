/***********************************************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.json;

@safe:
import uim.core;

/// Checks if every key is in json object
bool hasAllKeys(Json json, string[] keys, bool deepSearch = false) {
  foreach(key; keys) {
    if (!hasKey(json, key, deepSearch)) { return false; } 
  }
  return true;
}
///
unittest {
  assert(parseJsonString(`["a", "b", "c"]`).isArray);
  assert(!parseJsonString(`{"a":"b"}`).isArray);
}

bool isObject(Json json) {
  return (json.type == Json.Type.object);
}
///
unittest {
  assert(parseJsonString(`{"a":"b"}`).isObject);
  assert(!parseJsonString(`["a", "b", "c"]`).isObject);
}

/// Checks if every key is in json object
bool hasAllKeys(Json json, string[] keys, bool deepSearch = false) {
  return keys
    .filter!(k => hasKey(json, k, deepSearch))
    .array.length == keys.length;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasAllKeys(["a", "c"]));
  assert(json.hasAllKeys(["a", "d"], true));
}

/// Check if Json has key
bool hasAnyKey(Json json, string[] keys, bool deepSearch = false) { 
  foreach(key; keys) 
    if (hasKey(json, key, deepSearch)) { return true; }
  return false;
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasAnyKey(["a"]));
  assert(json.hasAnyKey(["d"], true));
}

/// Searching key in json, if depth = true also in subnodes  
bool hasKey(Json json, string key, bool deepSearch = false) {
  if (json.type == Json.Type.object) {
    foreach(kv; json.byKeyValue) {
      if (kv.key == key) { return true; }
      if (deepSearch) {
        auto result = kv.value.hasKey(key, deepSearch);
        if (result) { return true; }
      }
    }
  }
  if (deepSearch) {
    if (json.isArray) {
      for (size_t i = 0; i < json.length; i++) {
        const result = json[i].hasKey(key, deepSearch);
        if (result) { return true; } 
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

bool hasAllValues(Json json, Json[] values, bool deepSearch = false) {
  foreach(value; values) if (!hasValue(json, value, deepSearch)) { return false; }
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

bool hasAnyValue(Json json, Json[] values, bool deepSearch = false) {
  foreach(value; values) if (hasValue(json, value, deepSearch)) { return true; }
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
bool hasValue(Json json, Json value, bool deepSearch = false) {
  if (json.type == Json.Type.object) {
    foreach(kv; json.byKeyValue) {
      if (kv.value == value) { return true; }
      if (deepSearch) {
        auto result = kv.value.hasValue(value, deepSearch);
        if (result) { return true; }
      }
    }
  }
  if (deepSearch) {
    if (json.isArray) {
      for (size_t i = 0; i < json.length; i++) {
        const result = json[i].hasValue(value, deepSearch);
        if (result) { return true; } 
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
bool hasPath(Json json, string path) {
  if (!json.isObject) {
    return false;
  }

  auto items = path.split("/");
  if (items.length > 1) {
    return hasPath(json, items[1 .. $]);
  }
  {
    return false;
  }
}
///
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasPath("/c/d"));
  assert(!json.hasPath("/x/y"));
}

/// Check if jsonPath items exists
bool hasPath(Json json, string[] pathItems) {
  if (json.type != Json.Type.object) { return false; }

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
      .each(key => result[key] = json[key]);

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
Json removeKeys(Json json, string[] delKeys...) { return removeKeys(json, delKeys.dup); }
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

Json readJson(Json target, Json source, bool overwrite = false) {
  if (!target.isObject || !source.isObject) {
    return target;
  }

  auto result = target;
  foreach (kv; json.byKeyValue) {
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

// #region convert
// Convert string[] data to Json array
Json toJson(string[] values) {
  Json result = Json.emptyArray;
  values.each!(value => json ~= value);
  return result;
}

version (test_uim_core) {
  unittest {
    assert(["a", "b", "c"].toJson.length == 3);
    assert(["a", "b", "c"].toJson[0] == "a");
  }
}

Json toJson(STRINGAA data) {
  Json json = Json.emptyObject;
  values.byKeyValue.each!(kv => json[kv.key] = kv.value);
  return result;
}

version (test_uim_core) {
  unittest {
    assert(["a": "1", "b": "2", "c": "3"].toJson.length == 3);
    assert(["a": "1", "b": "2", "c": "3"].toJson["a"] == "1");
  }
}

Json toJson(string key, string value) {
  Json json = Json.emptyObject;
  json[key] = value;
  return json;
}

version (test_uim_core) {
  unittest {
    assert(toJson("a", "3")["a"] == "3");
  }
}

Json toJson(string key, UUID value) {
  Json json = Json.emptyObject;
  json[key] = value.toString;
  return json;
}

unittest {
  auto id = randomUUID;
  assert(toJson("id", id)["id"].get!string == id.toString);
}

/// Special case for managing entities
Json toJson(UUID id, size_t versionNumber = 0LU) {
  Json json = Json.emptyObject;
  json["id"] = id.toString;
  if (versionNumber > 0) {
    json["versionNumber"] = versionNumber;
  }
  return json;
}

version (test_uim_core) {
  unittest {
    auto id = randomUUID;
    assert(toJson(id)["id"].get!string == id.toString);
    assert("versionNumber" !in toJson(id));
    assert(toJson(id, 1)["id"].get!string == id.toString);
    assert(toJson(id, 1)["versionNumber"].get!size_t == 1);
}}

Json mergeJsonObject(Json baseJson, Json mergeJson) {
  Json result;
  
  if (mergeJson.isEmpty || mergeJson.type != Json.Type.object) {
    return baseJson;
  }
}
// #endregion convert

// #region merge
/// Merge jsons objects to one
Json mergeJsons(Json[] jsons...) {
  return mergeJsons(jsons.dup);
}
/// Merge jsons objects in array to one
Json mergeJsons(Json[] jsons, bool overwrite = true) {
  Json result = Json.emptyObject;

  jsons
    .filter!(json => json.isObject)
    .each!(json => result = result.mergeJsonObjects(json, overwrite))
    .array;

  return result;
}
///
version (test_uim_core) {
  unittest {
    auto json0 = parseJsonString(`{"a":"b", "c":{"d":1}}`);
    auto json1 = parseJsonString(`{"e":["f", {"g":"h"}]}`);
    auto mergeJson = mergeJsons(json0, json1);
    assert(mergeJson.hasKey("a") && mergeJson.hasKey("e"));
  }
}

Json mergeJsonObjects(Json baseJson, Json mergeJson, bool overwrite = true) {
  Json result = Json.emptyObject;
  if (baseJson.isNull && !baseJson.isObject) { return result; } 
  result = result.readJson(baseJson, overwrite);

  if (mergeJson.isNull && !mergeJson.isObject) { return result; } 
  mergeJson.readJson(mergeJson, overwrite);

  // Out
  return result;
}

///
unittest {
  Json json1 = parseJsonString(`{"a":"b", "c":{"d":1}}`);
  Json json2 = parseJsonString(`{"a":"b", "c":{"d":1}}`);
  // TODO add test
}
// #endregion merge

bool isEmpty(Json aJson) {
<<<<<<< HEAD
  return aJson == Json(null);
}
=======
  return aJson.isEmpty;
}
>>>>>>> 5d739b4 (Updates)
