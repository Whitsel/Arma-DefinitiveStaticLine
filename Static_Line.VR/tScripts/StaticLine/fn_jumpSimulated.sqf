
/*
 * Author: [7Cav] Whitsel
 * Initiates deployment of parachute and attachment of equipment whe in the air
 * Inteded for use with for players when jump similiation is turned on
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * player call tScripts_fnc_jumpSimulated;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_jumper"];

private _parachuteClass = CGVAR(parachuteClass);
private _playerEquipmentRetrieval = getNumber (missionConfigFile >> "CfgStaticLine" >> "enableplayerEquipmentRetrieval");

private _nvgClass = hmd _jumper;
private _vestObj = vestContainer _jumper;
private _vestMaxLoad = maxLoad _vestObj;
_vestObj setMaxLoad (_vestMaxLoad + 100);
_jumper unassignItem _nvgClass;
_vestObj setMaxLoad _vestMaxLoad;

sleep 1.5;

private _parachute = createVehicle [_parachuteClass, (position _Jumper), [], 0, "CAN_COLLIDE"];

_jumper moveInDriver _parachute;

if !(backpack _jumper == "") then {

	private _backpack = backpackContainer _jumper;
	private _backpackPicture = (getText (configFile >> "CfgVehicles" >> backpack player >> "picture") trim ["paa", 2]) trim [".",2];
	private _WeaponPicture = (getText (configFile >> "CfgWeapons" >> primaryWeapon player >> "picture") trim ["paa", 2]) trim [".",2];

	_jumper addBackpackGlobal "B_AssaultPack_khk"; // Throws current pack on ground in weapon holder
	removeBackpackGlobal _jumper;

	private _physXObj = createVehicle ["Land_PenBlack_F", getPos _jumper, [], 0, "NONE"];

	objectParent _backpack attachTo [_physXObj, [-0.1,-0.3,-0.55]];
	[objectParent _backpack, 0, 180, 0] call FUNC(orientObject);
	//objectParent _primaryWeapon attachTo [_physXObj, [-0.05, 0.05, 0.08]];
	//[objectParent _primaryWeapon, 0, 180, 0] call FUNC(orientObject);

	_physXObj attachTo [_parachute, [0.05, 0.25, 0]];
	[_physXObj, 180, -90, 180] call FUNC(orientObject);

	hintSilent composeText[
		lineBreak,
		parseText("<img size='4' image='" + _weaponPicture + "'/>"),
		lineBreak,
		parseText("<img size='6' image='" + _backpackPicture + "'/>"),
		lineBreak,
		lineBreak,
		lineBreak,
		"Press SPACE to lower equipment",
		lineBreak,
		lineBreak,
		"Press CTRL + SHIFT + SPACE to jettison equipment"
];

	SETVAR(_jumper,CGVAR(physXObj),_physXObj); //For EH to access out of scope
	SETVAR(_jumper,CGVAR(parachute),_parachute);

	private _displayEH_ID = (findDisplay 46) displayAddEventHandler ["KeyDown",
		{
			params ["_control", "_key", "_isShift", "_isControl", "_isAlt"];

			private _physXObj = GETVAR(player,CGVAR(physXObj),ObjNull);
			private _parachute = vehicle player;

			private _override = false;

			private _equipmentLowered = GETVAR(_parachute,CGVAR(equipmentLowered), false);

			if (_key == 57 && !(_isShift && _isControl) && _equipmentLowered == false) then { // Lower equipment

				_override = true;

				detach _physXObj;
				[_physXObj, 0, 0, 0] call FUNC(orientObject);

				ropeCreate [_parachute, [0,0,0], _physXObj, [0,0,0], 5];

				SETVAR(_parachute,CGVAR(equipmentLowered),true);

			};

			if (_key == 57 && _isShift && _isControl) then { // Jettison equipment

				_override = true;

				if (_equipmentLowered) then {
					private _loweringLine = (ropes _parachute)#0;
					deleteVehicle _loweringLine;
					hintSilent "Equipment Jettisoned";
				} else {
					detach _physXObj;
					[_physXObj, 0, 0, 0] call FUNC(orientObject);
					hintSilent "";
				};

				_control displayRemoveEventHandler ["keyDown", _thisEventHandler];

			};

			_override;
		}
	];

	waitUntil {sleep 1; isNull _parachute};

	if (isPlayer _jumper && _playerEquipmentRetrieval == 1) then {
			[_jumper, _physXObj, objectParent _backpack, _nvgClass] call FUNC(landSimulated)
		} else {
			[_jumper, _physXObj, objectParent _backpack, _nvgClass] call FUNC(landSimple)
	};
} else {

	if (_injuredJumperChemlights == 1) then {
		waitUntil {sleep 1; isNull _parachute};
		_jumper call FUNC(chemlightJumper)
	};

}