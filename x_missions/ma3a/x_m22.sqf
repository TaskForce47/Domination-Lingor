// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m22.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_22" call d_fnc_smmapos; // index: 22,   Convoy Cemarin to Pista, start and end position
d_x_sm_type = "convoy"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_842";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_753";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos select 0, d_x_sm_pos select 1, markerDir "d_sm_22"] spawn d_fnc_sideconvoy;
};
