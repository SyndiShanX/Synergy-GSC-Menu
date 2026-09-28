#include scripts\core_common\array_shared;
#include scripts\core_common\callbacks_shared;
#include scripts\core_common\clientfield_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\perks;
#include scripts\core_common\system_shared;
#include scripts\killstreaks\killstreaks_shared;

#include scripts\synergy;

#namespace synergy_mp;

autoexec __init__system__() { //89f2df9
	system::register("synergy_mp", &init, undefined, undefined);
	synergy::init();
}

init() { //9284135d
	if(!sessionModeIsWarzoneGame()) {
		callback::on_spawned(&player_connect);
	}
}

player_connect() { //1f26b6eb
	if(self isHost()) {
		self.access = "Host";
	} else {
		self.access = "None";
	}

	if(isBot(self)) {
		return;
	}

	if(self isHost() && (!isDefined(self.initialized) || !self.initialized)) {
		self thread initialize_menu();
	}
}

initial_variables() { //ec264b2e
	self.equip_attachment_in_progress = false;

	// Weapons

	self.syn["mastercraft"] = array();

	self.syn["weapons"]["category"][0] = ["assault_rifles", "sub_machine_guns", "tactical_rifles", "light_machine_guns", "sniper_rifles", "shotguns", "pistols", "launchers", "melee", "equipment", "extras", "specialist", "specialist_equipment"];
	self.syn["weapons"]["category"][1] = ["Assault Rifles", "Sub Machine Guns", "Tactical Rifles", "Light Machine Guns", "Sniper Rifles", "Shotguns", "Pistols", "Launchers", "Melee", "Equipment", "Extras", "Specialist", "Specialist Equipment"];

	self.syn["weapons"]["assault_rifles"][0] =       array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8");
	self.syn["weapons"]["sub_machine_guns"][0] =     array("smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8");
	self.syn["weapons"]["tactical_rifles"][0] =      array("tr_longburst_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8");
	self.syn["weapons"]["light_machine_guns"][0] =   array("lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_stealth_t8");
	self.syn["weapons"]["sniper_rifles"][0] =        array("sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8");
	self.syn["weapons"]["shotguns"][0] =             array("shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8");
	self.syn["weapons"]["pistols"][0] =              array("pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8");
	self.syn["weapons"]["launchers"][0] =            array("launcher_standard_t8", "special_crossbow_t8");
	self.syn["weapons"]["melee"][0] =                array("special_ballisticknife_t8_dw", "special_ballisticknife_t8_dw_dw", "melee_actionfigure_t8", "melee_slaybell_t8", "melee_secretsanta_t8", "melee_coinbag_t8", "melee_demohammer_t8", "melee_club_t8", "melee_cutlass_t8", "melee_zombiearm_t8", "melee_bowie_bloody", "melee_amuletfist_t8", "melee_stopsign_t8");
	self.syn["weapons"]["equipment"][0] =            array("hatchet", "frag_grenade", "eq_molotov", "eq_slow_grenade", "trophy_system", "eq_acid_bomb", "claymore", "eq_molotov", "proximity_grenade");
	self.syn["weapons"]["extras"][0] =               array("gun_ultimate_turret", "ultimate_turret", "molotov_fire", "mini_turret", "concussion_grenade", "ray_gun", "briefcase_bomb_defuse");
	self.syn["weapons"]["specialist"][0] =           array("sig_buckler_dw", "sig_buckler_turret", "hero_pineapplegun", "hero_pineapple_grenade", "hero_flamethrower", "ability_dog", "sig_bow_quickshot", "shock_rifle", "sig_lmg", "eq_gravityslam", "hero_annihilator", "sig_blade");
	self.syn["weapons"]["specialist_equipment"][0] = array("eq_swat_grenade", "eq_cluster_semtex_grenade", "gadget_supplypod", "gadget_radiation_field", "eq_tripwire", "eq_hawk", "eq_seeker_mine", "eq_shroud", "eq_sensor", "eq_grapple", "gadget_spawnbeacon", "eq_smoke", "eq_concertina_wire", "eq_emp_grenade");

	self.syn["weapons"]["assault_rifles"][1] =       array("ICR-7", "Maddox RFB", "KN-57", "Rampart 17", "VAPR-XKG", "Grav", "Swat RFT", "AN-94", "Doublecross", "Peacekeeper");
	self.syn["weapons"]["sub_machine_guns"][1] =     array("MX9", "Spitfire", "Saug 9mm", "GKS", "Cordite", "VMP", "Daemon 3XB", "Switchblade X9", "MicroMG 9mm");
	self.syn["weapons"]["tactical_rifles"][1] =      array("Swordfish", "ABR 223", "Auger DMR", "S6 Stingray", "M16");
	self.syn["weapons"]["light_machine_guns"][1] =   array("Titan", "Hades", "VKM 750", "Tigershark");
	self.syn["weapons"]["sniper_rifles"][1] =        array("SDM", "Paladin HB50", "Koshka", "Outlaw", "Locus", "Vendetta", "Havelina AA50");
	self.syn["weapons"]["shotguns"][1] =             array("SG12", "MOG 12", "Argus", "Rampage");
	self.syn["weapons"]["pistols"][1] =              array("Mozu", "Strife", "RK 7 Garrison", "KAP 45");
	self.syn["weapons"]["launchers"][1] =            array("Hellion Salvo", "Reaver C86");
	self.syn["weapons"]["melee"][1] =                array("Ballistic Knife", "Ballistic Knife (Double)", "Series 6 Outrider", "Slay Bell", "Secret Santa", "Cha-Ching", "Home Wrecker", "Nifo'oti", "Rising Tide", "Backhander", "Bowie Knife", "Eye of Apophis", "Full Stop");
	self.syn["weapons"]["equipment"][1] =            array("Combat Axe", "Frag Grenade", "Molotov", "Concussion", "Trophy System", "Acid Bomb", "Claymore", "Molotov", "Shock Charge");
	self.syn["weapons"]["extras"][1] =               array("Handheld Sentry Gun", "Sentry Gun", "Incendiary Grenade", "Mini Turret", "Concussion Grenade", "Ray Gun", "S&D Bomb");
	self.syn["weapons"]["specialist"][1] =           array("Ballistic Shield", "Ballistic Shield (Fortified)", "War Machine", "War Machine (Short Range)", "Purifier", "K9-Unit", "Sparrow", "Tempest", "Scythe", "Grav Slam", "Annihilator", "Shadow Blade");
	self.syn["weapons"]["specialist_equipment"][1] = array("9-Bang", "Cluster Grenade", "Assault Pack", "Reactor Core", "Mesh Mine", "Hawk", "Seeker", "Radar Shroud", "Sensor Dart", "Grapple Gun", "Tac-Deploy", "Smoke", "Razor Wire", "EMP Disruptor");

	self.syn["weapons"]["hashes"][0] = array("2580570083c8795a", "44214c17f34996ea", "5fd15d3e3a7a9b0c", "1039f66708e1d597", "cef408b2b3e35377", "bc2d17d2f2c857e1", "70f8f3d92031f6f7", "f662b8266f6be66", "6009b31eb328208b", "6cb6925ebe3bc0d6", "dbf4dd6dcf1d24f3", "e436ccb615a2b9c6", "7a398a475f8af4c7", "df1d38574585b35e", "2f42bb0a766b63b4", "a8b38fa134e54223", "62032b32d0d142be", "dd7835133aa2daa1", "af1f9926e48404f7", "5b3e3bae603f9641", "b73b6226aaa80f5", "edc98fe2dc7c7650", "7b2cb0cda291ae11", "9dd5e58c9eb28af6", "66adeb4d1a0422d2", "dd9abb421c753ff2", "497d3824e705398c", "57f46c2caf1de7fc", "8b75a649c0e85983", "369cff6935966a74", "485d0d5e33d6802b", "e840b7b398f4bb83", "e7b5b30f9aa8786c", "59618269d014e1fe", "33d6e545e88450c5", "ef8ae16433fba11c", "5243385728e38aa9", "df9eb7548cc02363", "7a7bda9ab5e9bf35", "b5a57559d3bdc159", "3003d1fc53331a5b", "c2f6b4f6dd8585ac", "9f48082b20588e4e", "3b0e53f588197120", "98a2b56939a972ee", "eab1184700ce0aa6", "85710451c453fe0e", "e8a980198a51e72b", "640df302fef996c9", "7b66427785660bae", "fc1ff1ad76b46da2", "e768b46ba75651ce", "82d4d1d3ec87299", "1a44144ddcdc7a06", "7ffcec935d4bcd61", "3c94920deb0cbd90", "20e5bae184643ee5", "48a954b0cb9f04e2", "2bb2c011d62c43c8", "277fe05e21fe4de4", "640d88fb13e0421e", "dcfdeed7c43f7060", "583dbb8b3c0d3b21", "4e23def16bca8076", "f9110fd100108ab9", "640d88fb13e0421e", "4ccbdb4876f0a027", "36a6454f13b54f18", "575116beccfad85", "a3dd6039fe2f36c6", "71a5a304a66b5bc9", "6e948344fd2eb524", "f847b8511647815a", "f3b55382af4bd7ab", "17deed0ce4d37971", "7d1d8f68d86b15ca", "c6b51d90ec5c7a06", "10285306541d5cc1", "e837931ce185238c", "489c5cedc5a1f9c8", "40380537847df901", "38b6b90f02622b4", "25b9fb682a777869", "cbb2d7f789b561eb", "ebb8d088aa5d2df5", "40ed3db21a4ef343", "28f808c767805112", "5a4ad500dc02f842", "8feadd53dae6b7e4", "efdb7a0ec4d32102", "81e6fe73573d39ea", "86509699f65bd279", "ca4ba36128b6582f", "8f525ab9cc66c061", "1a9c4a9e057c8eea", "3a19c6a9c8caef33", "ce328b70915ff6b9", "c9584349d375280d", "4cb9aca7f51434a4", "a1b346649d376bf3");
	self.syn["weapons"]["hashes"][1] = array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8", "smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8", "tr_longburst_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8", "lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_stealth_t8", "sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8", "shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8", "pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8", "launcher_standard_t8", "special_crossbow_t8", "special_ballisticknife_t8_dw", "special_ballisticknife_t8_dw_dw", "melee_actionfigure_t8", "melee_slaybell_t8", "melee_secretsanta_t8", "melee_coinbag_t8", "melee_demohammer_t8", "melee_club_t8", "melee_cutlass_t8", "melee_zombiearm_t8", "melee_bowie_bloody", "melee_amuletfist_t8", "melee_stopsign_t8", "hatchet", "frag_grenade", "eq_molotov", "eq_slow_grenade", "trophy_system", "eq_acid_bomb", "claymore", "eq_molotov", "proximity_grenade", "gun_ultimate_turret", "ultimate_turret", "molotov_fire", "mini_turret", "concussion_grenade", "ray_gun", "briefcase_bomb_defuse", "sig_buckler_dw", "sig_buckler_turret", "hero_pineapplegun", "hero_pineapple_grenade", "hero_flamethrower", "ability_dog", "sig_bow_quickshot", "shock_rifle", "sig_lmg", "eq_gravityslam", "hero_annihilator", "sig_blade", "eq_swat_grenade", "eq_cluster_semtex_grenade", "gadget_supplypod", "gadget_radiation_field", "eq_tripwire", "eq_hawk", "eq_seeker_mine", "eq_shroud", "eq_sensor", "eq_grapple", "gadget_spawnbeacon", "eq_smoke", "eq_concertina_wire", "eq_emp_grenade");

	// Attachments

	self.syn["attachments"][0] = array("acog", "damage", "damage2", "dualoptic", "dw", "elo", "extbarrel", "extbarrel2", "extclip", "extclip2", "fastreload", "fastreload2", "fmj", "fmj2", "grip", "grip2", "holo", "is", "ir", "mixclip", "mms", "pistolscope", "quickdraw", "quickdraw2", "reflex", "rf", "speedreloader", "stalker", "stalker2", "steadyaim", "steadyaim2", "suppressed", "swayreduc", "uber");
	self.syn["attachments"][1] = array("Acog", "High Caliber", "High Caliber II", "Dual Zoom", "Dual Wield", "Elo", "Long Barrel", "Long Barrel II", "Extended Mags", "Extended Mags II", "Fast Mags", "Fast Mags II", "FMJ", "FMJ II", "Grip", "Grip II", "Holographic", "Iron Sights", "Thermal", "Hybrid Mags", "Threat Detector", "Compact Scope", "Quickdraw", "Quickdraw II", "Reflex", "Rapid Fire", "Speed Loader", "Stock", "Stock II", "Laser Sight", "Laser Sight II", "Suppressor", "Stabilizer", "Operator Mod");
	self.syn["blacklisted_attachments"] = array("none", "null", "clantag", "custom1", "custom2", "killcounter");
	self.syn["optics"] = array("reflex", "elo", "mms", "holo", "acog", "dualoptic", "ir", "is");

	// Killstreaks

	self.syn["killstreaks"][0] = array("dart", "recon_car", "uav", "supply_drop", "counteruav", "planemortar", "ultimate_turret", "remote_missile", "drone_squadron", "overwatch_helicopter", "tank_robot", "straferun", "helicopter_comlink", "swat_team", "ac130");
	self.syn["killstreaks"][1] = array("Dart", "RC-XD", "UAV", "Care Package", "Counter-UAV", "Lightning Strike", "Sentry", "Hellstorm", "Drone Squad", "Sniper's Nest", "Mantis", "Thresher", "Attack Chopper", "Strike Team", "Gunship");

	// Camos

	self.syn["camos"][0] = array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 332, 198, 199, 45, 195, 194, 193, 192);
	self.syn["camos"][1] = array("Hunt", "Grassland", "Overgrowth", "Patrol", "Desert Fox", "Tundra", "Panther", "Coral Panther", "Rend", "Monsoon", "Radar", "Tropic", "Agitator", "Roll", "Roil", "URD", "Urban", "Mangrove", "Bengal", "Platoon", "Clash", "Massacre", "Frost", "Dune", "Red Tiger", "Blue Tiger", "Green Tiger", "Roller Rink", "Fast Times", "Gutter Ball", "Mother of Pearl", "Red Oyster", "Spore", "Purple Hex", "Stealth Hex", "Red Hex Redux", "Penthouse", "Yacht Club", "Emerald UG", "Spectrum", "Infiltrator", "Silverfish", "Gold", "Diamond", "Diamond Alt", "Purple Diamond", "Rainbow Diamond", "Dark Matter", "Dark Matter Orange", "Dark Matter Red", "Dark Matter Red Alt", "Classic Dark Matter");
	self.syn["camos"][2] = array(146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 280, 281, 282, 283, 284, 74, 75, 76, 77, 78, 345, 394);
	self.syn["camos"][3] = array("Voyage of Despair Blue", "Voyage of Despair Red", "Voyage of Despair Green", "Voyage of Despair Yellow", "Voyage of Despair Purple", "IX Blue", "IX Red", "IX Green", "IX Purple", "IX Yellow", "Blood of the Dead Yellow", "Blood of the Dead Red", "Blood of the Dead Purple", "Blood of the Dead Green", "Blood of the Dead Pink", "Classified White", "Classified Black", "Classified Blue", "Classified Green", "Classified Red", "Dead of the Night Green", "Dead of the Night Purple", "Dead of the Night Red", "Dead of the Night Blue", "Dead of the Night Yellow", "Ancient Evil Purple", "Ancient Evil Blue", "Ancient Evil Red", "Ancient Evil Yellow", "Ancient Evil Green", "Alpha Omega", "Tag Der Toten");
	self.syn["camos"][4] = array(129, 119, 346, 80, 86, 120, 117, 46, 81, 83, 79, 51, 314, 347, 355, 354, 348, 135, 387, 136, 121, 352, 349, 315, 49, 50, 122, 123, 317, 350, 351, 82, 316, 134, 353, 48, 84, 47, 88, 137, 118, 249, 124, 58, 59, 60, 61, 167, 184, 185, 91, 92, 131, 132, 133, 138, 89, 94, 95, 286, 287, 357, 391, 392, 393, 288, 289, 290, 295, 296, 297, 298, 53, 54, 55, 56, 306, 307, 305, 308, 172, 187, 188, 189, 191, 228, 310, 311, 312, 313, 68, 69, 70, 359, 360, 361, 385, 293, 170, 200, 300, 301, 302, 303, 363, 364, 365, 366, 168, 381, 382, 383, 384, 171, 181, 182, 126, 127, 389, 390, 166, 208, 209, 210, 211, 63, 64, 65, 66, 71, 72, 173, 201);
	self.syn["camos"][5] = array("115", "Afterglow", "America", "Armor", "Assassin", "Astronomy", "Bacon", "Bejamins", "Blowfish", "Board Shorts", "Burple", "Carbolicious", "Cherry Blossom", "Citrus", "Connected", "Datamine", "Dino Glyphs", "Fear Haze", "Fractal Flames", "Fractalized", "Goosebumps", "Green Gradient", "Jellymaw", "Killabyte", "Kiss of Death", "Lady Luck", "Paradise", "Picnic Royale", "Rocket Box", "Scratch n’ Sniff", "Sea Flake", "Shark Plaque", "Shimmer", "Smoke Blast", "Speedometer", "Splatter", "Stealth Seal", "Street Race", "Treasure", "Trifecta", "Twitch Prime", "Wrapped", "Zombie Mai Tai", "APB Stage 1", "APB Stage 2", "APB Stage 3", "APB Stage 4", "Access Denied Stage 1", "Access Denied Stage 2", "Access Denied Stage 3", "Afterlife Stage 1", "Afterlife Stage 2", "Brains Stage 1", "Brains Stage 2", "Brains Stage 3", "Brains Stage 4", "Celestial Stage 1", "Celestial Stage 2", "Celestial Stage 3", "Cipher Stage 1", "Cipher Stage 2", "Circle Slice Stage 1", "Circle Slice Stage 2", "Circle Slice Stage 3", "Circle Slice Stage 4", "Cyberpunk Stage 1", "Cyberpunk Stage 2", "Cyberpunk Stage 3", "D-Day Stage 1", "D-Day Stage 2", "D-Day Stage 3", "D-Day Stage 4", "Death Reel Stage 1", "Death Reel Stage 2", "Death Reel Stage 3", "Death Reel Stage 4", "Dogfight Stage 1", "Dogfight Stage 2", "Dogfight Stage 3", "Dogfight Stage 4", "Killathon Stage 1", "Killathon Stage 2", "Killathon Stage 3", "Killathon Stage 4", "Killathon Stage 6", "Killathon Stage 7", "Masked Stage 1", "Masked Stage 2", "Masked Stage 3", "Masked Stage 4", "Party Rock Stage 1", "Party Rock Stage 4", "Party Rock Stage 6", "Phased Stage 1", "Phased Stage 2", "Phased Stage 3", "Phased Stage 4", "Plasma Drive Stage 1", "Rampage Stage 4", "Rampage Stage 5", "Roadtrip Stage 1", "Roadtrip Stage 2", "Roadtrip Stage 3", "Roadtrip Stage 4", "Shattered Stage 1", "Shattered Stage 2", "Shattered Stage 3", "Shattered Stage 4", "Skull Cracker Stage 1", "Solar Flare Stage 1", "Solar Flare Stage 2", "Solar Flare Stage 3", "Solar Flare Stage 4", "Soul Eater Stage 1", "Soul Eater Stage 5", "Soul Eater Stage 6", "Spinal Stage 1", "Spinal Stage 2", "Symbiosis Stage 1", "Symbiosis Stage 2", "Take It Personally Stage 1", "Take It Personally Stage 2", "Take It Personally Stage 3", "Take It Personally Stage 4", "Take It Personally Stage 5", "The Strip Stage 1", "The Strip Stage 2", "The Strip Stage 3", "The Strip Stage 4", "The Strip Stage 5", "The Strip Stage 6", "Vanguard Stage 2", "Vanguard Stage 5");
}

initialize_menu() { //15544841
	level endon("game_ended");
	self endon("disconnect");

	while(!self.initialized) {
		if(self isHost()) {
			self initial_variables();
			self.initialized = true;

			level flag::wait_till("all_players_connected");

			if(!self.menu_initialized) {
				self notify("init_menu");
			}

			self.synergy_enabled = true;

			self thread menu_call();
		}
		wait 0.05;
	}
}

initialize_verified_menu() { //8e2077d4
	level endon("game_ended");
	self endon("disconnect");

	while(!self.initialized) {
		if(self.access != "None") {
			self initial_variables();
			self.initialized = true;

			while(!self.menu_initialized) {
				self notify("init_menu");
				wait 0.05;
			}

			self.synergy_enabled = true;

			self thread menu_call();
		}
		wait 0.05;
	}
}

menu_call() { //e63cb8af
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		self waittill("menu_option");
		self menu_option();
		wait 0.1;
	}
}

// Misc Functions

load_weapons(weapon_category) { //adb7e2c7
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		if(self.syn["weapons"][weapon_category][0][i] != "equipment" && self.syn["weapons"][weapon_category][0][i] != "extras" && self.syn["weapons"][weapon_category][0][i] != "specialist" && self.syn["weapons"][weapon_category][0][i] != "specialist_equipment") {
			self synergy::add_option(self.syn["weapons"][weapon_category][1][i], undefined, &give_weapon, self.syn["weapons"][weapon_category][0][i]);
		} else {
			self synergy::add_option(self.syn["weapons"][weapon_category][1][i], undefined, &give_grenade, self.syn["weapons"][weapon_category][0][i]);
		}
	}
}

// Menu Options

menu_option() { //bf384607
	self.structure = array();
	menu = self.current_menu;
	switch(menu) {
		case "Synergy":
			self synergy::set_title(menu);

			self synergy::add_option("Basic Options", undefined, &synergy::new_menu, "Basic Options");
			self synergy::add_option("Fun Options", undefined, &synergy::new_menu, "Fun Options");
			self synergy::add_option("Weapon Options", undefined, &synergy::new_menu, "Weapon Options");
			self synergy::add_option("Give Killstreaks", undefined, &synergy::new_menu, "Give Killstreaks");
			self synergy::add_option("Menu Options", undefined, &synergy::new_menu, "Menu Options");
			self synergy::add_option("All Players", undefined, &synergy::new_menu, "All Players");

			break;
		case "Basic Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("God Mode", "Makes you Invincible", &god_mode, self.god_mode);
			self synergy::add_toggle("Frag No Clip", "Fly through the Map using your ^3Equipment^7 Keybind", &frag_no_clip, self.frag_no_clip);

			self synergy::add_toggle("Infinite Ammo", "Gives you Infinite Ammo, Grenades, Specialist, and Killstreaks", &infinite_ammo, self.infinite_ammo);

			break;
		case "Fun Options":
			self synergy::set_title(menu);

			self synergy::add_increment("Set Speed", undefined, &set_speed, "set_speed", 1, 1, 15, 1);
			self synergy::add_increment("Set Gravity", undefined, &set_gravity, "set_gravity", 800, 100, 800, 100);

			self synergy::add_toggle("Third Person", undefined, &third_person, self.third_person);

			break;
		case "Weapon Options":
			self synergy::set_title(menu);

			self synergy::add_option("Give Weapons", undefined, &synergy::new_menu, "Give Weapons");
			self synergy::add_option("Give Mastercrafts", undefined, &synergy::new_menu, "Give Mastercrafts");

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				self synergy::add_option("Equip Attachment", undefined, &synergy::new_menu, "Equip Attachment");
			}
			self synergy::add_option("Equip Camo", undefined, &synergy::new_menu, "Equip Camo");

			self synergy::add_option("Take Current Weapon", undefined, &take_weapon);
			self synergy::add_option("Drop Current Weapon", undefined, &drop_weapon);

			break;
		case "Give Killstreaks":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["killstreaks"][0].size; i++) {
				self synergy::add_option(self.syn["killstreaks"][1][i], undefined, &give_killstreak, self.syn["killstreaks"][0][i]);
			}

			break;
		case "Menu Options":
			self synergy::set_title(menu);

			self synergy::add_increment("Move Menu X", "Move the Menu around Horizontally", &synergy::modify_menu_position, "move_menu_x", 0, -1200, 1200, 50, "x");
			self synergy::add_increment("Move Menu Y", "Move the Menu around Vertically", &synergy::modify_menu_position, "move_menu_y", 0, -250, 250, 25, "y");

			self synergy::add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", &synergy::set_menu_rainbow);

			self synergy::add_increment("Red", "Set the Red Value for the Menu Outline Color", &synergy::set_menu_colors, "set_red", 255, 1, 255, 1, "Red");
			self synergy::add_increment("Green", "Set the Green Value for the Menu Outline Color", &synergy::set_menu_colors, "set_green", 255, 1, 255, 1, "Green");
			self synergy::add_increment("Blue", "Set the Blue Value for the Menu Outline Color", &synergy::set_menu_colors, "set_blue", 255, 1, 255, 1, "Blue");

			self synergy::add_toggle("Hide UI", undefined, &synergy::hide_ui, self.hide_ui);

			break;
		case "All Players":
			self synergy::set_title(menu);

			foreach(player in level.players){
				self synergy::add_option(player.name, undefined, &synergy::new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self synergy::set_title(menu);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self synergy::add_option("Print", "Print Player Name", &print_name, target);

				if(!target isHost() && target.access == "None") {
					self synergy::add_option("Verify", "Give the Player Mod Menu Access", &verify_player, target);
				}
			} else {
				self synergy::add_option("Player not found");
			}

			break;
		case "Equip Attachment":
			self synergy::set_title(menu);

			self.equip_attachment_in_progress = true;

			self.syn["attachment_toggles"] = [];

			while(self getCurrentWeapon() == getWeapon(#"none")) {
				wait 0.05;
			}

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				for(i = 0; i < weapon_attachments.size; i++) {
					self.syn["attachment_toggles"][i] = weaponHasAttachment(self getCurrentWeapon(), weapon_attachments[i]);
					self synergy::add_toggle(get_attachment_name(weapon_attachments[i]), undefined, &equip_attachment, self.syn["attachment_toggles"][i], weapon_attachments[i], i);
				}
			}

			self.equip_attachment_in_progress = false;

			break;
		case "Equip Camo":
			self synergy::set_title(menu);

			self synergy::add_option("Default Camos", undefined, &synergy::new_menu, "Default Camos");
			self synergy::add_option("Pack-a-Punch Camos", undefined, &synergy::new_menu, "Pack-a-Punch Camos");
			self synergy::add_option("Black Market Camos", undefined, &synergy::new_menu, "Black Market Camos");

			break;
		case "Default Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][0].size; i++) {
				self synergy::add_option(self.syn["camos"][1][i], "" + self.syn["camos"][0][i], &equip_camo, self.syn["camos"][0][i]);
			}

			break;
		case "Pack-a-Punch Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][2].size; i++) {
				self synergy::add_option(self.syn["camos"][3][i], "" + self.syn["camos"][2][i], &equip_camo, self.syn["camos"][2][i]);
			}

			break;
		case "Black Market Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][4].size; i++) {
				self synergy::add_option(self.syn["camos"][5][i], "" + self.syn["camos"][4][i], &equip_camo, self.syn["camos"][4][i]);
			}

			break;
		case "Give Mastercrafts":
			self synergy::set_title(menu);

			self synergy::add_array("ICR-7 Variant", undefined, &give_mastercraft_weapon, "icr_mastercrafts", array("Blinding Glory", "Summon", "Gearhead"), undefined, "ar_accurate_t8");
			self synergy::add_array("Maddox RFB Variant", undefined, &give_mastercraft_weapon, "maddox_mastercrafts", array("Carbon Cobra", "$treet"), undefined, "ar_fastfire_t8");
			self synergy::add_array("KN-57 Variant", undefined, &give_mastercraft_weapon, "kn_mastercrafts", array("MkII", "Kuromaku", "Fabergé K"), undefined, "ar_modular_t8");
			self synergy::add_array("Rampart 17 Variant", undefined, &give_mastercraft_weapon, "rampart_mastercrafts", array("MkII", "Afterburner"), undefined, "ar_damage_t8");
			self synergy::add_option("VAPR-XKG - Vampire Hunter", undefined, &give_mastercraft_weapon, undefined, 2, "ar_stealth_t8");
			self synergy::add_array("Swat RFT Variant", undefined, &give_mastercraft_weapon, "swat_mastercrafts", array("MkII", "Temple of Boom"), undefined, "ar_standard_t8");
			self synergy::add_option("Peacekeeper - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "ar_peacekeeper_t8");

			self synergy::add_array("MX9 Variant", undefined, &give_mastercraft_weapon, "mx_mastercrafts", array("MkII Patriot", "Soldier of Fortune"), undefined, "smg_standard_t8");
			self synergy::add_array("Spitfire Variant", undefined, &give_mastercraft_weapon, "spitfire_mastercrafts", array("Deep Voyage", "MkII"), undefined, "smg_fastfire_t8", 1);
			self synergy::add_array("Saug 9mm Variant", undefined, &give_mastercraft_weapon, "saug_mastercrafts", array("Great Lion", "MkII"), undefined, "smg_handling_t8", 1);
			self synergy::add_array("GKS Variant", undefined, &give_mastercraft_weapon, "gks_mastercrafts", array("MkII - Damascus", "Tactical Unicorn", "Black Plague"), undefined, "smg_accurate_t8");
			self synergy::add_array("Cordite Variant", undefined, &give_mastercraft_weapon, "cordite_mastercrafts", array("Zero G", "MkII"), undefined, "smg_capacity_t8", 1);
			self synergy::add_array("Daemon 3XB Variant", undefined, &give_mastercraft_weapon, "daemon_mastercrafts", array("MkII", "Imaginator"), undefined, "smg_fastburst_t8");
			self synergy::add_option("Switchblade X9 - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "smg_folding_t8");

			self synergy::add_array("Swordfish Variant", undefined, &give_mastercraft_weapon, "swordfish_mastercrafts", array("Ahab's Revenge", "MkII"), undefined, "tr_longburst_t8", 1);
			self synergy::add_array("ABR 223 Variant", undefined, &give_mastercraft_weapon, "abr_mastercrafts", array("Fighter Ace", "MkII"), undefined, "tr_midburst_t8", 1);
			self synergy::add_array("S6 Stingray Variant", undefined, &give_mastercraft_weapon, "stingray_mastercrafts", array("Predator", "MkII"), undefined, "tr_flechette_t8");

			self synergy::add_array("Titan Variant", undefined, &give_mastercraft_weapon, "titan_mastercrafts", array("MkII - Sandstorm", "Black Knight"), undefined, "lmg_standard_t8");
			self synergy::add_option("Hades - Venom Cocktail", undefined, &give_mastercraft_weapon, undefined, 1, "lmg_spray_t8");
			self synergy::add_array("VKM 750 Variant", undefined, &give_mastercraft_weapon, "vkm_mastercrafts", array("Magic Carpet Ride", "MkII"), undefined, "lmg_heavy_t8", 1);
			self synergy::add_option("Tigershark - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "lmg_stealth_t8");

			self synergy::add_option("SDM - Lost Patrol", undefined, &give_mastercraft_weapon, undefined, 2, "sniper_powersemi_t8");
			self synergy::add_array("Paladin HB50 Variant", undefined, &give_mastercraft_weapon, "paladin_mastercrafts", array("Unknown", "Valkyrie", "MkII"), undefined, "sniper_powerbolt_t8");
			self synergy::add_array("Koshka Variant", undefined, &give_mastercraft_weapon, "koshka_mastercrafts", array("MkII", "Wundergewehr 115"), undefined, "sniper_quickscope_t8");
			self synergy::add_option("Outlaw - High Noon", undefined, &give_mastercraft_weapon, undefined, 2, "sniper_fastrechamber_t8");
			self synergy::add_option("Vendetta - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "sniper_mini14_t8");

			self synergy::add_array("SG12 Variant", undefined, &give_mastercraft_weapon, "sg_mastercrafts", array("MkII - Killcano", "Boombox"), undefined, "shotgun_semiauto_t8");
			self synergy::add_array("MOG 12 Variant", undefined, &give_mastercraft_weapon, "mog_mastercrafts", array("Enforcer", "MkII"), undefined, "shotgun_pump_t8", 1);
			self synergy::add_array("Rampage Variant", undefined, &give_mastercraft_weapon, "rampage_mastercrafts", array("MkII", "Desecrator"), undefined, "shotgun_fullauto_t8");

			self synergy::add_array("Mozu Variant", undefined, &give_mastercraft_weapon, "mozu_mastercrafts", array("Replicant", "MkII"), undefined, "pistol_revolver_t8", 1);
			self synergy::add_array("Strife Variant", undefined, &give_mastercraft_weapon, "strife_mastercrafts", array("MkII - Divinity", "Divine Justice"), undefined, "pistol_standard_t8");
			self synergy::add_option("RK 7 Garrison - Odin's Song", undefined, &give_mastercraft_weapon, undefined, 2, "pistol_burst_t8");
			self synergy::add_array("KAP 45 Variant", undefined, &give_mastercraft_weapon, "kap_mastercrafts", array("MkII", "Game Over"), undefined, "pistol_fullauto_t8");

			break;
		case "Give Weapons":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self synergy::add_option(self.syn["weapons"]["category"][1][i], undefined, &synergy::new_menu, self.syn["weapons"]["category"][1][i]);
			}

			break;
		case "Assault Rifles":
			self synergy::set_title(menu);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self synergy::set_title(menu);

			load_weapons("sub_machine_guns");

			break;
		case "Tactical Rifles":
			self synergy::set_title(menu);

			load_weapons("tactical_rifles");

			break;
		case "Light Machine Guns":
			self synergy::set_title(menu);

			load_weapons("light_machine_guns");

			break;
		case "Sniper Rifles":
			self synergy::set_title(menu);

			load_weapons("sniper_rifles");

			break;
		case "Shotguns":
			self synergy::set_title(menu);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self synergy::set_title(menu);

			load_weapons("pistols");

			break;
		case "Launchers":
			self synergy::set_title(menu);

			load_weapons("launchers");

			break;
		case "Melee":
			self synergy::set_title(menu);

			load_weapons("melee");

			break;
		case "Equipment":
			self synergy::set_title(menu);

			load_weapons("equipment");

			break;
		case "Extras":
			self synergy::set_title(menu);

			load_weapons("extras");

			break;
		case "Specialist":
			self synergy::set_title(menu);

			load_weapons("specialist");

			break;
		case "Specialist Equipment":
			self synergy::set_title(menu);

			load_weapons("specialist_equipment");

			break;
		default:
			if(!isDefined(self.selected_player)) {
				self.selected_player = self;
			}

			self player_option(menu, self.selected_player);

			self synergy::add_option(synergy::empty_option());
			break;
	}
}

// Basic Options

god_mode() { //df7ef5e9
	self.god_mode = !synergy::return_toggle(self.god_mode);
	if(self.god_mode) {
		self iPrintlnBold("God Mode [^2ON^7]");
		self enableInvulnerability();
		god_mode_loop();
	} else {
		self iPrintlnBold("God Mode [^1OFF^7]");
		self notify("stop_god_mode");
		self disableInvulnerability();
	}
}

god_mode_loop() { //da01789c
	self endon("stop_god_mode");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		self enableInvulnerability();
		wait 0.1;
	}
}

frag_no_clip() { //b991b337
	level endon("game_ended");
	self endon("disconnect");

	if(!isDefined(self.frag_no_clip)) {
		self.frag_no_clip = true;
		self iPrintlnBold("Frag No Clip [^2ON^7], Press your ^3Equipment^7 Keybind to Enter and ^3Melee^7 to Exit");
		while (isDefined(self.frag_no_clip)) {
			if(self fragButtonPressed()) {
				if(!isDefined(self.frag_no_clip_loop)) {
					self thread frag_no_clip_loop();
				}
			}
			wait 0.05;
		}
	} else {
		self.frag_no_clip = undefined;
		self iPrintlnBold("Frag No Clip [^1OFF^7]");
	}
}

frag_no_clip_loop() { //ec65b153
	self endon("noclip_end");
	level endon("game_ended");
	self endon("disconnect");

	self disableWeapons();
	self disableOffHandWeapons();
	self.frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.god_mode) || !self.god_mode) {
		self enableInvulnerability();
		self.temp_god_mode = true;
	}

	while (true) {
		vec = anglesToForward(self getPlayerAngles());
		end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);
		if(self attackButtonPressed()) {
			clip.origin = clip.origin + end;
		}
		if(self adsButtonPressed()) {
			clip.origin = clip.origin - end;
		}
		if(self meleeButtonPressed()) {
			break;
		}
		wait 0.05;
	}

	clip delete();
	self enableWeapons();
	self enableOffhandWeapons();

	if(isDefined(self.temp_god_mode)) {
		self disableInvulnerability();
		self.temp_god_mode = undefined;
	}

	self.frag_no_clip_loop = undefined;
}

infinite_ammo() { //8a006f06
	self.infinite_ammo = !synergy::return_toggle(self.infinite_ammo);
	if(self.infinite_ammo) {
		self iPrintlnBold("Infinite Ammo [^2ON^7]");
		self thread infinite_ammo_loop();
	} else {
		self iPrintlnBold("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

infinite_ammo_loop() { //f4d0adea
	self endon("stop_infinite_ammo");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		weapons = self getWeaponsList();
		for(i = 0; i < weapons.size; i++) {
			self giveMaxAmmo(weapons[i]);
		}
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);

		for(i = 0; i < 3; i++) {
			self gadgetPowerSet(i, 100);
		}

		wait 0.05;
	}
}

// Fun Options

set_speed(value) { //8b986195
	if(value == 1) {
		self.movement_speed = undefined;
	}
	self setMoveSpeedScale(value);
}

set_gravity(value) { //e1877c95
	setDvar(#"bg_gravity", value);
}

third_person() { //ed855e11
	self.third_person = !synergy::return_toggle(self.third_person);
	if(self.third_person) {
		self iPrintlnBold("Third Person [^2ON^7]");
		self setClientThirdPerson(1);
	} else {
		self iPrintlnBold("Third Person [^1OFF^7]");
		self setClientThirdPerson(0);
	}
}

// Player Options

player_option(menu, player) { //a3b23e83
	if(!isDefined(menu) || !isDefined(player) || !isPlayer(player)) {
		menu = "Error";
	}

	switch (menu) {
		case "Player Option":
			self synergy::set_title(clean_name(player get_name()));
			break;
		case "Error":
			self synergy::set_title();
			self synergy::add_option("Oops, Something Went Wrong!", "Condition: Undefined");
			break;
		default:
			error = true;
			if(error) {
				self synergy::set_title("Critical Error");
				self synergy::add_option("Oops, Something Went Wrong!", "Condition: Menu Index");
			}
			break;
	}
}

get_name() { //c91549ce
	name = self.name;
	if(name[0] != "[") {
		return name;
	}

	for(a = (name.size - 1); a >= 0; a--) {
		if(name[a] == "]") {
			break;
		}
	}

	return getSubStr(name, (a + 1));
}

clean_name(name) { //675b8c0
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = ["^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "^:"];
	new_string = "";
	for(a = 0; a < name.size; a++) {
		if(a < (name.size - 1)) {
			if(array::contains(illegal, (name[a] + name[(a + 1)]))) {
				a += 2;
				if(a >= name.size) {
					break;
				}
			}
		}

		if(isDefined(name[a]) && a < name.size) {
			new_string += name[a];
		}
	}

	return new_string;
}

print_name(target) { //c4da1a2b
	self iPrintlnBold(target.name);
}

verify_player(target) { //b5373ddb
	target.access = "Verified";
	target thread initialize_verified_menu();
}

// Killstreaks

give_killstreak(streak) { //ec07394f
	self killstreaks::give(streak, 1);
}

// Weapon Options

give_grenade(grenade) { //9270d7fd
	weapon = getWeapon(grenade);
	self giveWeapon(weapon);
	self giveMaxAmmo(weapon);
}

give_weapon(weapon) { //5be7a94b
	weapon = getWeapon(weapon);

	if(!self hasWeapon(weapon)) {
		if(self getWeaponsListPrimaries().size >= 2) {
			self takeWeapon(self getCurrentWeapon());
		}

		self giveWeapon(weapon);
		self switchToWeaponImmediate(weapon);

		wait 0.25;
		self giveStartAmmo(weapon);
	} else {
		self switchToWeaponImmediate(weapon);
	}
}

give_mastercraft_weapon(null, mastercraft_index, weapon, offset) { //72d8cec0
	current_weapon = self getCurrentWeapon();
	if(getWeapon(weapon).rootWeapon.name == current_weapon.rootWeapon.name) {
		weapon = current_weapon;
	} else {
		weapon = getWeapon(weapon);
	}

	if(!isDefined(mastercraft_index)) {
		synergy::scroll_slider();
		mastercraft_index = int(self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))] + 1);
	}

	if(isDefined(offset) && isInt(offset)) {
		mastercraft_index = int(mastercraft_index) + offset;
	}

	self.syn["mastercraft"][weapon.rootWeapon.name] = mastercraft_index;

	weapon_options = self calcWeaponOptions(0, 0, mastercraft_index);

	if(self getWeaponsListPrimaries().size >= 2) {
		self takeWeapon(self getCurrentWeapon());
	}

	self giveWeapon(weapon, weapon_options);

	wait 0.25;
	self giveStartAmmo(weapon);
}

get_weapon_attachments() { //de099fee
	weapon = self getCurrentWeapon();

	if(weapon == getWeapon(#"none")) {
		return;
	}

	supported_attachments = weapon.supportedAttachments;

	foreach(blacklisted_attachment in self.syn["blacklisted_attachments"]) {
		if(isInArray(supported_attachments, blacklisted_attachment)) {
			supported_attachments = synergy::remove_from_array(supported_attachments, blacklisted_attachment);
		}
	}

	return supported_attachments;
}

function get_attachment_name(attachment) { //44ecc3e9
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
	return attachment;
}

get_equipped_attachments(weapon) { //b04978d6
	attachments = array();
	equipped = strTok(getWeaponName(weapon), "+");

	for (i = 1; i < equipped.size; i++) {
		attachments[attachments.size] = equipped[i];
	}

	return attachments;
}

equip_attachment(attachment, i) { //224c09c9
	weapon = self getCurrentWeapon();

	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);
	attachments = get_equipped_attachments(weapon);

	if(isArray(attachments)) {
		if(isInArray(attachments, attachment)) {
			attachments = synergy::remove_from_array(attachments, attachment);
		} else {
			if(isInArray(self.syn["optics"], attachment)) {
				foreach(optic in self.syn["optics"]) {
					if(isInArray(attachments, optic)) {
						attachments = synergy::remove_from_array(attachments, optic);
					}
				}
			}

			attachments[attachments.size] = attachment;
		}
		weapon = getWeapon(weapon.rootWeapon.name, attachments);
	}

	camo_index = get_camo_index(self getCurrentWeapon());
	if(!isDefined(camo_index) || !isInt(camo_index)) {
		camo_index = 0;
	}

	mastercraft_index = 0;
	if(isDefined(self.syn["mastercraft"][weapon.rootWeapon.name])) {
		mastercraft_index = self.syn["mastercraft"][weapon.rootWeapon.name];
	}

	self.previous_weapon = self getCurrentWeapon();
	self takeWeapon(self getCurrentWeapon());

	weapon_options = self calcWeaponOptions(camo_index, 0, mastercraft_index);

	self giveWeapon(weapon, weapon_options);

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
	self setSpawnWeapon(weapon, true);
}

equip_camo(camo_index) { //52f76807
	weapon = self getCurrentWeapon();
	self setCamo(weapon, camo_index);
}

get_camo_index(weapon) { //bb7c0ede
	if(isDefined(weapon) && weapon != level.weaponNone) {
		weapon_options = self getWeaponOptions(weapon);
		camo_index = getCamoIndex(weapon_options);
		return camo_index;
	} else {
		return undefined;
	}
}

take_weapon() { //5e8f396d
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

drop_weapon() { //84172a80
	self dropItem(self getCurrentWeapon());
}
