/*
 * Author: [7Cav] Whitsel
 * Initializes the static line variables. Lets the script know what mods are loaded and how to handle itself. Also sets default values for how the jump should behave
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * true
 *
 * Example:
 * call tScripts_fnc_staticLineInit;
 *
 * Public: Yes?
 */

#include "script_component.hpp";

CGVAR(jumpableAircraft) = [
	"B_T_VTOL_01_infantry_F"
	];

// Builds array of jumpable aircraft based on activated mods
if ("rhsusf_main" in activatedAddons) then {
	CGVAR(jumpableAircraft) append ["RHS_C130J"];
	diag_log "tScripts StaticLine: RHS USAF detected: C130J added to jumpable aircraft";
};
if ("usaf_main" in activatedAddons) then {
	CGVAR(jumpableAircraft) append ["USAF_C130J"];
	CGVAR(jumpableAircraft) append ["USAF_C17"];
	diag_log "tScripts StaticLine: USAF detected: C-130J Super Hercules and C-17 Globemaster III added to jumpable aircraft";
};

// IR Chemlight used if ACE is loaded
if ("ace_main" in activatedAddons) then {
	CGVAR(chemlightClass) = "ACE_Chemlight_IR_dummy";
	diag_log "tScripts StaticLine: ACE detected: Bag chemlights set to IR Chems";
} else {
	CGVAR(chemlightClass) = "chemlight_blue"
};

//Selects the best parachute based on activated mods
if ("rhs_main" in activatedAddons) then {
	CGVAR(parachuteClass) = "rhs_d6_Parachute";
	diag_log "tScripts StaticLine: RHS AFRF: D6 PArachute Bag selected";
} else {
	if ("rhs_main" in activatedAddons) then {
		CGVAR(parachuteClass) = "rhsusf_eject_Parachute";
		diag_log "tScripts StaticLine: RHS USAF detected: Static Parachute Bag selected";
	} else {
		if ("ace_main" in activatedAddons) then {
			CGVAR(parachuteClass) = "NonSteerable_Parachute_F";
			diag_log "tScripts StaticLine: ACE detected: Non Steerable Parachute selected";
		} else {
			CGVAR(parachuteClass) = "Steerable_Parachute_F";
			diag_log "tScripts StaticLine: No parachute mod detected: Steerable Parachute selected";
		}
	};
};
