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

SETVAR(_unit, CGVAR(isJumpmaster), true);

_unit addAction
[
	colorHexUnknown + iconEdenSortDown + "</t>" + "Get Ready",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"true"
];

_unit addAction //Need to make hold action
[
	"  " + colorHexGuer + iconLight + "</t> " + "Green Light",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"true"
];

_unit addAction
[
	"  " + colorHexEast + iconLight + "</t> " + "Red Light",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"true"
];

_unit addAction
[
	colorHexCiv + iconPerformance + "</t> " + "Check Jump Conditions",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
	},
	nil,
	1.5,
	false,
	true,
	"",
	"true"
];

true;
