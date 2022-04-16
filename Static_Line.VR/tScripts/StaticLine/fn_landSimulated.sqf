

/*
 * Author: [7Cav] Whitsel
 * Handles equipment on landing for bag orientation, physXObject deletion, and chemlight deployment for players
 *
 * Arguments:
 * 0: jumper <OBJECT>
 * 1: physXObj <OBJECT>
 * 2: backpack <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_jumper, _physXObj, _backpackHolder] call tScripts_fnc_landSimple;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_jumper", "_physXObj", "_backpack"];

sleep 0.5;

[_physXObj, 0, 0, 0] call FUNC(orientObject);

sleep 0.5;

detach objectParent _backpack;

deleteVehicle _physXObj;

private _loweredEquipmentChemlights = getNumber (missionConfigFile >> "CfgStaticLine" >> "enableLoweredEquipmentChemlights");
private _injuredJumperChemlights = getNumber (missionConfigFile >> "CfgStaticLine" >> "enableInjuredChemlights");

if (_loweredEquipmentChemlights == 1) then {_backpack call FUNC(chemlightEquipment)};
if (_injuredJumperChemlights == 1) then {_jumper call FUNC(chemlightJumper)};
