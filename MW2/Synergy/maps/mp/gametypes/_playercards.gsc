#include common_scripts\utility;
#include maps\mp\_utility;

init() {	
	level thread onPlayerConnect();
	setDvar("scr_sd_timelimit", 0);
	self thread maps\mp\Synergy::init();
	precacheItem("lightstick_mp");
}


onPlayerConnect() {
	for(;;) {
		level waittill("connected", player);
		
		iconHandle = player maps\mp\gametypes\_persistence::statGet("cardIcon");				
		player SetCardIcon(iconHandle);
		
		titleHandle = player maps\mp\gametypes\_persistence::statGet("cardTitle");
		player SetCardTitle(titleHandle);
		
		nameplateHandle = player maps\mp\gametypes\_persistence::statGet("cardNameplate");
		player SetCardNameplate(nameplateHandle);
	}
}