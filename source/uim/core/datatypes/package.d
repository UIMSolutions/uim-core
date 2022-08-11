/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://www.sicherheitsschmiede.de/docus/uim-core/datatypes/overview
************************************************************************************************/
module uim.core.datatypes;

import std.meta;
import uim.core;

public import uim.core.datatypes.boolean;
public import uim.core.datatypes.datetime;
public import uim.core.datatypes.integral;
public import uim.core.datatypes.json;
public import uim.core.datatypes.floating;
public import uim.core.datatypes.general;
public import uim.core.datatypes.string_;
public import uim.core.datatypes.uuid;

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
                if (index == values.length-1) return values[0];
                return values[index+1];
            }
            else {
                if (index == 0) return values[$-1];
                return values[index-1];
            }
        }
    }
    return value;
}
version(test_uim_core) { unittest {
    assert(1.rotate([2,3,1,4,5]) == 4);
}}

