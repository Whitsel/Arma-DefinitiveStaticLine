
/*
 * Author: [7Cav] Whitsel
 * Assigns the unit as a jumpmaster and gives them actions to control the static line jump
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * player call tScripts_fnc_makeJM;
 *
 * Public: No
 */

#include "script_component.hpp";

params ["_unit"];

SETVAR(_unit,CGVAR(isJumpmaster),true);

_unit addAction [ //Get Ready
	colorHexUnknown + iconEdenSortDown + "</t> " + "Get Ready",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		SETVAR(vehicle _caller,CGVAR(getReadyProgress),true);

		_caller call FUNC(getReady);

	},
	nil,
	2,
	false,
	true,
	"",
	"!((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	!((vehicle _this) getVariable ['tScripts_StaticLine_getReadyProgress', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];

[ //Green Light
	_unit,
	colorHexGuer + iconLight + "</t> " + "Green Light",
	"\a3\ui_f\data\igui\cfg\actions\beacons_on_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
	"((vehicle _this) getVariable ['tScripts_StaticLine_getReady', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	"true",									//Condition to progress
	{										//Code when started
		params ["_target", "_caller", "_actionId", "_arguments"];

		_caller call FUNC(greenLight);

	},
	{},										//Code executed every tick
	{},										//Code executed on completion
	{										//Code executed on interupt
		params ["_target", "_caller", "_actionId", "_arguments"];

		_caller call FUNC(redLight);

	},
	[],										//Arguments passed to the scripts
	count(fullCrew [vehicle _unit, "cargo", false])/1.25,										//Execution time in seconds
	2,									//Priority
	false,									//Remove on completion
	false									//Show when uncon
] call BIS_fnc_holdActionAdd;

_unit addAction [ //Abort Jump
	colorHexEast + iconLight + "</t> " + "Abort Jump",
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
	2,
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
	2,
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
	2,
	false,
	true,
	"",
	"(_this getVariable ['tScripts_StaticLine_performance', false]) &&
	(_this getVariable ['tScripts_StaticLine_isJumpmaster', false])",
	0
];
