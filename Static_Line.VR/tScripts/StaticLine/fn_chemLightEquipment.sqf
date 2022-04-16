
/*
 * Author: [7Cav] Whitsel
 * Handles chem light deployment for equipment
 *
 * Arguments:
 * 0: backpack <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_jumper, _backpackHolder] call tScripts_fnc_chemLightEquipment;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_backpackHolder"];

private _sunriseSunsetTime = date call BIS_fnc_sunriseSunsetTime;

if (dayTime < _sunriseSunsetTime#0 || dayTime > _sunriseSunsetTime#1) then {
	private _chemlight = createVehicle [CGVAR(chemlightClass), position _backpackHolder, [], 1.5, "CAN_COLLIDE"];
};
