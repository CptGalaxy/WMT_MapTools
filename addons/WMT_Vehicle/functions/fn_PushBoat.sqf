/*
 	Name: WMT_fnc_PushBoat
 	
 	Author(s):
		Zealot

 	Description:
		Push boat 

	Parameters:
		Nothing

 	Returns:
		Nothing
*/
private ["_veh", "_spd", "_withcrew", "_dir", "_vel", "_tVel"];

_veh = (nearestObjects [player,["Ship"], 8]) select 0;
_spd = 5;

if (isNil "_veh") exitwith {};

player playActionNow "PutDown";
sleep 0.05;

// Check crew vehicle. Vehicle must be empty.
_withcrew = (count crew _veh != 0);
if (_withcrew) exitwith {titleText [localize("STR_BOAT_ERR"),"PLAIN",1];};

// Push 
_dir = direction player;
[[ [_veh,owner player],{(_this select 0) setOwner (_this select 1);}] ,"bis_fnc_spawn", false] call bis_fnc_mp;
sleep 0.3;
_veh setVelocity [(sin _dir)*_spd, (cos _dir)*_spd, 0]; 

sleep 0.5;

// Slowdown
for "_i" from 0 to 5 do {
	_vel = velocity _veh;
	_veh setvelocity [(_vel select 0)*0.5, (_vel select 1)*0.5, (_vel select 2)*0.5];
	sleep 0.3;
};


