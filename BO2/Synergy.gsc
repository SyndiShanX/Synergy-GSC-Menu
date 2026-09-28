#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init() {
	setDvar("sv_cheats", "1");

	precacheshader("ui_scrollbar_arrow_right");

	level thread player_connect();
	level thread create_rainbow_color();

	wait 0.5;
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
	self.font_scale = 1;
	self.x_offset = 175;
	self.y_offset = 160;

	self.point_increment = 100;
	self.map_name = getDvar("mapname");
	self.color_theme = "rainbow";
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.cursor_index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.description_height = 0;
	self.previous_option = undefined;

	// Visions

	self.syn["visions"]["zm_prison"][0] = array("zm_afterlife", "zm_audio_log", "zm_electric_cherry");
	self.syn["visions"]["zm_prison"][1] = array("Afterlife", "Black & White", "Electric Cherry");

	self.syn["visions"]["zm_tomb"][0] = array("zm_powerup_zombie_blood_visionset");
	self.syn["visions"]["zm_tomb"][1] = array("Zombie Blood");

	// Weapons

	self.syn["weapons"]["category"] = array("Assault Rifles", "Sub Machine Guns", "Sniper Rifles", "Shotguns", "Light Machine Guns", "Pistols", "Launchers", "Extras");

	self.syn["weapons"]["extras"][0] = array("defaultweapon_mp");
	self.syn["weapons"]["extras"][1] = array("Default Weapon");

	self.syn["weapons"]["extras"]["zm_transit"][0] = array("equip_turbine_zm");
	self.syn["weapons"]["extras"]["zm_transit"][0] = array("Turbine");

	self.syn["weapons"]["extras"]["zm_prison"][0] = array("alcatraz_shield_zm", "lightning_hands_zm", "spoon_zm_alcatraz", "spork_zm_alcatraz");
	self.syn["weapons"]["extras"]["zm_prison"][1] = array("Zombie Shield", "Lightning Hands", "Spoon", "Spork");

	self.syn["weapons"]["extras"]["zm_tomb"][0] = array("tomb_shield_zm", "sticky_grenade_zm");
	self.syn["weapons"]["extras"]["zm_tomb"][1] = array("Zombie Shield", "Semtex Grenades");

	// Perks

	self.syn["perks"][0] = array("specialty_quickrevive", "specialty_armorvest", "specialty_rof", "specialty_longersprint", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_deadshot", "specialty_scavenger", "specialty_grenadepulldeath", "specialty_finalstand", "specialty_nomotionsensor", "specialty_flakjacket");
	self.syn["perks"][1] = array("Quick Revive", "Juggernog", "Double Tap", "Stamin-Up", "Speed Cola", "Mule Kick", "Deadshot", "Tombstone", "Electric Cherry", "Who's Who", "Vulture Aid", "PhD Flopper");

	self.syn["perks"]["common"] =  		 array("specialty_armorvest", "specialty_rof", "specialty_fastreload");
	self.syn["perks"]["zm_transit"] =  array("specialty_quickrevive", "specialty_longersprint", "specialty_scavenger");
	self.syn["perks"]["zm_highrise"] = array("specialty_quickrevive", "specialty_additionalprimaryweapon", "specialty_finalstand");
	self.syn["perks"]["zm_prison"] =   array("specialty_additionalprimaryweapon", "specialty_deadshot", "specialty_grenadepulldeath");
	self.syn["perks"]["zm_buried"] =   array("specialty_quickrevive", "specialty_additionalprimaryweapon", "specialty_longersprint", "specialty_nomotionsensor");
	self.syn["perks"]["zm_tomb"] =     array("specialty_quickrevive", "specialty_flakjacket", "specialty_additionalprimaryweapon", "specialty_longersprint", "specialty_deadshot", "specialty_grenadepulldeath");

	// Visions

	foreach(type, v_array in level.vsmgr) {
		foreach(v_name, v_struct in level.vsmgr[type].info) {
			vision = level.vsmgr[type].info[v_name];
			displayName = construct_string(replace_character(vision.name, "_", " "));
			if(isSubStr(displayName, "Zm")) {
				displayName = getSubStr(displayName, 3);
			}
			vision.displayName = displayName;
			foreach(existingVision in self.syn["visions"]) {
				if(vision.name == existingVision.name) {
					self.isInArray = true;
				}
			}
			if(!isDefined(self.isInArray)) {
				self.syn["visions"][self.syn["visions"].size] = vision;
			}
			self.isInArray = undefined;
		}
	}

	// Powerups

	self.syn["powerups"][0] = getArrayKeys(level.zombie_include_powerups);
	self.syn["powerups"][1] = [];
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
	  self.syn["powerups"][1][i] = construct_string(replace_character(self.syn["powerups"][0][i], "_", " "));
		if(self.syn["powerups"][1][i] == "Full Ammo") {
			self.syn["powerups"][1][i] = "Max Ammo";
		} else if (self.syn["powerups"][1][i] == "Insta Kill") {
			self.syn["powerups"][1][i] = "Insta-Kill";
		}
	}

	// Weapons

	weapon_types = array("assault", "smg", "cqb", "lmg", "sniper", "pistol", "launcher", "grenade", "special");

	weapon_names = [];
	foreach(weapon in getArrayKeys(level.zombie_weapons)) {
		weapon_names[weapon_names.size] = weapon;
	}

	for(i = 0; i < weapon_types.size; i++) {
		self.syn["weapons"][i] = [];
		for(e = 1; e < 156; e++) {
			weapon_category = tableLookup("zm/zm_statstable.csv", 0, e, 2);
			weapon_id = tableLookup("zm/zm_statstable.csv", 0, e, 4);
			weapon_id = weapon_id + "_zm";

			if(weapon_category == "weapon_" + weapon_types[i] && weapon_id != "sticky_grenade_zm" && strTok(weapon_id, "_")[2] != "upgraded") {
				if(isInArray(weapon_names, weapon_id)) {
					weapon = spawnStruct();
					weapon.name = getWeaponDisplayName(weapon_id);
					if(weapon_id == "knife_ballistic_bowie_zm") {
						weapon.name = "Ballistic Knife (Bowie)";
					} else if(weapon_id == "jetgun_zm") {
						weapon.name = "Jet Gun";
					} else if(weapon_id == "frag_grenade_zm") {
						weapon.name = "Frag Grenades";
					} else if(weapon_id == "cymbal_monkey_zm") {
						weapon.name = "Monkey Bombs";
					} else if(weapon_id == "emp_grenade_zm") {
						weapon.name = "EMP Grenades";
					} else if(weapon_id == "beacon_zm") {
						weapon.name = "G-Strike";
					}
					weapon.id = weapon_id;
					if(weapon_category == "weapon_grenade") {
						weapon.category = "weapon_special";
					} else {
						weapon.category = weapon_category;
					}
					if(weapon_id == "lsat_zm") {
						weapon.category = "weapon_lmg";
					} else if(weapon_id == "fnfal_zm") {
						weapon.category = "weapon_assault";
					} else if(weapon_id == "galil_zm") {
						weapon.category = "weapon_assault";
					}
					self.syn["weapons"][i][self.syn["weapons"][i].size] = weapon;
				}
			}
		}
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
						self freezeControls(false);

						level.player_out_of_playable_area_monitor = false;
						self notify("stop_player_out_of_playable_area_monitor");

						self thread input_manager();

						self.menu["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset - 1), (self.y_offset - 1), 226, 122, self.color_theme, 1, 1);
						self.menu["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, self.y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
						self.menu["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
						self.menu["separator_1"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 5.5), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
						self.menu["separator_2"] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 220), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
						self.menu["cursor"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, 215, 224, 16, (0.15, 0.15, 0.15), 0, 4);

						self.menu["title"] = self create_text("Title", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 94.5), (self.y_offset + 3), (1, 1, 1), 1, 10);
						self.menu["description"] = self create_text("Description", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + (self.option_limit * 17.5)), (0.75, 0.75, 0.75), 0, 10);
						self.menu["slider_text"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), (self.y_offset + 19), (0.75, 0.75, 0.75), 0, 10);
						self.menu["slider"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + 15), 224, 16, (0.25, 0.25, 0.25), 0, 5);

						for(i = 1; i <= self.option_limit; i++) {
							self.menu["toggle_" + i] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 11), ((self.y_offset + 4) + (i * 15)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
							self.menu["option_" + i] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), ((self.y_offset + 4) + (i * 15)), (0.75, 0.75, 0.75), 1, 10);
							self.menu["submenu_icon_" + i] = self create_shader("ui_scrollbar_arrow_right", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 223), ((self.y_offset + 4) + (i * 15)), 7, 7, (0.5, 0.5, 0.5), 0, 10);
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

						self.controls_menu_open = true;

						wait 8;

						if(self.controls_menu_open) {
							close_controls_menu();
						}
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

input_manager() {
	level endon("game_ended");
	self endon("disconnect");

	while(self isHost()) {
		if(!self.in_menu) {
			if(self adsButtonPressed() && self meleeButtonPressed()) {
				if(self.controls_menu_open) {
					close_controls_menu();
				}

				self playSoundToPlayer("wpn_tomahawk_catch_plr", self);

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

				self playSoundToPlayer("zmb_plane_takeoff", self);

				if(isDefined(self.previous[(self.previous.size - 1)])) {
					self new_menu();
				} else {
					self close_menu();
				}

				while(self meleeButtonPressed()) {
					wait 0.2;
				}
			} else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {
				self playSoundToPlayer("zmb_plane_fall", self);

				scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

				wait (0.2);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {
				self playSoundToPlayer("evt_spawn", self);

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
				}

				wait (0.2);
			} else if(self useButtonPressed()) {
				self.saved_index[self.current_menu] = self.cursor_index;
				self.saved_offset[self.current_menu] = self.scrolling_offset;
				self.saved_trigger[self.current_menu] = self.previous_trigger;

				self playSoundToPlayer("zmb_character_revived", self);

				if(self.structure[self.cursor_index].command == ::new_menu) {
					self.previous_option = self.structure[self.cursor_index].text;
				}

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					if(isDefined(self.structure[self.cursor_index].array)) {
						cursor_selected = self.structure[self.cursor_index].array[self.slider[(self.current_menu + "_" + self.cursor_index)]];
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

player_connect() {
	level endon("game_ended");

	for(;;) {
		level waittill("connected", player);

		player.access = player isHost() ? "Host" : "None";

		player initial_variables();
		player thread initialize_menu();
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
	self.menu["border"] set_shader("white", self.menu["border"].width, 123);
	self.menu["background"] set_shader("white", self.menu["background"].width, 121);
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 106);

	self.controls_menu_open = false;

	set_menu_visibility(0);

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
		if(isInt(text)) {
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

	shaderElement setParent(level.uiParent);
	shaderElement setPoint(align_x, align_y, x_offset, y_offset);

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
	self.menu["border"].x = (self.x_offset - 1);
	self.menu["border"].y = (self.y_offset - 1);

	self.menu["background"].x = self.x_offset;
	self.menu["background"].y = self.y_offset;

	self.menu["foreground"].x = self.x_offset;
	self.menu["foreground"].y = (self.y_offset + 15);

	self.menu["separator_1"].x = (self.x_offset + 5);
	self.menu["separator_1"].y = (self.y_offset + 7.5);

	self.menu["separator_2"].x = (self.x_offset + 220);
	self.menu["separator_2"].y = (self.y_offset + 7.5);

	self.menu["cursor"].x = self.x_offset;

	self.menu["description"].y = (self.y_offset + (self.option_limit * 17.5));

	self.menu["slider_text"].x = (self.x_offset + 132.5);
	self.menu["slider_text"].y = ((self.y_offset + 4) + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	self.menu["slider"].x = self.x_offset;
	self.menu["slider"].y = (self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].x = (self.x_offset + 11);
		self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["option_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["submenu_icon_" + i].x = (self.x_offset + 223);
		self.menu["submenu_icon_" + i].y = ((self.y_offset + 4) + (i * 15));
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

clean_name(name) {
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = array("^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "^:");
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

construct_string(string) {
	final = "";
	for(e = 0; e < string.size; e++) {
		if(e == 0)
			final += toUpper(string[e]);
		else if(string[e - 1] == " ")
			final += toUpper(string[e]);
		else
			final += string[e];
	}
	return final;
}

replace_character(string, substring, replace) {
	final = "";
	for(e = 0; e < string.size; e++) {
		if(string[e] == substring)
			final += replace;
		else
			final += string[e];
	}
	return final;
}

set_increment(value) {
	self.point_increment = value;
}

load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"].size; i++) {
		foreach(weapon in self.syn["weapons"][i]) {
			if(weapon.category == weapon_category) {
				self add_option(weapon.name, undefined, ::give_weapon, weapon.id);
			}
		}
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

add_array(text, description, command, array, show_options, parameter_1, parameter_2, parameter_3) {
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
	if(isInt(start)) {
		option.start = start;
	} else {
		option.start = 0;
	}
	if(isInt(minimum)) {
		option.minimum = minimum;
	} else {
		option.minimum = 0;
	}
	if(isInt(maximum)) {
		option.maximum = maximum;
	} else {
		option.maximum = 10;
	}
	if(isInt(increment)) {
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
	letter_index = array(" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
	letter_width = array(5, 12, 11, 11, 10, 10, 10, 11, 11, 5, 10, 10, 9, 12, 11, 11, 10, 12, 10, 19, 11, 10, 11, 14, 10, 11, 10);
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

add_menu(title) {
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
	option = array("Nothing To See Here!", "Quiet Here, Isn't It?", "Oops, Nothing Here Yet!", "Bit Empty, Don't You Think?");
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
				if(self.previous_scrolling_offset != self.scrolling_offset) {
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

				self.menu["slider_text_" + i] set_text(slider_text);
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
			self add_menu(menu);

			self add_option("Basic Options", undefined, ::new_menu, "Basic Options");
			self add_option("Fun Options", undefined, ::new_menu, "Fun Options");
			self add_option("Weapon Options", undefined, ::new_menu, "Weapon Options");
			self add_option("Zombie Options", undefined, ::new_menu, "Zombie Options");
			self add_option("Map Options", undefined, ::new_menu, "Map Options");
			self add_option("Powerup Options", undefined, ::new_menu, "Powerup Options");
			self add_option("Menu Options", undefined, ::new_menu, "Menu Options");

			break;
		case "Basic Options":
			self add_menu(menu);

			self add_toggle("God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);

			self add_toggle("Infinite Ammo", "Gives you Infinite Ammo, Grenades, and Specialist", ::infinite_ammo, self.infinite_ammo);
			self add_toggle("Infinite Shield", "Gives you Infinite Shield Durability", ::infinite_shield, self.infinite_shield);

			self add_option("Give Perks", undefined, ::new_menu, "Give Perks");
			self add_option("Take Perks", undefined, ::new_menu, "Take Perks");
			self add_option("Give Perkaholic", undefined, ::give_perkaholic);

			self add_option("Point Options", undefined, ::new_menu, "Point Options");

			break;
		case "Fun Options":
			self add_menu(menu);

			self add_toggle("Forge Mode", undefined, ::forge_mode, self.forge_mode);

			self add_increment("Set Speed", undefined, ::set_speed, 1, 1, 15, 1);
			self add_increment("Set Timescale", undefined, ::set_timescale, 1, 1, 10, 1);
			self add_increment("Set Gravity", undefined, ::set_gravity, 900, 130, 900, 10);

			self add_toggle("Third Person", undefined, ::third_person, self.third_person);
			self add_toggle("Invisiblity", undefined, ::invisiblity, self.invisiblity);

			self add_option("Visions", undefined, ::new_menu, "Visions");

			break;
		case "Weapon Options":
			self add_menu(menu);

			self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");
			self add_toggle("Give Pack-a-Punched Weapons", "Weapons Given will be Pack-a-Punched", ::give_packed_weapon, self.give_packed_weapon);

			self add_option("Take Current Weapon", undefined, ::take_weapon);
			self add_option("Drop Current Weapon", undefined, ::drop_weapon);

			break;
		case "Zombie Options":
			self add_menu(menu);

			self add_toggle("No Target", "Zombies won't Target You", ::no_target, self.no_target);

			self add_increment("Set Round", undefined, ::set_round, 1, 1, 255, 1);

			self add_option("Kill All Zombies", undefined, ::kill_all_zombies);
			self add_option("Teleport Zombies to Me", undefined, ::teleport_zombies);

			self add_toggle("One Shot Zombies", undefined, ::one_shot_zombies, self.one_shot_zombies);
			self add_toggle("Freeze Zombies", undefined, ::freeze_zombies, self.freeze_zombies);
			self add_toggle("Disable Spawns", undefined, ::disable_spawns, self.disable_spawns);

			self add_array("Set Zombie Speed", undefined, ::set_zombie_speed, array("Restore", "Walk", "Run", "Sprint", "Super Sprint"), true);

			self add_increment("Set Round Health Cap", "Cap Zombies Health to Specified Round", ::set_zombie_health_cap, 1, 1, 255, 1);
			self add_option("Reset Zombie Health Cap", "Set Health Cap back to Normal", ::reset_zombie_health_cap);

			break;
		case "Map Options":
			self add_menu(menu);

			self add_toggle("Freeze Box", "Locks the Mystery Box, so it can't move", ::freeze_box, self.freeze_box);
			self add_option("Open Doors", undefined, ::open_doors);

			if(!flag("power_on")) {
				self add_option("Turn Power On", undefined, ::power_on);
			}

			break;
		case "Powerup Options":
			self add_menu(menu);

			self add_toggle("Shoot Powerups", undefined, ::shoot_powerups, self.shoot_powerups);

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				self add_option("Spawn " + self.syn["powerups"][1][i], undefined, ::spawn_powerup, self.syn["powerups"][0][i]);
			}

			break;
		case "Menu Options":
			self add_menu(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 20, 10, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -100, 30, 10, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, ::hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

			break;
		case "Give Perks":
			self add_menu(menu);

			foreach(perk in self.syn["perks"]["common"]) {
				perk_name = get_perk_name(perk);
				self add_option(perk_name, undefined, ::give_perk, perk);
			}

			if(self.map_name != "zm_nuked") {
				foreach(perk in self.syn["perks"][self.map_name]) {
					perk_name = get_perk_name(perk);
					self add_option(perk_name, undefined, ::give_perk, perk);
				}
			}

			break;
		case "Take Perks":
			self add_menu(menu);

			foreach(perk in self.syn["perks"]["common"]) {
				perk_name = get_perk_name(perk);
				self add_option(perk_name, undefined, ::take_perk, perk);
			}

			if(self.map_name != "zm_nuked") {
				foreach(perk in self.syn["perks"][self.map_name]) {
					perk_name = get_perk_name(perk);
					self add_option(perk_name, undefined, ::take_perk, perk);
				}
			}

			break;
		case "Point Options":
			self add_menu(menu);

			self add_increment("Set Increment", undefined, ::set_increment, 100, 100, 10000, 100);

			self add_increment("Set Points", undefined, ::set_points, 500, 500, 100000, self.point_increment);
			self add_increment("Add Points", undefined, ::add_points, 500, 500, 100000, self.point_increment);
			self add_increment("Take Points", undefined, ::take_points, 500, 500, 100000, self.point_increment);

			break;
		case "Visions":
			self add_menu(menu);

			self add_option("None", undefined, ::set_vision, "none");

			map = self.map_name;

			if(map == "zm_prison" || map == "zm_tomb") {
				for(i = 0; i < self.syn["visions"][map][0].size; i++) {
					self add_option(self.syn["visions"][map][1][i], undefined, ::set_vision, self.syn["visions"][map][0][i]);
				}
			}

			foreach(vision in self.syn["visions"]) {
				switch(vision.name) {
					case "":
						break;
					default:
						self add_option(vision.displayName, vision.name, ::set_vision, vision.name);
						break;
				}
			}

			break;
		case "Give Weapons":
			self add_menu(menu);

			for(i = 0; i < self.syn["weapons"]["category"].size; i++) {
				self add_option(self.syn["weapons"]["category"][i], undefined, ::new_menu, self.syn["weapons"]["category"][i]);
			}

			break;
		case "Assault Rifles":
			self add_menu(menu);

			load_weapons("weapon_assault");

			break;
		case "Sub Machine Guns":
			self add_menu(menu);

			load_weapons("weapon_smg");

			break;
		case "Light Machine Guns":
			self add_menu(menu);

			load_weapons("weapon_lmg");

			break;
		case "Sniper Rifles":
			self add_menu(menu);

			load_weapons("weapon_sniper");

			break;
		case "Shotguns":
			self add_menu(menu);

			load_weapons("weapon_cqb");

			break;
		case "Pistols":
			self add_menu(menu);

			load_weapons("weapon_pistol");

			break;
		case "Launchers":
			self add_menu(menu);

			load_weapons("weapon_launcher");

			break;
		case "Extras":
			self add_menu(menu);

			load_weapons("weapon_special");

			for(i = 0; i < self.syn["weapons"]["extras"][0].size; i++) {
				self add_option(self.syn["weapons"]["extras"][1][i], "Added via Global Extra", ::give_weapon, self.syn["weapons"]["extras"][0][i]);
			}

			map = self.map_name;

			if(map == "zm_transit" || map == "zm_prison" || map == "zm_tomb") {
				for(i = 0; i < self.syn["weapons"]["extras"][map][0].size; i++) {
					self add_option(self.syn["weapons"]["extras"][map][1][i], "Added via Map Extra", ::give_weapon, self.syn["weapons"]["extras"][map][0][i]);
				}
			}

			break;
		default:
			if(!isDefined(self.selected_player)) {
				self.selected_player = self;
			}

			self player_option(menu, self.selected_player);
			break;
	}
}

player_option(menu, player) {
	if(!isDefined(menu) || !isDefined(player) || !isPlayer(player)) {
		menu = "Error";
	}

	switch (menu) {
		case "Player Option":
			self add_menu(clean_name(player get_name()));
			break;
		case "Error":
			self add_menu();
			self add_option("Oops, Something Went Wrong!", "Condition: Undefined");
			break;
		default:
			error = true;
			if(error) {
				self add_menu("Critical Error");
				self add_option("Oops, Something Went Wrong!", "Condition: Menu Index");
			}
			break;
	}
}

// Menu Options

iPrintString(string) {
	if(!isDefined(self.syn["string"])) {
	  self.syn["string"] = self create_text(string, "default", 1.5, "center", "top", 0, -115, (1,1,1), 1, 9999, false);
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

// Basic Options

god_mode() {
	self.god_mode = !return_toggle(self.god_mode);
	if(self.god_mode) {
		self iPrintString("God Mode [^2ON^7]");
		self enableInvulnerability();
	} else {
		self iPrintString("God Mode [^1OFF^7]");
		self disableInvulnerability();
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
		weapons = self getWeaponsList();
		for(i = 0; i < weapons.size; i++) {
			self giveMaxAmmo(weapons[i]);
		}
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);
		wait 0.05;
	}
}

infinite_shield() {
	self.infinite_shield = !return_toggle(self.infinite_shield);
	if(self.infinite_shield) {
		iPrintString("Infinite Shield [^2ON^7]");
		self thread infinite_shield_loop();
	} else {
		iPrintString("Infinite Shield [^1OFF^7]");
		self notify("stop_infinite_shield");
	}
}

infinite_shield_loop() {
	self endon("stop_infinite_shield");
	self endon("game_ended");

	for(;;) {
		self [[self.player_shield_reset_health]]();
		wait 2.5;
	}
}

get_perk_name(perk) {
	for(i = 0; i < self.syn["perks"][0].size; i++) {
		if(perk == self.syn["perks"][0][i]) {
			return self.syn["perks"][1][i];
		}
	}
	return perk;
}

give_perk(perk) {
	if(!self hasPerk(perk)) {
		self maps\mp\zombies\_zm_perks::give_perk(perk, 0);
	}
}

take_perk(perk) {
	if(self hasPerk(perk)) {
		self notify(perk + "_stop");
	}
}

give_perkaholic() {
	foreach(perk in self.syn["perks"][0]) {
		if(isDefined(self.perk_purchased) && self.perk_purchased == perk) {
			continue;
		}
		if(self hasPerk(perk) || self maps\mp\zombies\_zm_perks::has_perk_paused(perk)) {
			continue;
		}
		self maps\mp\zombies\_zm_perks::give_perk(perk, 0);
		wait 0.25;
	}
}

set_points(value) {
	self.score = value;
}

add_points(value) {
	self maps\mp\zombies\_zm_score::add_to_player_score(value);
}

take_points(value) {
	self maps\mp\zombies\_zm_score::minus_to_player_score(value);
}

// Fun Options

forge_mode() {
	self.forge_mode = !return_toggle(self.forge_mode);
	if(self.forge_mode) {
		iPrintString("Forge Mode [^2ON^7], Press ^3[{+speed_throw}]^7 to Pick Up/Drop Objects");
		self thread forge_mode_loop();
	} else {
		iPrintString("Forge Mode [^1OFF^7]");
		self notify("stop_forge_mode");
	}
}

forge_mode_loop() {
	self endon("disconnect");
	self endon("stop_forge_mode");

	while (true) {
		trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 1, self);
		if(isDefined(trace["entity"])) {
			if(self adsButtonPressed()) {
				while (self adsButtonPressed()) {
					trace["entity"] forceTeleport(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200);
					trace["entity"].origin = self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200;
					wait 0.01;
				}
			}
			if(self attackButtonPressed()) {
				while (self attackButtonPressed()) {
					trace["entity"] rotatePitch(1, .01);
					wait 0.01;
				}
			}
			if(self fragButtonPressed()) {
				while (self fragButtonPressed()) {
					trace["entity"] rotateYaw(1, .01);
					wait 0.01;
				}
			}
			if(self secondaryOffhandButtonPressed()) {
				while (self secondaryOffhandButtonPressed()) {
					trace["entity"] rotateRoll(1, .01);
					wait 0.01;
				}
			}
			if(!isPlayer(trace["entity"]) && self meleeButtonPressed()) {
				trace["entity"] delete();
				wait 0.2;
			}
		}
		wait 0.05;
	}
}

set_speed(value) {
	if(value == 1) {
		self.movement_speed = undefined;
	}
	self setMoveSpeedScale(value);
}

set_timescale(value) {
	setDvar("timescale", value);
}

set_gravity(value) {
	setDvar("bg_gravity", value);
}

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
		iPrintString("Third Person [^2ON^7]");
		self setClientThirdPerson(1);
		setDvar("cg_thirdPersonAngle", "5");
	  setDvar("cg_thirdPersonRange", "138");
	  setDvar("cg_fov", "20");
	} else {
		iPrintString("Third Person [^1OFF^7]");
		self setClientThirdPerson(0);
		setDvar("cg_fov", getDvar("cg_fov_default"));
	}
	self resetFov();
}

invisiblity() {
	self.invisiblity = !return_toggle(self.invisiblity);
	if(self.invisiblity) {
		iPrintString("Invisiblity [^2ON^7]");
		self hide();
	} else {
		iPrintString("Invisiblity [^1OFF^7]");
		self show();
	}
}

set_vision(vision) {
	if(isDefined(self.previous_vision)) {
		maps\mp\_visionset_mgr::vsmgr_deactivate("visionset", self.previous_vision, self);
	}
	if(isDefined(self.previous_vision_overlay)) {
		maps\mp\_visionset_mgr::vsmgr_deactivate("overlay", self.previous_vision_overlay, self);
	}

	wait 0.05;

	switch(vision) {
		case "zm_transit_burn":
		case "zm_ai_avogadro_electrified":
		case "zm_ai_screecher_blur":
		case "zm_trap_electric":
		case "zm_trap_burn":
		case "vulture_stink_overlay":
		case "zombie_time_bomb_overlay":
			maps\mp\_visionset_mgr::vsmgr_activate("overlay", vision, self);
			self.previous_vision_overlay = vision;
			break;
		case "zm_afterlife":
			maps\mp\_visionset_mgr::vsmgr_activate("visionset", vision, self);
			maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_afterlife_filter", self);
			self.previous_vision = vision;
			self.previous_vision_overlay = "zm_afterlife_filter";
			break;
		case "zm_powerup_zombie_blood_visionset":
			maps\mp\_visionset_mgr::vsmgr_activate("visionset", vision, self);
			maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_powerup_zombie_blood_overlay", self);
			self.previous_vision = vision;
			self.previous_vision_overlay = "zm_powerup_zombie_blood_overlay";
			break;
		case "none":
			break;
		default:
			maps\mp\_visionset_mgr::vsmgr_activate("visionset", vision, self);
			self.previous_vision = vision;
			break;
	}
}

// Map Options

freeze_box() {
	self.freeze_box = !return_toggle(self.freeze_box);
	if(self.freeze_box) {
		iPrintString("Freeze Box [^2ON^7]");
		wait 5;
		level.chest_min_move_usage = 999;
	} else {
		iPrintString("Freeze Box [^1OFF^7]");
		wait 5;
		level.chest_min_move_usage = 4;
	}
}

open_doors() {
	setDvar("zombie_unlock_all", 1);
	types = array("zombie_door", "zombie_doors", "zombie_airlock_buy", "zombie_debris", "flag_blocker", "window_shutter", "zombie_trap", "sloth_barricade");
	foreach(type in types) {
		zombie_doors = getEntArray(type, "targetname");
		foreach(door in zombie_doors) {
			door notify("trigger");
			wait 0.05;
		}
	}

	doors_trigs = getEntArray("zombie_door", "targetname");

	foreach(door in doors_trigs) {
	  doors = getEntArray(door.target, "targetname");
	  array_thread(doors, ::self_delete);
	}

	array_thread(doors_trigs, ::self_delete);

	debris_trigs = getEntArray("zombie_debris", "targetname");

	foreach(trig in debris_trigs) {
	  if(isDefined(trig.script_flag)) {
	    flag_set(trig.script_flag);
		}

	  parts = getEntArray(trig.target, "targetname");
	  array_thread(parts, ::self_delete);
	}

	array_thread(debris_trigs, ::self_delete);

	if(self.map_name == "zm_buried") {
		sloth_trigs = getEntArray("sloth_barricade", "targetname");

	  foreach(trig in sloth_trigs) {
	    if(isDefined(trig.script_flag)) {
	      flag_set(trig.script_flag);
			}

	    parts = getEntArray(trig.target, "targetname");
	    array_thread(parts, ::self_delete);
	  }

		array_thread(sloth_trigs, ::self_delete);
	}

	level notify("open_sesame");
	setDvar("zombie_unlock_all", 0);
}

get_power_trigger() {
	trigger = getEnt("use_elec_switch", "targetname");
	if(isDefined(trigger)) {
		return trigger;
	}
	return false;
}

power_on() {
	flag_set("power_on");
	trigger = get_power_trigger();
	trigger notify("trigger", self);

	if(self.map_name == "zm_prison") {
		level notify("gondola_powered_on_roof");
	}
}

// Powerup Options

spawn_powerup(powerup) {
	specific_powerup_drop(powerup, self.origin + anglesToForward(self.angles) * 115);
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
			specific_powerup_drop(powerup, self.origin + anglesToForward(self.angles) * 115);
			wait 0.5;
		}
		wait 0.05;
	}
}

// Weapon Options

give_packed_weapon() {
	self.give_packed_weapon = !return_toggle(self.give_packed_weapon);
}

give_weapon(weapon) {
	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon == 1) {
		if(can_upgrade_weapon(weapon)) {
			weapon = level.zombie_weapons[weapon].upgrade_name;
		}
	}

	if(!self hasWeapon(weapon)) {
		max_weapon_num = get_player_weapon_limit(self);
		saved_weapon = undefined;

		switch(weapon) {
			case "beacon_zm":
			case "bowie_knife_zm":
			case "tazer_knuckles_zm":
			case "claymore_zm":
			case "cymbal_monkey_zm":
			case "sticky_grenade_zm":
			case "frag_grenade_zm":
			case "emp_grenade_zm":
			case "bouncing_tomahawk_zm":
			case "upgraded_tomahawk_zm":
			case "willy_pete_zm":
			case "spoon_zm_alcatraz":
			case "spork_zm_alcatraz":
			case "time_bomb_zm":
			case "riotshield_zm":
			case "alcatraz_shield_zm":
			case "tomb_shield_zm":
				saved_weapon = self getCurrentWeapon();
				self takeWeapon(self getCurrentWeapon());
				break;
			default:
				if(self getWeaponsListPrimaries().size >= max_weapon_num) {
					self takeWeapon(self getCurrentWeapon());
				}
				break;
		}

		self giveWeapon(weapon);
		self switchToWeapon(weapon);

		switch(weapon) {
			case "riotshield_zm":
			case "alcatraz_shield_zm":
			case "tomb_shield_zm":
				self [[self.player_shield_reset_health]]();
				break;
		}

		if(isDefined(saved_weapon)) {
			wait 0.5;
			self giveWeapon(saved_weapon);
			self switchToWeapon(saved_weapon);
			saved_weapon = undefined;
		}
	} else {
		self switchToWeaponImmediate(weapon);
	}
	wait 0.5;
	self giveStartAmmo(weapon);
}

take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[1]);
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
}

// Zombie Options

get_zombies() {
	return getAISpeciesArray("all", "all");
}

no_target() {
	self.no_target = !return_toggle(self.no_target);
	if(self.no_target) {
		iPrintString("No Target [^2ON^7]");
		self.ignoreMe = 1;
	} else {
		iPrintString("No Target [^1OFF^7]");
		self.ignoreMe = 0;
	}
}

set_round(value) {
	level.round_number = value - 1;
	level.zombie_health = calculate_health(value - 1);
	kill_all_zombies();
}

kill_all_zombies() {
	level.zombie_total = 0;
	foreach(zombie in get_zombies()) {
		zombie doDamage(zombie.health * 5000, (0, 0, 0));
		wait 0.05;
	}
}

teleport_zombies() {
	foreach(zombie in get_zombies()) {
		zombie forceTeleport(self.origin + anglesToForward(self.angles) * 115);
	}
}

one_shot_zombies() {
	if(!isDefined(self.one_shot_zombies)) {
		iPrintString("One Shot Zombies [^2ON^7]");
		self.one_shot_zombies = true;
		zombies = get_zombies();
		level.prev_health = zombies[0].health;
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
			zombie.maxHealth = level.prev_health;
			zombie.health = level.prev_health;
		}
	}
}

freeze_zombies() {
	self.freeze_zombies = !return_toggle(self.freeze_zombies);
	if(self.freeze_zombies) {
		iPrintString("Freeze Zombies [^2ON^7]");
		setDvar("g_ai", "0");
	} else {
		iPrintString("Freeze Zombies [^1OFF^7]");
		setDvar("g_ai", "1");
	}
}

disable_spawns() {
	self.disable_spawns = !return_toggle(self.disable_spawns);
	if(self.disable_spawns) {
		iPrintString("Disable Spawns [^2ON^7]");
		flag_clear("spawn_zombies");
	} else {
		iPrintString("Disable Spawns [^1OFF^7]");
		flag_set("spawn_zombies");
	}
}

set_zombie_speed(speed) {
	if(!isDefined(self.zombie_move_speed_original)) {
		self.zombie_move_speed_original = get_zombies()[0].zombie_move_speed;
	}

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

	if(level.run_cycle != "restore") {
		foreach(zombie in get_zombies()) {
			zombie thread update_zombie_speed();
		}
	} else {
		foreach(zombie in get_zombies()) {
			zombie set_zombie_run_cycle(zombie.zombie_move_speed_original);
		}
	}

	if(level.run_cycle != "restore") {
		self thread update_zombie_speed_loop();
	} else {
		self notify("stop_update_zombie_speed");
	}
}

update_zombie_speed() {
	if(level.run_cycle == "super_sprint" && !(isDefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area)) {
		self waittill_any("death", "completed_emerging_into_playable_area");
	}
	if(level.run_cycle != "restore") {
		self set_zombie_run_cycle(level.run_cycle);
	}
}

update_zombie_speed_loop() {
	self endon("stop_update_zombie_speed");
	self endon("game_ended");

	for(;;) {
		foreach(zombie in get_zombies()) {
			zombie thread update_zombie_speed();
		}
		wait 5;
	}
}

calculate_health(round_number) {
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	for (i = 2; i <= round_number; i++) {
	  if(i >= 10) {
	    old_health = level.zombie_health;
	    level.zombie_health = level.zombie_health + (int(level.zombie_health * 0.1));
	  }
	  level.zombie_health = int(level.zombie_health + 100);
	}
	return level.zombie_health;
}

reset_zombie_health_cap() {
	self notify("stop_zombie_health_cap");
	wait 0.5;
	level.zombie_health = calculate_health(level.round_number);
	foreach(zombie in get_zombies()) {
		zombie.maxHealth = level.zombie_health;
		zombie.health = level.zombie_health;
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
		if(round < level.round_number) {
			level.zombie_health = health_cap;

			foreach(zombie in get_zombies()) {
				if(zombie.maxHealth > health_cap) {
					zombie.maxHealth = health_cap;
				}
				if(zombie.health > health_cap) {
					zombie.health = health_cap;
				}
			}
		} else {
			level waittill("start_of_round");
		}
		wait 0.5;
	}
}