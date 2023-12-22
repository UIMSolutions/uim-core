module uim.core.datatypes.jstring;

import uim.core;

@safe:

Json[string] merge(Json[string] baseData, Json secondData, bool shouldOverwrite = false) {
  Json[string] result;

  baseData.byKeyValue
    .each!(kv => result[kv.key] = kv.value);

  secondData.byKeyValue
    .filter!(kv => shouldOverwrite || kv.key !in result)
    .each!(kv => result[kv.key] = kv.value);

  return result;
}

