
/*
 * Author: [7Cav] Whitsel
 * Handles chem light deployment for injured soldiers
 *
 * Arguments:
 * 0: jumper <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [_jumper] call tScripts_fnc_chemLightJumper;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_jumper"];

if ("ace_main" in activatedAddons) then {
		private _isUnconscious = _jumper getVariable ["ACE_isUnconscious", false];

		if (_isUnconscious) then {
			createVehicle ["chemlight_red", position _jumper, [], 1.5, "CAN_COLLIDE"];
		} else {
			//Need to detect ACE injury
		}
} else {
	private _jumperLifeState = damage _jumper;
	private _injuredThreshold = 0.01;

	switch _jumperLifeState do {
		case "DEAD": {createVehicle ["chemlight_red", position _jumper, [], 1.5, "CAN_COLLIDE"]};
		case "DEAD-RESPAWN": {createVehicle ["chemlight_red", position _jumper, [], 1.5, "CAN_COLLIDE"]};
		case "DEAD-SWITCHING": {createVehicle ["chemlight_red", position _jumper, [], 1.5, "CAN_COLLIDE"]};
		case "INCAPACITATED": {createVehicle ["chemlight_red", position _jumper, [], 1.5, "CAN_COLLIDE"]};
		default {
			if (damage _jumper >= _injuredThreshold) then {
				createVehicle ["chemlight_yellow", position _jumper, [], 1.5, "CAN_COLLIDE"];
			}
		};
	};
};
