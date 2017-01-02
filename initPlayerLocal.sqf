// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerLocal.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerLocal.sqf"];
__TRACE_1("","_this")
if (hasInterface) then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
};
_null = [] execVM "tf47\VA.sqf";
_null = [] execVM "tf47CoreScripts\infantryInit.sqf";
execVM "tasks.sqf";
diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerLocal.sqf processed"];
