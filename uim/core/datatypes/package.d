/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://www.sicherheitsschmiede.de/docus/uim-core/datatypes/overview
************************************************************************************************/
module uim.core.datatypes;

import uim.core;

public {
  import uim.core.datatypes.datetime;
  import uim.core.datatypes.boolean;
  import uim.core.datatypes.datetime;
  import uim.core.datatypes.floating;
  import uim.core.datatypes.general;
  import uim.core.datatypes.datetime;
  import uim.core.datatypes.integral;
  import uim.core.datatypes.json;
  import uim.core.datatypes.jstring;
  import uim.core.datatypes.string_;
  import uim.core.datatypes.uuid;
}

/*
T toogle(T)(T value, T checkValue, T changeValue) if (!isBoolean!T) {
    if (value == checkValue) return changeValue;
    if (value == changeValue) return checkValue;
    return value;
}
version(test_uim_core) { unittest {
    assert(1.toggle(1, 2) == 2);
    assert(2.toggle(1, 2) == 1);
    assert(3.toggle(1, 2) == 3);
}*/

T rotate(T)(T value, T[] values, bool directionRight = true) {
  if (values.length > 0)
  foreach(index, val; values) {
    if (val == value) {
      if (directionRight) {
        return index == values.length-1 
          ? values[0]
          : values[index+1];
      }
      else {
        return index == 0 
          ? values[$-1] 
          : values[index-1];
      }
    }
  }
  return value;
}
unittest {
  assert(1.rotate([2,3,1,4,5]) == 4);
}

