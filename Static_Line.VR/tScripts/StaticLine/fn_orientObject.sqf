
/*
 * Author: Anonymous wiki contributor
 * Orients object with yaw, pitch, and roll
 *
 * Arguments:
 * 0: unit <OBJECT>
 * 1: yaw <SCALAR>
 * 2: pitch <SCALAR>
 * 3: roll <SCALAR>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * player call tScripts_fnc_orientObject;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_object", "_y", "_p", "_r"];

_object setVectorDirAndUp [
	[sin _y * cos _p, cos _y * cos _p, sin _p],
	[[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D
];
