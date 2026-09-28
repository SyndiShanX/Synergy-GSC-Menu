#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\_utility;

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

	self.equip_attachment_in_progress = false;

	// Weapons

	self.syn["weapons"]["category"] = array("Assault Rifles", "Sub Machine Guns", "Sniper Rifles", "Shotguns", "Light Machine Guns", "Pistols", "Launchers", "Extras");

	self.syn["weapons"]["assault_rifles"][0] =     array("tar21_mp", "type95_mp", "sig556_mp", "sa58_mp", "hk416_mp", "scar_mp", "saritch_mp", "xm8_mp", "an94_mp");
	self.syn["weapons"]["sub_machine_guns"][0] =   array("mp7_mp", "pdw57_mp", "vector_mp", "insas_mp", "qcw05_mp", "evoskorpion_mp", "peacekeeper_mp");
	self.syn["weapons"]["light_machine_guns"][0] = array("mk48_mp", "qbb95_mp", "lsat_mp", "hamr_mp");
	self.syn["weapons"]["sniper_rifles"][0] =      array("svu_mp", "dsr50_mp", "ballista_mp", "as50_mp");
	self.syn["weapons"]["shotguns"][0] =           array("870mcs_mp", "saiga12_mp", "ksg_mp", "srm1216_mp");
	self.syn["weapons"]["pistols"][0] =            array("fiveseven_mp", "fnp45_mp", "beretta93r_mp", "judge_mp", "kard_mp", "kard_dw_mp");
	self.syn["weapons"]["launchers"][0] =          array("smaw_mp", "fhj18_mp", "usrpg_mp");
	self.syn["weapons"]["extras"][0] =             array("riotshield_mp", "knife_held_mp", "crossbow_mp", "knife_ballistic_mp", "defaultweapon_mp");

	self.syn["weapons"]["assault_rifles"][1] =     array("MTAR", "Type 25", "SWAT-556", "FAL OSW", "M27", "SCAR-H", "SMR", "M8A1", "AN-94");
	self.syn["weapons"]["sub_machine_guns"][1] =   array("MP7", "PDW-57", "Vector K10", "MSMC", "Chicom CQB", "Scorpion EVO", "Peacekeeper");
	self.syn["weapons"]["light_machine_guns"][1] = array("Mk 48", "QBB LSW", "LSAT", "HAMR");
	self.syn["weapons"]["sniper_rifles"][1] =      array("SVU-AS", "DSR 50", "Ballista", "XPR-50");
	self.syn["weapons"]["shotguns"][1] =           array("R870 MCS", "S12", "KSG", "M1216");
	self.syn["weapons"]["pistols"][1] =            array("Five-seven", "Tac-45", "B23R", "Executioner", "KAP-40", "KAP-40 (Dual Wield)");
	self.syn["weapons"]["launchers"][1] =          array("SMAW", "FHJ-18 AA", "RPG");
	self.syn["weapons"]["extras"][1] =             array("Assault Shield", "Combat Knife", "Crossbow", "Ballistic Knife", "Default Weapon");

	// Attachments

	self.syn["attachments"][0] = array("reflex", "steadyaim", "silencer", "dualclip", "holo", "grip", "fastads", "fmj", "extbarrel", "rangefinder", "stalker", "extclip", "sf", "rf", "mms", "acog", "dualoptic", "gl", "vzoom", "ir", "swayreduc", "tacknife", "dw", "is", "stackfire");
	self.syn["attachments"][1] = array("Reflex", "Laser Sight", "Suppressor", "Fast Mag", "EOTech", "Fore Grip", "Quickdraw", "FMJ", "Long Barrel", "Target Finder", "Stock", "Extended Clip", "Select Fire", "Rapid Fire", "MMS", "Acog", "Hybrid Optic", "Launcher", "Zoom", "Dual Band", "Ballistics CPU", "Tactical Knife", "Dual Wield", "Iron Sights", "Tri-bolt");
	self.syn["optics"] = array("reflex", "holo", "rangefinder", "mms", "acog", "dualoptic", "ir", "is");

	// Killstreaks

	self.syn["killstreaks"][0] = array("radar_mp", "rcbomb_mp", "inventory_missile_drone_mp", "counteruav_mp", "microwaveturret_mp", "remote_missile_mp", "planemortar_mp", "autoturret_mp", "minigun_mp", "m32_mp", "inventory_ai_tank_drop_mp", "helicopter_comlink_mp", "radardirection_mp", "helicopter_guard_mp", "emp_mp", "straferun_mp", "remote_mortar_mp", "helicopter_player_gunner_mp", "dogs_mp", "missile_swarm_mp");
	self.syn["killstreaks"][1] = array("UAV", "RC-XD", "Hunter Killer", "Counter UAV", "Guardian", "Hellstorm Missile", "Lightning Strike", "Sentry Gun", "Death Machine", "War Machine", "A.G.R.", "Stealth Chopper", "Orbital VSAT", "Escort Drone", "EMP Systems", "Warthog", "Lodestar", "VTOL Warship", "K9 Unit", "Swarm");

	// Perks

	self.syn["perks"][0] = array("specialty_movefaster", "specialty_killstreak", "specialty_nottargetedbyairsupport", "specialty_flakjacket", "specialty_gpsjammer", "specialty_bulletflinch", "specialty_noname", "specialty_fastequipmentuse", "specialty_immunecounteruav", "specialty_scavenger", "specialty_fastads", "specialty_longersprint", "specialty_showenemyequipment", "specialty_stunprotection", "specialty_quieter", "specialty_loudenemies");
	self.syn["perks"][1] = array("Lightweight", "Hardline", "Blind Eye", "Flak Jacket", "Ghost", "Toughness", "Cold Blooded", "Fast Hands", "Hard Wired", "Scavenger", "Dexterity", "Extreme Conditioning", "Engineer", "Tactical Mask", "Dead Silence", "Awareness");
	self.syn["perks"][2] = array("specialty_additionalprimaryweapon", "specialty_armorpiercing", "specialty_armorvest", "specialty_bulletdamage", "specialty_bulletpenetration", "specialty_deadshot", "specialty_extraammo", "specialty_finalstand", "specialty_fireproof", "specialty_grenadepulldeath", "specialty_holdbreath", "specialty_pistoldeath", "specialty_quickrevive", "specialty_rof", "specialty_stalker", "specialty_unlimitedsprint");
	self.syn["perks"][3] = array("Mule Kick", "FMJ", "Armor Vest", "Stopping Power", "Deep Impact", "Deadshot", "Extra Ammo", "Final Stand", "Fireproof", "Martyrdom", "Iron Lungs", "Last Stand", "Quick Revive", "Double Tap", "Stalker", "Stamin-Up");
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
	self setTextUnlimited(text);
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

clean_name(name) {
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = array("^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "^:");
	new_string = "";
	for(a = 0; a < name.size; a++) {
		if(a < (name.size - 1)) {
			if(isInArray(illegal, (name[a] + name[(a + 1)]))) {
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
			self add_option("Give Killstreaks", undefined, ::new_menu, "Give Killstreaks");
			self add_option("Weapon Options", undefined, ::new_menu, "Weapon Options");
			self add_option("Menu Options", undefined, ::new_menu, "Menu Options");

			break;
		case "Basic Options":
			self add_menu(menu);

			self add_toggle("God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);

			self add_toggle("Infinite Ammo", "Gives you Infinite Ammo, Grenades, and Specialist", ::infinite_ammo, self.infinite_ammo);
			self add_toggle("Infinite UAV", undefined, ::infinite_uav, self.infinite_uav);

			self add_option("Give All Perks", undefined, ::give_all_perks);
			self add_option("Take All Perks", undefined, ::take_all_perks);

			self add_option("Give Perks", undefined, ::new_menu, "Give Perks");
			self add_option("Take Perks", undefined, ::new_menu, "Take Perks");

			break;
		case "Fun Options":
			self add_menu(menu);

			self add_toggle("Forge Mode", undefined, ::forge_mode, self.forge_mode);

			self add_increment("Set Speed", undefined, ::set_speed, 1, 1, 15, 1);
			self add_increment("Set Timescale", undefined, ::set_timescale, 1, 1, 10, 1);
			self add_increment("Set Gravity", undefined, ::set_gravity, 900, 130, 900, 10);

			self add_toggle("Third Person", undefined, ::third_person, self.third_person);
			self add_toggle("Invisiblity", undefined, ::invisiblity, self.invisiblity);

			break;
		case "Give Killstreaks":
			self add_menu(menu);

			for(i = 0; i < self.syn["killstreaks"][0].size; i++) {
				self add_option(self.syn["killstreaks"][1][i], undefined, ::give_killstreak, self.syn["killstreaks"][0][i]);
			}

			break;
		case "Weapon Options":
			self add_menu(menu);

			self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");

			weapon_name = strTok(self getCurrentWeapon(), "+")[0];

			if(weapon_name != "riotshield_mp" && weapon_name != "smaw_mp" || weapon_name != "fhj18_mp" || weapon_name != "usrpg_mp" || weapon_name != "knife_ballistic_mp" || weapon_name != "defaultweapon_mp" || weapon_name != "minigun_mp" || weapon_name != "m32_mp") {
				self add_option("Equip Attachment", undefined, ::new_menu, "Equip Attachment");
			}

			self add_increment("Equip Camo", undefined, ::equip_camo, 1, 1, 45, 1);

			self add_option("Take Current Weapon", undefined, ::take_weapon);
			self add_option("Drop Current Weapon", undefined, ::drop_weapon);

			break;
		case "Menu Options":
			self add_menu(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 20, 10, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -70, 30, 10, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, ::hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

			break;
		case "Give Perks":
	    self add_menu(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::give_perk, self.syn["perks"][0][i]);
			}

			for(i = 0; i < self.syn["perks"][2].size; i++) {
				self add_option(self.syn["perks"][3][i], undefined, ::give_perk, self.syn["perks"][2][i]);
			}

	    break;
	  case "Take Perks":
	    self add_menu(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::take_perk, self.syn["perks"][0][i]);
			}

			for(i = 0; i < self.syn["perks"][2].size; i++) {
				self add_option(self.syn["perks"][3][i], undefined, ::take_perk, self.syn["perks"][2][i]);
			}

	    break;
		case "Equip Attachment":
			self add_menu(menu);

			self.equip_attachment_in_progress = true;

			self.syn["attachment_toggles"] = [];

			while(self getCurrentWeapon() == "none") {
				wait 0.05;
			}

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				for(i = 0; i < weapon_attachments.size; i++) {
					self.syn["attachment_toggles"][i] = weaponHasAttachment(self getCurrentWeapon(), weapon_attachments[i]);
					if(weapon_attachments[i] == "dw") {
						if(isSubStr(self getCurrentWeapon(), "_dw_mp")) {
							self.syn["attachment_toggles"][i] = true;
						} else {
							self.syn["attachment_toggles"][i] = false;
						}
					}
					self add_toggle(get_attachment_name(weapon_attachments[i]), undefined, ::equip_attachment, self.syn["attachment_toggles"][i], weapon_attachments[i]);
				}
			}

			self.equip_attachment_in_progress = false;

			break;
		case "Give Weapons":
			self add_menu(menu);

			for(i = 0; i < self.syn["weapons"]["category"].size; i++) {
				self add_option(self.syn["weapons"]["category"][i], undefined, ::new_menu, self.syn["weapons"]["category"][i]);
			}

			break;
		case "Assault Rifles":
			self add_menu(menu);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self add_menu(menu);

			load_weapons("sub_machine_guns");

			break;
		case "Light Machine Guns":
			self add_menu(menu);

			load_weapons("light_machine_guns");

			break;
		case "Sniper Rifles":
			self add_menu(menu);

			load_weapons("sniper_rifles");

			break;
		case "Shotguns":
			self add_menu(menu);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self add_menu(menu);

			load_weapons("pistols");

			break;
		case "Launchers":
			self add_menu(menu);

			load_weapons("launchers");

			break;
		case "Extras":
			self add_menu(menu);

			load_weapons("extras");

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
	if(!isDefined(menu) || !isDefined(player) || !isplayer(player)) {
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
	self.syn["string"] setTextUnlimited(string);
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

infinite_uav() {
	self.infinite_uav = !return_toggle(self.infinite_uav);
	if(self.infinite_uav) {
		iPrintString("Infinite UAV [^2ON^7]");
		self thread infinite_uav_loop();
	} else {
		iPrintString("Infinite UAV [^1OFF^7]");
		self notify("stop_infinite_uav");
		wait 0.2;
		activeuavs = level.activeuavs[self.entnum];
		activeuavsandsatellites = (activeuavs + (isDefined(level.activesatellites) ? level.activesatellites[self.entnum] : 0));

		self setClientUIVisibilityFlag("radar_client", (activeuavsandsatellites > 0));
		self.hassatellite = 0;
	}
}

infinite_uav_loop() {
	self endon("stop_infinite_uav");
	self endon("game_ended");

	for(;;) {
		self setClientUIVisibilityFlag("radar_client", 1);
		self.hasSatellite = 1;
		wait 0.1;
	}
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
		setDvar("cg_fov", getdvar("cg_fov_default"));
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

// Perks

give_perk(perk) {
	self setPerk(perk);

	if(perk == "specialty_movefaster") { // Lightweight
		self setPerk("specialty_fallheight");
	} else if(perk == "specialty_killstreak") { // Hardline
		self setPerk("specialty_earnmoremomentum");
	} else if(perk == "specialty_noname") { // Cold Bloodeed
		self setPerk("specialty_immunemms");
		self setPerk("specialty_immunenvthermal");
		self setPerk("specialty_immunerangefinder");
		self setPerk("specialty_nokillstreakreticle");
		self setPerk("specialty_nottargettedbysentry");
	} else if(perk == "specialty_fastequipmentuse") { // Fast Hands
		self setPerk("specialty_fasttoss");
		self setPerk("specialty_fastweaponswitch");
		self setPerk("specialty_fastreload");
		self setPerk("specialty_fastmeleerecovery");
	} else if(perk == "specialty_immunecounteruav") { // Hard Wired
		self setPerk("specialty_immuneemp");
	} else if(perk == "specialty_fastads") { // Dexterity
		self setPerk("specialty_fastladderclimb");
		self setPerk("specialty_fastmantle");
	} else if(perk == "specialty_longersprint") { // Extreme Conditioning
		self setPerk("specialty_sprintrecovery");
	} else if(perk == "specialty_showenemyequipment") { // Engineer
		self setPerk("specialty_detectexplosive");
		self setPerk("specialty_delayexplosive");
		self setPerk("specialty_disarmexplosive");
	} else if(perk == "specialty_stunprotection") { // Tactical Mask
		self setPerk("specialty_flashprotection");
		self setPerk("specialty_proximityprotection");
	} else if(perk == "specialty_deadshot") { // Deadshot
		self setPerk("specialty_bulletaccuracy");
	} else if(perk == "specialty_quickrevive") { // Quick Revive
		self setPerk("specialty_healthregen");
	} else if(perk == "specialty_bulletdamage") { // Stopping Power
		self setPerk("specialty_explosivedamage");
	}
}

take_perk(perk) {
	self unsetPerk(perk);

	if(perk == "specialty_movefaster") { // Lightweight
		self unsetPerk("specialty_fallheight");
	} else if(perk == "specialty_killstreak") { // Hardline
		self unsetPerk("specialty_earnmoremomentum");
	} else if(perk == "specialty_noname") { // Cold Bloodeed
		self unsetPerk("specialty_immunemms");
		self unsetPerk("specialty_immunenvthermal");
		self unsetPerk("specialty_immunerangefinder");
		self unsetPerk("specialty_nokillstreakreticle");
		self unsetPerk("specialty_nottargettedbysentry");
	} else if(perk == "specialty_fastequipmentuse") { // Fast Hands
		self unsetPerk("specialty_fasttoss");
		self unsetPerk("specialty_fastweaponswitch");
		self unsetPerk("specialty_fastreload");
		self unsetPerk("specialty_fastmeleerecovery");
	} else if(perk == "specialty_immunecounteruav") { // Hard Wired
		self unsetPerk("specialty_immuneemp");
	} else if(perk == "specialty_fastads") { // Dexterity
		self unsetPerk("specialty_fastladderclimb");
		self unsetPerk("specialty_fastmantle");
	} else if(perk == "specialty_longersprint") { // Extreme Conditioning
		self unsetPerk("specialty_sprintrecovery");
	} else if(perk == "specialty_showenemyequipment") { // Engineer
		self unsetPerk("specialty_detectexplosive");
		self unsetPerk("specialty_delayexplosive");
		self unsetPerk("specialty_disarmexplosive");
	} else if(perk == "specialty_stunprotection") { // Tactical Mask
		self unsetPerk("specialty_flashprotection");
		self unsetPerk("specialty_proximityprotection");
	} else if(perk == "specialty_deadshot") { // Deadshot
		self unsetPerk("specialty_bulletaccuracy");
	} else if(perk == "specialty_quickrevive") { // Quick Revive
		self unsetPerk("specialty_healthregen");
	} else if(perk == "specialty_bulletdamage") { // Stopping Power
		self unsetPerk("specialty_explosivedamage");
	}
}

give_all_perks() {
	for(i = 0; i < self.syn["perks"][0].size; i++) {
		self setPerk(self.syn["perks"][0][i]);
	}

	for(i = 0; i < self.syn["perks"][2].size; i++) {
		self setPerk(self.syn["perks"][2][i]);
	}
}

take_all_perks() {
	self clearPerks();
}

// Killstreaks

give_killstreak(killstreak) {
	self givekillstreakweapon(killstreak, 1);
}

// Weapon Options

give_weapon(weapon) {
	if(!self hasWeapon(weapon)) {
		max_weapon_num = 2;

		switch(weapon) {
			default:
				if(self getWeaponsListPrimaries().size >= max_weapon_num) {
					self takeWeapon(self getCurrentWeapon());
				}
				self giveWeapon(weapon);
				self switchToWeapon(weapon);
				break;
		}
	} else {
		self switchToWeaponImmediate(weapon);
	}

	wait 0.5;

	self giveStartAmmo(weapon);
}

get_weapon_category(weapon_name) {
	if(isSubStr(weapon_name, "tar21") || isSubStr(weapon_name, "type95") || isSubStr(weapon_name, "sig556") || isSubStr(weapon_name, "sa58") || isSubStr(weapon_name, "hk416") || isSubStr(weapon_name, "scar") || isSubStr(weapon_name, "saritch") || isSubStr(weapon_name, "xm8") || isSubStr(weapon_name, "an94_mp")) {
		return "assault_rifles";
	} else if(isSubStr(weapon_name, "mp7") || isSubStr(weapon_name, "pdw57") || isSubStr(weapon_name, "vector") || isSubStr(weapon_name, "insas") || isSubStr(weapon_name, "qcw05") || isSubStr(weapon_name, "evoskorpion") || isSubStr(weapon_name, "peacekeeper_mp")) {
		return "sub_machine_guns";
	} else if(isSubStr(weapon_name, "mk48") || isSubStr(weapon_name, "qbb95") || isSubStr(weapon_name, "lsat") || isSubStr(weapon_name, "hamr_mp")) {
		return "light_machine_guns";
	} else if(isSubStr(weapon_name, "svu") || isSubStr(weapon_name, "dsr50") || isSubStr(weapon_name, "ballista") || isSubStr(weapon_name, "as50_mp")) {
		return "sniper_rifles";
	} else if(isSubStr(weapon_name, "870mcs") || isSubStr(weapon_name, "saiga12") || isSubStr(weapon_name, "ksg") || isSubStr(weapon_name, "srm1216_mp")) {
		return "shotguns";
	} else if(isSubStr(weapon_name, "fiveseven") || isSubStr(weapon_name, "fnp45") || isSubStr(weapon_name, "beretta93r") || isSubStr(weapon_name, "judge") || isSubStr(weapon_name, "kard_mp")) {
		return "pistols";
	} else if(isSubStr(weapon_name, "smaw") || isSubStr(weapon_name, "fhj18") || isSubStr(weapon_name, "usrpg")) {
		return "launchers";
	} else if(isSubStr(weapon_name, "riotshield") || isSubStr(weapon_name, "knife_held") || isSubStr(weapon_name, "crossbow") || isSubStr(weapon_name, "knife_ballistic") || isSubStr(weapon_name, "defaultweapon_mp")) {
		return "extras";
	}
}

get_weapon_attachments() {
	weapon_name = self getCurrentWeapon();
	switch (get_weapon_category(weapon_name)) {
		case "assault_rifles":
			return array("reflex", "fastads", "dualclip", "acog", "grip", "stalker", "rangefinder", "steadyaim", "sf", "holo", "silencer", "fmj", "dualoptic", "extclip", "gl", "mms");
		case "sub_machine_guns":
			return array("reflex", "steadyaim", "silencer", "dualclip", "holo", "grip", "fastads", "fmj", "extbarrel", "rangefinder", "stalker", "extclip", "sf", "rf", "mms");
		case "light_machine_guns":
			return array("holo", "grip", "fmj", "reflex", "fastads", "rangefinder", "stalker", "acog", "steadyaim", "silencer", "vzoom", "extclip", "dualoptic", "rf", "ir");
		case "sniper_rifles":
			if(isSubStr(weapon_name, "ballista")) {
				return array("silencer", "swayreduc", "vzoom", "dualclip", "fmj", "acog", "extclip", "steadyaim", "ir", "is");
			} else {
				return array("silencer", "swayreduc", "vzoom", "dualclip", "fmj", "acog", "extclip", "steadyaim", "ir");
			}
		case "shotguns":
			return array("reflex", "extbarrel", "dualclip", "steadyaim", "stalker", "silencer", "extclip", "fastads", "mms");
		case "pistols":
			if(isSubStr(weapon_name, "judge")) {
				return array("reflex", "steadyaim", "extbarrel", "fmj", "dualclip", "silencer", "tacknife", "dw");
			} else {
				return array("reflex", "extclip", "steadyaim", "extbarrel", "fmj", "dualclip", "silencer", "tacknife", "dw");
			}
		case "extras":
			if(isSubStr(weapon_name, "crossbow")) {
				return array("reflex", "acog", "ir", "vzoom", "stackfire");
			}
		default:
			return array("None");
	}
}

get_attachment_name(attachment) {
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
	return attachment;
}

get_equipped_attachments(weapon) {
	attachments = [];
	equipped = strTok(weapon, "+");

	if(isArray(equipped)) {
		for (i = 1; i < equipped.size; i++) {
			attachments[attachments.size] = equipped[i];
		}
	}

	return attachments;
}

get_compatible_attachments(attachments, check_attachment) {
	compatible_attachments = [];

	foreach(attachment in attachments) {
		for(i = 1; i < 29; i++) {
			item_row = tableLookupRowNum("mp/attachmentTable.csv", 9, i);

			if(item_row > -1) {
				attachment_name = tableLookupColumnForRow("mp/attachmentTable.csv", item_row, 4);
				if(attachment == attachment_name) {
					compatible_attachments_list = strTok(tableLookupColumnForRow("mp/attachmentTable.csv", item_row, 11), " ");
					if(isInArray(compatible_attachments_list, check_attachment)) {
						compatible_attachments[compatible_attachments.size] = attachment_name;
					}
				}
			}
		}
  }

	if(alphabetize(attachments) == alphabetize(compatible_attachments)) {
		return true;
	} else {
		return false;
	}
}

validate_selected_attachments(attachments, attachment, add_attachment) {
	if(attachment == "dualclip") {
		if(isInArray(attachments, "extclip")) {
			attachments = remove_from_array(attachments, "extclip");
		}
	}

	if(attachment == "extclip") {
		if(isInArray(attachments, "dualclip")) {
			attachments = remove_from_array(attachments, "dualclip");
		}
	}

	if(attachment == "grip") {
		if(isInArray(attachments, "gl")) {
			attachments = remove_from_array(attachments, "gl");
		}
	}

	if(attachment == "gl") {
		if(isInArray(attachments, "grip")) {
			attachments = remove_from_array(attachments, "grip");
		}

		if(isInArray(attachments, "sf")) {
			attachments = remove_from_array(attachments, "sf");
		}

		if(isInArray(attachments, "dualoptic")) {
			attachments = remove_from_array(attachments, "dualoptic");
		}
	}

	if(attachment == "sf") {
		if(isInArray(attachments, "gl")) {
			attachments = remove_from_array(attachments, "gl");
		}

		if(isInArray(attachments, "dualoptic")) {
			attachments = remove_from_array(attachments, "dualoptic");
		}
	}

	if(attachment == "dualoptic") {
		if(isInArray(attachments, "sf")) {
			attachments = remove_from_array(attachments, "sf");
		}

		if(isInArray(attachments, "gl")) {
			attachments = remove_from_array(attachments, "gl");
		}
	}

	if(attachment == "silencer") {
		if(isInArray(attachments, "extbarrel")) {
			attachments = remove_from_array(attachments, "extbarrel");
		}
	}

	if(attachment == "extbarrel") {
		if(isInArray(attachments, "silencer")) {
			attachments = remove_from_array(attachments, "silencer");
		}
	}

	if(attachment == "fmj") {
		if(isInArray(attachments, "mms")) {
			attachments = remove_from_array(attachments, "mms");
		}
	}

	if(attachment == "mms") {
		if(isInArray(attachments, "fmj")) {
			attachments = remove_from_array(attachments, "fmj");
		}
	}

	if(attachment == "reflex" || attachment == "acog" || attachment == "is" || attachment == "holo" || attachment == "dualoptic" || attachment == "rangefinder") {
		if(isInArray(attachments, "vzoom")) {
			attachments = remove_from_array(attachments, "vzoom");
		}
	}

	if(attachment == "vzoom") {
		if(isInArray(attachments, "reflex")) {
			attachments = remove_from_array(attachments, "reflex");
		}

		if(isInArray(attachments, "acog")) {
			attachments = remove_from_array(attachments, "acog");
		}

		if(isInArray(attachments, "is")) {
			attachments = remove_from_array(attachments, "is");
		}

		if(isInArray(attachments, "holo")) {
			attachments = remove_from_array(attachments, "holo");
		}

		if(isInArray(attachments, "dualoptic")) {
			attachments = remove_from_array(attachments, "dualoptic");
		}

		if(isInArray(attachments, "rangefinder")) {
			attachments = remove_from_array(attachments, "rangefinder");
		}
	}

	if(attachment == "acog" || attachment == "is") {
		if(isInArray(attachments, "swayreduc")) {
			attachments = remove_from_array(attachments, "swayreduc");
		}
	}

	if(attachment == "swayreduc") {
		if(isInArray(attachments, "acog")) {
			attachments = remove_from_array(attachments, "acog");
		}

		if(isInArray(attachments, "is")) {
			attachments = remove_from_array(attachments, "is");
		}
	}

	if(attachment == "reflex" || attachment == "extclip" || attachment == "steadyaim" || attachment == "extbarrel" || attachment == "fmj" || attachment == "dualclip" || attachment == "silencer" || attachment == "tacknife") {
		if(isInArray(attachments, "dw")) {
			attachments = remove_from_array(attachments, "dw");
		}
	}

	if(attachment == "dw" && add_attachment) {
		attachments = "dw";
	}

	return attachments;
}

equip_attachment(attachment) {
	weapon = self getCurrentWeapon();
	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);
	attachments = get_equipped_attachments(weapon);

	skip_validation = false;
	add_attachment = true;

	if(isArray(attachments)) {
		if(isInArray(attachments, attachment)) {
			attachments = remove_from_array(attachments, attachment);
			add_attachment = false;
		} else {
			if(isInArray(self.syn["optics"], attachment)) {
				foreach(optic in self.syn["optics"]) {
					if(isInArray(attachments, optic)) {
						attachments = remove_from_array(attachments, optic);
						skip_validation = true;
					}
				}
			}
		}

		if(isSubStr(weapon, "_dw_mp")) {
			weapon = strTok(weapon, "_")[0] + "_mp";
			if(attachment == "dw") {
				add_attachment = false;
			}
		}

		if(attachment == "dw" && add_attachment) {
			weapon = strTok(weapon, "_")[0] + "_dw_mp";
			attachments = [];
			attachments = "";
		}

		if(get_compatible_attachments(attachments, attachment)) {
			if(add_attachment) {
				attachments[attachments.size] = attachment;
			}
		} else if(!skip_validation) {
			return;
		}

		attachments = validate_selected_attachments(attachments, attachment, add_attachment);
		attachments = alphabetize(attachments);

		attachment_list = "";
		foreach(attachment_name in attachments) {
			attachment_list = attachment_list + "+" + attachment_name;
		}

		if(attachments.size > 3) {
			return;
		}

		weapon = strTok(weapon, "+")[0] + attachment_list;
	}

	self takeWeapon(self getCurrentWeapon());

	if(isDefined(self.saved_camo)) {
		self giveWeapon(weapon, 0, self.saved_camo);
	} else {
		self giveWeapon(weapon);
	}

	self setSpawnWeapon(weapon);
	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
}

equip_camo(camo) {
	weapon = self getCurrentWeapon();
	self.saved_camo = camo;
	self takeWeapon(weapon);
	self giveWeapon(weapon, 0, camo);
	self switchToWeapon(weapon);
}

take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[1]);
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
}