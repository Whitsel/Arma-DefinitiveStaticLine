
/*
 * Author: [7Cav] Whitsel
 * Ititiates green light procedures for jumpmaster aircraft
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * player call tScripts_fnc_greenLight;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_caller"];

private _vehicle = vehicle _caller;
private _passengers = fullCrew [_vehicle, "cargo", false];

SETVAR(_vehicle,CGVAR(jumpInterupt),false);

for "_i" from (count _passengers -1) to 0 step -1 do { // Move JM to rear index
	if (_caller == (_passengers#_i#0)) then {
		_passengers append [_passengers#_i];
		_passengers deleteAt _i;
	}
};

systemChat format ["%1: GO!!! GO!!! GO!!!", (name _caller)];
_vehicle animateSource ["jumplight",1];

sleep 1;

[_vehicle, _passengers] spawn {
	params ["_vehicle", "_passengers"];
	{
		if (GETVAR(_vehicle,CGVAR(jumpInterupt),false)) exitWith{};
		private _jumper = _x#0;
		private _spacing = 50;

		moveOut _jumper;

		_jumper spawn {
			params ["_jumper"];

			private _playerEquipmentLowering = getNumber (missionConfigFile >> "CfgStaticLine" >> "enablePlayerEquipmentLowering");

			if (isPlayer _jumper && _playerEquipmentLowering == 1) then {
				_jumper call FUNC(jumpSimulated);
			} else {
				_jumper call FUNC(jumpSimple);
			};
		};

		sleep (_spacing / (speed _vehicle /3.6));

	} forEach _passengers;
};
