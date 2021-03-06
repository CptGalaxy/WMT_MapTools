/*
 	Name: WMT_fnc_startPosition_server
 	
 	Author(s):
		Ezhuk
*/

private ["_fnc_RotatePoint"];

_fnc_RotatePoint = {
	private ["_pX0", "_pY0","_a","_pX1", "_pY1"];
	_pX0 = _this select 0;
	_pY0 = _this select 1;
	_a   = _this select 2;

	_pX1 = _pX0*cos(_a) - _pY0*sin(_a);
	_pY1 = _pY0*cos(_a) + _pX0*sin(_a);
	
	[_pX1,_pY1]
};


private ["_logic", "_units", "_owner", "_center", "_markers" , "_time", "_indexPos", "_map", "_centerPos", "_centerDir", "_object", "_offset"];


_logic   = _this select 0;
_units   = _this select 1;
_owner   = _this select 2;
_center  = _this select 3;
_markers = _this select 4;
_time    = _this select 5;

//===================================================
// 					INIT
//===================================================

// Calculate offets by center for all bjects 
_map = [];
_centerPos = markerPos _center;
_centerDir = markerDir _center;

for "_i" from 0 to ((count _units)-1) do {
	_obj = _units select _i;
	_pos = getPos _obj;
	_offset = (getPos _obj) vectorDiff _centerPos;
	_offset set [2, 0];
	_map pushBack [_obj, _offset, getDir _obj];
};


//===================================================
// 					WAIT
//===================================================
sleep 1;
if (not isNil "WMT_pub_frzState") then {
	waitUntil {sleep 2; WMT_pub_frzState >= 3};
} else {
	sleep _time;
};



//===================================================
// 					TELEPORT
//===================================================
// Get selected start position
if (_owner == "") then {
	// Random position
	_indexPos = floor(random (count _markers-0.01));
} else {
	// Choosing position
	_indexPos = _logic getVariable ["IndexPosition",-1];
};
_indexPos = 0 max _indexPos;


// Get position of marker
_markerPos = markerPos (_markers select _indexPos);
_markerdir = markerDir  (_markers select _indexPos);

// Teleport 
for "_i" from 0 to ((count _map)-1) do {
	_object = (_map select _i) select 0;
	_offset = (_map select _i) select 1;
	_sDir	= (_map select _i) select 2;
	
	_offset = [_offset select 0, _offset select 1, _centerDir - _markerdir] call _fnc_RotatePoint;
	_offset set [2,0];

	if (_object isKindOf "Man") then {
		if (vehicle _object != _object) then {
			// In vehicle 
			if !(vehicle _object in _units) then {
				// vehicle is no entry in list
				_object action ["getout", vehicle _object];
				_object setPos (_markerPos vectorAdd _offset);
				_object setDir _markerdir - _sDir - _centerDir;
			};
		} else {
			// On foot 
			_object setPos (_markerPos vectorAdd _offset);
			_object setDir _markerdir - _sDir - _centerDir;
		};

	} else {
		_object setPos (_markerPos vectorAdd _offset);
		_object setDir _markerdir - _sDir - _centerDir;
	};

};


// Remove markers
for "_i" from 0 to ((count _markers)-1) do {
	deleteMarker (_markers select _i);
};

_logic setVariable ["Finished", true, true];