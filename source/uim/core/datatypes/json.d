module uim.core.datatypes.json;

@safe:
import uim.core;

bool hasAllKeys(Json json, string[] keys, bool deepSearch = false) {
  foreach(key; keys) {
    if (!hasKey(json, key, deepSearch)) return false; 
  }
  return true;
}
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasAllKeys(["a", "c"]));
  assert(json.hasAllKeys(["a", "d"], true));
}

/// Searching key in json, if depth = true also in subnodes  
bool hasKey(Json json, string key, bool deepSearch = false) {
  if (json.type == Json.Type.object) {
    foreach(kv; json.byKeyValue) {
      if (kv.key == key) return true;
      if (deepSearch) {
        auto result = kv.value.hasKey(key, deepSearch);
        if (result) return true;
      }
    }
  }
  if (deepSearch) {
    if (json.type == Json.Type.array) {
      for(size_t i = 0; i < json.length; i++) {
        const result = json[i].hasKey(key, deepSearch);
        if (result) return true; 
      }
    }
  }
  return false;
}
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasKey("a"));
  assert(json.hasKey("d", true));
}

bool hasAllValues(Json json, Json[] values, bool deepSearch = false) {
  foreach(value; values) {
    if (!hasValue(json, value, deepSearch)) return false;
  }
  return true;
}
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}], "i":"j"}`);
  assert(json.hasAllValues([Json("b"), Json("j")]));
  assert(json.hasAllValues([Json("h"), Json(1)], true));
}

// Searching for value in Json
bool hasValue(Json json, Json value, bool deepSearch = false) {
  if (json.type == Json.Type.object) {
    foreach(kv; json.byKeyValue) {
      if (kv.value == value) return true;
      if (deepSearch) {
        auto result = kv.value.hasValue(value, deepSearch);
        if (result) return true;
      }
    }
  }
  if (deepSearch) {
    if (json.type == Json.Type.array) {
      for(size_t i = 0; i < json.length; i++) {
        const result = json[i].hasValue(value, deepSearch);
        if (result) return true; 
      }
    }
  }
  return false;
}
unittest {
  auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}]}`);
  assert(json.hasValue(Json("b")));
  assert(json.hasValue(Json("h"), true));
}

bool hasPath(Json json, string path) {
  return hasPath(json, path.split("/"));
}

bool hasPath(Json json, string[] path) {
  auto j = json;
  foreach(item; path) {
    if (item in j) j = j[item];
    else return false;
  }
  return true;
}

Json reduce(Json json, string[] keys) {
  if (json.type == Json.Type.object) {
      Json result = Json.emptyObject;
      foreach(key; keys) if (key in json) result[key] = json[key];
      return result;
  }
  return Json(null);
}