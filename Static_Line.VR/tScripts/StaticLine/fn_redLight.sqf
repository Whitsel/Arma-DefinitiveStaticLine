
/*
 * Author: [7Cav] Whitsel
 * Interupts green light prcedures
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * player call tScripts_fnc_redLight;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_caller"];

private _vehicle = vehicle _caller;
private _passengers = fullCrew [_vehicle, "cargo", false];

for "_i" from (count _passengers -1) to 0 step -1 do { // Move JM to rear index
	if (_caller == (_passengers#_i#0)) then {
		_passengers deleteAt _i;
	}
};

_vehicle animateSource ["jumplight",0];

systemChat format ["%1: RED LIGHT!!! RED LIGHT!!! RED LIGHT!!!", (name _caller)];
if (count(_passengers) >= 2) then {
	systemChat format ["%1: RED LIGHT!!! RED LIGHT!!! RED LIGHT!!!", (name(_passengers#0#0))];
	systemChat format ["%1: RED LIGHT!!! RED LIGHT!!! RED LIGHT!!!", (name(_passengers#1#0))];
};

SETVAR(_vehicle,CGVAR(jumpInterupt),true);

_vehicle spawn {

	params ["_vehicle"];

	sleep 2;

	_vehicle animateDoor ["door_2_1", 1, true];
	_vehicle animateDoor ["door_2_2", 1, true];

};
