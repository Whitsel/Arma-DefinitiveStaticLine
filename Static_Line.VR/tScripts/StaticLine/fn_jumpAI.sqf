
/*
 * Author: [7Cav] Whitsel
 * Initiates deployment of parachute and attachment of equipment whe in the air
 * Inteded for use with AI or for players when jump similiation is turned off
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * player call tScripts_fnc_jumpAI;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_jumper"];

private _backpackClass = backpack _jumper;
//private _backpackContents = ((getUnitLoadout _jumper)#5)#1;
private _parachuteClass = CGVAR(parachuteClass);

sleep 1.5;

private _parachute = createVehicle [_parachuteClass, (position _Jumper), [], 0, "CAN_COLLIDE"];

_jumper moveInDriver _parachute;

sleep 1;

private _physXObj = createVehicle ["Land_PenBlack_F", getPos _jumper, [], 0, "NONE"];
private _backpack = objectParent createVehicle [_backpackClass, position _jumper, [], 0, "NONE"];
_backpack attachTo [_physXObj, [-0.1,-0.3,-0.45]];
_y = 0; _p = 180; _r = 0;
_backpack setVectorDirAndUp [
   [sin _y * cos _p, cos _y * cos _p, sin _p],
   [[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D
  ];

_physXObj attachTo [_parachute, [0.05, 0.25, 0]];
_y = 180; _p = -90; _r = 180;
_physXObj setVectorDirAndUp [
   [sin _y * cos _p, cos _y * cos _p, sin _p],
   [[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D
];

sleep 2;

detach _physXObj;

_y = 0; _p = 0; _r = 0;
_physXObj setVectorDirAndUp [
   [sin _y * cos _p, cos _y * cos _p, sin _p],
   [[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D
];

sleep 2;

_hookPileTapeLoweringLine = ropeCreate [_parachute, [0,0,0], _physXObj, [0,0,0], 10];
