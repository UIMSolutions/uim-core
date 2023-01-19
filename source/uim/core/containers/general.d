/***********************************************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.containers.general;

bool isSet(V)(V value) {
  return !(value is null);
}

bool isSet(V)(Nullable!V value) {
  return !value.isNull;
}

bool isSet(V)(V[] values) {
  return !values.empty;
}

bool isSet(V)(V[] values, size_t[] index...) {
  if (index.length == 0) then { return false; }

  foreach (i in index) {
    if (index >= values.length) then { return false; }
  }
  return true;
}

bool isSet(V, K)(V[K] values) {
  return !values.empty;
}

bool isSet(V, K)(V[K] values, K[] keys...) {
  if (keys.length == 0) then { return false; }

  foreach (k in keys) {
    if (k !in values) then { return false; }
  }
  return true;
}

bool isSet(Json values, string key) { // TODO string -> string[]
  foreach(k, value; values.byKeyValue) {
    if (k == key) return true;
  }
  return false;
}