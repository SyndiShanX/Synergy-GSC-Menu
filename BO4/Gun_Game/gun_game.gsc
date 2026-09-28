#include scripts\core_common\aat_shared;
#include scripts\core_common\array_shared;
#include scripts\core_common\callbacks_shared.gsc;
#include scripts\core_common\flag_shared;
#include scripts\core_common\spawner_shared;
#include scripts\core_common\system_shared.gsc;
#include scripts\core_common\ai\zombie_utility;
#include scripts\zm_common\zm_pack_a_punch_util;
#include scripts\zm_common\zm_score;
#include scripts\zm_common\zm_weapons;

#include scripts\synergy;

#namespace gun_game;

autoexec __init__system__() { //89f2df9
	system::register(#"gun_game", &init, undefined, undefined);
	synergy::init();
}

init() {
	callback::on_spawned(&player_connect);
}

initial_variables() { //ec264b2e
	self.in_menu = false;
	self.gun_game_initialized = false;

	self.equip_attachment_in_progress = false;

	self.map_name = get_map_name();

	self.controls_menu_open = false;
	self.gun_game_started = false;
	self.pack_weapons = false;
	self.pack_tier = 0;

	self.point_increment = 250;
	self.kill_increment = 5;

	self.progression_method = "points";

	// Weapons

	self.syn["weapons"]["names"][0] = array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_mg1909_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8", "smg_drum_pistol_t8", "smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_mp40_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8", "smg_thompson_t8", "tr_longburst_t8", "tr_leveraction_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8", "lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_double_t8", "lmg_stealth_t8", "sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8", "shotgun_trenchgun_t8", "shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8", "pistol_topbreak_t8", "pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8", "launcher_standard_t8", "special_crossbow_t8", "special_ballisticknife_t8_dw", "minigun", "ray_gun", "ray_gun_mk2", "ww_freezegun_t8", "ww_tricannon_t8", "ww_tricannon_earth_t8", "ww_tricannon_fire_t8", "ww_tricannon_water_t8", "ww_tricannon_air_t8", "ww_crossbow_t8", "ww_blundergat_t8", "ww_blundergat_fire_t8", "ww_blundergat_acid_t8", "ww_blundergat_fire_t8_unfinished", "ww_crossbow_impaler_t8", "ww_random_ray_gun1", "ww_random_ray_gun2", "ww_random_ray_gun3", "ww_hand_o", "ww_hand_h", "ww_hand_g", "ww_hand_c", "ray_gun_mk2v", "ray_gun_mk2x", "ray_gun_mk2y", "ray_gun_mk2z", "thundergun", "tundragun", "ww_tesla_gun_t8", "ww_tesla_sniper_t8", "ar_accurate_t8_upgraded", "ar_fastfire_t8_upgraded", "ar_modular_t8_upgraded", "ar_mg1909_t8_upgraded", "ar_damage_t8_upgraded", "ar_stealth_t8_upgraded", "ar_galil_t8_upgraded", "ar_standard_t8_upgraded", "ar_an94_t8_upgraded", "ar_doublebarrel_t8_upgraded", "ar_peacekeeper_t8_upgraded", "smg_drum_pistol_t8_upgraded", "smg_standard_t8_upgraded", "smg_fastfire_t8_upgraded", "smg_handling_t8_upgraded", "smg_accurate_t8_upgraded", "smg_capacity_t8_upgraded", "smg_mp40_t8_upgraded", "smg_vmp_t8_upgraded", "smg_fastburst_t8_upgraded", "smg_folding_t8_upgraded", "smg_minigun_t8_upgraded", "tr_longburst_t8_upgraded", "tr_leveraction_t8_upgraded", "tr_midburst_t8_upgraded", "tr_powersemi_t8_upgraded", "tr_flechette_t8_upgraded", "tr_damageburst_t8_upgraded", "lmg_standard_t8_upgraded", "lmg_spray_t8_upgraded", "lmg_heavy_t8_upgraded", "lmg_double_t8_upgraded", "lmg_stealth_t8_upgraded", "sniper_powersemi_t8_upgraded", "sniper_powerbolt_t8_upgraded", "sniper_quickscope_t8_upgraded", "sniper_fastrechamber_t8_upgraded", "sniper_locus_t8_upgraded", "sniper_mini14_t8_upgraded", "sniper_damagesemi_t8_upgraded", "shotgun_trenchgun_t8_upgraded", "shotgun_semiauto_t8_upgraded", "shotgun_pump_t8_upgraded", "shotgun_precision_t8_upgraded", "shotgun_fullauto_t8_upgraded", "pistol_topbreak_t8_upgraded", "pistol_revolver_t8_upgraded", "pistol_standard_t8_upgraded", "pistol_burst_t8_upgraded", "pistol_fullauto_t8_upgraded", "launcher_standard_t8_upgraded", "special_crossbow_t8_upgraded", "special_ballisticknife_t8_dw_upgraded", "ww_tricannon_t8_upgraded", "ww_tricannon_earth_t8_upgraded", "ww_tricannon_fire_t8_upgraded", "ww_tricannon_water_t8_upgraded", "ww_tricannon_air_t8_upgraded", "ray_gun_upgraded", "ray_gun_mk2_upgraded", "ww_freezegun_t8_upgraded", "thundergun_upgraded", "tundragun_upgraded", "ww_tesla_gun_t8_upgraded", "ww_tesla_sniper_upgraded_t8", "ww_blundergat_t8_upgraded", "ww_blundergat_fire_t8_upgraded", "ww_blundergat_acid_t8_upgraded", "ww_crossbow_t8_upgraded", "ww_hand_o_upgraded", "ww_hand_h_upgraded", "ww_hand_g_upgraded", "ww_hand_c_upgraded", "ray_gun_mk2v_upgraded", "ray_gun_mk2x_dw", "ray_gun_mk2y_upgraded", "ray_gun_mk2z_upgraded");
	self.syn["weapons"]["names"][1] = array("ICR-7", "Maddox RFB", "KN-57", "Hitchcock M9", "Rampart 17", "VAPR-XKG", "Grav", "Swat RFT", "AN-94", "Doublecross", "Peacekeeper", "Escargot", "MX9", "Spitfire", "Saug 9mm", "GKS", "Cordite", "MP-40", "VMP", "Daemon 3XB", "Switchblade X9", "MicroMG 9mm", "M1927", "Swordfish", "Essex Model 07", "ABR 223", "Auger DMR", "S6 Stingray", "M16", "Titan", "Hades", "VKM 750", "Zweihänder", "Tigershark", "SDM", "Paladin HB50", "Koshka", "Outlaw", "Locus", "Vendetta", "Havelina AA50", "M1897 Trebuchet", "SG12", "MOG 12", "Argus", "Rampage", "Welling", "Mozu", "Strife", "RK 7 Garrison", "KAP 45", "Hellion Salvo", "Reaver C86", "Ballistic Knife", "Death Machine", "Ray Gun", "Ray Gun Mark II", "Winter's Howl", "Kraken", "Decayed Kraken", "Plasmatic Kraken", "Purified Kraken", "Radiant Kraken", "Death of Orion", "Blundergat", "Magmagat", "Acidgat", "Tempered Blundergat", "Savage Impaler", "Alistair's Folly", "Chaos Theory", "Alistair's Annihilator", "Redeemed Hand of Ouranous", "Redeemed Hand of Hemera", "Redeemed Hand of Gaia", "Redeemed Hand of Charon", "Ray Gun Mark II-V", "Ray Gun Mark II-X", "Ray Gun Mark II-Y", "Ray Gun Mark II-Z", "Thundergun", "Tundragun", "Wunderwaffe DG-2", "Wunderwaffe DG-Scharfschutze", "ICR-7", "Maddox RFB", "KN-57", "Hitchcock M9", "Rampart 17", "VAPR-XKG", "Grav", "Swat RFT", "AN-94", "Doublecross", "Peacekeeper", "Escargot", "MX9", "Spitfire", "Saug 9mm", "GKS", "Cordite", "MP-40", "VMP", "Daemon 3XB", "Switchblade X9", "MicroMG 9mm", "Swordfish", "Essex Model 07", "ABR 223", "Auger DMR", "S6 Stingray", "M16", "Titan", "Hades", "VKM 750", "Zweihänder", "Tigershark", "SDM", "Paladin HB50", "Koshka", "Outlaw", "Locus", "Vendetta", "Havelina AA50", "M1897 Trebuchet", "SG12", "MOG 12", "Argus", "Rampage", "Welling", "Mozu", "Strife", "RK 7 Garrison", "KAP 45", "Hellion Salvo", "Reaver C86", "Ballistic Knife", "Kraken", "Decayed Kraken", "Plasmatic Kraken", "Purified Kraken", "Radiant Kraken", "Ray Gun", "Ray Gun Mark II", "Winter's Howl", "Thundergun", "Tundragun", "Wunderwaffe DG-2", "Wunderwaffe DG-Scharfschutze", "Blundergat", "Magmagat", "Acidgat", "Death of Orion", "Redeemed Hand of Ouranous", "Redeemed Hand of Hemera", "Redeemed Hand of Gaia", "Redeemed Hand of Charon", "Ray Gun Mark II-V", "Ray Gun Mark II-X", "Ray Gun Mark II-Y", "Ray Gun Mark II-Z");

	self.syn["weapons"]["blacklisted_weapons"] = array("bowie_knife", "stake_knife", "galvaknuckles_t8", "eq_frag_grenade", "eq_acid_bomb", "claymore", "sticky_grenade", "eq_molotov", "eq_wraith_fire", "mini_turret", "proximity_grenade", "homunculus", "homunculus_leprechaun", "cymbal_monkey", "music_box", "eq_nesting_doll_grenade", "eq_nesting_doll_grenade_niko", "eq_nesting_doll_grenade_rich", "eq_nesting_doll_grenade_takeo", "minigun", "zhield_dw", "zhield_frost_dw", "ww_blundergat_fire_t8_unfinished", "ww_crossbow_impaler_t8", "ww_random_ray_gun1", "ww_random_ray_gun2", "ww_random_ray_gun3", "zhield_zpear_dw", "hero_chakram_lv3", "hero_hammer_lv3", "hero_scepter_lv3", "hero_sword_pistol_lv3", "hero_flamethrower_t8_lv3", "hero_minigun_t8_lv3", "hero_katana_t8_lv3", "hero_gravityspikes_t8_lv3");
	self.syn["weapons"]["gun_game"] = array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_mg1909_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8", "smg_drum_pistol_t8", "smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_mp40_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8", "tr_longburst_t8", "tr_leveraction_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8", "lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_double_t8", "lmg_stealth_t8", "sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8", "shotgun_trenchgun_t8", "shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8", "pistol_topbreak_t8", "pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8", "launcher_standard_t8", "special_crossbow_t8", "special_ballisticknife_t8_dw", "minigun");

	if(self.map_name == "blood_of_the_dead" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
		array::add(self.syn["weapons"]["gun_game"], "smg_thompson_t8");
	}

	if(self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
		array::add(self.syn["weapons"]["gun_game"], "ray_gun");
		array::add(self.syn["weapons"]["gun_game"], "ray_gun_mk2");
	}

	if(self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
		array::add(self.syn["weapons"]["gun_game"], "ww_freezegun_t8");
	}

	if(self.map_name == "voyage_of_despair") {
		array::add(self.syn["weapons"]["gun_game"], "ww_tricannon_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_tricannon_earth_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_tricannon_fire_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_tricannon_water_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_tricannon_air_t8");
	}

	if(self.map_name == "ix") {
		array::add(self.syn["weapons"]["gun_game"], "ww_crossbow_t8");
	}

	if(self.map_name == "blood_of_the_dead") {
		array::add(self.syn["weapons"]["gun_game"], "ww_blundergat_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_blundergat_fire_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_blundergat_acid_t8");
	}

	if(self.map_name == "dead_of_the_night") {
		array::add(self.syn["weapons"]["gun_game"], "ww_crossbow_impaler_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_random_ray_gun1");
		array::add(self.syn["weapons"]["gun_game"], "ww_random_ray_gun2");
		array::add(self.syn["weapons"]["gun_game"], "ww_random_ray_gun3");
	}

	if(self.map_name == "ancient_evil") {
		array::add(self.syn["weapons"]["gun_game"], "ww_hand_o");
		array::add(self.syn["weapons"]["gun_game"], "ww_hand_h");
		array::add(self.syn["weapons"]["gun_game"], "ww_hand_g");
		array::add(self.syn["weapons"]["gun_game"], "ww_hand_c");
	}

	if(self.map_name == "alpha_omega") {
		array::add(self.syn["weapons"]["gun_game"], "ray_gun_mk2v");
		array::add(self.syn["weapons"]["gun_game"], "ray_gun_mk2x");
		array::add(self.syn["weapons"]["gun_game"], "ray_gun_mk2y");
		array::add(self.syn["weapons"]["gun_game"], "ray_gun_mk2z");
		array::add(self.syn["weapons"]["gun_game"], "special_ballisticknife_freezing_t8_dw");
	}

	if(self.map_name == "tag_der_toten") {
		array::add(self.syn["weapons"]["gun_game"], "thundergun");
		array::add(self.syn["weapons"]["gun_game"], "tundragun");
		array::add(self.syn["weapons"]["gun_game"], "ww_tesla_gun_t8");
		array::add(self.syn["weapons"]["gun_game"], "ww_tesla_sniper_t8");
	}

	self.syn["weapons"]["gun_game"] = array::randomize(self.syn["weapons"]["gun_game"]);


	// Camos

	self.syn["camos"]["gun_game"] = array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 332, 198, 199, 45, 195, 194, 193, 192, 129, 119, 346, 80, 86, 120, 117, 46, 81, 83, 79, 51, 314, 347, 355, 354, 348, 135, 387, 136, 121, 352, 349, 315, 49, 50, 122, 123, 317, 350, 351, 82, 316, 134, 353, 48, 84, 47, 88, 137, 118, 249, 124, 58, 59, 60, 61, 167, 184, 185, 91, 92, 131, 132, 133, 138, 89, 94, 95, 286, 287, 357, 391, 392, 393, 288, 289, 290, 295, 296, 297, 298, 53, 54, 55, 56, 306, 307, 305, 308, 172, 187, 188, 189, 191, 228, 310, 311, 312, 313, 68, 69, 70, 359, 360, 361, 385, 293, 170, 200, 300, 301, 302, 303, 363, 364, 365, 366, 168, 381, 382, 383, 384, 171, 181, 182, 126, 127, 389, 390, 166, 208, 209, 210, 211, 63, 64, 65, 66, 71, 72, 173, 201);
	self.syn["camos"]["gun_game_packed"] = array(146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 280, 281, 282, 283, 284, 74, 75, 76, 77, 78, 345, 394);

	// Special Check Weapons

	level.ray_gun_2 = zm_weapons::get_base_weapon(getWeapon("ww_random_ray_gun2"));
	level.ray_gun_2_charged = zm_weapons::get_base_weapon(getWeapon("ww_random_ray_gun2_charged"));
	level.ray_gun_3 = zm_weapons::get_base_weapon(getWeapon("ww_random_ray_gun3"));
	level.ray_gun_3_charged = zm_weapons::get_base_weapon(getWeapon("ww_random_ray_gun3_charged"));

	level.death_of_orion = zm_weapons::get_base_weapon(getweapon(#"ww_crossbow_t8"));
  level.death_of_orion_upgraded = zm_weapons::get_base_weapon(getweapon(#"ww_crossbow_t8_upgraded"));
  level.death_of_orion_charged = zm_weapons::get_base_weapon(getweapon(#"ww_crossbow_charged_t8"));
  level.death_of_orion_charged_upgraded = zm_weapons::get_base_weapon(getweapon(#"ww_crossbow_charged_t8_upgraded"));
}

initialize_menu() { //15544841
	level endon("game_ended");
	self endon("disconnect");

	while(!self.gun_game_initialized) {
		if(self.host) {
			self.gun_game_initialized = true;

			level flag::wait_till("initial_blackscreen_passed");

			self.gun_game_enabled = true;

			level flag::clear("spawn_zombies");

			if(!self.menu_initialized) {
				self notify("init_menu");
			}

			self thread menu_call();
			self thread menu_open();

			self.current_menu = "Setup Options";

			wait 8;

			synergy::open_menu();
		}
		wait 0.05;
	}
}

player_connect() { //1f26b6eb
	self.host = self isHost();

	self initial_variables();
	self thread initialize_menu();
}

// Hud Functions

menu_call() { //e63cb8af
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		self waittill("menu_option_gun_game");
		self menu_option();
		wait 0.1;
	}
}

menu_open() { //84f1b42d
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		self waittill("open_gun_game_menu");
		self open_gun_game_menu();
		wait 0.1;
	}
}

open_gun_game_menu() { //5b4045fc
	self.in_menu = true;

	synergy::set_menu_visibility(1);

	self.current_menu = "Gun Game Options";

	self menu_option();
	synergy::scroll_cursor();
	synergy::set_options();
}

// Misc Functions

get_map_name() { //53bbf9d2
	if(level.script == "zm_zodt8") return "voyage_of_despair";
	if(level.script == "zm_towers") return "ix";
	if(level.script == "zm_escape") return "blood_of_the_dead";
	if(level.script == "zm_office") return "classified";
	if(level.script == "zm_mansion") return "dead_of_the_night";
	if(level.script == "zm_red") return "ancient_evil";
	if(level.script == "zm_white") return "alpha_omega";
	if(level.script == "zm_orange") return "tag_der_toten";
}

// Menu Options

menu_option() { //bf384607
	self.structure = array();
	menu = self.current_menu;
	switch(menu) {
		case "Setup Options":
			self synergy::set_title(menu);

				self synergy::add_array("Progression Method", "Progress is made using either Points or Kills", &set_progression_method, "progression_method", array("Points", "Kills"));

				if(self.progression_method == "points") {
					self synergy::add_increment("Set Point Increment", "Progress is made every (x * Tier) Points", &set_point_increment, "point_increment", 250, 150, 1000, 50);
				}

				if(self.progression_method == "kills") {
					self synergy::add_increment("Set Kill Increment", "Progress is made every (x * Tier) Kills", &set_kill_increment, "kill_increment", 5, 2, 100, 1);
				}

				self synergy::add_array("Set Zombie Speed", undefined, &set_zombie_speed, "zombie_speed", array("Walk", "Run", "Sprint", "Super Sprint"));

				self synergy::add_option("Start Gun Game", undefined, &start_game);
				self synergy::add_option("Start Normal Game", undefined, &start_normal_game);

			break;
		case "Gun Game Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("Third Person", undefined, &third_person, self.third_person);

			if(self zm_score::can_player_purchase(1500)) {
				ammo_price_color = "^2";
			} else {
				ammo_price_color = "^1";
			}

			self synergy::add_option("Refill Ammo (" + ammo_price_color + "$1,500 ^7)", undefined, &refill_ammo);

			if(self.pack_tier < 5) {
				if(self zm_score::can_player_purchase(15000)) {
					pack_price_color = "^2";
				} else {
					pack_price_color = "^1";
				}

				if(self.pack_tier >= 1) {
					pack_string = "Re-Pack-a-Punch";
				} else {
					pack_string = "Pack-a-Punch";
				}

				self synergy::add_option(pack_string + " Weapons (" + pack_price_color + "$15,000 ^7)", undefined, &increment_pack_level);
			}

			if(self zm_score::can_player_purchase(5000)) {
				skip_price_color = "^2";
			} else {
				skip_price_color = "^1";
			}

			self synergy::add_option("Skip Weapon (" + skip_price_color + "$5,000 ^7)", undefined, &skip_weapon);

			break;
		default:
			self synergy::add_option(synergy::empty_option());
			break;
	}
}

start_normal_game() { //22fdd3a8
	level flag::set("spawn_zombies");
	synergy::close_menu();

	self.structure = array();
	self.previous = array();
	self.previous_option = undefined;
	self.saved_index = array();
	self.saved_offset = array();
	self.saved_trigger = array();
	self.slider = array();
	self.syn["background"] = spawnStruct();
	self.syn["cursor"] = spawnStruct();
	self.syn["background"].height = 450;
	self.syn["cursor"].y = 430;
	self.syn["cursor"].index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;

	wait 0.05;
	synergy::scroll_cursor();

	self.gun_game_enabled = false;
	self.gun_game_started = false;

	if(self.synergy_enabled) {
		self.current_menu = "Synergy";
	}
}

// Gun Game Functions

start_game() { //ebb653eb
	level flag::set("spawn_zombies");

	synergy::close_menu();

	self.structure = array();
	self.previous = array();
	self.saved_index = array();
	self.saved_offset = array();

	luinotifyevent(#"synergy_element_7", 2, 200002, 1);
	luinotifyevent(#"synergy_element_8", 2, 200002, 1);

	luinotifyevent(#"synergy_extra_text_1", 2, 200002, 1);
	luinotifyevent(#"synergy_extra_text_2", 2, 200002, 1);
	luinotifyevent(#"synergy_extra_text_3", 2, 200002, 1);
	luinotifyevent(#"synergy_extra_text_4", 2, 200002, 1);

	luinotifyevent(#"synergy_extra_text_1", 3, 200008, 1, 3);
	luinotifyevent(#"synergy_extra_text_2", 3, 200008, 1, 3);
	luinotifyevent(#"synergy_extra_text_3", 3, 200008, 1, 3);
	luinotifyevent(#"synergy_extra_text_4", 3, 200008, 1, 3);

	self.extra_text_1_offset = -1;
	self.extra_text_2_offset = -1;
	self.extra_text_3_offset = -1;
	self.extra_text_4_offset = -1;

	self.extra_text_1_previous_offset = 0;
	self.extra_text_2_previous_offset = 0;
	self.extra_text_3_previous_offset = 0;
	self.extra_text_4_previous_offset = 0;

	wait 0.25;

	title = "Controls";
	synergy::set_text("title", title, 0);

	if(title.size <= 7) {
		synergy::set_lui_element_x("title", int((self.x_offset + 189) - title.size));
	} else {
		synergy::set_lui_element_x("title", int((self.x_offset + 189) - int(title.size * 2.5)));
	}

	if(self.synergy_enabled) {
		synergy::set_text("option_1", "Open: ^3[{+switchseat}]", 2);
	} else {
		synergy::set_text("option_1", "Open: ^3[{+speed_throw}] ^7and ^3[{+melee}] ^7or ^3[{+switchseat}]", 2);
	}
	synergy::set_text("option_2", "Scroll: ^3[{+speed_throw}] ^7or ^3[{+attack}]", 2);
	synergy::set_text("option_3", "Select: ^3[{+activate}] ^7Back: ^3[{+melee}]", 2);
	synergy::set_text("option_4", "Sliders: ^3[{+smoke}]^7 ^7or ^3[{+frag}]", 2);
	synergy::set_text("option_5", "", 2);
	synergy::set_text("option_6", "", 2);
	synergy::set_text("option_7", "", 2);

	for(i = 1; i <= 5; i++) {
		luinotifyevent(#"synergy_element_" + string(i), 2, 200002, 1);
		luinotifyevent(#"synergy_toggle_" + string(i), 2, 200002, 0);
	}

	luinotifyevent(#"synergy_title", 2, 200002, 1);
	luinotifyevent(#"synergy_description", 2, 200002, 1);

	for(i = 1; i <= 5; i++) {
		luinotifyevent(#"synergy_option_" + string(i), 2, 200002, 1);
		luinotifyevent(#"synergy_option_" + string(i), 4, 200001, 127, 127, 127);
		synergy::set_lui_element_x("option_" + string(i), int(self.x_offset + 10));
	}

	synergy::set_shader_height("element_1", 156);
	synergy::set_shader_height("element_2", 152);
	synergy::set_shader_height("element_3", 122);

	self.controls_menu_open = true;
	self.gun_game_started = true;

	if(self.point_increment <= 100) {
		self.point_increment = 500;
	}

	if(self.kill_increment <= 1) {
		self.kill_increment = 5;
	}

	self.gun_game_points = 0;
	self.previous_score = int(self.score);
	self.spent_score = 0;

	self.gun_game_kills = 0;
	self.extra_kills = int(self.kills);

	self.previous_remaining_points = 0;
	self.previous_remaining_kills = 0;
	self.previous_index = 0;
	self.previous_weapon_name = "";

	self.current_weapon_index = -1;
	self.updating_weapon = false;

	synergy::set_lui_element_x("extra_text_1", int(self.x_offset + 428));
	synergy::set_text("extra_text_1", "^3Starting in 5...", 5);
	wait 1;
	synergy::set_text("extra_text_1", "^3Starting in 4...", 5);
	wait 1;
	synergy::set_text("extra_text_1", "^3Starting in 3...", 5);
	wait 1;
	synergy::set_text("extra_text_1", "^3Starting in 2...", 5);
	wait 1;
	synergy::set_text("extra_text_1", "^3Starting in 1...", 5);
	wait 1;

	if(self.controls_menu_open) {
		synergy::close_controls_menu();
		synergy::close_menu();
	}

	self track_progress();
}

track_progress() { //20cdaa9f
	self thread update_game_info();
	self update_weapon();
	self thread guarantee_weapon();

	if(self.progression_method == "points") {
		callback::on_ai_damage(&check_weapon);
		self thread increment_points();
		self thread watch_points_spent();
		self thread track_points();
	} else {
		callback::on_ai_killed(&check_weapon);
		self thread increment_kills();
		self thread watch_extra_kills();
		self thread track_kills();
	}
}

check_weapon(params) { //279297cc
	attacker = params.eattacker;
  weapon = params.weapon;

	if(isPlayer(attacker)) {
		damage_weapon = zm_weapons::get_base_weapon(weapon);
		attacker_weapon = zm_weapons::get_base_weapon(attacker.current_weapon);

		if(damage_weapon == attacker_weapon || ((attacker_weapon.name == level.ray_gun_2.name || attacker_weapon.name == level.ray_gun_3.name) && (damage_weapon.name == level.ray_gun_2_charged.name || damage_weapon.name == level.ray_gun_3_charged.name)) || ((attacker_weapon.name == level.death_of_orion.name || attacker_weapon.name == level.death_of_orion_upgraded.name) && (damage_weapon.name == level.death_of_orion_charged.name || damage_weapon.name == level.death_of_orion_charged_upgraded.name)) || (attacker_weapon.name == "25a13b6f6232a985" && (damage_weapon.name == "3de0926b89369160" || damage_weapon.name == "494f5501b3f8e1e9"))) {
			level notify("weapon_check_passed");
		} else {
			level notify("weapon_check_failed");
		}
	}
}

// Point Tracking Functions

increment_points() { //997a26f9
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		level waittill("weapon_check_passed");
		self.gun_game_points += int(self.score - self.previous_score);
	}
}

watch_points_spent() { //4ff72f46
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		if(self.score < self.previous_score) {
			self.spent_score = int(self.previous_score - self.score);
		}
		self.previous_score = self.score;
		wait 0.25;
	}
}

track_points() { //c9f765ff
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		self.target_points = int(self.gun_game_points + (self.point_increment * synergy::set_variable((self.current_weapon_index > 0), (self.current_weapon_index + 1), 1)));

		while(self.gun_game_points < self.target_points) {
			remaining_points = int(self.target_points - self.gun_game_points);

			if(remaining_points != self.previous_remaining_points) {
				synergy::set_text("extra_text_3", "^3Points Remaining: " + int(self.target_points - self.gun_game_points), 5);
				if(remaining_points > 9 && remaining_points <= 99) {
					self.extra_text_3_offset = int(self.x_offset + 397);
				} else if(remaining_points > 99 && remaining_points <= 999) {
					self.extra_text_3_offset = int(self.x_offset + 390);
				} else if(remaining_points > 999 && remaining_points <= 9999) {
					self.extra_text_3_offset = int(self.x_offset + 384);
				} else if(remaining_points > 9999 && remaining_points <= 99999) {
					self.extra_text_3_offset = int(self.x_offset + 377);
				} else if(remaining_points > 99999) {
					self.extra_text_3_offset = int(self.x_offset + 371);
				} else {
					self.extra_text_3_offset = int(self.x_offset + 403);
				}
			}

			if(self.extra_text_3_offset != self.extra_text_3_previous_offset) {
				synergy::set_lui_element_x("extra_text_3", self.extra_text_3_offset);
			}

			self.extra_text_3_previous_offset = self.extra_text_3_offset;
			self.previous_remaining_points = remaining_points;
			wait 0.1;
		}

		self update_weapon();
	}
}

// Kill Tracking Functions

increment_kills() { //24de1ff7
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		level waittill("weapon_check_passed");
		self.gun_game_kills = int(self.kills - self.extra_kills);
	}
}

watch_extra_kills() { //aed168df
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		level waittill("weapon_check_failed");
		self.extra_kills = int(self.kills - self.gun_game_kills);
	}
}

track_kills() { //c56ee18d
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		self.target_kills = int(self.gun_game_kills + (self.kill_increment * synergy::set_variable((self.current_weapon_index > 0), (self.current_weapon_index + 1), 1)));

		while(self.gun_game_kills < self.target_kills) {
			remaining_kills = int(self.target_kills - self.gun_game_kills);

			if(remaining_kills != self.previous_remaining_kills) {
				synergy::set_text("extra_text_3", "^3Kills Remaining: " + int(self.target_kills - self.gun_game_kills), 5);
				if(remaining_kills > 9 && remaining_kills <= 99) {
					self.extra_text_3_offset = int(self.x_offset + 406);
				} else if(remaining_kills > 99 && remaining_kills <= 999) {
					self.extra_text_3_offset = int(self.x_offset + 400);
				} else if(remaining_kills > 999) {
					self.extra_text_3_offset = int(self.x_offset + 393);
				} else {
					self.extra_text_3_offset = int(self.x_offset + 413);
				}
			}

			if(self.extra_text_3_offset != self.extra_text_3_previous_offset) {
				synergy::set_lui_element_x("extra_text_3", self.extra_text_3_offset);
			}

			self.extra_text_3_previous_offset = self.extra_text_3_offset;
			self.previous_remaining_kills = remaining_kills;
			wait 0.1;
		}

		self update_weapon();
	}
}

get_string_width(string) { //739d5750
	letter_index = array(" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
	letter_width = array(5, 15, 14, 13, 17, 12, 12, 17, 14, 10, 9, 14, 13, 18, 14, 15, 14, 15, 14, 14, 14, 14, 15, 24, 15, 14, 13, 10, 13, 12, 10, 12, 12, 10, 15, 13, 5, 6, 12, 5, 17, 14, 12, 12, 12, 10, 12, 9, 13, 12, 19, 11, 12, 11);

	string_width = 0;

	for(i = 1; i < string.size; i++) {
		matched = false;
		for(x = 1; x < letter_index.size; x++) {
			if(string[i] == letter_index[x]) {
				string_width += int(letter_width[x] + 2);
				matched = true;
			}
		}
		if(!matched) {
			string_width += 12;
		}
	}

	return abs(ceil(406 * (string_width - 383) * (string_width - 121) / ((219 - 383) * (219 - 121)) + 347 * (string_width - 219) * (string_width - 121) / ((383 - 219) * (383 - 121)) + 440 * (string_width - 219) * (string_width - 383) / ((121 - 219) * (121 - 383))));
}

update_game_info() { //6a4d1be9
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		total = self.syn["weapons"]["gun_game"].size;
		current_index = self.current_weapon_index;

		if(current_index != self.previous_index) {
			synergy::set_text("extra_text_1", "^3Weapon: " + (current_index + 1) + "/" + (total + 1), 5);
			if(current_index > 9 && current_index <= 99) {
				self.extra_text_1_offset = int(self.x_offset + 423);
			} else if(current_index > 99) {
				self.extra_text_1_offset = int(self.x_offset + 410);
			} else {
				self.extra_text_1_offset = int(self.x_offset + 429);
			}
		}

		if(self.extra_text_1_offset != self.extra_text_1_previous_offset) {
			synergy::set_lui_element_x("extra_text_1", self.extra_text_1_offset);
		}

		self.extra_text_1_previous_offset = self.extra_text_1_offset;
		self.previous_index = current_index;

		if(isDefined(self.current_weapon_string)) {
			for(id = 0; id < self.syn["weapons"]["names"][0].size; id++) {
				if(self.current_weapon_string == self.syn["weapons"]["names"][0][id]) {
					current_weapon_name = self.syn["weapons"]["names"][1][id];
				}
			}

			if(!isDefined(current_weapon_name)) {
				current_weapon_name = self.current_weapon_string;
			}

			weapon_name_width = get_string_width(current_weapon_name);

			if(current_weapon_name != self.previous_weapon_name) {
				synergy::set_text("extra_text_2", "^3" + current_weapon_name, 5);
				synergy::set_lui_element_x("extra_text_2", int(self.x_offset + weapon_name_width));
			}

			self.previous_weapon_name = current_weapon_name;
		}

		synergy::set_shader_height("element_7", 90);
		synergy::set_shader_height("element_8", 86);

		wait 1;
	}
}

// Weapon Functions

refill_ammo() { //3d49c176
	if(self zm_score::can_player_purchase(1500)) {
		weapon = self getCurrentWeapon();
		self setWeaponAmmoClip(weapon, 999);
		self giveMaxAmmo(weapon);
		self.score = int(self.score - 1500);
	}
}

skip_weapon() { //fdd0f5b8
	if(self zm_score::can_player_purchase(5000)) {
		self.target_points = int(self.gun_game_points + (self.point_increment * synergy::set_variable((self.current_weapon_index > 0), (self.current_weapon_index + 1), 1)));
		self.target_kills = int(self.gun_game_kills + (self.kill_increment * synergy::set_variable((self.current_weapon_index > 0), (self.current_weapon_index + 1), 1)));
		update_weapon();
		self.score = int(self.score - 5000);
	}
}

guarantee_weapon() { //8e8cf6d1
	self endon(#"disconnect");
	self endon("gun_game_won");

	for(;;) {
		if(isDefined(self.current_weapon) && !self hasWeapon(self.current_weapon) && !self.updating_weapon) {
			self takeWeapon(self.current_weapon);
			wait 0.1;
			self.current_weapon = self zm_weapons::give_build_kit_weapon(self.current_weapon);
			wait 0.25;
			self switchToWeapon(self.current_weapon);
			self setCamo(self.current_weapon, self.camo);
		}
		wait 0.25;
	}
}

increment_pack_level() { //6b616c01
	if(self.pack_tier < 5) {
		if(self zm_score::can_player_purchase(15000)) {
			self.score = int(self.score - 15000);
			self.pack_weapons = true;
			self.pack_tier++;
			pack_weapons();
			self.camo = self.syn["camos"]["gun_game_packed"][randomIntRange(0, (self.syn["camos"]["gun_game_packed"].size - 1))];
		}
	}
}

pack_weapons() { //dc2d810d
	self.updating_weapon = true;

	if(self.pack_tier >= 1) {
		if(!zm_weapons::is_weapon_upgraded(getWeapon(self.current_weapon_string))) {
			if(self.current_weapon_string == "ray_gun_mk2x") {
				self.current_weapon_string = "ray_gun_mk2x_dw";
			} else if(self.current_weapon_string == "ww_tesla_sniper_t8") {
				self.current_weapon_string = "ww_tesla_sniper_upgraded_t8";
			} else if(!isInArray(self.syn["weapons"]["blacklisted_weapons"], self.current_weapon_string)) {
				self.current_weapon_string = self.current_weapon_string + "_upgraded";
			}
		}
	}


	weapon = getWeapon(self.current_weapon_string);

	if(isDefined(self.current_weapon) && self hasWeapon(self.current_weapon)) {
		self takeWeapon(self.current_weapon);
		wait 0.1;
	}

	weapon = self zm_weapons::give_build_kit_weapon(weapon);

	if(self.pack_tier >= 2 && zm_weapons::is_weapon_upgraded(weapon)) {
		if(!isInArray(self.syn["weapons"]["blacklisted_weapons"], self.current_weapon_string)) {
			if(zm_weapons::weapon_supports_aat(weapon)) {
				self thread aat::acquire(weapon);
				self zm_pap_util::repack_weapon(weapon, self.pack_tier);
			}
		}
	}


	self.current_weapon = weapon;
	wait 1;
	self switchToWeapon(self.current_weapon);
	self.updating_weapon = false;
}

update_weapon() { //1adba75e
	self.updating_weapon = true;
	self.current_weapon_index++;

	if(self.current_weapon_index >= self.syn["weapons"]["gun_game"].size) {
		synergy::set_text("extra_text_1", "^1You Won!", 5);
		self notify("gun_game_won");
		return;
	}

	if(!isDefined(self.syn["weapons"]["gun_game"][self.current_weapon_index])) {
		return;
	}

	if(isDefined(self.current_weapon) && self hasWeapon(self.current_weapon)) {
		self takeWeapon(self.current_weapon);
		wait 0.1;
	}

	new_weapon = getWeapon(self.syn["weapons"]["gun_game"][self.current_weapon_index]);
	self.current_weapon_string = self.syn["weapons"]["gun_game"][self.current_weapon_index];

	if(self hasWeapon(new_weapon)) {
		self switchToWeapon(new_weapon);
	}

	if(self.pack_weapons) {
		pack_weapons();
		self.camo = self.syn["camos"]["gun_game_packed"][randomIntRange(0, (self.syn["camos"]["gun_game_packed"].size - 1))];
	} else {
		new_weapon = self zm_weapons::give_build_kit_weapon(new_weapon);
		wait 0.1;
		self switchToWeapon(new_weapon);
		self giveMaxAmmo(new_weapon);
		self.camo = self.syn["camos"]["gun_game"][randomIntRange(0, (self.syn["camos"]["gun_game"].size - 1))];
		self.current_weapon = new_weapon;
	}
	wait 0.1;

	wait 1;
	self switchToWeapon(self.current_weapon);
	self setCamo(self.current_weapon, self.camo);
	self.updating_weapon = false;
}

// Gun Game Options

third_person() { //ed855e11
	self.third_person = !synergy::return_toggle(self.third_person);
	if(self.third_person) {
		iPrintlnBold("Third Person [^2ON^7]");
		self setClientThirdPerson(1);
	} else {
		iPrintlnBold("Third Person [^1OFF^7]");
		self setClientThirdPerson(0);
	}
}

set_progression_method(method) { //143b1119
	iPrintlnBold("Set Progression Method to " + method);
	self.progression_method = toLower(method);
}

set_point_increment(value) { //c9575d65
	self.point_increment = int(value);
}

set_kill_increment(value) { //81ef3cc7
	self.kill_increment = int(value);
}

get_zombies() { //81b284e5
	return getAITeamArray(level.zombie_team);
}

set_zombie_speed(speed) { //5f4e093d
	speed = toLower(speed);

	if(speed == "super sprint") {
		speed = "super_sprint";
	}

	if(!isDefined(level.run_cycle)) {
		level.run_cycle = "restore";
	}
	if(level.run_cycle != speed) {
		level.run_cycle = speed;
	}

	spawner::remove_global_spawn_function("zombie", &update_zombie_speed);
	if(level.run_cycle != "restore") {
		spawner::add_archetype_spawn_function("zombie", &update_zombie_speed);
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie thread update_zombie_speed();
			}
		}
	} else {
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie zombie_utility::set_zombie_run_cycle_restore_from_override();
			}
		}
	}
}

update_zombie_speed() { //772907d2
	if(level.run_cycle == "super_sprint" && !(isDefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area)) {
		self waittill(#"death", #"completed_emerging_into_playable_area");
	}
	if(level.run_cycle != "restore") {
		self zombie_utility::set_zombie_run_cycle(level.run_cycle);
	}
}