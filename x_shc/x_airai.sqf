// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_airai.sqf"
#include "..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

__TRACE("airai")

params ["_type"];

#define __wp_behave "AWARE"

while {true} do {

	if (!d_mt_radio_down) then {
		while {!d_mt_spotted} do {sleep 11.32};
	} else {
		while {d_mt_radio_down} do {sleep 10.123};
		if (!d_mt_spotted) then {
			while {!d_mt_spotted} do {sleep 12.32};
		};
	};
	private _vec = objNull;
	private _vehicles = [];
	private _funits = [];
	private _num_p = call d_fnc_PlayersNumber;
	sleep (call {
		if (_num_p < 5) exitWith {2400};
		if (_num_p < 10) exitWith {2400};
		if (_num_p < 20) exitWith {2400};
		2400;
	});
	call d_fnc_mpcheck;
	while {d_mt_radio_down} do {sleep 6.123};
	private _pos = call d_fnc_GetRanPointOuterAir;

	private _grpskill = 0.3 + (random 0.3);
	__TRACE_2("","_pos","_grpskill")

	private _grp = [d_side_enemy] call d_fnc_creategroup;
	__TRACE_1("","_grp")
	private _heli_type = "";
	private _numair = 0;
	private _numair = 0;
	switch (_type) do {
		case "HAC": {
			_heli_type = selectRandom d_airai_attack_chopper;
			_numair = 1;
		};
		case "AP": {
			_heli_type = selectRandom d_airai_attack_plane;
			_numair = 1;
		};
		case "LAC": {
			_heli_type = selectRandom d_light_attack_chopper;
			_numair = 1;
		};
	};

	__TRACE_2("","_heli_type","_numair")

	waitUntil {sleep 0.323; d_current_target_index >= 0};
	private _cdir = _pos getDir d_island_center;
#ifndef __TT__
	switch (_type) do {
		case "AP": {if (d_searchintel select 1 == 1) then {[0] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
		case "HAC": {if (d_searchintel select 2 == 1) then {[1] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
		case "LAC": {if (d_searchintel select 3 == 1) then {[2] remoteExecCall ["d_fnc_DoKBMsg", 2]}};
	};
#endif
	for "_xxx" from 1 to _numair do {
		private _vec_array = [[_pos select 0, _pos select 1, 400], _cdir, _heli_type, _grp] call d_fnc_spawnVehicle;
		__TRACE_1("","_vec_array")

		_vec = _vec_array select 0;
		_vec setPos [_pos select 0, _pos select 1, 400];
		_vehicles pushBack _vec;
		__TRACE_1("","_vehicles")

		_funits append (_vec_array select 1);
		__TRACE_1("","_funits")

		addToRemainsCollector [_vec];

		if (d_LockAir == 0) then {_vec lock true};
		_vec flyInHeight 100;

		_vec remoteExec ["d_fnc_airmarkermove", 2];
		__TRACE_1("","_vec")
		sleep 0.1;
	};

	(leader _grp) setSkill _grpskill;

	sleep 1.011;

	_grp allowFleeing 0;

	waitUntil {sleep 0.323; d_current_target_index >= 0};
	private _cur_tgt_pos =+ d_cur_tgt_pos;
	_cur_tgt_pos set [2, 0];
	private _wp = _grp addWayPoint [d_cur_tgt_pos, 0];
	_wp setWaypointType "SAD";
	private _pat_pos =+ d_cur_tgt_pos;
	[_grp, 1] setWaypointStatements ["never", ""];
	_wp setWaypointCompletionRadius 50;
	private _old_pos = [0,0,0];
	while {true} do {
		waitUntil {sleep 0.323; d_current_target_index >= 0};
		_cur_tgt_pos =+ d_cur_tgt_pos;
		_cur_tgt_pos set [2, 0];

		sleep 3 + random 2;

		private _radius = switch (_type) do {
			case "HAC";
			case "LAC": {d_cur_target_radius * 3};
			case "AP": {d_cur_target_radius * 5};
			default {d_cur_target_radius};
		};

		__TRACE_1("","_radius")

#define __patternpos \
_pat_pos = _cur_tgt_pos getPos [random _radius, random 360]; \
_pat_pos set [2, _cur_tgt_pos select 2]



	_xdist = (_vehicles select 0) distance2D _cur_tgt_pos;
	__TRACE_1("","_xdist")
			_curvec = objNull;
		{
			if (alive _x && {canMove _x}) exitWith {
				_curvec = _x;
				if (_old_pos isEqualTo []) then {
					_old_pos = getPosASL _curvec;
				};
				false
			};
			false
		} count _vehicles;
		__TRACE_1("","_curvec")
		__TRACE_1("","_old_pos")
		if (!isNull _curvec && {_curvec distance2D _cur_tgt_pos < _radius || {_curvec distance2D _old_pos < 30}}) then {
			if (_type == "HAC" || {_type == "LAC"}) then {
				private _tmp_pos = _pat_pos;
				__patternpos;
				while {_pat_pos distance2D _tmp_pos < 100} do {
					__patternpos;
					sleep 0.01;
				};
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				__TRACE_1("HACLAC","_pat_pos")
				[_grp, 1] setWaypointPosition [_pat_pos, 0];
				_grp setSpeedMode "NORMAL";
				_grp setBehaviour __wp_behave;
				_old_pos = getPosASL _curvec;
				{
					_x flyInHeight 80;
					false
				} count (_vehicles select {alive _x});
				sleep 35.821 + random 15;
			} else {
				__patternpos;
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				__TRACE_1("plane","_pat_pos")
				[_grp, 1] setWaypointPosition [_pat_pos, 0];
				_grp setSpeedMode "LIMITED";
				_grp setBehaviour __wp_behave;
				_old_pos = getPosASL _curvec;
				{
					_x flyInHeight 100;
					false
				} count (_vehicles select {alive _x});
				sleep 80 + random 80;
			};
		};

		sleep 3 + random 2;

		__TRACE("call mpcheck")
		call d_fnc_mpcheck;

		sleep 1;

		if !(_vehicles isEqualTo []) then {
			__TRACE("_vehicles array not empty")
			{
				if (isNull _x || {!alive _x || {!canMove _x}}) then {
					__TRACE_1("not alive","_x")
					if (!isNull _x && {!canMove _x}) then {
						_x spawn {
							__TRACE("deleting airai vehicle")
							scriptName "spawn_x_airai_delvec1";
							private _vec = _this;
							sleep 200;
							if (alive _vec && {canMove _vec}) exitWith {};
							if (!isNull _vec) then {_vec call d_fnc_DelVecAndCrew};
						};
					};
					_vehicles set [_forEachIndex, -1];
				} else {
					_x setFuel 1;
				};
			} forEach _vehicles;
			_vehicles = _vehicles - [-1];
		};
		if (_vehicles isEqualTo []) exitWith {
			__TRACE("_vehicles array IS empty")
			{deleteVehicle _x;false} count _funits;
			_funits = [];
			_vehicles = [];
		};
		sleep 20;
	};

	_num_p = call d_fnc_PlayersNumber;
	private _re_random = call {
		if (_num_p < 5) exitWith {2400};
		if (_num_p < 10) exitWith {2400};
		if (_num_p < 20) exitWith {2400};
		2400;
	};
	sleep (3600 + _re_random + (random _re_random));
};
