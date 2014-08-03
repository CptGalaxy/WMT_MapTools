/*
 	Name: WMT_fnc_BriefingMissionParameters
 	
 	Author(s):
		Ezhuk

 	Description:
		Add list of squads and players to briefing 

	Parameters:
 		Nothing
 	Returns:
		Nothing 
*/

#define PR(x) private ['x']; x

PR(_text) = "";

if(!isNil "wmt_param_MaxViewDistance") then {
	_text = _text + format ["%1 <font color='#c7861b'>%2</font><br/>", 
					localize "STR_WMT_ViewDistance", wmt_param_MaxViewDistance];
};

if(!isNil "wmt_param_PrepareTime") then {
	_text = _text + format ["%1: <font color='#c7861b'>%2</font><br/>", 
					localize "STR_WMT_PrepareTime_param", [wmt_param_PrepareTime,"HH:MM:SS"] call BIS_fnc_secondsToString];
};

_text = _text + format ["%1: <font color='#c7861b'>%2:00</font><br/>",
					localize "STR_BR_T_PARAM_START", [dayTime,"HH:MM"] call bis_fnc_TimeToString];

if(!isNil "wmt_param_MissionTime") then {
	_text = _text + format ["%1: <font color='#c7861b'>%2</font><br/>", 
					localize "STR_BR_T_PARAM_DURATION"	, [wmt_param_MissionTime,"HH:MM:SS"] call BIS_fnc_secondsToString];
};

if(!isNil "wmt_param_TI") then {
	switch wmt_param_TI do {
		case 0 : {
			_text = _text + format ["%1: <font color='#c7861b'>%2</font><br/>", 
							localize "STR_WMT_TI", localize "STR_WMT_Enable"];
		};
		case 1 : {
			_text = _text + format ["%1: <font color='#ed2616'>%2</font><br/>", 
							localize "STR_WMT_TI", localize "STR_WMT_TI_DisableInVehicle"];
		};
		case 2 : {
			_text = _text + format ["%1: <font color='#ed2616'>%2</font><br/>", 
							localize "STR_WMT_TI", localize "STR_WMT_Disable"];
		};
	};
};

["diary",localize "STR_WMT_MissionParameters", _text] call WMT_fnc_CreateDiaryRecord;