#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
	precacheshader("hud_arrow_right");

	level thread player_connect();
	level thread create_rainbow_color();

	wait 0.5;

	level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	level.callbackPlayerDamage = ::player_damage_callback; // Retropack
	level.rankedmatch = 1; // Retropack
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

	self.color_theme = "rainbow";
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.cursor_index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.description_height = 0;
	self.previous_option = undefined;

	self.syn["visions"][0] = strTok("ac130;ac130_inverted;aftermath;airplane;airport;airport_death;airport_exterior;airport_green;airport_intro;airport_stairs;ambush;armada;armada_water;bigcity_destroyed;blackout;blackout_nvg;bog;boneyard;bridge;cargoship;cheat_bw;cheat_bw_contrast;cheat_bw_invert;cheat_chaplinnight;cheat_contrast;cheat_invert;cheat_invert_contrast;cliffhanger;dcemp;dcemp_emp;default;default_night;default_night_mp;end_game;introscreen;mp_afghan;mpnuke;mpnuke_aftermath;mpoutro;near_death;near_death_mp;thermal_mp", ";");
	self.syn["visions"][1] = strTok("AC-130;AC-130 inverted;Aftermath;Airplane;Airport;Airport Death;Airport Exterior;Airport Green;Airport Intro;Airport Stairs;Ambush;Armada;Armada Water;Big City Destroyed;Blackout;Blackout Nvg;Bog;Boneyard;Bridge;Cargo Ship;Cheat BW;Cheat BW Contrast;Cheat BW Invert;Cheat Chaplin Night;Cheat Contrast;Cheat Invert;Cheat Invert Contrast;Cliff Hanger;DC;DC EMP;Default;Default Night;Default Night MP;End Game;Intro Screen;MP Afghan;MP Nuke;MP Nuke Aftermath;MP Outro;Near Death;Near Death MP;Thermal MP", ";");

	self.syn["weapons"]["category"][0] = strTok("assault_rifles;sub_machine_guns;light_machine_guns;sniper_rifles;machine_pistols;shotguns;pistols;launchers;extras", ";");
	self.syn["weapons"]["category"][1] = strTok("Assault Rifles;Sub Machine Guns;Light Machine Guns;Sniper Rifles;Machine Pistols;Shotguns;Pistols;Launchers;Extras", ";");

	// Weapon IDs
	self.syn["weapons"]["assault_rifles"][0] =     strTok("m4;famas;scar;tavor;fal;m16;masada;fn2000;ak47;ak47classic", ";");
	self.syn["weapons"]["sub_machine_guns"][0] =   strTok("mp5k;ump45;kriss;p90;uzi;ak74u;peacekeeper", ";");
	self.syn["weapons"]["light_machine_guns"][0] = strTok("sa80;rpd;mg4;aug;m240", ";");
	self.syn["weapons"]["sniper_rifles"][0] =      strTok("cheytac;barrett;wa2000;m21;m40a3;dragunov", ";");
	self.syn["weapons"]["machine_pistols"][0] =    strTok("pp2000;glock;beretta393;tmp", ";");
	self.syn["weapons"]["shotguns"][0] =           strTok("spas12;aa12;striker;ranger;m1014;model1887", ";");
	self.syn["weapons"]["pistols"][0] =            strTok("usp;coltanaconda;beretta;deserteagle;deserteaglegold", ";");
	self.syn["weapons"]["launchers"][0] =          strTok("at4;m79;stinger;javelin;rpg", ";");
	self.syn["weapons"]["extras"][0] =             strTok("riotshield;defaultweapon;frag_grenade;semtex;throwingknife;claymore;c4;flash_grenade;concussion_grenade;smoke_grenade", ";");

	// Weapon Names
	self.syn["weapons"]["assault_rifles"][1] =     strTok("M4A1;Famas;Scar-H;Tar-21;FAL;M16A4;ACR;F2000;AK-47;AK-47 Classic", ";");
	self.syn["weapons"]["sub_machine_guns"][1] =   strTok("MP5K;UMP45;Vector;P90;Mini-Uzi;AK-74u;Peacekeeper", ";");
	self.syn["weapons"]["light_machine_guns"][1] = strTok("L86 LSW;RPD;MG4;AUG HBAR;M240", ";");
	self.syn["weapons"]["sniper_rifles"][1] =      strTok("Intervention;Barrett .50cal;WA2000;M21 EBR;M40A3;Dragunov", ";");
	self.syn["weapons"]["machine_pistols"][1] =    strTok("PP2000;G18;M93 Raffica;TMP", ";");
	self.syn["weapons"]["shotguns"][1] =           strTok("SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887", ";");
	self.syn["weapons"]["pistols"][1] =            strTok("USP .45;.44 Magnum;M9;Desert Eagle;Gold Desert Eagle", ";");
	self.syn["weapons"]["launchers"][1] =          strTok("AT4-HS;Thumper;Stinger;Javelin;RPG-7", ";");
	self.syn["weapons"]["extras"][1] =             strTok("Riot Shield;Default Weapon;Frag Grenade;Semtex;Throwing Knife;Claymore;C4;Flash Grenade;Stun Grenade;Smoke Grenade", ";");

	// Attachments
	self.syn["attachments"][0] = strTok("reflex;eotech;acog;thermal;grip;gl;shotgun;tactical;heartbeat;silencer;xmags;rof;akimbo;fmj", ";");
	self.syn["attachments"][1] = strTok("Reflex Sight;Holographic Sight;Acog Scope;Thermal Scope;Grip;Grenade Launcher;Shotgun;Tactical Knife;Heartbeat Sensor;Silencer;Extended Mags;Rapid Fire;Akimbo;FMJ", ";");

	// Perks
	self.syn["perks"][0] = strTok("specialty_marathon;specialty_fastreload;specialty_scavenger;specialty_bling;specialty_ONEMANARMY;specialty_bulletdamage;specialty_lightweight;specialty_hardline;specialty_coldblooded;specialty_explosivedamage;specialty_extendedmelee;specialty_bulletaccuracy;specialty_localjammer;specialty_NINJA;specialty_detectexplosive;specialty_heartbreaker", ";");
	self.syn["perks"][1] = strTok("Marathon;Slight of Hand;Scavenger;Bling;One Man Army;Stopping Power;Lightweight;Hardline;Cold-Blooded;Danger Close;Commando;Steady Aim;Scrambler;Ninja;SitRep;Last Stand", ";");

	self.syn["death_streaks"][0] = strTok("specialty_copycat;specialty_combathigh;specialty_MARTYRDOM;specialty_finalstand", ";");
	self.syn["death_streaks"][1] = strTok("Copycat;Painkiller;Martyrdom;Finalstand", ";");

	// Killstreaks
	self.syn["killstreaks"][0] = strTok("uav;airdrop;counter_uav;sentry;airdrop_sentry_minigun;predator_missile;precision_airstrike;harrier_airstrike;helicopter;airdrop_mega;helicopter_flares;stealth_airstrike;helicopter_minigun;ac130;emp;nuke", ";");
	self.syn["killstreaks"][1] = strTok("UAV;Care Package;Counter-UAV;Sentry Gun;Sentry Gun Care Package;Predator Missile;Precision Airstrike;Harrier Strike;Attack Helicopter;Emergency Airdrop;Pave Low;Stealth Bomber;Chopper Gunner;AC-130;EMP;Nuke", ";");
	self.syn["killstreaks"][2] = strTok("3;4;4;5;5;5;6;7;7;8;9;9;11;11;15;25", ";");
}

create_menu() {
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
	
	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 11), ((self.y_offset + 4) + (i * 15)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
		self.menu["slider_" + i] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + (i * 15)), 224, 16, (0.25, 0.25, 0.25), 0, 5);
		self.menu["option_" + i] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), ((self.y_offset + 4) + (i * 15)), (0.75, 0.75, 0.75), 1, 10);
		self.menu["slider_text_" + i] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), ((self.y_offset + 4) + (i * 15)), (0.75, 0.75, 0.75), 0, 10);
		self.menu["submenu_icon_" + i] = self create_shader("hud_arrow_right", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 223), ((self.y_offset + 4) + (i * 15)), 7, 7, (0.5, 0.5, 0.5), 0, 10);
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

				self playSoundToPlayer("mp_killstreak_radar", self);

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

				self playSoundToPlayer("copycat_steal_class", self);

				if(isDefined(self.previous[(self.previous.size - 1)])) {
					self new_menu();
				} else {
					self close_menu();
				}

				while(self meleeButtonPressed()) {
					wait 0.2;
				}
			} else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {

				self playSoundToPlayer("mouse_over", self);

				scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

				wait (0.2);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {

				self playSoundToPlayer("ui_mp_suitcasebomb_timer", self);

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
				}

				wait (0.2);
			} else if(self useButtonPressed()) {
				self.saved_index[self.current_menu] = self.cursor_index;
				self.saved_offset[self.current_menu] = self.scrolling_offset;
				self.saved_trigger[self.current_menu] = self.previous_trigger;

				self playSoundToPlayer("mouse_click", self);

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

		player.access = set_variable(player isHost(), "Host",  "None");

		if(player isHost()) {
			player initial_variables();
			player thread initialize_menu();
		}
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
		for(i = 1; i <= self.option_limit; i++) {
			self.menu["toggle_" + i].alpha = opacity;
			self.menu["slider_" + i].alpha = opacity;
			self.menu["submenu_icon_" + i].alpha = opacity;
		}
	}

	self.menu["title"].alpha = opacity;
	self.menu["separator_1"].alpha = opacity;
	self.menu["separator_2"].alpha = opacity;

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["option_" + i].alpha = opacity;
		self.menu["slider_text_" + i].alpha = opacity;
	}

	waitframe();

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
		if(strIsNumber(text)) {
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

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].x = (self.x_offset + 11);
		self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["slider_" + i].x = self.x_offset;
		self.menu["slider_" + i].y = (self.y_offset + (i * 15));

		self.menu["option_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["slider_text_" + i].x = (self.x_offset + 132.5);
		self.menu["slider_text_" + i].y = ((self.y_offset + 4) + (i * 15));

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

	illegal = strTok("^A;^B;^F;^H;^I;^0;^1;^2;^3;^4;^5;^6;^7;^8;^9;^:", ";");
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

player_damage_callback(inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset) {
	self endon("disconnect");

	if(isDefined(self.god_mode) && self.god_mode) {
		return;
	}

	[[level.originalCallbackPlayerDamage]](inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset);
}

strIsNumber(value) {
	return !isString(value);
}

array_contains(array_x, value_x) {
	if(array_x.size <= 0) {
		return false;
	}

	foreach(key_x in array_x) {
		if(key_x == value_x) {
			return true;
		}
	}

	return false;
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

add_array(text, description, command, array, parameter_1, parameter_2, parameter_3) {
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
	if(strIsNumber(start)) {
		option.start = start;
	} else {
		option.start = 0;
	}
	if(strIsNumber(minimum)) {
		option.minimum = minimum;
	} else {
		option.minimum = 0;
	}
	if(strIsNumber(maximum)) {
		option.maximum = maximum;
	} else {
		option.maximum = 10;
	}
	if(strIsNumber(increment)) {
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
	letter_index = strTok(" ;A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z", ";");
	letter_width = strTok("5;12;11;11;10;10;10;11;11;5;10;10;9;12;11;11;10;12;10;19;11;10;11;14;10;11;10", ";");
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
	option = strTok("Nothing To See Here!;Quiet Here, Isn't It?;Oops, Nothing Here Yet!;Bit Empty, Don't You Think?", ";");
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
	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].alpha = 0;
		self.menu["slider_" + i].alpha = 0;
		self.menu["option_" + i] set_text("");
		self.menu["slider_text_" + i] set_text("");
		self.menu["submenu_icon_" + i].alpha = 0;
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

				slider_text = self.structure[x].array[self.slider[(self.current_menu + "_" + x)]] + " [" + (self.slider[(self.current_menu + "_" + x)] + 1) + "/" + self.structure[x].array.size + "]";

				self.menu["slider_text_" + i] set_text(slider_text);
			} else if(isDefined(self.structure[x].increment) && (self.cursor_index) == x) {
				value = abs((self.structure[x].minimum - self.structure[x].maximum)) / 224;
				width = ceil((self.slider[(self.current_menu + "_" + x)] - self.structure[x].minimum) / value);

				if(width >= 0) {
					self.menu["slider_" + i] set_shader("white", int(width), 16);
				} else {
					self.menu["slider_" + i] set_shader("white", 0, 16);
					self.menu["slider_" + i].alpha = 0;
				}

				if(!isDefined(self.slider[(self.current_menu + "_" + x)]) || self.slider[(self.current_menu + "_" + x)] < self.structure[x].minimum) {
					self.slider[(self.current_menu + "_" + x)] = self.structure[x].start;
				}

				slider_value = self.slider[(self.current_menu + "_" + x)];
				self.menu["slider_text_" + i] set_text("" + slider_value);
				self.menu["slider_" + i].alpha = 1;
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
			self add_option("Give Killstreaks", undefined, ::new_menu, "Give Killstreaks");
			self add_option("Menu Options", undefined, ::new_menu, "Menu Options");
			self add_option("All Players", undefined, ::new_menu, "All Players");

			break;
		case "Basic Options":
			self add_menu(menu);

			self add_toggle("God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);
			self add_toggle("Infinite Ammo", "Gives you Infinite Ammo and Infinite Grenades", ::infinite_ammo, self.infinite_ammo);

			self add_option("Give All Perks", undefined, ::give_all_perks);
			self add_option("Take All Perks", undefined, ::take_all_perks);

			self add_option("Give Perks", undefined, ::new_menu, "Give Perks");
			self add_option("Take Perks", undefined, ::new_menu, "Take Perks");

			break;
		case "Fun Options":
			self add_menu(menu);

			self add_toggle("Forge Mode", undefined, ::forge_mode, self.forge_mode);

			self add_increment("Set Speed", undefined, ::set_speed, 190, 190, 990, 20);
			self add_increment("Set Timescale", undefined, ::set_timescale, 1, 1, 10, 1);
			self add_increment("Set Gravity", undefined, ::set_gravity, 900, 120, 900, 20);

			self add_toggle("Fullbright", "Removes all Shadows and Lighting", ::fullbright, self.fullbright);
			self add_toggle("Third Person", undefined, ::third_person, self.third_person);

			self add_option("Visions", undefined, ::new_menu, "Visions");

			break;
		case "Menu Options":
			self add_menu(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 20, 10, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -50, 50, 10, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, ::hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

			break;
		case "All Players":
			self add_menu(menu);

			foreach(player in level.players){
				self add_option(player.name, undefined, ::new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self add_menu(menu);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self add_option("Print", "Print Player Name", ::print_player_name, target);
				self add_option("Kill", "Kill the Player", ::commit_suicide, target);

				if(!target isHost() && target.access == "None") {
					self add_option("Verify", "Give the Player Mod Menu Access", ::verify_player, target);
				}

				if(!target isHost()) {
					self add_option("Kick", "Kick the Player from the Game", ::kick_player, target);
				}
			} else {
				self add_option("Player not found");
			}

			break;
		case "Give Perks":
			self add_menu(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::give_perk, self.syn["perks"][0][i], 0);
			}

			break;
		case "Take Perks":
			self add_menu(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::take_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Visions":
			self add_menu(menu);

			self add_option("None", undefined, ::set_vision, "");

			for(i = 0; i < self.syn["visions"][0].size; i++) {
				self add_option(self.syn["visions"][1][i], undefined, ::set_vision, self.syn["visions"][0][i]);
			}

			break;
		case "Give Killstreaks":
			self add_menu(menu);

			for(i = 0; i < self.syn["killstreaks"][0].size; i++) {
				self add_option(self.syn["killstreaks"][1][i], undefined, ::give_killstreak, self.syn["killstreaks"][0][i], self.syn["killstreaks"][2][i]);
			}

			break;
		case "Weapon Options":
			self add_menu(menu);

			category = get_category(getBaseWeaponName(self getCurrentWeapon()));

			self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");

			if(isDefined(category)) {
				if(category != "launchers" && category != "extras") {
					self add_option("Attachments", undefined, ::new_menu, "Attachments");
				}
			}

			self add_option("Take Current Weapon", undefined, ::take_weapon);
			self add_option("Drop Current Weapon", undefined, ::drop_weapon);

			break;
		case "Give Weapons":
			self add_menu(menu);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self add_option(self.syn["weapons"]["category"][1][i], undefined, ::new_menu, self.syn["weapons"]["category"][1][i]);
			}

			break;
		case "Attachments":
			self add_menu(menu);

			category = get_category(getBaseWeaponName(self getCurrentWeapon()));

			if(isDefined(category)) {
				if(category != "launchers" && category != "extras") {
					self add_option("Equip Attachment", undefined, ::new_menu, "Equip Attachment");
				}
				if(category != "launchers" && category != "machine_pistols" && category != "shotguns" && category != "pistols" && category != "extras") {
					self add_option("Equip Camo", undefined, ::new_menu, "Equip Camo");
				}
			}

			break;
		case "Equip Attachment":
			self add_menu(menu);

			weapon_attachments = get_weapon_attachments(getBaseWeaponName(self getCurrentWeapon()));

			foreach(attachment in weapon_attachments) {
				self add_option(get_attachment_name(attachment), undefined, ::equip_attachment, attachment);
			}

			break;
		case "Equip Camo":
			self add_menu(menu);

			self add_increment("Equip Camo", undefined, ::equip_camo, 1, 1, 8, 1);
			self add_toggle("Cycle Camos", undefined, ::cycle_camos, self.cycle_camos);

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
		case "Machine Pistols":
			self add_menu(menu);

			load_weapons("machine_pistols");

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
		self.syn["string"] = self create_text(string, "default", 1.5, "center", "top", 0, -100, (1, 1, 1), 1, 9999, false);
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
		iPrintln(color + " Changed to " + value);
	} else if(color == "Green") {
		self.menu_color_green = value;
		iPrintln(color + " Changed to " + value);
	} else if(color == "Blue") {
		self.menu_color_blue = value;
		iPrintln(color + " Changed to " + value);
	} else {
		iPrintln(value + " | " + color);
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
		self.god_mode = true;
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
		self.god_mode = false;
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

		self setWeaponAmmoStock(self getCurrentWeapon(), 999);

		wait 0.5;
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
		trace = bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 1, self);
		if(isDefined(trace["entity"])) {
			if(self adsButtonPressed()) {
				while (self adsButtonPressed()) {
					trace["entity"] moveTo(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200, .5);
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
	setDvar("g_speed", value);
}

set_timescale(value) {
	setDvar("timescale", value);
}

set_gravity(value) {
	setDvar("g_gravity", value);
}

fullbright() {
	self.fullbright = !return_toggle(self.fullbright);
	if(self.fullbright) {
		iPrintString("Fullbright [^2ON^7]");
		setDvar("r_fullbright", 1);
		wait 0.01;
	} else {
		iPrintString("Fullbright [^1OFF^7]");
		setDvar("r_fullbright", 0);
		wait 0.01;
	}
}

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
		iPrintString("Third Person [^2ON^7]");
		setDvar("camera_thirdPerson", 1);
	} else {
		iPrintString("Third Person [^1OFF^7]");
		setDvar("camera_thirdPerson", 0);
	}
}

set_vision(vision) {
	self visionSetNakedForPlayer("", 0.1);
	wait 0.25;
	self visionSetNakedForPlayer(vision, 0.1);
}

// Player Options

print_player_name(target) {
	iPrintString(target);
}

commit_suicide(target) {
	target suicide();
}

verify_player(target) {
	target.access = "Verified";
	target thread initialize_verified_menu();
}

kick_player(target) {
	kick(target getEntityNumber());
}

// Killstreaks

give_killstreak(streak, value) {
	self maps\mp\killstreaks\_killstreaks::tryGiveKillstreak(streak, int(value));
}

// Perks

give_all_perks() {
	foreach(perk in self.syn["perks"][0]) {
		give_perk(perk);
	}
}

take_all_perks() {
	foreach(perk in self.syn["perks"][0]) {
		take_perk(perk);
	}
}

give_perk(perk) {
	self _setPerk(perk);
}

take_perk(perk) {
	if(_hasPerk(perk)) {
		_unsetPerk(perk);
	}
}

// Weapon Options

get_category(weapon) {
	foreach(weapon_category in self.syn["weapons"]["category"][0]) {
		foreach(weapon_id in self.syn["weapons"][weapon_category][0]) {
			if(weapon_id == weapon) {
				return weapon_category;
			}
		}
	}
}

check_weapons(weapon) {
	if(isDefined(self getWeaponsListPrimaries()[1])) {
		extra_weapon_check = self getWeaponsListPrimaries()[1] != weapon;
	} else {
		extra_weapon_check = true;
	}
	return self getCurrentWeapon() != weapon && extra_weapon_check;
}

give_weapon(weapon, category, index) {
	if(check_weapons(weapon)) {
		max_weapon_num = 2;
		if(self getWeaponsListPrimaries().size >= max_weapon_num) {
			self take_weapon();
		}

		weapon = weapon + "_mp";

		self giveWeapon(weapon);
		self switchToWeapon(weapon);
	} else {
		self switchToWeaponImmediate(weapon);
	}
	wait 1;
	self setWeaponAmmoClip(self getCurrentWeapon(), 999);
}

equip_attachment(attachment) {
	weapon = getBaseWeaponName(self getCurrentWeapon());
	weapon_split = strtok(self getCurrentWeapon(), "_");
	weapon_attachment_1 = undefined;
	weapon_attachment_2 = undefined;

	if(weapon_split.size > 1) {
		for(i = 2; i < weapon_split.size; i++) {
			if(isDefined(weapon_split[i]) && weapon_split[i] != "mp") {
				if(array_contains(self.syn["attachments"][0], weapon_split[i])) {
					if(!isDefined(weapon_attachment_1)) {
						weapon_attachment_1 = weapon_split[i];
					} else if(!isDefined(weapon_attachment_2)) {
						weapon_attachment_2 = weapon_split[i];
					}
				}
			}
		}
	}

	if(!isDefined(weapon_attachment_1)) {
		weapon_attachment_1 = attachment;
	} else if(!isDefined(weapon_attachment_2)) {
		weapon_attachment_2 = attachment;
	}

	if(!isDefined(weapon_attachment_1)) {
		weapon_attachment_1 = "none";
	}
	if(!isDefined(weapon_attachment_2)) {
		weapon_attachment_2 = "none";
	}

	weapon_attached = maps\mp\gametypes\_class::buildWeaponName(weapon, weapon_attachment_1, weapon_attachment_2);
	if(check_weapons(weapon_attached)) {
		self take_weapon();
		self _giveWeapon(weapon_attached);
		self switchToWeapon(weapon_attached);
	} else {
		self switchToWeapon(weapon);
	}
}

get_weapon_attachments(weapon) {
	attachments = [];

	for(i = 11;; i++) {
		column = tableLookup("mp/statsTable.csv", 4, weapon, i);

		if(!isDefined(column) || column == "") {
			break;
		}

		attachments[attachments.size] = column;
	}

	return alphabetize(attachments);
}

get_attachment_name(attachment) {
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
}

equip_camo(camo_index) {
	weapon = self getCurrentWeapon();
	self take_weapon();

	wait(0.05);

	self _giveWeapon(weapon, int(camo_index));
	self switchToWeapon(weapon);
}

cycle_camos() {
	self.cycle_camos = !return_toggle(self.cycle_camos);
	if(self.cycle_camos) {
		self iPrintString("Cycle Camos [^2ON^7]");
		self thread cycle_camos_loop();
	} else {
		self iPrintString("Cycle Camos [^1OFF^7]");
		self notify("stop_cycle_camos");
	}
}

cycle_camos_loop() {
	self endon("stop_cycle_camos");
	self endon("game_ended");

	for(;;) {
		for(i = 1; i <= 8; i++) {
			equip_camo(i);
			wait 2;
		}
	}
}

take_weapon() {
	if(isDefined(self getCurrentWeapon())) {
		self takeweapon(self getCurrentWeapon());
		self switchToWeapon(self getWeaponsListPrimaries()[0]);
	}
}

drop_weapon() {
	if(isDefined(self getCurrentWeapon())) {
		self dropItem(self getCurrentWeapon());
		self switchToWeapon(self getWeaponsListPrimaries()[0]);
	}
}