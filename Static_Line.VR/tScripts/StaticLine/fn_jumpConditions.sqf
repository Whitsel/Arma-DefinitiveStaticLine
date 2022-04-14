
/*
 * Author: [7Cav] Whitsel
 * Displays looped hint with aircraft diagnostics including speed, altitude, pitch, bank, and wind speed
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * player call tScripts_fnc_jumpConditions;
 *
 * Public: No
 */

#include "script_component.hpp";

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
