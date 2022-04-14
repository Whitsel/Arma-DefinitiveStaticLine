/*
 * Author: [7Cav] Whitsel
 * Assigs the unit as a jumpmaster and give them actions to control the static line jump
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * True
 *
 * Example:
 * player call tScripts_fnc_makeJM;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_unit"];

SETVAR(_unit,CGVAR(isJumpmaster),true);

_unit addAction [
	colorHexUnknown + iconEdenSortDown + "</t>" + "Get Ready",
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; //Need to add hint to players in cargo

		SETVAR(vehicle _caller,CGVAR(getReady),true);

		_vehicle = vehicle _caller;
		_vehicle animateSource ["jumplight",0]; //Need to check light names for planes
		_vehicle animateDoor ["door_2_1", 1, false]; //Need to check door names for different planes
		_vehicle animateDoor ["door_2_2", 1, false];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"!((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

_unit addAction [ //Need to make hold action
	"  " + colorHexGuer + iconLight + "</t> " + "Green Light",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _vehicle = vehicle _caller;
		_vehicle animateSource ["jumplight",1];

		_passengers = fullCrew [_plane, "cargo", false];

		for "_i" from (count _passengers -1) to 0 step -1 do {
			if (player == (_passengers#_i#0)) then {
				_passengers append [_passengers#_i];
				_passengers deleteAt _i;
			}
		};
	},
	nil,
	1.5,
	false,
	true,
	"",
	"((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

_unit addAction [
	"  " + colorHexEast + iconLight + "</t> " + "Abort Jump",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		SETVAR(vehicle _caller,CGVAR(getReady),false);
		private _vehicle = vehicle _caller;
		_vehicle animateSource ["jumplight",0];
		sleep 1;
		_vehicle animateDoor ["door_2_1", 0, false];
		_vehicle animateDoor ["door_2_2", 0, false];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

_unit addAction [
	"  " + colorHexEast + iconLight + "</t> " + "Red Light",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _vehicle = vehicle _caller;
		_vehicle animateSource ["jumplight",0];
		sleep 3;
		_vehicle animateDoor ["door_2_1", 0, false];
		_vehicle animateDoor ["door_2_2", 0, false];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

_unit addAction [ //Check Conditions
	colorHexCiv + iconPerformance + "</t> " + "Check Jump Conditions",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		SETVAR(_caller,CGVAR(performance),true);

		_caller call FUNC(jumpConditions);

	},
	nil,
	1.5,
	false,
	true,
	"",
	"!(_this getVariable ['tScripts_StaticLine_performance', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

_unit addAction [ //Hide Conditions
	colorHexCiv + iconPerformance + "</t> " + "Hide Jump Conditions",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		SETVAR(_caller,CGVAR(performance),false);

		onEachFrame {};
		hintSilent "";
	},
	nil,
	1.5,
	false,
	true,
	"",
	"(_this getVariable ['tScripts_StaticLine_performance', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

true;
