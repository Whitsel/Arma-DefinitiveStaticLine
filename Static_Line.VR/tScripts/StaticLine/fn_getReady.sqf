
/*
 * Author: [7Cav] Whitsel
 * Starts procedures to prepare for jump
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * player call tScripts_fnc_getReady;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_caller"];

private _vehicle = vehicle _caller;
private _passengers = fullCrew [_vehicle, "cargo", false];

for "_i" from (count _passengers -1) to 0 step -1 do { // Move JM to rear index
	if (_caller == (_passengers#_i#0)) then {
		_passengers append [_passengers#_i];
		_passengers deleteAt _i;
	}
};

[_caller] spawn { //Verbal get ready command
	params ["_caller"];

	private _sound = ("true" configClasses (configFile >> "CfgSounds"));
	private _soundMountUp = [_caller, _caller] say3D [configName (_sound#616), 100, 1, true];

	sleep 1.75;

	deleteVehicle _soundMountUp;
};

_vehicle animateSource ["jumplight",0]; //Need to check light names for planes
_vehicle animateDoor ["door_2_1", 1, false]; //Need to check door names for different planes
_vehicle animateDoor ["door_2_2", 1, false];

sleep 3;
systemChat str formatText ["%1: Outboard personnel stand up!", (name _caller)];
sleep 1.75;
systemChat str formatText ["%1: Inboard personnel stand up!", (name _caller)];
sleep 1.75;
systemChat str formatText ["%1: Hook up!", (name _caller)];
sleep 1.75;
systemChat str formatText ["%1: Check Static Lines!", (name _caller)];
sleep 1.75;
systemChat str formatText ["%1: Check Equipment!", (name _caller)];
sleep 1.75;
systemChat str formatText ["%1: Sound off for equipment check!", (name _caller)];
sleep 1.75;

for "_i" from (count _passengers - 2) to 1 step -1 do {
	private _jumperName = (name(_passengers#_i#0));
	systemChat str formatText ["%1: OK!", _jumperName];
	sleep 0.15;
};
sleep 0.25;
systemChat str formatText ["%1: All OK Jumpmaster!!!", (name (_passengers#0#0))];
sleep 0.25;
systemChat str formatText ["%1: Standby!!!", (name _caller)];

SETVAR(vehicle _caller,CGVAR(getReady),true);
SETVAR(vehicle _caller,CGVAR(getReadyProgress),false);
