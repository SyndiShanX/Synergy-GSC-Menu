#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init() {
	setDvar("sv_cheats", 1);

	level thread player_connect();
	level thread create_rainbow_color();

	wait 0.5;

	level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	level.callbackPlayerDamage = ::player_damage_callback; // Retropack
}

player_connect() {
	level endon("game_ended");

	for(;;) {
		level waittill("connected", player);

		player.access = player isHost() ? "Host" : "None";

		if(player isHost()) {
			player initial_variables();
			player thread initialize_menu();
		}
	}
}

initial_variables() {
	self.in_menu = false;
	self.hud_created = false;
	self.loaded_offset = false;
	self.option_limit = 7;
	self.current_menu = "Synergy";
	self.structure = [];
	self.previous = [];
	self.saved_index = [];
	self.saved_offset = [];
	self.saved_trigger = [];
	self.slider = [];

	self.font = "default";
	self.font_scale = 0.7;
	self.x_offset = 175;
	self.y_offset = 160;

	self.map_name = get_map_name();
	self.color_theme = "rainbow";
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.cursor_index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.description_height = 0;
	self.previous_option = undefined;

	self.point_increment = 100;
	self.round_increment = 1;
	self.outline_zombies = undefined;
	self.equip_attachment_in_progress = false;
	self.weapon_condition = 2;

	self.syn = [];

	// Visions

	self.syn["visions"][0] = ["", "zm_camo", "airplane", "end_game", "default_night_mp", "near_death_hdr_zm", "mp_countdown"];
	self.syn["visions"][1] = ["None", "Camo", "Filter", "Red", "Green", "Near Death", "Black & White"];

	// Powerups

	self.syn["powerups"][0] = ["nuke", "ammo", "insta_kill", "double_points", "ability_fill"];
	self.syn["powerups"][1] = ["Nuke", "Max Ammo", "Instakill", "Double Points", "Full Power"];

	// Weapons

	self.syn["weapons"] = [];

	self.syn["weapons"]["category"][0] = ["assault_rifles", "sub_machine_guns", "light_machine_guns", "sniper_rifles", "shotguns", "pistols", "launchers"];
	self.syn["weapons"]["category"][1] = ["Assault Rifles", "Sub Machine Guns", "Light Machine Guns", "Sniper Rifles", "Shotguns", "Pistols", "Launchers"];

	self.syn["weapons"]["assault_rifles"][0] =     ["m1garand", "svt40", "stg44", "fg42", "bar", "m1941", "m1a1", "g43", "volk", "type5", "m1935", "m2carbine", "avs36", "federov", "sudaev", "charlton", "kgm21", "wimmer", "grofuss"];
	self.syn["weapons"]["sub_machine_guns"][0] =   ["greasegun", "mp40", "ppsh41", "thompson", "type100", "mp28", "sten", "beretta", "mas38", "sterling", "nambu", "zk383", "ribeyrolles", "tokyo", "emp44", "blyskawica", "erma", "austen", "m2hyde", "bechowiec"];
	self.syn["weapons"]["light_machine_guns"][0] = ["bren", "lewis", "mg15", "mg42", "breda30", "mg81", "m1919", "vmg1927", "lad", "chatelleroult"];
	self.syn["weapons"]["sniper_rifles"][0] =      ["kar98", "leeenfield", "karabin", "springfield", "arisaka", "leveraction", "ptrs41", "delisle", "mosin", "sdk", "wz35", "mas36"];
	self.syn["weapons"]["shotguns"][0] =           ["winchester1897", "m30", "model21", "walther", "blunderbuss"];
	self.syn["weapons"]["pistols"][0] =            ["luger", "luger_auto", "m1911", "m712", "p38", "reich", "enfieldno2"];
	self.syn["weapons"]["launchers"][0] =          ["fliegerfaust", "dp28", "bazooka", "panzerschreck", "flamethrower"];

	self.syn["weapons"]["assault_rifles"][1] =     ["M1 Garand", "SVT-40", "STG44", "FG 42", "BAR", "M1941", "M1A1 Carbine", "Gewehr 43", "Volkssturmgewehr", "Type 5", "Itra Burst", "M2 Carbine", "AVS-36", "Automaton", "AS-44", "NZ-41", "KG M-21", "Wimmersperg SPZ", "GPD-79"];
	self.syn["weapons"]["sub_machine_guns"][1] =   ["Grease Gun", "MP-40", "PPSH-41", "M1928", "Type 100", "Waffe 28", "Sten", "Orso", "M-38", "Sterling", "Nambu Type 2", "ZK-383", "Ribeyrolles", "Proto-X1", "EMP44", "Blyskawica", "Erma EMP", "Austen", "M267", "Bechowiec"];
	self.syn["weapons"]["light_machine_guns"][1] = ["Bren", "Lewis", "MG 15", "MG 42", "GPMG", "MG 81", "Stinger", "VMG 1927", "LAD Machine Gun", "Chatellerault"];
	self.syn["weapons"]["sniper_rifles"][1] =      ["Kar98k", "Lee Enfield", "Karabin", "M1903", "Type 38", "Lever Action", "PTRS-41", "De Lisle", "3-Line Rifle", "SDK 9mm", "WZ. 35", "M36"];
	self.syn["weapons"]["shotguns"][1] =           ["Combat Shotgun", "M30 Luftwaffe Drilling", "Sawed Off Shotgun", "Toggle Action", "Blunderbuss"];
	self.syn["weapons"]["pistols"][1] =            ["P-08", "P-08 (Auto)", "1911", "Machine Pistol", "9mm SAP", "Reichsrevolver", "Enfield No. 2"];
	self.syn["weapons"]["launchers"][1] =          ["Fliegerfaust", "Crossbow", "Bazooka", "Panzerschreck", "Flamethrower"];

	self.syn["weapons"]["blacklisted_weapons"] = ["hilt_inspect_zm", "hilt_inspect_hc_zm", "island_grenade_hc_zm", "spine_inspect_pest_zm", "spine_inspect_wustling_zm", "spine_inspect_assassin_zm", "spine_inspect_zombie_zm", "spine_inspect_depleted_zm", "corpse_eater_dlc4_zm", "throwinghammer_lhand_zm", "zom_moonorb_grenade_zm", "zom_moonorb_grenade_emp_zm"];

	// Attachments

	self.syn["attachments"][0] = ["lens_sight", "aperture_sight", "telescopic_sight", "iron_sight_sniper", "fast_ads", "grip", "fmj", "hipfire", "rapid_fire", "head_damage_zm", "reduced_sway", "extended_mag", "extended_range_smg", "extended_range_rifle", "extended_range_shotgun", "akimbo", "tribolt_dp28", "fast_mag_dp28", "fast_bolt_dp28", "explosive_tips_dp28"];
	self.syn["attachments"][1] = ["Lens Sight", "Aperture Sight", "Telescopic Sight", "Iron Sight (Sniper)", "Quickdraw", "Grip", "FMJ", "Steady Aim", "Rapid Fire", "High Caliber", "Ballistic CPU", "Extended Mags", "Advanced Rifling", "Advanced Rifling", "Advanced Rifling", "Akimbo", "Tri-Bolt", "Fast Mag", "Fast Bolt", "Explosive Tips"];

	self.syn["blacklisted_attachments"] = ["none", "null", "clantag", "custom1", "custom2", "killcounter"];
	self.syn["optics"] = ["lens_sight", "aperture_sight", "telescopic_sight", "iron_sight_sniper", "iron_sight_sniper_mosin", "lens_sight_ribeyrolles"];

	self.syn["named_attachments"]["aperture_sight"] = ["m2hyde", "charlton", "sudaev", "federov", "grofuss", "wimmer", "dp28", "lad", "erma", "tokyo", "avs36", "emp44", "blyskawica", "bechowiec", "austen", "zk383", "kgm21", "chatelleroult", "ribeyrolles", "m2carbine", "vmg1927", "m1935", "mas38", "sterling", "nambu", "type99", "m30", "walther", "model21", "ppsh41", "beretta", "mp28", "type100", "sten", "thompson", "greasegun", "m1a1", "m1941", "type5", "volk", "g43", "stg44", "svt40", "mp40", "fg42", "m1garand", "bren", "m1919", "mg81", "mg42", "mg15", "lewis", "bar"];
	self.syn["named_attachments"]["telescopic_sight"] = ["sdk", "charlton", "sudaev", "federov", "grofuss", "wimmer", "wz35", "dp28", "lad", "avs36", "leveraction", "delisle", "ptrs41", "mosin", "mas36", "kgm21", "chatelleroult", "m2carbine", "vmg1927", "m1935", "type99", "m1919", "bren", "mg42", "mg81", "lewis", "mg15", "type38", "fg42", "springfield", "enfield", "kar98k", "m1941", "type5", "m1a1", "volk", "g43", "stg44", "svt40", "bar", "m1garand"];

	self.syn["attachments"]["assault_rifles"][0] = ["lens_sight", "fast_ads", "grip", "aperture_sight", "hipfire", "fmj", "telescopic_sight", "rapid_fire", "extended_mag", "extended_range_rifle", "head_damage_zm"]; // ARs
	self.syn["attachments"]["assault_rifles_alt"][0] = ["fast_ads", "grip", "aperture_sight", "hipfire", "fmj", "telescopic_sight", "rapid_fire", "extended_mag", "extended_range_rifle", "head_damage_zm"]; // ARs Alt (FG 42, M1941)
	self.syn["attachments"]["sub_machine_guns"][0] = ["lens_sight", "fast_ads", "grip", "aperture_sight", "hipfire", "fmj", "rapid_fire", "extended_mag", "extended_range_smg"]; // SMGs
	self.syn["attachments"]["zm393"][0] = ["lens_sight", "fast_ads", "grip", "aperture_sight", "hipfire", "fmj", "extended_mag", "extended_range_smg"]; // SMGs Alt
	self.syn["attachments"]["light_machine_guns"][0] = ["fast_ads", "grip", "aperture_sight", "hipfire", "fmj", "telescopic_sight", "rapid_fire", "extended_mag"]; // LMGs
	self.syn["attachments"]["sniper_rifles"][0] = ["fmj", "telescopic_sight", "iron_sight_sniper", "rapid_fire", "extended_mag", "reduced_sway"]; // Snipers
	self.syn["attachments"]["shotguns"][0] = ["fast_ads", "aperture_sight", "hipfire", "rapid_fire", "extended_mag", "extended_range_shotgun"]; // Shotguns
	self.syn["attachments"]["shotguns_alt"][0] = ["fast_ads", "aperture_sight", "hipfire", "rapid_fire", "extended_range_shotgun"]; // Shotguns Alt (M30 Luftwaffe Drilling, Sawed Off Shotgun)
	self.syn["attachments"]["blunderbuss"][0] = ["fast_ads", "hipfire", "extended_range_shotgun"]; // Blunderbuss
	self.syn["attachments"]["pistols"][0] = ["fast_ads", "hipfire", "fmj", "extended_mag", "extended_range", "head_damage_zm", "akimbo"]; // Pistols
	self.syn["attachments"]["pistols_alt"][0] = ["fast_ads", "hipfire", "fmj", "extended_mag", "extended_range", "head_damage_zm", "akimbo"]; // Pistols Alt (Reichsrevolver, Enfield No.2)
	self.syn["attachments"]["crossbow"][0] = ["aperture_sight", "telescopic_sight", "tribolt_dp28", "fast_mag_dp28", "fast_bolt_dp28", "explosive_tips_dp28"]; // Crossbow

	// Perks

	self.syn["perks"][0] = ["quickrevive", "doubletap", "fastreload", "runperk", "electriccherry", "punchperk"];
	self.syn["perks"][1] = ["Quick Revive", "Double Tap", "Speed Cola", "Stamin-Up", "Electric Cherry", "Melee Damage"];

	// Camos

	self.syn["camos"][0] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 25, 23, 16, 19, 17, 106, 21];
	self.syn["camos"][1] = ["Frogskin", "Brownspot", "Heeres-Splittermuster 31", "Leibermuster", "Pea Pattern", "Oakleaf", "Palm tree", "Platanemuster", "Ambush", "M1916", "Snow", "Cheetah", "Bronze", "Copper", "Gold", "Diamond", "Gold Leopard", "Gold Cheetah", "Chrome"];
	self.syn["camos"][2] = [64, 67, 71, 68, 70, 79, 78, 94, 93, 75, 84, 83, 26, 81, 45, 80, 82, 88, 42, 43, 76, 85, 54, 27, 109, 39, 142, 143, 145, 146, 160, 96, 148, 150, 152, 133, 147, 86, 44, 162, 163, 164, 165, 167];
	self.syn["camos"][3] = ["Olive Drab", "Canary", "Sunset", "Candy Apple", "Pitch", "Tattoo", "Victory", "Stone Leopard", "Woodland Stripes", "Brutal Tiger", "Wood Paneled", "Turqoise", "Rattlesnake", "Jade", "Carbon Stripes", "Amethyst", "Lapis Lazuli", "Purple Passion", "Parachute", "Clouds", "Metalflage", "Disco", "Noir Black", "Mother of Pearl", "Racer", "Speckled", "Vinyl", "Hypnotist", "Cherry Pie", "Summer Dreaming", "Treegate", "Electric Blue", "Bunker", "Atomic", "Power Surge", "Amphibious", "Gilded Dragon", "Bubble Wrap", "Gore", "Skullz", "Jeepers Peepers", "Mischief", "Bat Outta Hell", "Evil Grin"];
	self.syn["camos"][4] = [34, 37, 47, 48, 49, 73, 87, 101, 97, 138, 137, 139, 130, 129, 131, 136, 105];
	self.syn["camos"][5] = ["Geistkraft", "Bomb Voyage", "Schwein Gehabt", "Verrotteter Rabe", "Gruner Knoten", "Thule's Errand", "Durst", "Nebel Rollt Hinein", "Unheimlich", "Fleishpastete", "Feuerwerk", "Kitschig", "Uber Sturm", "Fehlleitung", "Basalt und Batterie", "Kaltblutig", "Lahmen"];
	self.syn["camos"][6] = [38, 95, 72, 122, 118, 111, 120, 112, 125, 114, 124, 115, 121, 116, 119, 113, 123, 117, 134, 144, 158, 157, 156, 155, 154, 153, 149, 161, 159];
	self.syn["camos"][7] = ["Pot of Gold", "Blind Luck", "C.O.D.E. Fear Not", "Echo Fox", "Epsilon", "eUnited", "Evil Geniuses", "FaZe", "Luminosity Gaming", "Mindfreak", "OpTic Gaming", "Red Reserve", "Rise Nation", "Splyce", "Team EnVyUs", "Team Kaliber", "UNILAD", "Vitality", "World League", "Beachside", "Bengal Beige", "Dangerous Sterling", "Reptilian Oak", "Icy Veins", "Molten Magma", "Royalty Tiger", "Redacted", "Devil's Candy", "Blood Tiger"];
	self.syn["camos"][8] = [77, 50, 126, 128, 141, 151, 166, 140, 132, 22, 28, 135, 98, 99, 100, 35, 102, 103, 104];
	self.syn["camos"][9] = ["Ruby", "Rotten", "Stitches", "Teeth", "Watermelon", "Retrofuture", "Trick or Treat", "Missing Texture", "Coffee", "Chrome Tiger", "The Final Reich Pack-a-Punch", "Pack-a-Punch 4", "Amp 3", "Amp 4", "Amp 5", "Raven", "Madmin", "Camo 1", "Frontline"];
}

create_menu() {
	self freezeControls(false);

	self thread input_manager();

	self.menu["border"] = self create_shader("white", "left", "middle", ((self.x_offset + 320) - 1), (self.y_offset - 1), 226, 122, self.color_theme, 1, 1);
	self.menu["background"] = self create_shader("white", "left", "middle", (self.x_offset + 320), self.y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
	self.menu["foreground"] = self create_shader("white", "left", "middle", (self.x_offset + 320), (self.y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
	self.menu["separator_1"] = self create_shader("white", "left", "middle", ((self.x_offset + 320) + 5), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	self.menu["separator_2"] = self create_shader("white", "right", "middle", (self.x_offset + 540), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	self.menu["cursor"] = self create_shader("white", "left", "middle", (self.x_offset + 320), 215, 224, 16, (0.15, 0.15, 0.15), 0, 4);

	self.menu["title"] = self create_text("Title", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 94.5), (self.y_offset + 3), (1, 1, 1), 1, 10);
	self.menu["description"] = self create_text("Description", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + (self.option_limit * 17.5)), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider_text"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), (self.y_offset + 19), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider"] = self create_shader("white", "left", "middle", (self.x_offset + 320), (self.y_offset + 15), 224, 16, (0.25, 0.25, 0.25), 0, 5);

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i] = self create_shader("white", "right", "middle", ((self.x_offset + 320) - 4), ((self.y_offset + 4) + (i * 15)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
		self.menu["option_" + i] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), ((self.y_offset + 4) + (i * 15)), (0.75, 0.75, 0.75), 1, 10);
		self.menu["submenu_icon_" + i] = self create_text(">", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 215), ((self.y_offset + 1) + (i * 15)), (0.75, 0.75, 0.75), 0, 10);
	}

	self.hud_created = true;

	self.menu["title"] set_text("Controls");
	self.menu["option_1"] set_text("Open: ^3[{+speed_throw}] ^7and ^3[{+melee}]");
	self.menu["option_2"] set_text("Scroll: ^3[{+speed_throw}] ^7and ^3[{+attack}]");
	self.menu["option_3"] set_text("Select: ^3[{+activate}] ^7Back: ^3[{+melee}]");
	self.menu["option_4"] set_text("Sliders: ^3[{+smoke}] ^7and ^3[{+frag}]");
	self.menu["option_5"].alpha = 0;
	self.menu["option_6"].alpha = 0;
	self.menu["option_7"].alpha = 0;

	self.menu["border"] set_shader("white", self.menu["border"].width, 78);
	self.menu["background"] set_shader("white", self.menu["background"].width, 76);
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 61);

	update_element_positions();

	self.controls_menu_open = true;

	wait 8;

	if(self.controls_menu_open) {
		close_controls_menu();
	}
}

initialize_menu() {
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		event_name = self waittill_any_return("spawned_player", "player_downed", "death", "joined_spectators");
		switch (event_name) {
			case "spawned_player":
				if(self isHost()) {
					if(!self.hud_created) {
						self create_menu();
					}
				}
				break;
			default:
				if(!self isHost()) {
					continue;
				}

				if(self.in_menu) {
					self close_menu();
				}
				break;
		}
	}
}

initialize_verified_menu() {
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		if(self.access != "None") {
			if(!self.hud_created) {
				self initial_variables();

				wait 0.25;

				self create_menu();
			}
		}
		wait 1;
	}
}

input_manager() {
	level endon("game_ended");
	self endon("disconnect");

	while(self.access != "None") {
		if(!self.in_menu) {
			if(self adsButtonPressed() && self meleeButtonPressed()) {
				if(self.controls_menu_open) {
					close_controls_menu();
				}


				open_menu();

				while(self adsButtonPressed() && self meleeButtonPressed()) {
					wait 0.2;
				}
			}
		} else {
			if(self meleeButtonPressed()) {
				self.saved_index[self.current_menu] = self.cursor_index;
				self.saved_offset[self.current_menu] = self.scrolling_offset;
				self.saved_trigger[self.current_menu] = self.previous_trigger;


				if(isDefined(self.previous[(self.previous.size - 1)])) {
					self new_menu();
				} else {
					self close_menu();
				}

				while(self meleeButtonPressed()) {
					wait 0.2;
				}
			} else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {

				self menu_option();

				scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

				wait (0.2);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
				}

				wait (0.2);
			} else if(self useButtonPressed()) {
				self.saved_index[self.current_menu] = self.cursor_index;
				self.saved_offset[self.current_menu] = self.scrolling_offset;
				self.saved_trigger[self.current_menu] = self.previous_trigger;


				if(self.structure[self.cursor_index].command == ::new_menu) {
					self.previous_option = self.structure[self.cursor_index].text;
				}

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					if(isDefined(self.structure[self.cursor_index].array)) {
						if(!isDefined(self.structure[self.cursor_index].use_array_index)) {
							cursor_selected = self.structure[self.cursor_index].array[self.slider[(self.current_menu + "_" + self.cursor_index)]];
						} else {
							cursor_selected = self.slider[(self.current_menu + "_" + (self.cursor_index))];
						}
					} else {
						cursor_selected = self.slider[(self.current_menu + "_" + (self.cursor_index))];
					}
					self thread execute_function(self.structure[self.cursor_index].command, cursor_selected, self.structure[self.cursor_index].parameter_1, self.structure[self.cursor_index].parameter_2, self.structure[self.cursor_index].parameter_3);
				} else if(isDefined(self.structure[self.cursor_index]) && isDefined(self.structure[self.cursor_index].command)) {
					self thread execute_function(self.structure[self.cursor_index].command, self.structure[self.cursor_index].parameter_1, self.structure[self.cursor_index].parameter_2, self.structure[self.cursor_index].parameter_3);
				}

				self menu_option();
				set_options();

				while(self useButtonPressed()) {
					wait 0.2;
				}
			}
		}
		wait 0.05;
	}
}

// Hud Functions

open_menu() {
	self.in_menu = true;

	set_menu_visibility(1);

	self menu_option();
	scroll_cursor();
	set_options();
}

close_menu() {
	set_menu_visibility(0);

	self.in_menu = false;
}

close_controls_menu() {
	set_menu_visibility(0);

	self.menu["border"] set_shader("white", self.menu["border"].width, 123);
	self.menu["background"] set_shader("white", self.menu["background"].width, 121);
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 106);

	self.controls_menu_open = false;

	self.menu["title"] set_text("");
	self.menu["option_1"] set_text("");
	self.menu["option_2"] set_text("");
	self.menu["option_3"] set_text("");
	self.menu["option_4"] set_text("");

	self.in_menu = false;
}

set_menu_visibility(opacity) {
	if(opacity == 0) {
		self.menu["border"].alpha = opacity;
		self.menu["description"].alpha = opacity;
		self.menu["slider"].alpha = opacity;
		for(i = 1; i <= self.option_limit; i++) {
			self.menu["toggle_" + i].alpha = opacity;
			self.menu["submenu_icon_" + i].alpha = opacity;
		}
	}

	self.menu["title"].alpha = opacity;
	self.menu["separator_1"].alpha = opacity;
	self.menu["separator_2"].alpha = opacity;
	self.menu["slider_text"].alpha = opacity;

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["option_" + i].alpha = opacity;
	}

	wait 0.05;

	self.menu["background"].alpha = opacity;
	self.menu["foreground"].alpha = opacity;
	self.menu["cursor"].alpha = opacity;

	if(opacity == 1) {
		self.menu["border"].alpha = opacity;
	}
}

create_text(text, font, font_scale, align_x, align_y, x_offset, y_offset, color, alpha, z_index, hide_when_in_menu) {
	textElement = self createFontString(font, font_scale);
	textElement setPoint(align_x, align_y, x_offset, y_offset);

	textElement.alpha = alpha;
	textElement.sort = z_index;
	textElement.anchor = self;
	textElement.archived = self auto_archive();

	if(isDefined(hide_when_in_menu)) {
		textElement.hideWhenInMenu = hide_when_in_menu;
	} else {
		textElement.hideWhenInMenu = true;
	}

	if(isDefined(color)) {
		if(!isString(color)) {
			textElement.color = color;
		} else if(color == "rainbow") {
			textElement.color = level.rainbow_color;
			textElement thread start_rainbow();
		}
	} else {
		textElement.color = (0, 1, 1);
	}

	if(isDefined(text)) {
		if(isNumber(text)) {
			textElement setValue(text);
		} else {
			textElement set_text(text);
		}
	}

	self.element_result++;
	return textElement;
}

set_text(text) {
	if(!isDefined(self) || !isDefined(text)) {
		return;
	}

	self.text = text;
	self setText(text);
}

create_shader(shader, align_x, align_y, x_offset, y_offset, width, height, color, alpha, z_index, hide_when_in_menu) {
	shaderElement = newClientHudElem(self);
	shaderElement.elemType = "icon";
	shaderElement.children = [];
	shaderElement.alpha = alpha;
	shaderElement.sort = z_index;
	shaderElement.anchor = self;
	shaderElement.archived = self auto_archive();

	shaderElement.alignx = "left";
  shaderElement.aligny = "top";
	shaderElement.xoffset = x_offset;
	shaderElement.yoffset = y_offset;

	shaderElement.hideWhenInMenu = false;

	if(isDefined(hide_when_in_menu)) {
		shaderElement.hideWhenInMenu = hide_when_in_menu;
	} else {
		shaderElement.hideWhenInMenu = true;
	}

	if(isDefined(color)) {
		if(!isString(color)) {
			shaderElement.color = color;
		} else if(color == "rainbow") {
			shaderElement.color = level.rainbow_color;
			shaderElement thread start_rainbow();
		}
	} else {
		shaderElement.color = (0, 1, 1);
	}

	shaderElement set_shader(shader, width, height);

	self.element_result++;
	return shaderElement;
}

set_shader(shader, width, height) {
	if(!isDefined(self)) {
		return;
	}

	if(!isDefined(shader)) {
		if(!isDefined(self.shader)) {
			return;
		}

		shader = self.shader;
	}

	if(!isDefined(width)) {
		if(!isDefined(self.width)) {
			return;
		}

		width = self.width;
	}

	if(!isDefined(height)) {
		if(!isDefined(self.height)) {
			return;
		}

		height = self.height;
	}

	self.shader = shader;
	self.width = width;
	self.height = height;
	self setShader(shader, width, height);
}

auto_archive() {
	if(!isDefined(self.element_result)) {
		self.element_result = 0;
	}

	if(!isAlive(self) || self.element_result > 22) {
		return true;
	}

	return false;
}

update_element_positions() {
	self.menu["border"].x = ((self.x_offset + 320) - 1);
	self.menu["border"].y = (self.y_offset - 1);

	self.menu["background"].x = (self.x_offset + 320);
	self.menu["background"].y = self.y_offset;

	self.menu["foreground"].x = (self.x_offset + 320);
	self.menu["foreground"].y = (self.y_offset + 15);

	self.menu["separator_1"].x = ((self.x_offset + 320) + 5);
	self.menu["separator_1"].y = (self.y_offset + 7.5);

	self.menu["separator_2"].x = ((self.x_offset + 320) + 177.5);
	self.menu["separator_2"].y = (self.y_offset + 7.5);

	self.menu["cursor"].x = (self.x_offset + 320);

	self.menu["description"].y = (self.y_offset + (self.option_limit * 17.5));

	self.menu["slider_text"].x = (self.x_offset + 132.5);
	self.menu["slider_text"].y = ((self.y_offset + 4) + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	self.menu["slider"].x = (self.x_offset + 320);
	self.menu["slider"].y = (self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].x = ((self.x_offset + 320) + 3);
		self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["option_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["submenu_icon_" + i].x = (self.x_offset + 215);
		self.menu["submenu_icon_" + i].y = ((self.y_offset + 3) + (i * 15));
	}
}

// Colors

create_rainbow_color() {
	x = 0; y = 0;
	r = 0; g = 0; b = 0;
	level.rainbow_color = (0, 0, 0);

	level endon("game_ended");

	while(true) {
		if(y >= 0 && y < 258) {
			r = 255;
			g = 0;
			b = x;
		} else if(y >= 258 && y < 516) {
			r = 255 - x;
			g = 0;
			b = 255;
		} else if(y >= 516 && y < 774) {
			r = 0;
			g = x;
			b = 255;
		} else if(y >= 774 && y < 1032) {
			r = 0;
			g = 255;
			b = 255 - x;
		} else if(y >= 1032 && y < 1290) {
			r = x;
			g = 255;
			b = 0;
		} else if(y >= 1290 && y < 1545) {
			r = 255;
			g = 255 - x;
			b = 0;
		}

		x += 3;
		if(x > 255) {
			x = 0;
		}

		y += 3;
		if(y > 1545) {
			y = 0;
		}

		level.rainbow_color = (r/255, g/255, b/255);
		wait 0.05;
	}
}

start_rainbow() {
	level endon("game_ended");
	self endon("stop_rainbow");
	self.rainbow_enabled = true;

	while(isDefined(self) && self.rainbow_enabled) {
		self fadeOverTime(.05);
		self.color = level.rainbow_color;
		wait 0.05;
	}
}

// Misc Functions

return_toggle(variable) {
	return isDefined(variable) && variable;
}

set_variable(check, option_1, option_2) {
	if(check) {
		return option_1;
	} else {
		return option_2;
	}
}

get_map_name() {
	map_name = getDvar("mapname");
	if(map_name == "mp_zombie_training") return "prologue";
	if(map_name == "mp_zombie_nest_01") return "the_final_reich";
	if(map_name == "mp_zombie_house") return "groesten_haus";
	if(map_name == "mp_zombie_island") return "the_darkest_shore";
	if(map_name == "mp_zombie_berlin") return "the_shadowed_throne";
	if(map_name == "mp_zombie_windmill") return "tortured_path_1";
	if(map_name == "mp_zombie_dnk") return "tortured_path_2";
	if(map_name == "mp_zombie_dig_02") return "tortured_path_3";
	if(map_name == "mp_zombie_descent") return "the_frozen_dawn";
}

in_array(array, item) {
	if(!isDefined(array) || !isArray(array)) {
		return;
	}

	for(a = 0; a < array.size; a++) {
		if(array[a] == item) {
			return true;
		}
	}

	return false;
}

remove_from_array(array, object) {
	if(!isDefined(array) || !isDefined(object)) {
	  return;
	}
	new_array = [];
	foreach(item in array) {
	  if(item != object) {
	    new_array[new_array.size] = item;
	  }
	}
	return new_array;
}

player_damage_callback(inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset) {
	self endon("disconnect");

	if((isDefined(self.god_mode) && self.god_mode) || (isDefined(self.temp_god_mode) && self.temp_god_mode)) {
		return;
	}

	[[level.originalCallbackPlayerDamage]](inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset);
}

vector_scale(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

get_bullet_trace_position() {
	start = self getEye();
	end = vector_scale(anglesToForward(self getPlayerAngles()), 9999);

	return bulletTrace(start, start + end, false, self)["position"];
}

load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		self add_option(self.syn["weapons"][weapon_category][1][i], undefined, ::give_weapon, self.syn["weapons"][weapon_category][0][i]);
	}
}

// Custom Structure

execute_function(command, parameter_1, parameter_2, parameter_3, parameter_4) {
	self endon("disconnect");

	if(!isDefined(command)) {
		return;
	}

	if(isDefined(parameter_4)) {
		return self thread[[command]](parameter_1, parameter_2, parameter_3, parameter_4);
	}

	if(isDefined(parameter_3)) {
		return self thread[[command]](parameter_1, parameter_2, parameter_3);
	}

	if(isDefined(parameter_2)) {
		return self thread[[command]](parameter_1, parameter_2);
	}

	if(isDefined(parameter_1)) {
		return self thread[[command]](parameter_1);
	}

	self thread[[command]]();
}

add_option(text, description, command, parameter_1, parameter_2, parameter_3) {
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = ::empty_function;
	} else {
		option.command = command;
	}
	if(isDefined(parameter_1)) {
		option.parameter_1 = parameter_1;
	}
	if(isDefined(parameter_2)) {
		option.parameter_2 = parameter_2;
	}
	if(isDefined(parameter_3)) {
		option.parameter_3 = parameter_3;
	}

	self.structure[self.structure.size] = option;
}

add_toggle(text, description, command, variable, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = ::empty_function;
	} else {
		option.command = command;
	}
	option.toggle = isDefined(variable) && variable;
	if(isDefined(parameter_1)) {
		option.parameter_1 = parameter_1;
	}
	if(isDefined(parameter_2)) {
		option.parameter_2 = parameter_2;
	}

	self.structure[self.structure.size] = option;
}

add_array(text, description, command, array, show_options, use_array_index, parameter_1, parameter_2, parameter_3) {
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = ::empty_function;
	} else {
		option.command = command;
	}
	if(!isDefined(command)) {
		option.array = [];
	} else {
		option.array = array;
	}
	if(isDefined(show_options)) {
		option.show_options = show_options;
	} else {
		option.show_options = false;
	}
	if(isDefined(use_array_index)) {
		option.use_array_index = use_array_index;
	} else {
		option.use_array_index = undefined;
	}
	if(isDefined(parameter_1)) {
		option.parameter_1 = parameter_1;
	}
	if(isDefined(parameter_2)) {
		option.parameter_2 = parameter_2;
	}
	if(isDefined(parameter_3)) {
		option.parameter_3 = parameter_3;
	}

	self.structure[self.structure.size] = option;
}

add_increment(text, description, command, start, minimum, maximum, increment, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = ::empty_function;
	} else {
		option.command = command;
	}
	if(isNumber(start)) {
		option.start = start;
	} else {
		option.start = 0;
	}
	if(isNumber(minimum)) {
		option.minimum = minimum;
	} else {
		option.minimum = 0;
	}
	if(isNumber(maximum)) {
		option.maximum = maximum;
	} else {
		option.maximum = 10;
	}
	if(isNumber(increment)) {
		option.increment = increment;
	} else {
		option.increment = 1;
	}
	if(isDefined(parameter_1)) {
		option.parameter_1 = parameter_1;
	}
	if(isDefined(parameter_2)) {
		option.parameter_2 = parameter_2;
	}

	self.structure[self.structure.size] = option;
}

get_title_width(title) {
	letter_index = [" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
	letter_width = [5, 12, 11, 11, 10, 10, 10, 11, 11, 5, 10, 10, 9, 12, 11, 11, 10, 12, 10, 19, 11, 10, 11, 14, 10, 11, 10];
	title_width = 0;

	for(i = 1; i < title.size; i++) {
		for(x = 1; x < letter_index.size; x++) {
			if(tolower(title[i]) == tolower(letter_index[x])) {
				title_width = int(title_width) + int(letter_width[x]);
			}
		}
	}

	return title_width;
}

set_title(title) {
	self.menu["title"] set_text(title);

	title_width = get_title_width(title);

	self.menu["title"].x = (self.x_offset + ceil((((-0.0000124 * title_width + 0.003832) * title_width - 0.52) * title_width + 115.258) * 10) / 10);
	self.menu["title"].y = (self.y_offset + 3);
}

new_menu(menu) {
	if(!isDefined(menu)) {
		menu = self.previous[(self.previous.size - 1)];
		self.previous[(self.previous.size - 1)] = undefined;
	} else {
		self.previous[self.previous.size] = self.current_menu;
	}

	if(!isDefined(self.slider[(menu + "_" + (self.cursor_index))])) {
		self.slider[(menu + "_" + (self.cursor_index))] = 0;
	}

	self.current_menu = set_variable(isDefined(menu), menu, "Synergy");

	if(isDefined(self.saved_index[self.current_menu])) {
		self.cursor_index = self.saved_index[self.current_menu];
		self.scrolling_offset = self.saved_offset[self.current_menu];
		self.previous_trigger = self.saved_trigger[self.current_menu];
		self.loaded_offset = true;
	} else {
		self.cursor_index = 0;
		self.scrolling_offset = 0;
		self.previous_trigger = 0;
	}

	self menu_option();
	scroll_cursor();
}

empty_function() {}

empty_option() {
	option = ["Nothing To See Here!", "Quiet Here, Isn't It?", "Oops, Nothing Here Yet!", "Bit Empty, Don't You Think?"];
	return option[randomInt(option.size)];
}

scroll_cursor(direction) {
	maximum = self.structure.size - 1;
	fake_scroll = false;

	if(maximum < 0) {
		maximum = 0;
	}

	if(isDefined(direction)) {
		if(direction == "down") {
			self.cursor_index++;
			if(self.cursor_index > maximum) {
				self.cursor_index = 0;
				self.scrolling_offset = 0;
			}
		} else if(direction == "up") {
			self.cursor_index--;
			if(self.cursor_index < 0) {
				self.cursor_index = maximum;
				if(((self.cursor_index) + int((self.option_limit / 2))) >= (self.structure.size - 2)) {
					self.scrolling_offset = (self.structure.size - self.option_limit);
				}
			}
		}
	} else {
		while(self.cursor_index > maximum) {
			self.cursor_index--;
		}
		self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 15));
	}

	self.previous_scrolling_offset = self.scrolling_offset;

	if(!self.loaded_offset) {
		if(self.cursor_index >= int(self.option_limit / 2) && self.structure.size > self.option_limit) {
			if((self.cursor_index + int(self.option_limit / 2)) >= (self.structure.size - 2)) {
				self.scrolling_offset = (self.structure.size - self.option_limit);
				if(self.previous_trigger == 2) {
					self.scrolling_offset--;
				}
				if(self.previous_scrolling_offset != self.scrolling_offset && self.previous_trigger != 1) {
					fake_scroll = true;
					self.previous_trigger = 1;
				}
			} else {
				self.scrolling_offset = (self.cursor_index - int(self.option_limit / 2));
				self.previous_trigger = 2;
			}
		} else {
			self.scrolling_offset = 0;
			self.previous_trigger = 0;
		}
	}

	if(self.scrolling_offset < 0) {
		self.scrolling_offset = 0;
	}

	if(!fake_scroll) {
		self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 15));
	}

	if(isDefined(self.structure[self.cursor_index]) && isDefined(self.structure[self.cursor_index].description)) {
		self.menu["description"] set_text(self.structure[self.cursor_index].description);
		self.description_height = 15;

		self.menu["description"].x = (self.x_offset + 5);
		self.menu["description"].alpha = 1;
	} else {
		self.menu["description"] set_text("");
		self.menu["description"].alpha = 0;
		self.description_height = 0;
	}

	self.loaded_offset = false;
	set_options();
}

scroll_slider(direction) {
	current_slider_index = self.slider[(self.current_menu + "_" + (self.cursor_index))];
	if(isDefined(direction)) {
		if(isDefined(self.structure[self.cursor_index].array)) {
			if(direction == "left") {
				current_slider_index--;
				if(current_slider_index < 0) {
					current_slider_index = (self.structure[self.cursor_index].array.size - 1);
				}
			} else if(direction == "right") {
				current_slider_index++;
				if(current_slider_index > (self.structure[self.cursor_index].array.size - 1)) {
					current_slider_index = 0;
				}
			}
		} else {
			if(direction == "left") {
				current_slider_index -= self.structure[self.cursor_index].increment;
				if(current_slider_index < self.structure[self.cursor_index].minimum) {
					current_slider_index = self.structure[self.cursor_index].maximum;
				}
			} else if(direction == "right") {
				current_slider_index += self.structure[self.cursor_index].increment;
				if(current_slider_index > self.structure[self.cursor_index].maximum) {
					current_slider_index = self.structure[self.cursor_index].minimum;
				}
			}
		}
	}
	self.slider[(self.current_menu + "_" + (self.cursor_index))] = current_slider_index;
	set_options();
}

set_options() {
	if(isDefined(self.equip_attachment_in_progress)) {
		while(self.equip_attachment_in_progress) {
			wait 0.05;
		}
	}

	self.menu["slider_text"] set_text("");
	self.menu["slider"].alpha = 0;

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].alpha = 0;
		self.menu["submenu_icon_" + i].alpha = 0;

		self.menu["option_" + i] set_text("");
	}

	update_element_positions();

	if(isDefined(self.structure)) {
		if(self.structure.size == 0) {
			self add_option(empty_option());
		}

		self.maximum = int(min(self.structure.size, self.option_limit));

		if(self.structure.size <= self.option_limit) {
			self.scrolling_offset = 0;
		}

		for(i = 1; i <= self.maximum; i++) {
			x = ((i - 1) + self.scrolling_offset);

			self.menu["option_" + i] set_text(self.structure[x].text);

			if(isDefined(self.structure[x].toggle)) {
				self.menu["option_" + i].x = (self.x_offset + 13.5);
				self.menu["option_" + i].alpha = 1;
				self.menu["toggle_" + i].alpha = 1;

				if(self.structure[x].toggle) {
					self.menu["toggle_" + i].color = (1, 1, 1);
				} else {
					self.menu["toggle_" + i].color = (0.25, 0.25, 0.25);
				}
			} else {
				self.menu["option_" + i].x = (self.x_offset + 5);
				self.menu["toggle_" + i].alpha = 0;
			}

			if(isDefined(self.structure[x].array) && (self.cursor_index) == x) {
				if(!isDefined(self.slider[(self.current_menu + "_" + x)])) {
					self.slider[(self.current_menu + "_" + x)] = 0;
				}

				if(self.slider[(self.current_menu + "_" + x)] > (self.structure[x].array.size - 1) || self.slider[(self.current_menu + "_" + x)] < 0) {
					self.slider[(self.current_menu + "_" + x)] = set_variable(self.slider[(self.current_menu + "_" + x)] > (self.structure[x].array.size - 1), 0, (self.structure[x].array.size - 1));
				}

				if(self.structure[x].show_options) {
					slider_text = self.structure[x].array[self.slider[(self.current_menu + "_" + x)]] + " [" + (self.slider[(self.current_menu + "_" + x)] + 1) + "/" + self.structure[x].array.size + "]";
				} else {
					slider_text = self.structure[x].array[self.slider[(self.current_menu + "_" + x)]];
				}

				self.menu["slider_text"] set_text(slider_text);
			} else if(isDefined(self.structure[x].increment) && (self.cursor_index) == x) {
				if(!isDefined(self.slider[(self.current_menu + "_" + x)])) {
					self.slider[(self.current_menu + "_" + x)] = 0;
				}
				value = abs((self.structure[x].minimum - self.structure[x].maximum)) / 224;
				width = ceil((self.slider[(self.current_menu + "_" + x)] - self.structure[x].minimum) / value);

				if(width >= 0) {
					self.menu["slider"] set_shader("white", int(width), 16);
				} else {
					self.menu["slider"] set_shader("white", 0, 16);
					self.menu["slider"].alpha = 0;
				}

				if(!isDefined(self.slider[(self.current_menu + "_" + x)]) || self.slider[(self.current_menu + "_" + x)] < self.structure[x].minimum) {
					self.slider[(self.current_menu + "_" + x)] = self.structure[x].start;
				}

				slider_value = self.slider[(self.current_menu + "_" + x)];
				self.menu["slider_text"] set_text("" + slider_value);
				self.menu["slider"].alpha = 1;
			}

			if(isDefined(self.structure[x].command) && self.structure[x].command == ::new_menu) {
				self.menu["submenu_icon_" + i].alpha = 1;
			}

			if(!isDefined(self.structure[x].command)) {
				self.menu["option_" + i].color = (0.75, 0.75, 0.75);
			} else {
				if((self.cursor_index) == x) {
					self.menu["option_" + i].color = (0.75, 0.75, 0.75);
					self.menu["submenu_icon_" + i].color = (0.75, 0.75, 0.75);
				} else {
					self.menu["option_" + i].color = (0.5, 0.5, 0.5);
					self.menu["submenu_icon_" + i].color = (0.5, 0.5, 0.5);
				}
			}
		}
	}

	menu_height = int(18 + (self.maximum * 15));

	self.menu["description"].y = int((self.y_offset + 4) + ((self.maximum + 1) * 15));

	self.menu["border"] set_shader("white", self.menu["border"].width, int(menu_height + self.description_height));
	self.menu["background"] set_shader("white", self.menu["background"].width, int((menu_height - 2) + self.description_height));
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, int(menu_height - 17));
}

// Menu Options

menu_option() {
	self.structure = [];
	menu = self.current_menu;
	switch(menu) {
		case "Synergy":
			self set_title(menu);

			self add_option("Basic Options", undefined, ::new_menu, "Basic Options");
			self add_option("Fun Options", undefined, ::new_menu, "Fun Options");
			self add_option("Weapon Options", undefined, ::new_menu, "Weapon Options");
			self add_option("Perk Options", undefined, ::new_menu, "Perk Options");
			self add_option("Zombie Options", undefined, ::new_menu, "Zombie Options");
			self add_option("Powerup Options", undefined, ::new_menu, "Powerup Options");
			self add_option("Account Options", undefined, ::new_menu, "Account Options");
			self add_option("Open Doors", undefined, ::open_doors);
			self add_option("Menu Options", undefined, ::new_menu, "Menu Options");
			self add_option("All Players", undefined, ::new_menu, "All Players");

			break;
		case "Basic Options":
			self set_title(menu);

			self add_toggle("God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);
			self add_toggle("Infinite Ammo", undefined, ::infinite_ammo, self.infinite_ammo);
			self add_option("Point Options", undefined, ::new_menu, "Point Options");

			break;
		case "Fun Options":
			self set_title(menu);

			self add_toggle("Third Person", undefined, ::third_person, self.third_person);

			self add_option("Visions", undefined, ::new_menu, "Visions");

			break;
		case "Weapon Options":
			self set_title(menu);

			self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");
			self add_option("Give Weapon Variant", undefined, ::new_menu, "Give Weapon Variant");
			self add_toggle("Give Pack-a-Punched Weapons", "Weapons Given will be Pack-a-Punched", ::give_packed_weapon, self.give_packed_weapon);
			self add_option("Pack-a-Punch Current Weapon", "Held Weapon will be Pack-a-Punched", ::pack_weapon);
			self add_option("Un-Pack-a-Punch Current Weapon", "Held Weapon will be Un-Pack-a-Punched", ::unpack_weapon);

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				self add_option("Equip Attachment", undefined, ::new_menu, "Equip Attachment");
			}

			self add_option("Equip Camo", undefined, ::new_menu, "Equip Camo");

			self add_option("Take Current Weapon", undefined, ::take_weapon);
			self add_option("Drop Current Weapon", undefined, ::drop_weapon);

			break;
		case "Perk Options":
			self set_title(menu);

			self add_option("Give Perks", undefined, ::new_menu, "Give Perks");
			self add_option("Take Perks", undefined, ::new_menu, "Take Perks");
			self add_option("Give Perkaholic", undefined, ::give_perkaholic);
			self add_option("Take Perkaholic", undefined, ::take_perkaholic);

			self add_increment("Set Perk Limit", undefined, ::set_perk_limit, 4, 1, 6, 1);

			break;
		case "Zombie Options":
			self set_title(menu);

			self add_toggle("No Target", "Zombies won't Target You", ::no_target, self.no_target);

			self add_toggle("Zombie Counter", undefined, ::zombie_counter, self.zombie_counter);

			self add_option("Kill All Zombies", undefined, ::kill_all_zombies);
			self add_option("Teleport Zombies to Crosshair", undefined, ::teleport_zombies);

			self add_toggle("One Shot Zombies", undefined, ::one_shot_zombies, self.one_shot_zombies);
			self add_toggle("Freeze Zombies", undefined, ::freeze_zombies, self.freeze_zombies);

			self add_increment("Set Round Health Cap", "Cap Zombies Health to Specified Round", ::set_zombie_health_cap, 1, 1, 255, 1);
			self add_option("Reset Zombie Health Cap", "Set Health Cap back to Normal", ::reset_zombie_health_cap);

			self add_array("Zombie Outline Color", undefined, ::set_outline_color, ["None", "White", "Red", "Green"], true);

			break;
		case "Powerup Options":
			self set_title(menu);

			self add_toggle("Shoot Powerups", undefined, ::shoot_powerups, self.shoot_powerups);

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				self add_option("Spawn " + self.syn["powerups"][1][i], undefined, ::spawn_powerup, self.syn["powerups"][0][i]);
			}

			break;
		case "Account Options":
			self set_title(menu);

			self add_increment("Set Prestige", undefined, ::set_prestige, 0, 0, 20, 1);
			self add_increment("Set Level", undefined, ::set_rank, 1, 1, 999, 1);
			self add_increment("Set XP Scale", undefined, ::set_xp_scale, 1, 1, 10, 1);

			self add_option("Unlock All", undefined, ::unlock_all);
			self add_option("Unlock Tortured Path", undefined, ::unlock_tortured_path_chapters);

			break;
		case "Menu Options":
			self set_title(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 600, 5, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -100, 100, 5, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, ::hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

			break;
		case "All Players":
			self set_title(menu);

			foreach(player in level.players) {
				self add_option(player.name, undefined, ::new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self set_title(menu);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self add_option("Print", "Print Player Name", ::print_player_name, target);

				if(!target isHost()) {
					self add_option("Kick", "Kick the Player from the Game", ::kick_player, target);
				}
			} else {
				self add_option("Player not found");
			}

			break;
		case "Point Options":
			self set_title(menu);

			self add_increment("Set Point Increment", undefined, ::set_point_increment, 100, 100, 10000, 100);

			self add_increment("Set Points", undefined, ::set_points, 500, 0, 100000, self.point_increment);
			self add_increment("Add Points", undefined, ::add_points, 500, 500, 100000, self.point_increment);
			self add_increment("Take Points", undefined, ::take_points, 500, 500, 100000, self.point_increment);

			break;
		case "Visions":
			self set_title(menu);

			for(i = 0; i < self.syn["visions"][0].size; i++) {
				self add_option(self.syn["visions"][1][i], undefined, ::set_vision, self.syn["visions"][0][i]);
			}

			if(self.map_name == "the_darkest_shore") {
				self add_option("Distortion", undefined, ::set_vision, "mp_zombie_island_distort");
			}

			if(self.map_name == "the_darkest_shore") {
				self add_option("Moon Raven Green", undefined, ::set_vision, "mp_zombie_descent_moonravengreen");
				self add_option("Underwater", undefined, ::set_vision, "mp_zombie_descent_underwater");
			}

			break;
		case "Give Perks":
			self set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::give_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Take Perks":
			self set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::take_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Equip Attachment":
			self set_title(menu);

			self.equip_attachment_in_progress = true;

			self.syn["attachment_toggles"] = [];

			while(self getCurrentWeapon() == "none") {
				if(!isDefined(self.fail_counter)) {
					self.fail_counter = 0;
				}

				wait 0.05;

				self.fail_counter++;

				if(self.fail_counter > 10) {
					self.saved_index[self.current_menu] = self.cursor_index;
					self.saved_offset[self.current_menu] = self.scrolling_offset;
					self.saved_trigger[self.current_menu] = self.previous_trigger;
					self.equip_attachment_in_progress = false;
					self new_menu();
					self menu_option();
					set_options();
				}
			}

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				for(i = 0; i < weapon_attachments.size; i++) {
					self.syn["attachment_toggles"][i] = weapon_has_attachment(self getCurrentWeapon(), weapon_attachments[i]);
					self add_toggle(get_attachment_name(weapon_attachments[i]), undefined, ::equip_attachment, self.syn["attachment_toggles"][i], weapon_attachments[i]);
				}
			}

			self.equip_attachment_in_progress = false;

			break;
		case "Equip Camo":
			self set_title(menu);

			self add_option("Challenge Camos", undefined, ::new_menu, "Challenge Camos");
			self add_option("Operation Overlord Camos", undefined, ::new_menu, "Operation Overlord Camos");
			self add_option("Zombies Camos", undefined, ::new_menu, "Zombies Camos");
			self add_option("Special Camos", undefined, ::new_menu, "Special Camos");
			self add_option("Misc Camos", undefined, ::new_menu, "Misc Camos");

			break;
		case "Challenge Camos":
			self set_title(menu);

			self add_option("None", "0", ::equip_camo, 0);

			for(i = 0; i < self.syn["camos"][0].size; i++) {
				self add_option(self.syn["camos"][1][i], "" + self.syn["camos"][0][i], ::equip_camo, self.syn["camos"][0][i]);
			}

			break;
		case "Operation Overlord Camos":
			self set_title(menu);

			self add_option("None", "0", ::equip_camo, 0);

			for(i = 0; i < self.syn["camos"][2].size; i++) {
				self add_option(self.syn["camos"][3][i], "" + self.syn["camos"][2][i], ::equip_camo, self.syn["camos"][2][i]);
			}

			break;
		case "Zombies Camos":
			self set_title(menu);

			self add_option("None", "0", ::equip_camo, 0);

			for(i = 0; i < self.syn["camos"][4].size; i++) {
				self add_option(self.syn["camos"][5][i], "" + self.syn["camos"][4][i], ::equip_camo, self.syn["camos"][4][i]);
			}

			break;
		case "Special Camos":
			self set_title(menu);

			self add_option("None", "0", ::equip_camo, 0);

			for(i = 0; i < self.syn["camos"][6].size; i++) {
				self add_option(self.syn["camos"][7][i], "" + self.syn["camos"][6][i], ::equip_camo, self.syn["camos"][6][i]);
			}

			break;
		case "Misc Camos":
			self set_title(menu);

			self add_option("None", "0", ::equip_camo, 0);

			for(i = 0; i < self.syn["camos"][8].size; i++) {
				self add_option(self.syn["camos"][9][i], "" + self.syn["camos"][8][i], ::equip_camo, self.syn["camos"][8][i]);
			}

			break;
		case "Give Weapon Variant":
			self set_title(menu);

			self add_increment("Set Condition", undefined, ::set_weapon_condition, 2, 1, 2, 1);

			foreach(category in self.syn["weapons"]["category"][0]) {
				if(category != "extras" && category != "equipment") {
					for(i = 0; i < self.syn["weapons"][category][0].size; i++) {
						self add_array(self.syn["weapons"][category][1][i] + " Variants", undefined, ::give_weapon_variant, [1, 2, 3, 4], true, true, self.syn["weapons"][category][0][i]);
					}
				}
			}

			break;
		case "Give Weapons":
			self set_title(menu);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self add_option(self.syn["weapons"]["category"][1][i], undefined, ::new_menu, self.syn["weapons"]["category"][1][i]);
			}

			self add_option("Melee Weapons", undefined, ::new_menu, "Melee Weapons");
			self add_option("Equipment", undefined, ::new_menu, "Equipment");
			self add_option("Extras", undefined, ::new_menu, "Extras");

			break;
		case "Assault Rifles":
			self set_title(menu);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self set_title(menu);

			load_weapons("sub_machine_guns");

			self add_option("The Classic", undefined, ::give_weapon, "ppsh41_classic_zm+extended_mag", true);

			break;
		case "Light Machine Guns":
			self set_title(menu);

			load_weapons("light_machine_guns");

			if(self.map_name == "the_frozen_dawn") {
				self add_option("The Vintage", undefined, ::give_weapon, "mg42_vintage_zm+extended_mag_mg42");
			}

			break;
		case "Sniper Rifles":
			self set_title(menu);

			load_weapons("sniper_rifles");

			break;
		case "Shotguns":
			self set_title(menu);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self set_title(menu);

			load_weapons("pistols");

			break;
		case "Launchers":
			self set_title(menu);

			load_weapons("launchers");

			break;
		case "Melee Weapons":
			self set_title(menu);

			self add_option("US Shovel", undefined, ::give_weapon, "shovel");

			if(self.map_name == "the_darkest_shore" || self.map_name == "the_shadowed_throne" || self.map_name == "the_frozen_dawn") {
				self add_option("Ripsaw Melee", undefined, ::give_weapon, "razergun_melee");
			}

			if(self.map_name == "the_final_reich" || self.map_name == "the_darkest_shore" || self.map_name == "the_shadowed_throne") {
				self add_option("Raven Sword", undefined, ::give_weapon, "raven_sword");
			}

			if(self.map_name == "the_shadowed_throne" || self.map_name == "tortured_path_1" || self.map_name == "tortured_path_2" || self.map_name == "tortured_path_3") {
				self add_option("Baseball Bat", undefined, ::give_weapon, "zom_dlc2_1");
				self add_option("Trench Knife", undefined, ::give_weapon, "zom_dlc2_2");
				self add_option("Pickaxe", undefined, ::give_weapon, "zom_dlc2_3");
				self add_option("Blade", undefined, ::give_weapon, "zom_dlc2_4");
			}

			if(self.map_name == "tortured_path_1" || self.map_name == "tortured_path_2" || self.map_name == "tortured_path_3") {
				self add_option("Sword of Barbarossa", undefined, ::give_weapon, "zom_dlc3_5");
			}

			if(self.map_name == "the_frozen_dawn") {
				self add_option("Thulian Scythe", undefined, ::give_weapon, "zom_dlc4_scythe");
				self add_option("Fanf of An'heist", undefined, ::give_weapon, "zom_dlc4_scythe_emp");
				self add_option("Thulian Shield", undefined, ::give_weapon, "zom_dlc4_shield");
				self add_option("Roar of Sang'ket", undefined, ::give_weapon, "zom_dlc4_shield_emp");
				self add_option("Broken Flail", undefined, ::give_weapon, "zom_dlc4_spike");
				self add_option("Talon of Lu'roth", undefined, ::give_weapon, "zom_dlc4_spike_emp");
				self add_option("Thulian Hammer", undefined, ::give_weapon, "zom_dlc4_hammer");
				self add_option("Fist of Tal'rek", undefined, ::give_weapon, "zom_dlc4_hammer_emp");
			}

			break;
		case "Equipment":
			self set_title(menu);

			self add_option("Jack-in-the-Box", undefined, ::give_jacks);

			self add_option("Frag Grenade", undefined, ::give_equipment, "frag_grenade_zm");
			self add_option("Semtex Grenade", undefined, ::give_equipment, "semtex_zm");
			self add_option("Bouncing Betty", undefined, ::give_equipment, "bouncingbetty_zm");
			self add_option("Throwing Knife", undefined, ::give_equipment, "throwingknife_zm");
			self add_option("C4", undefined, ::give_equipment, "c4_zm");

			if(self.map_name == "the_darkest_shore") {
				self add_option("Island Grenade", undefined, ::give_equipment, "island_grenade_hc_zm");
			}

			if(self.map_name == "the_frozen_dawn") {
				self add_option("Corpse Eater Grenade", undefined, ::give_equipment, "corpse_eater_dlc4_zm");
				self add_option("Scythe Shard", undefined, ::give_equipment, "scythe_shard_zm");
				self add_option("Throwing Hammer", undefined, ::give_equipment, "zom_hammer_grenade_zm");
				self add_option("Throwing Hammer (Left)", undefined, ::give_equipment, "throwinghammer_lhand_zm");
				self add_option("Throwing Hammer (Right)", undefined, ::give_equipment, "throwinghammer_rhand_zm");
				self add_option("Moon Orb Grenade", undefined, ::give_equipment, "zom_moonorb_grenade_zm");
				self add_option("Moon Orb Grenade EMP", undefined, ::give_equipment, "zom_moonorb_grenade_emp_zm");
			}

			break;
		case "Extras":
			self set_title(menu);

			self add_option("Tesla Gun", undefined, ::give_weapon, "teslagun");
			self add_option("Midnight", undefined, ::give_weapon, "teslagun_zm_moon", true);
			self add_option("Reaper", undefined, ::give_weapon, "teslagun_zm_death", true);
			self add_option("Hurricane", undefined, ::give_weapon, "teslagun_zm_storm", true);
			self add_option("Bloodthirst", undefined, ::give_weapon, "teslagun_zm_blood", true);

			if(self.map_name == "the_darkest_shore" || self.map_name == "the_shadowed_throne" || self.map_name == "the_frozen_dawn" || self.map_name == "tortured_path_1" || self.map_name == "tortured_path_2" || self.map_name == "tortured_path_3") {
				self add_option("Ripsaw", undefined, ::give_weapon, "razergun");
			}

			if(self.map_name == "the_shadowed_throne") {
				self add_option("Wunderbuss", undefined, ::give_weapon, "alt+wunderbuss");
			}

			if(self.map_name == "the_frozen_dawn") {
				self add_option("Raven Gun", undefined, ::give_weapon, "raven_gun");
			}

			break;
		default:
			break;
	}
}

// Basic Options

god_mode() {
	self.god_mode = !return_toggle(self.god_mode);
	if(self.god_mode) {
		iPrintString("God Mode [^2ON^7]");
	} else {
		iPrintString("God Mode [^1OFF^7]");
	}
}

frag_no_clip() {
	self endon("disconnect");
	self endon("game_ended");

	if(!isDefined(self.frag_no_clip)) {
		self.frag_no_clip = true;
		iPrintString("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
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
		iPrintString("Frag No Clip [^1OFF^7]");
	}
}

frag_no_clip_loop() {
	self endon("disconnect");
	self endon("noclip_end");

	self disableWeapons();
	self disableOffHandWeapons();
	self.frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.god_mode) || !self.god_mode) {
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
		self.temp_god_mode = undefined;
	}

	self.frag_no_clip_loop = undefined;
}

infinite_ammo() {
	self.infinite_ammo = !return_toggle(self.infinite_ammo);
	if(self.infinite_ammo) {
		iPrintString("Infinite Ammo [^2ON^7]");
		self thread infinite_ammo_loop();
	} else {
		iPrintString("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

infinite_ammo_loop() {
	self endon("stop_infinite_ammo");
	self endon("game_ended");

	for(;;) {
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);
		self setWeaponAmmoClip(self getCurrentWeapon(), 999, "left");
		self setWeaponAmmoClip(self getCurrentWeapon(), 999, "right");

		wait 0.2;
	}
}

set_point_increment(value) {
	self.point_increment = value;
}

set_points(value) {
	self maps\mp\gametypes\zombies::_id_7D63(value);
}

add_points(value) {
	self maps\mp\gametypes\zombies::_id_4798(value);
}

take_points(value) {
	self maps\mp\gametypes\zombies::_id_90F5(value);
}

// Fun Options

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
		iPrintString("Third Person [^2ON^7]");
		setDvar("311", 1);
		setthirdpersondof(1);
	} else {
		iPrintString("Third Person [^1OFF^7]");
		setDvar("311", 0);
		setthirdpersondof(0);
	}
}

set_vision(vision) {
	self visionSetNakedForPlayer("", 0.1);
	wait 0.25;
	self visionSetNakedForPlayer(vision, 0.1);
}

// Player Options

player_option(menu, player) {
	if(!isDefined(menu) || !isDefined(player) || !isPlayer(player)) {
		menu = "Error";
	}

	switch (menu) {
		case "Player Option":
			self set_title(clean_name(player get_name()));
			break;
		case "Error":
			self set_title();
			self add_option("Oops, Something Went Wrong!", "Condition: Undefined");
			break;
		default:
			error = true;
			if(error) {
				self set_title("Critical Error");
				self add_option("Oops, Something Went Wrong!", "Condition: Menu Index");
			}
			break;
	}
}

get_name() {
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

clean_name(name) {
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = ["^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "^:"];
	new_string = "";
	for(a = 0; a < name.size; a++) {
		if(a < (name.size - 1)) {
			if(in_array(illegal, (name[a] + name[(a + 1)]))) {
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

print_player_name(target) {
	iPrintString(target);
}

commit_suicide(target) {
	target suicide();
}

kick_player(target) {
	kick(target getEntityNumber());
}

// Powerup Options

spawn_powerup(powerup) {
	maps\mp\gametypes\zombies::_id_281C(powerup, self.origin + anglesToForward(self.angles) * 115);
}

shoot_powerups() {
	self.shoot_powerups = !return_toggle(self.shoot_powerups);
	if(self.shoot_powerups) {
		iPrintString("Shoot Powerups [^2ON^7]");
		shoot_powerups_loop();
	} else {
		iPrintString("Shoot Powerups [^1OFF^7]");
		self notify("stop_shoot_powerups");
	}
}

shoot_powerups_loop() {
	self endon("stop_shoot_powerups");
	self endon("game_ended");

	for(;;) {
		while(self attackButtonPressed()) {
			powerup = self.syn["powerups"][0][randomint(self.syn["powerups"][0].size)];
			maps\mp\gametypes\zombies::_id_281C(powerup, get_bullet_trace_position());
			wait 0.5;
		}
		wait 0.05;
	}
}

// Menu Options

iPrintString(string) {
	if(!isDefined(self.syn["string"])) {
		self.syn["string"] = self create_text(string, "default", 1, "center", "top", 0, -100, (1, 1, 1), 1, 9999, true);
	} else {
		self.syn["string"] set_text(string);
	}
	self.syn["string"] notify("stop_hud_fade");
	self.syn["string"].alpha = 1;
	self.syn["string"] setText(string);
	self.syn["string"] thread fade_hud(0, 2.5);
}

fade_hud(alpha, time) {
	self endon("stop_hud_fade");
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

modify_menu_position(offset, axis) {
	if(axis == "x") {
		self.x_offset = 175 + offset;
	} else {
		self.y_offset = 160 + offset;
	}
	self close_menu();
	self open_menu();
}

set_menu_rainbow() {
	if(!isString(self.color_theme)) {
		self.color_theme = "rainbow";
		self.menu["border"] thread start_rainbow();
		self.menu["separator_1"] thread start_rainbow();
		self.menu["separator_2"] thread start_rainbow();
		self.menu["border"].color = self.color_theme;
		self.menu["separator_1"].color = self.color_theme;
		self.menu["separator_2"].color = self.color_theme;
	}
}

set_menu_color(value, color) {
	if(color == "Red") {
		self.menu_color_red = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Green") {
		self.menu_color_green = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Blue") {
		self.menu_color_blue = value;
		iPrintString(color + " Changed to " + value);
	} else {
		iPrintString(value + " | " + color);
	}
	self.color_theme = (self.menu_color_red / 255, self.menu_color_green / 255, self.menu_color_blue / 255);
	self.menu["border"] notify("stop_rainbow");
	self.menu["separator_1"] notify("stop_rainbow");
	self.menu["separator_2"] notify("stop_rainbow");
	self.menu["border"].rainbow_enabled = false;
	self.menu["separator_1"].rainbow_enabled = false;
	self.menu["separator_2"].rainbow_enabled = false;
	self.menu["border"].color = self.color_theme;
	self.menu["separator_1"].color = self.color_theme;
	self.menu["separator_2"].color = self.color_theme;
}

hide_ui() {
	self.hide_ui = !return_toggle(self.hide_ui);
	setDvar("cg_draw2d", !self.hide_ui);
}

hide_weapon() {
	self.hide_weapon = !return_toggle(self.hide_weapon);
	setDvar("cg_drawgun", !self.hide_weapon);
}

// Perk Options

give_perk(perk) {
	if(!self _hasperk(perk)) {
		splash_id = "";
		switch(perk) {
			case "fastreload":
				_id_056A::_id_47B5();
				splash_id = "zm_collectible_splash_1";
				break;
			case "punchperk":
				_id_056A::_id_47B0();
				splash_id = "zm_collectible_splash_2";
				break;
			case "runperk":
				_id_056A::_id_47B8();
				splash_id = "zm_collectible_splash_3";
				break;
			case "quickrevive":
				_id_056A::_id_47B1();
				splash_id = "zm_collectible_splash_4";
				break;
			case "electriccherry":
				_id_056A::_id_4785();
				splash_id = "zm_collectible_splash_5";
				break;
			case "doubletap":
				_id_056A::_id_4784();
				splash_id = "zm_collectible_splash_6";
				break;
		}
	}
}

take_perk(perk) {
	switch(perk) {
		case "fastreload":
			_id_056A::_id_95F1();
			break;
		case "punchperk":
			_id_056A::_id_95EF();
			break;
		case "runperk":
			_id_056A::_id_95F3();
			break;
		case "quickrevive":
			_id_056A::_id_95F0();
			break;
		case "electriccherry":
			_id_056A::_id_95D5();
			break;
		case "doubletap":
			_id_056A::_id_95D3();
			break;
	}
}

give_perkaholic() {
	foreach(perk in self.syn["perks"][0]) {
		give_perk(perk);
	}
}

take_perkaholic() {
	foreach(perk in self.syn["perks"][0]) {
		take_perk(perk);
	}
}

set_perk_limit(value) {
	level._id_5F5A = 1;
	self setClientOmnvar("zm_blitz_items_limit", value);
}

// Weapon Options

get_weapon_attachments() {
	weapon = self getCurrentWeapon();

	if(isSubStr(weapon, "+")) {
		weapon = strtok(weapon, "+")[0];
	}

	if(isSubStr(weapon, "_")) {
		weapon = strtok(weapon, "_")[0];
	}

	attachments = [];

	if(in_array(self.syn["weapons"]["assault_rifles"][0], weapon)) {
		if(weapon == "fg42" || weapon == "m1941") {
			attachments = self.syn["attachments"]["assault_rifles_alt"][0];
		} else {
			attachments = self.syn["attachments"]["assault_rifles"][0];
		}
	} else if(in_array(self.syn["weapons"]["sub_machine_guns"][0], weapon)) {
		if(weapon == "zm393") {
			attachments = self.syn["attachments"]["zm393"][0];
		} else {
			attachments = self.syn["attachments"]["sub_machine_guns"][0];
		}
	} else if(in_array(self.syn["weapons"]["light_machine_guns"][0], weapon)) {
		attachments = self.syn["attachments"]["light_machine_guns"][0];
	} else if(in_array(self.syn["weapons"]["sniper_rifles"][0], weapon)) {
		attachments = self.syn["attachments"]["sniper_rifles"][0];
	} else if(in_array(self.syn["weapons"]["shotguns"][0], weapon)) {
		if(weapon == "blunderbuss") {
			attachments = self.syn["attachments"]["blunderbuss"][0];
		} else if(weapon == "m30" || weapon == "model21") {
			attachments = self.syn["attachments"]["shotguns_alt"][0];
		} else {
			attachments = self.syn["attachments"]["shotguns"][0];
		}
	} else if(in_array(self.syn["weapons"]["pistols"][0], weapon)) {
		if(weapon == "reich" || weapon == "enfieldno2") {
			attachments = self.syn["attachments"]["pistols_alt"][0];
		} else {
			attachments = self.syn["attachments"]["pistols"][0];
		}
	} else if(weapon == "dp28") {
		attachments = self.syn["attachments"]["crossbow"][0];
	}

	return attachments;
}

weapon_has_attachment(weapon, attachment) {
	equipped_attachments = get_equipped_attachments(self, weapon, true);

	if(in_array(equipped_attachments, attachment)) {
		return true;
	}

	equipped_attachments = get_equipped_attachments(self, weapon);

	if(isSubStr(equipped_attachments, attachment)) {
		return true;
	}

	return false;
}

get_equipped_attachments(target, weapon, return_array) {
	if(!isDefined(target)) {
		target = self;
	}

	if(isSubStr(weapon, "+")) {
		weapon_split = strtok(weapon, "+");
		if(isDefined(return_array) && return_array) {
			weapon_attachments = [];
		} else {
			weapon_attachments = "";
		}

		for(i = 1; i < weapon_split.size; i++) {
			if(isDefined(return_array) && return_array) {
				weapon_attachments[weapon_attachments.size] = weapon_split[i];
			} else {
				weapon_attachments = weapon_attachments + "+" + weapon_split[i];
			}
		}
	} else {
		if(isDefined(return_array) && return_array) {
			weapon_attachments = [];
		} else {
			weapon_attachments = "";
		}
	}

	return weapon_attachments;
}

get_attachment_name(attachment) {
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
	return attachment;
}

equip_attachment(attachment) {
	weapon = self getCurrentWeapon();

	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);

	attachments = get_equipped_attachments(self, weapon, true);
	weapon_attachments = "";
	condition = "";
	attachment_named = undefined;
	attachment_named_aperture = undefined;
	attachment_named_telescopic = undefined;

	if(isSubStr(weapon, "+")) {
		weapon = strtok(weapon, "+")[0];
	}

	if(isSubStr(weapon, "_")) {
		weapon_name = strtok(weapon, "_")[0];
	} else {
		weapon_name = "";
	}


	if(attachment == "akimbo" && weapon_name == "m712") {
		attachment = "akimbo_fullauto";
	} else if(attachment == "iron_sight_sniper" && weapon_name == "mosin") {
		attachment = "iron_sight_sniper_mosin";
	} else if(attachment == "lens_sight" && weapon_name == "ribeyrolles") {
		attachment = "lens_sight_ribeyrolles";
	}

	if(attachment == "aperture_sight" || attachment == "telescopic_sight") {
		if(in_array(self.syn["named_attachments"][attachment], weapon_name)) {
			attachment_named = attachment + "_" + weapon_name;
		}
	}

	if(isArray(attachments)) {
		if(in_array(attachments, attachment)) {
			attachments = remove_from_array(attachments, attachment);
		} else {
			if(in_array(self.syn["optics"], attachment)) {
				foreach(optic in self.syn["optics"]) {
					if(in_array(attachments, optic)) {
						attachments = remove_from_array(attachments, optic);
					}
					if(in_array(attachments, attachment + "_" + weapon_name)) {
						attachments = remove_from_array(attachments, attachment + "_" + weapon_name);
					}
					if(in_array(attachments, "aperture_sight_" + weapon_name)) {
						attachments = remove_from_array(attachments, "aperture_sight_" + weapon_name);
					}
					if(in_array(attachments, "telescopic_sight_" + weapon_name)) {
						attachments = remove_from_array(attachments, "telescopic_sight_" + weapon_name);
					}
				}
			}

			if(isDefined(attachment_named)) {
				attachment = attachment_named;
			}


			attachments[attachments.size] = attachment;
		}

		attachments = alphabetize(attachments);

		for(i = 0; i < attachments.size; i++) {
			if(isSubStr(attachments[i], "camo")) {
				self.saved_camo = strtok(attachments[i], "camo")[0];
			} else if(isSubStr(attachments[i], "cond")) {
				condition = "+cond" + strtok(attachments[i], "cond")[0];
			} else {
				weapon_attachments = weapon_attachments + "+" + attachments[i];
			}
		}
	}

	weapon = weapon + weapon_attachments + condition;

	self takeWeapon(self getCurrentWeapon());
	self giveWeapon(weapon);

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
	self switchToWeapon(weapon);

	wait 0.1;

	if(isDefined(self.saved_camo)) {
		equip_camo(self.saved_camo);
	}
}

give_packed_weapon() {
	self.give_packed_weapon = !return_toggle(self.give_packed_weapon);
}

pack_weapon(target) {
	if(!isDefined(target)) {
		target = self;
	}

	weapon = target getCurrentWeapon();

	if(isSubStr(weapon, "_")) {
		weapon = strtok(weapon, "_")[0];
	}

	self.pack_weapon = 1;
	give_weapon(weapon);
}

unpack_weapon(target) {
	if(!isDefined(target)) {
		target = self;
	}

	if(isSubStr(target getCurrentWeapon(), "+")) {
		weapon_split = strtok(target getCurrentWeapon(), "+");
		weapon = weapon_split[0];
		weapon_attachments = get_equipped_attachments(target, weapon);
	} else {
		weapon = target getCurrentWeapon();
		weapon_attachments = "";
	}


	if(isSubStr(weapon, "_")) {
		weapon_packed = strtok(weapon, "_")[0];
	} else {
		weapon_packed = weapon;
	}


	weapon_packed = weapon_packed + "_zm" + weapon_attachments;
	if(check_weapons(weapon_packed)) {
		target take_weapon(target getCurrentWeapon());
		target giveWeapon(weapon_packed);


		target switchToWeapon(weapon_packed);
	} else {
		target switchToWeapon(weapon);
	}
}

get_max_weapons() {
  if(_id_0547::_id_4BA7("specialty_class_mule_kick_zm")) {
    return 3;
	}

  return 2;
}

is_packed(weapon) {
  if(isSubStr(weapon, "_pap")) {
    return true;
	}

  return false;
}

give_jacks() {
	self thread _id_057D::_id_4766();
	self setWeaponAmmoClip("jack_in_box_decoy_zm", 3);
}

give_equipment(weapon) {
	self setLethalWeapon(weapon);
	self giveWeapon(weapon);
	self setWeaponAmmoClip(weapon, 8);
}

give_weapon(weapon, is_finished_weapon) {
	backup_weapon = self getCurrentWeapon();
	if(((isDefined(self.give_packed_weapon) && self.give_packed_weapon == 1) || (isDefined(self.pack_weapon) && self.pack_weapon == 1)) && !(isDefined(is_finished_weapon) && is_finished_weapon == true)) {
		if(!is_packed(weapon)) {
			weapon = weapon + "_pap";
		}
	}

	if(!(isDefined(is_finished_weapon) && is_finished_weapon == true)) {
		weapon = weapon + "_zm";
	}

	if(!self hasWeapon(weapon)) {
		saved_weapon = undefined;

		if(in_array(self.syn["weapons"]["blacklisted_weapons"], weapon)) {
			saved_weapon = self getCurrentWeapon();
			self takeWeapon(self getCurrentWeapon());
		} else {
			if(self getWeaponListPrimaries().size >= get_max_weapons()) {
				self takeWeapon(self getCurrentWeapon());
			}
		}


		self giveWeapon(weapon);
		self switchToWeapon(weapon);

		if(isDefined(saved_weapon)) {
			wait 0.5;
			self giveWeapon(saved_weapon);
			self switchToWeaponImmediate(saved_weapon);
			saved_weapon = undefined;
		}
	} else {
		self switchToWeaponImmediate(weapon);
	}

	self.pack_weapon = 0;
	wait 0.5;
	self giveStartAmmo(weapon);

	while(self getCurrentWeapon() == "none") {
		if(!isDefined(self.fail_counter)) {
			self.fail_counter = 0;
		}

		wait 0.05;

		self.fail_counter++;

		if(self.fail_counter > 10) {
			self giveWeapon(backup_weapon);
		}
	}
}

set_weapon_condition(value) {
	self.weapon_condition = value;
}

give_weapon_variant(variant, weapon) {
	weapon_attachments = "";
	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon == 1) {
		weapon = weapon + "_loot" + variant + "_pap_zm" + weapon_attachments + "+cond" + self.weapon_condition;
	} else {
		weapon = weapon + "_loot" + variant + "_zm" + weapon_attachments + "+cond" + self.weapon_condition;
	}

	give_weapon(weapon, true);
}

check_weapons(weapon) {
	return self getCurrentWeapon() != weapon && self getWeaponListPrimaries()[1] != weapon && self getWeaponListPrimaries()[2] != weapon;
}

equip_camo(camo) {
	camo = int(camo);

	weapon = self getCurrentWeapon();

	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);

	if(isSubStr(self getCurrentWeapon(), "+")) {
		weapon_split = strtok(self getCurrentWeapon(), "+");
		weapon_attachments = get_equipped_attachments(self, self getCurrentWeapon());
		weapon = weapon_split[0];
	} else {
		weapon = self getCurrentWeapon();
		weapon_attachments = "";
	}


	if(camo < 10) {
		camo = "00" + camo;
	} else if(int(camo) > 9 && int(camo) < 100) {
		camo = "0" + camo;
	}


	weapon_painted = weapon + weapon_attachments + "+camo" + camo;
	if(check_weapons(weapon_painted)) {
		self take_weapon(self getCurrentWeapon());
		self give_weapon(weapon_painted, true);

		self switchToWeapon(weapon_painted);
	} else {
		self switchToWeapon(weapon);
	}

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
}

take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponListPrimaries()[1]);
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
}

// Map Options

open_doors() { // Psalm 91
	foreach(door in level._id_AC1D) {
		door notify("open");
	}
}

// Zombie Options

get_zombies() {
	return _id_053C::_id_4F88();
}

no_target() {
	self.no_target = !return_toggle(self.no_target);
	if(self.no_target) {
		iPrintString("No Target [^2ON^7]");
		self._id_AC5C = 1;
		self._id_AC5B = 1;
		self notify("zombiesIgnoreMeChanged", 1);
	} else {
		iPrintString("No Target [^1OFF^7]");
		self._id_AC5C = 0;
		self._id_AC5B = 0;
		self notify("zombiesIgnoreMeChanged", 0);
	}
}

kill_all_zombies() {
	foreach(zombie in get_zombies()) {
		zombie doDamage(zombie.health + 999, zombie.origin);
	}
}

teleport_zombies() {
	foreach(zombie in get_zombies()) {
		zombie setOrigin(get_bullet_trace_position());
	}
}

one_shot_zombies() {
	if(!isDefined(self.one_shot_zombies)) {
		iPrintString("One Shot Zombies [^2ON^7]");
		self.one_shot_zombies = true;
		zombies = get_zombies();
		level.prevHealth = zombies[0].health;
		while(isDefined(self.one_shot_zombies)) {
			foreach(zombie in get_zombies()) {
				zombie.maxHealth = 1;
				zombie.health = zombie.maxHealth;
			}
			wait 0.01;
		}
	} else {
		iPrintString("One Shot Zombies [^1OFF^7]");
		self.one_shot_zombies = undefined;
		foreach(zombie in get_zombies()) {
			zombie.maxHealth = level.prevHealth;
			zombie.health = level.prevHealth;
		}
	}
}

freeze_zombies() {
	if(!isDefined(self.freeze_zombies)) {
		iPrintString("Freeze Zombies [^2ON^7]");
		self.freeze_zombies = true;
		while(isDefined(self.freeze_zombies)) {
			foreach(zombie in get_zombies()) {
				zombie freezeControls(true);
			}
			wait 0.01;
		}
	} else {
		iPrintString("Freeze Zombies [^1OFF^7]");
		self.freeze_zombies = undefined;
		foreach(zombie in get_zombies()) {
			zombie freezeControls(false);
		}
	}
}

get_remaining_zombies() {
	check_remaining_zombies();
	for(;;) {
		level.remaining_zombies = 0;
		level.zombies_to_spawn_zeroed = false;
    level waittill("zombie_wave_started");
  }
}

check_remaining_zombies() {
	while(level.zombies_to_spawn == 0) {
		level.zombies_to_spawn = level._id_AC12 maps\mp\_utility::_id_5DCB();
		level.remaining_zombies = _id_0547::_id_408F().size;
		wait 0.01;
	}
	level.zombies_to_spawn++;
	level.zombies_to_spawn_zeroed = false;

	for(;;) {
		if(level.zombies_to_spawn != 0 && !level.zombies_to_spawn_zeroed) {
			level.zombies_to_spawn = level._id_AC12 maps\mp\_utility::_id_5DCB();
		} else {
			level.zombies_to_spawn_zeroed = true;
		}

    spawned_zombies = _id_0547::_id_408F().size;
    zombies_to_respawn = level._id_ABEC maps\mp\_utility::_id_5DCB();
    var_2 = level._id_ABED maps\mp\_utility::_id_5DCB();

		if(!isDefined(spawned_zombies)) {
			spawned_zombies = 0;
		}
		if(!isDefined(zombies_to_respawn)) {
			zombies_to_respawn = 0;
		}
		if(!isDefined(var_2)) {
			var_2 = 0;
		}

    level.remaining_zombies = level.zombies_to_spawn + spawned_zombies + zombies_to_respawn + var_2;
    wait 2.5;
  }
}

zombie_counter() {
	if(!isDefined(self.zombie_counter)) {
		self thread get_remaining_zombies();
		self.zombie_counter = true;
		while(isDefined(self.zombie_counter)) {
			count = level.remaining_zombies;
			if(!isDefined(count)) {
				count = 0;
			}
			if(!isDefined(self.syn["counter"])) {
				self.syn["counter"] = self create_text("Zombies Remaining: " + count, "default", 1, "right", "top", 349, -220, (0.65, 0.64, 0.56), 1, 9999, false);
			} else {
				self.syn["counter"] set_text("Zombies Remaining: " + count);
			}
			wait 0.01;
		}
	} else {
		self.zombie_counter = undefined;
		self.syn["counter"] destroy();
	}
}

calculate_health(round_number) {
	return int(maps\mp\gametypes\zombies::_id_1E59(_id_0547::_id_0A51("zombie_generic"), (round_number - 1)));
}

reset_zombie_health_cap() {
	self notify("stop_zombie_health_cap");
	wait 0.5;
	level.zombie_health = calculate_health(level.currentWave);
	foreach(zombie in get_zombies()) {
		if(zombie._id_0A4B == "zombie_generic") {
			zombie.maxHealth = level.zombie_health;
			zombie.health = level.zombie_health;
		}
	}
}

set_zombie_health_cap(round) {
	iPrintString("Set Round " + round + " Health Cap");
	self notify("stop_zombie_health_cap");
	wait 0.5;
	self thread zombie_health_cap_loop(round, calculate_health(round));
}

zombie_health_cap_loop(round, health_cap) {
	self endon("stop_zombie_health_cap");
	level endon("game_ended");
	for(;;) {
		if(round < level.currentWave) {
			foreach(zombie in get_zombies()) {
				if(zombie._id_0A4B == "zombie_generic") {
					if(zombie.maxHealth > health_cap) {
						zombie.maxHealth = health_cap;
					}
					if(zombie.health > health_cap) {
						zombie.health = health_cap;
					}
				}
			}
		}
		wait 1;
	}
}

set_outline_color(color) {
	if(color == "White") {
		self.outline_color = 0;
	} else if(color == "Red") {
		self.outline_color = 1;
	} else if(color == "Green") {
		self.outline_color = 2;
	}

	if(!isDefined(self.outline_zombies) && color != "None") {
		iPrintString("Zombie ESP [^2ON^7]");
		self.outline_zombies = true;
		outline_zombies_loop();
	} else if(color == "None") {
		iPrintString("Zombie ESP [^1OFF^7]");
		self notify("stop_outline_zombies");
		self.outline_zombies = undefined;
		wait 0.3;
		foreach(zombie in get_zombies()) {
			zombie hudoutlinedisableforclient(self);
		}
	}
}

outline_zombies_loop() {
	self endon("stop_outline_zombies");
	self endon("game_ended");

	for(;;) {
		foreach(zombie in get_zombies()) {
			zombie hudoutlineenableforclient(self, self.outline_color, 1);
		}
		wait 0.2;
	}
}

// Account Options

set_prestige(value) { // Lazy Dev
	self setPlayerData(_id_46AE(), "prestigeLevel", value);
}

set_rank(value) { // Lazy Dev
	if(value > 55) {
		self setPlayerData(_id_46AE(), "totalXP", int(tablelookup("mp/cp_ranktable.csv", 0, (value - 2), 7)));
		self setPlayerData(_id_46AE(), "prestigeLevel", 10);
	} else {
		self setPlayerData(_id_46AE(), "totalXP", int(tablelookup("mp/cp_ranktable.csv", 0, (value - 2), 7)));
	}
}

set_xp_scale(xpScale) {
	iPrintString("XP Multiplier Set to [^3" + xpScale + "x^7]");

	level.rankscale = xpScale;
	level.weaponrankscale = xpScale;
	level.divisionrankscale = xpScale;

	setDvar("party_rankXPScale", xpScale);
	setDvar("party_weaponXPScale", xpScale);
	setDvar("party_divisionXPScale", xpScale);
}

unlock_all() { // CF4_99
	self iPrintString("Unlock All Started");
	foreach(challengeRef, challengeData in level.challengeInfo) {
		finalTarget = 0;
		finalTier = 0;

		for(tierId = 1;isDefined(challengeData["targetval"][tierId]); tierId++) {
			finalTarget = challengeData["targetval"][tierId];
			finalTier   = tierId + 1;
		}

		self setPlayerData(_id_46AE(), "challengeProgress", challengeRef, finalTarget);
		self setPlayerData(_id_46AE(), "challengeState", challengeRef, finalTier);
		wait 0.01;
	}

	self iPrintString("Unlock All Complete");
}

unlock_tortured_path_chapters() { // Psalm 91
	self endon("disconnect");
	var_pd = _id_46A8();
	self setPlayerData(var_pd, "zmShatteredRecord", "mapCompleted", 7);
	self setPlayerData(var_pd, "zmShatteredRecord", "ETDMapInfo", 7);
	self setPlayerData(var_pd, "zmShatteredRecord", "hasCompletedEESequence", 1);
	self setPlayerData(var_pd, "zmShatteredRecord", "isMapInSequence", 1);
	self setPlayerData(var_pd, "zmShatteredRecord", "isEEInSequence", 1);
	self setPlayerData(var_pd, "zmShatteredRecord", "isRedSkullInSequence", 1);
	self setPlayerData(var_pd, "zmShatteredRecord", "prevWinStatus", 1);
	var_map_ids = [];
	var_map_ids[0] = 5;
	var_map_ids[1] = 6;
	var_map_ids[2] = 7;
	for (var_i = 0; var_i < var_map_ids.size; var_i++) {
		var_keys = [];
		var_keys[0] = 5;
		var_keys[1] = var_map_ids[var_i];
		var_keys[2] = 1;
		var_keys[3] = 1;
		self _meth_8697(41, var_keys);
		wait 0.05;
	}
	var_keys = [];
	var_keys[0] = 5;
	var_keys[1] = 5;
	self _meth_8697(43, var_keys);
	wait 0.05;
	var_keys = [];
	var_keys[0] = 5;
	var_keys[1] = 6;
	self _meth_8697(43, var_keys);
	wait 0.05;
	var_keys = [];
	var_keys[0] = 5;
	var_keys[1] = 7;
	self _meth_8697(43, var_keys);
	wait 0.05;
	var_keys = [];
	var_keys[0] = 5;
	var_keys[1] = 5;
	self _meth_8697(42, var_keys);

	self iPrintString("All Tortured Path Chapters Unlocked");
}