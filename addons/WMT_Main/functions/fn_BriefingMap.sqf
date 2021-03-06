/*
 	Name:  
 		WMT_fnc_BriefingMap
 	
 	Author(s):
		Zealot

 	Description:
		Add map for player in briefing time and remove after start
		Add map while near the player having the map or in vehicle which has gps or map in crew inv.

	Parameters:
 		Nothing
 	
 	Returns:
		Nothing 
*/

wmt_mapadded = false;

[] spawn {
	waituntil {not isNull player};	
	while {time < 0.1} do {
		uisleep 0.7;
		if (!("ItemMap" in assignedItems player) && (!wmt_mapadded)) then {
			wmt_mapadded = true;
			player linkItem "ItemMap";
		};
	};
	if (wmt_mapadded) then {
		player unlinkItem "itemMap";
		wmt_mapadded = false;
	};
};
["itemAdd", ["wmtbriefingmap", {
	if (visibleMap && {!("ItemMap" in assignedItems player)}) then {
		if (vehicle player == player) then {
			_people = nearestObjects [player, ["Man"], 5];
			{
				scopeName "loop1";
				if (side _x == playerSide && {"ItemMap" in assignedItems _x}) then {
					wmt_mapadded = true;
					wmt_mapsource = ["man",_x];
					player linkItem "ItemMap";
					hint format [localize "STR_WMT_MapFromAlly", name _x];
					breakOut "loop1";
				};
			} foreach _people;
		} else {
			_hasgps = getNumber ( configFile >> "CfgVehicles" >> typeOf(vehicle player) >> "enableGPS");
			if (_hasgps > 0) then {
				wmt_mapadded = true; player linkItem "ItemMap"; wmt_mapsource = ["veh",vehicle player];
				hint localize "STR_WMT_MapFromVehicle";
			} else {
				{
					scopeName "loopcrew";
					if ("ItemMap" in assignedItems _x) then {
						wmt_mapadded = true;
						wmt_mapsource = ["veh",vehicle player];
						player linkItem "ItemMap";
						hint localize "STR_WMT_MapFromVehicleCrew";
						breakOut "loopcrew";
					};
				} foreach (crew vehicle player);
			};
		};
	};
	if (!visibleMap && wmt_mapadded) then {
		player unlinkItem "itemMap";
		wmt_mapadded = false;
		hint "";
	};
	if (visibleMap && wmt_mapadded) then {
		_source = missionNamespace getVariable ["wmt_mapsource", ["man", player]];
		if ((_source select 0) == "man") then {
			if ((_source select 1) distance player > 5) then { player unlinkItem "itemMap"; wmt_mapadded = false; hint format [localize "STR_WMT_MapFromAllyEnd", name (_source select 1)]; };
		};
	};
}, 50, "frames", {time > 0.5},{!alive player}]] call BIS_fnc_loop;