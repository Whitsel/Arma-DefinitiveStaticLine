
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
 * player call tScripts_fnc_jumpSimple;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_jumper"];

private _parachuteClass = CGVAR(parachuteClass);
private _playerEquipmentRetrieval = getNumber (missionConfigFile >> "CfgStaticLine" >> "enableplayerEquipmentRetrieval");

sleep 1.5;

private _parachute = createVehicle [_parachuteClass, (position _Jumper), [], 0, "CAN_COLLIDE"];

_jumper moveInDriver _parachute;

if !(backpack _jumper == "") then {

	private _backpack = backpackContainer _jumper;

	_jumper addBackpackGlobal "B_AssaultPack_khk"; //throws current pack on ground in weapon holder
	removeBackpackGlobal _jumper;

	private _physXObj = createVehicle ["Land_PenBlack_F", getPos _jumper, [], 0, "NONE"];

	objectParent _backpack attachTo [_physXObj, [-0.1,-0.3,-0.55]];
	[objectParent _backpack, 0, 180, 0] call FUNC(orientObject);

	_physXObj attachTo [_parachute, [0.05, 0.25, 0]];
	[_physXObj, 180, -90, 180] call FUNC(orientObject);

	waitUntil {sleep 1; (getPosATL _parachute)#2 < 35};

	detach _physXObj;

	[_physXObj, 0, 0, 0] call FUNC(orientObject);

	sleep 1;

	private _hookPileTapeLoweringLine = ropeCreate [_parachute, [0,0,0], _physXObj, [0,0,0], 5];

	waitUntil {sleep 1; isNull _parachute};

	deleteVehicle _hookPileTapeLoweringLine;

	if (isPlayer _jumper && _playerEquipmentRetrieval == 1) then {
			[_jumper, _physXObj, objectParent _backpack] call FUNC(landSimulated)
		} else {
			[_jumper, _physXObj, objectParent _backpack] call FUNC(landSimple)
	};
};
