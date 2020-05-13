module uim.core.datatypes;

import std.meta;
public import uim.core.datatypes.annotations;
public import uim.core.datatypes.mixins;
public import uim.core.datatypes.boolean;
public import uim.core.datatypes.datetime;
public import uim.core.datatypes.integral;
public import uim.core.datatypes.floating;
public import uim.core.datatypes.general;
public import uim.core.datatypes.string_;
public import uim.core.datatypes.uuid;

T toogle(T value, T checkValue, T changeValue) {
    if (value == checkValue) return changeValue;
    if (value == changeValue) return checkValue;
    return value;
}
unittest {
    assert(1.toggle(1, 2) == 2);
    assert(2.toggle(1, 2) == 1);
    assert(3.toggle(1, 2) == 3);
}

T rotate(T value, T[] values, bool directionRight = true) {
    if (values.length > 0)
    foreach(index, val; values) {
        if (val == value) {
            if (directionRight) {
                if (index == values.length-1) return values[0];
                return values[index+1];
            }
            else {
                if (index == 0) return values[$-1];
                retirn values[index-1];
            }
        }
    }
    return value;
}
unittest {
    assert(1.rotate(2,3,1,4,5) == 4);
}

T rotateReverse(T value, T[] values, bool directionRight = true) {
    if (values.length > 0)
    foreach_reverse(index, val; values) {
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
unittest {
    assert(1.rotate(2,3,1,4,5) == 3);
}
