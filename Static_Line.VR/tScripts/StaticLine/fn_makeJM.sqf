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

_unit addAction [
	colorHexCiv + iconPerformance + "</t> " + "Check Jump Conditions",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		SETVAR(_caller,CGVAR(performance),true);

		onEachFrame {
			private _planeClassName = typeOf vehicle player;
			private _planeDisplayName = getText (configFile >> "CfgVehicles" >> _planeClassName >> "displayName");
			private _speed = round(speed vehicle player);
			private _height = round((getPos vehicle player)#2);
			private _pitchBank = vehicle player call BIS_fnc_getPitchBank;
			private _windStrength =  round(19.4 *sqrt(wind#0^2 + wind#1^2))/10;

			private _speedColor = if (
				_speed >= 150 && _speed <= 300
			) then { //Need to adjust numbers based on aircraft
				"<t color='#9900ff00'>"
			} else {
				"<t color='#99ff0000'>"
			};

			private _heightColor = if (
				_height >= 180 && _height <= 350
			) then {
				"<t color='#9900ff00'>"
			} else {
				"<t color='#99ff0000'>"
			};

			private _pitchColor = if (
				abs(_pitchBank#0) <= 4
			) then {
				"<t color='#9900ff00'>"
			} else {
				"<t color='#99ff0000'>"
			};

			private _pitchDirection = if (round(_pitchBank#0) > 0) then {
				"Up"
			} else {
				if (round(_pitchBank#1) < 0) then {
					"Down"
				} else {
					""
				}
			};

			private _bankColor = if (
				abs(_pitchBank#1) <= 4
			) then {
				"<t color='#9900ff00'>"
			} else {
				"<t color='#99ff0000'>"
			};

			private _bankDirection = if (round(_pitchBank#1) > 0) then {
				"Right"
			} else {
				if (round(_pitchBank#1) < 0) then {
					"Left"
				} else {
					""
				}
			};

			private _windColor = if (
				_windStrength <= 10
			) then {
				"<t color='#9900ff00'>"
			} else {
				"<t color='#99ff0000'>"
			};

			hintSilent composeText [
				parseText format ["<t size='1.3' color='#660080'>" + iconPerformance + " " + _planeDisplayName + "</t>"],
				lineBreak,
				parseText format["<t align='left'>Speed: %2%1</t>kph", _speed, _speedColor], //Adjust colors based on numbers
				lineBreak,
				parseText format["<t align='left'>Altitude: %2%1</t>m ATL", _height, _heightColor],
				lineBreak,
				parseText format["<t align='left'>Pitch: %2%1</t>° %3", round(_pitchBank#0), _pitchColor, _pitchDirection],
				lineBreak,
				parseText format["<t align='left'>Bank: %2%1</t>° %3", round(abs(_pitchBank#1)), _bankColor, _bankDirection],
				lineBreak,
				parseText format["<t align='left'>Wind: %2%1</t> knots", _windStrength, _windColor]
			];
		};

		_caller addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle", "_turret"];

			if (!(_unit in fullCrew [_vehicle, "cargo", false])) then {
				onEachFrame {};
				hintSilent "";
			}

		}];
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

_unit addAction [
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
