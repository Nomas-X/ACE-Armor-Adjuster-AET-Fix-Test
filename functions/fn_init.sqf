// Copyright 2022 Sysroot

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

    // http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Override damage handling for ACE Medical for all units on server
if (isServer) then {
	// Call AAA_fnc_initUnit locally to each unit when they init
	["CAManBase", "init", {
		params ["_unit"];
		if (local _unit) then {
			[_unit] call AAA_fnc_initUnit;
		} else {
			[_unit] remoteExecCall ["AAA_fnc_initUnit", _unit];
		};
	}, true, [], true] call CBA_fnc_addClassEventHandler;
};


["CBA_settingsInitialized", {
missionNameSpace setVariable ["AAA_VAR_isCBAsettingsInitialized", true, false];


_simulationType = switch (true) do {
		case (!isMultiplayer): 				{ "Singleplayer" };
		case (is3DENMultiplayer): 			{ "Editor Multiplayer" };
		case (isMultiplayerSolo): 			{ "Local Hosted Solo" };
		case (isDedicated): 				{ "Dedicated Server" };
		case (isServer && hasInterface): 	{ "Local Hosted" };
		case (hasInterface && !isServer ): 	{ "Player Client" };
		case (!hasInterface && !isServer ): { "Headless Client" };
	};

diag_log format ['[CVO](debug)(fn_init) cba_settingsInitialized! -  player: %1 - _simulationType: %2 - didJIP: %3', player , _simulationType, didJIP];
}] call CBA_fnc_addEventHandler;

