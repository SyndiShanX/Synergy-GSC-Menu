#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\zombies;

init() {
	executeCommand("sv_cheats 1");

	level thread player_connect();
	level thread create_rainbow_color();

	wait 0.5;

	level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	level.callbackPlayerDamage = ::player_damage_callback; // Retropack

	level thread overflow_fix_init();
}

initial_variables() {
	self.in_menu = false;
	self.hud_created = false;
	self.loaded_offset = false;
	self.option_limit = 25;
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
	self.y_offset = 140;
	self.previous_y_offset = 140;

	self.point_increment = 100;
	self.map_name = get_map_name();
	self.color_theme = "rainbow";
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.cursor_index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.previous_option = undefined;

	// Visions

	self.syn["visions"][0] = ["", "mp_comeback", "mp_comeback_osp", "mp_comeback_drone", "mp_comeback_warbird", "coup_sunblind", "mp_recovery", "mp_zombie_lab_infected", "mp_zombie_lab_infected_crazy"];
	self.syn["visions"][1] = ["None", "Comeback", "Comeback OSP", "Comeback Drone", "Comeback Warbird", "Coup Sunblind", "Recovery", "mp_zombie_lab_infected", "mp_zombie_lab_infected_crazy"];

	// Weapons

	self.syn["weapons"]["assault_rifles"][0] =   ["iw5_bal27zm_mp", "iw5_ak12zm_mp", "iw5_arx160zm_mp", "iw5_hbra3zm_mp", "iw5_himarzm_mp", "iw5_m182sprzm_mp", "iw5_dlcgun1zm_mp"];
	self.syn["weapons"]["sub_machine_guns"][0] = ["iw5_mp11zm_mp", "iw5_asm1zm_mp", "iw5_sn6zm_mp", "iw5_sac3zm_mp_akimbosac3", "iw5_hmr9zm_mp"];
	self.syn["weapons"]["sniper_rifles"][0] =    ["iw5_gm6zm_mp_gm6scope"];
	self.syn["weapons"]["shotguns"][0] =         ["iw5_maulzm_mp", "iw5_uts19zm_mp", "iw5_rhinozm_mp"];
	self.syn["weapons"]["heavy_weapons"][0] =    ["iw5_em1zm_mp", "iw5_lsatzm_mp", "iw5_asawzm_mp"];
	self.syn["weapons"]["pistols"][0] =          ["iw5_titan45zm_mp", "iw5_rw1zm_mp", "iw5_vbrzm_mp"];
	self.syn["weapons"]["launchers"][0] =        ["iw5_exocrossbowzm_mp", "iw5_mahemzm_mp_mahemscopebase"];
	self.syn["weapons"]["equipment"][0] =        ["frag_grenade_zombies_mp", "contact_grenade_zombies_mp", "distraction_drone_zombie_mp", "dna_aoe_grenade_zombie_mp", "explosive_drone_zombie_mp"];

	self.syn["weapons"]["assault_rifles"][1] =   ["Bal-27", "AK12", "ARX-160", "HBRa3", "IMR", "MK14", "AE4"];
	self.syn["weapons"]["sub_machine_guns"][1] = ["MP11", "ASM1", "SN6", "SAC3", "AMR9"];
	self.syn["weapons"]["sniper_rifles"][1] =    ["Lynx"];
	self.syn["weapons"]["shotguns"][1] =         ["Bulldog", "Tac-19", "S-12"];
	self.syn["weapons"]["heavy_weapons"][1] =    ["EM1", "Pytaek", "Ameli"];
	self.syn["weapons"]["pistols"][1] =          ["Atlas 45", "RW1", "PDW"];
	self.syn["weapons"]["launchers"][1] =        ["Crossbow", "MAHEM"];
	self.syn["weapons"]["equipment"][1] =        ["Frag Grenade", "Contact Grenade", "Distraction Drone", "Nano Swarm", "Explosive Drone"];

	// Powerups

	self.syn["powerups"][0] = ["nuke", "ammo", "insta_kill", "double_points", "fire_sale", "trap"];
	self.syn["powerups"][1] = ["Nuke", "Max Ammo", "Insta Kill", "Double Points", "Fire Sale", "Security"];

	// Attachments

	self.syn["attachments"][0] = ["opticstargetenhancer", "quickdraw"];
	self.syn["attachments"][1] = ["Target Enhancer", "Quickdraw", "Extended Mags"];

	// Camos

	self.syn["camos"][0] = ["camo23", "camo07", "camo14", "camo03", "camo02", "camo04", "camo05", "camo06", "camo25", "camo08", "camo12", "camo10", "camo11", "camo24", "camo18", "camo13", "camo09", "camo15", "camo17"];
	self.syn["camos"][1] = ["Mk 2", "Mk 3", "Mk 4", "Mk 5", "Mk 6", "Mk 7", "Mk 8", "Mk 9", "Mk 10", "Mk 11", "Mk 12", "Mk 13", "Mk 14", "Mk 15", "Mk16", "Mk 17", "Mk 18", "Mk 19", "Mk 20"];
}

initialize_menu() {
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
	  event_name = self waittill_any_return("spawned_player", "player_downed", "death", "joined_spectators");
	  switch (event_name) {
	    case "spawned_player":
	      if(self isHost()) {
	        self freezeControls(false);

	        self thread input_manager();

	        if(!self.hud_created) {
	          self.menu["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset - 1), (self.y_offset - 1), 226, 122, self.color_theme, 1, 1);
	          self.menu["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, self.y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
	          self.menu["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
	          self.menu["separator_1"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 5.5), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	          self.menu["separator_2"] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 220), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	          self.menu["cursor"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, 215, 223, 13, (0.15, 0.15, 0.15), 0, 4);

	          self.menu["title"] = self create_text("Synergy", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 94.5), (self.y_offset), (1, 1, 1), 1, 10);

	          self.menu["options"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + 15), (0.75, 0.75, 0.75), 1, 10);
	          self.menu["submenu_icons"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 215), ((self.y_offset + 15)), (0.75, 0.75, 0.75), 0, 10);
						self.menu["slider_text"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), (self.y_offset + 19), (0.75, 0.75, 0.75), 0, 10);
						self.menu["slider"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + 15), 224, 16, (0.25, 0.25, 0.25), 0, 5);

	          for(i = 1; i <= self.option_limit; i++) {
	            self.menu["toggle_" + i] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 11), ((self.y_offset + 4) + (i * 12) + 1), 8, 8, (0.25, 0.25, 0.25), 0, 9);
	          }

	          self.hud_created = true;
	        }

	        self.menu["title"] set_text("Controls");

	        self.menu["options"] set_text("Open: ^3[{+speed_throw}] ^7and ^3[{+melee}]\n^7Scroll: ^3[{+speed_throw}] ^7and ^3[{+attack}]\n^7Select: ^3[{+activate}] ^7Back: ^3[{+melee}]\n^7Sliders: ^3[{+smoke}] ^7and ^3[{+frag}]");

	        self.menu["border"] set_shader("white", self.menu["border"].width, 73);
	        self.menu["background"] set_shader("white", self.menu["background"].width, 71);
	        self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 56);

	        self.controls_menu_open = true;

	        wait 8;

	        if(self.controls_menu_open) {
	          close_controls_menu();
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

	      //self playSoundToPlayer("zmb_hit_oz_boss", self);

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

	      //self playSoundToPlayer("zmb_hit", self);

	      if(isDefined(self.previous[(self.previous.size - 1)])) {
	        self new_menu();
	      } else {
	        self close_menu();
	      }

	      while(self meleeButtonPressed()) {
	        wait 0.2;
	      }
	    } else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {

	      //self playSoundToPlayer("distraction_drone_deploy", self);

	      scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

	      wait (0.2);
	    } else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {

	      //self playSoundToPlayer("distraction_drone_alarm", self);

	      if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
	        scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
	      }

	      wait (0.2);
	    } else if(self useButtonPressed()) {
	      self.saved_index[self.current_menu] = self.cursor_index;
	      self.saved_offset[self.current_menu] = self.scrolling_offset;
	      self.saved_trigger[self.current_menu] = self.previous_trigger;

	      //self playSoundToPlayer("ee_door_locked", self);

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

	self.in_menu = false;
}

set_menu_visibility(opacity) {
	if(opacity == 0) {
	  self.menu["border"].alpha = opacity;
		self.menu["slider"].alpha = opacity;
	  for(i = 1; i <= self.option_limit; i++) {
	    self.menu["toggle_" + i].alpha = opacity;
	  }
	}

	self.menu["title"].alpha = opacity;
	self.menu["separator_1"].alpha = opacity;
	self.menu["separator_2"].alpha = opacity;

	self.menu["options"].alpha = opacity;
	self.menu["submenu_icons"].alpha = opacity;
	self.menu["slider_text"].alpha = opacity;

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
		textElement set_text(text);
	}

	self.element_result++;
	return textElement;
}

set_text(text) {
	if(!isDefined(self) || !isDefined(text)) {
	  return;
	}

	self.text = text;
	self overflow_set_text(text);
}

add_text(text, index) {
	if(!isDefined(self) || !isDefined(text)) {
	  return;
	}

	self.text = text;
	self.text_array[index] = text + "\n";
}

set_text_array() {
	if(!isDefined(self)) {
	  return;
	}

	if(!isDefined(self.previous_text)) {
	  self.previous_text = "";
	}

	text = "";

	for(i = 1; i <= self.text_array.size; i++) {
	  text = text + self.text_array[i];
	}

	if(text != self.previous_text) {
	  self.previous_text = text;
		self set_text(text);
	}
}

overflow_fix_init() {
	level.strings = [];

	level.overflowElem = createServerFontString("default", 1.5);
	level.overflowElem setText("overflow");
	level.overflowElem.alpha = 0;

	level thread overflow_monitor();
}

overflow_set_text(string) {
	self.string = string;
	self setText(string);
	self overflow_add_string(string);
	self thread overflow_fix_string();
}

overflow_add_string(string) {
	level.strings[level.strings.size] = string;
	level notify("string_added");
}

overflow_fix_string() {
	self notify("new_string");
	self endon("new_string");

	while(isDefined(self)) {
		level waittill("overflow_fixed");
		if(isDefined(self.string)) {
			self overflow_set_text(self.string);
		}
	}
}

overflow_monitor() {
	level endon("game_ended");
	for(;;) {
		level waittill("string_added");
		if(level.strings.size >= 25) {
			level.overflowElem clearAllTextAfterHudElem();
			level.strings = [];
			level notify("overflow_fixed");
		}
		wait 0.01;
	}
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

	self.menu["options"].x = (self.x_offset + 5);
	self.menu["options"].y = (self.y_offset + 15);

	self.menu["submenu_icons"].x = (self.x_offset + 215);
	self.menu["submenu_icons"].y = (self.y_offset + 15);

	self.menu["slider_text"].x = (self.x_offset + 132.5);
	self.menu["slider_text"].y = ((self.y_offset + 4) + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	self.menu["slider"].x = self.x_offset;
	self.menu["slider"].y = (self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 12) + 3);

	for(i = 1; i <= self.option_limit; i++) {
	  self.menu["toggle_" + i].x = (self.x_offset + 11);
	  self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 12) + 1);
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
	if(level.script == "mp_zombie_lab") return "outbreak";
	if(level.script == "mp_zombie_brg") return "infection";
	if(level.script == "mp_zombie_ark") return "carrier";
	if(level.script == "mp_zombie_h20") return "Descent";
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

load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
	  if(weapon_category != "equipment") {
	    self add_option(self.syn["weapons"][weapon_category][1][i], undefined, ::give_weapon, self.syn["weapons"][weapon_category][0][i]);
	  } else {
	    self add_option(self.syn["weapons"][weapon_category][1][i], undefined, ::give_grenade, self.syn["weapons"][weapon_category][0][i]);
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

add_menu(title) {
	self.menu["title"] set_text(title);

	title_width = get_title_width(title);

	self.menu["title"].x = (self.x_offset + ceil((((-0.000015 * title_width + 0.003832) * title_width - 0.52) * title_width + 115.258) * 10) / 10);
	self.menu["title"].y = (self.y_offset);
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
	  self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 12) + 3);
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
	  self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 12) + 3);
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

	    self.menu["options"] add_text(self.structure[x].text, i);

	    if(isDefined(self.structure[x].toggle)) {
	      self.menu["options"].alpha = 1;
	      self.menu["toggle_" + i].alpha = 1;

	      if(self.structure[x].toggle) {
	        self.menu["toggle_" + i].color = (1, 1, 1);
	      } else {
	        self.menu["toggle_" + i].color = (0.25, 0.25, 0.25);
	      }
	    } else {
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
	      self.menu["submenu_icons"] add_text(">", i);
	    }
	  }
	}

	self.menu["options"] set_text_array();
	self.menu["submenu_icons"] set_text_array();

	menu_height = int(18 + (self.maximum * 12) + 3);

	self.menu["border"] set_shader("white", self.menu["border"].width, int(menu_height));
	self.menu["background"] set_shader("white", self.menu["background"].width, int((menu_height - 2)));
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
	    self add_option("Powerup Options", undefined, ::new_menu, "Powerup Options");
	    self add_option("Menu Options", undefined, ::new_menu, "Menu Options");
	    self add_option("All Players", undefined, ::new_menu, "All Players");

	    break;
	  case "Basic Options":
	    self add_menu(menu);

	    self add_toggle("    God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
	    self add_toggle("    Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);
	    self add_toggle("    Infinite Ammo", "Gives you Infinite Ammo and Infinite Grenades", ::infinite_ammo, self.infinite_ammo);

	    self add_increment("Set Points", undefined, ::set_points, 500, 0, 100000, 500);

	    break;
	  case "Fun Options":
	    self add_menu(menu);

	    self add_toggle("    Fullbright", "Removes all Shadows and Lighting", ::fullbright, self.fullbright);
	    self add_toggle("    Third Person", undefined, ::third_person, self.third_person);

	    self add_increment("Set Speed", undefined, ::set_speed, 190, 190, 1190, 50);
	    self add_increment("Set Timescale", undefined, ::set_timescale, 1, 1, 10, 1);
	    self add_increment("Set Gravity", undefined, ::set_gravity, 800, 40, 800, 10);

	    self add_option("Visions", undefined, ::new_menu, "Visions");

	    break;
	  case "Weapon Options":
	    self add_menu(menu);

	    self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");

	    self add_toggle("    Give Pack-a-Punched Weapons", "Weapons Given will be Pack-a-Punched", ::give_packed_weapon, self.give_packed_weapon);
	    self add_toggle("    Give Max Pack-a-Punched Weapons", "Weapons Given will be Pack-a-Punched to Mk 20", ::give_max_packed_weapon, self.give_max_packed_weapon);

	    self add_option("Take Current Weapon", undefined, ::take_weapon);
	    self add_option("Drop Current Weapon", undefined, ::drop_weapon);

	    self add_toggle("    Freeze 3D Printer", "Locks the 3D Printer, so it can't move", ::freeze_box, self.freeze_box);

	    break;
	  case "Powerup Options":
	    self add_menu(menu);

	    self add_toggle("    Shoot Powerups", undefined, ::shoot_powerups, self.shoot_powerups);

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

	    self add_toggle("    Hide UI", undefined, ::hide_ui, self.hide_ui);
	    self add_toggle("    Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

	    break;
	  case "All Players":
	    self add_menu(menu);

	    foreach(player in level.players) {
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

	      if(!target isHost()) {
	        self add_option("Kick", "Kick the Player from the Game", ::kick_player, target);
	      }
	    } else {
	      self add_option("Player not found");
	    }

	    break;
	  case "Give Weapons":
	    self.y_offset = self.previous_y_offset;

	    self add_menu(menu);

	    self add_option("Normal Weapons", undefined, ::new_menu, "Normal Weapons");
	    self add_option("Equipment", undefined, ::new_menu, "Equipment");
	    if(self.map_name != "outbreak") {
	      self add_option("Extras", undefined, ::new_menu, "Extras");
	    } else {
	      self add_option("CEL-3 Cauterizer", undefined, ::give_weapon, "iw5_fusionzm_mp");
	    }

	    break;
	  case "Visions":
	    self add_menu(menu);

	    for(i = 0; i < self.syn["visions"][0].size; i++) {
	      self add_option(self.syn["visions"][1][i], undefined, ::set_vision, self.syn["visions"][0][i]);
	    }

	    break;
	  case "Normal Weapons":
	    if(self.y_offset != 70) {
	      self.previous_y_offset = self.y_offset;
	      self.y_offset = 70;
	    }

	    self add_menu(menu);

	    load_weapons("assault_rifles");

	    load_weapons("sub_machine_guns");

	    load_weapons("sniper_rifles");

	    load_weapons("shotguns");

	    load_weapons("heavy_weapons");

	    load_weapons("pistols");

	    load_weapons("launchers");

	    break;
	  case "Equipment":
	    self add_menu(menu);

	    load_weapons("equipment");

	    if(self.map_name == "carrier") {
	      self add_option("Teleport Grenade", undefined, ::give_grenade, "teleport_zombies_mp");
	      self add_option("Repulsor", undefined, ::give_grenade, "repulsor_zombie_mp");
	    }

	    break;
	  case "Extras":
	    self add_menu(menu);

	    self add_option("CEL-3 Cauterizer", undefined, ::give_weapon, "iw5_fusionzm_mp");

	    if(self.map_name == "carrier") {
	      self add_option("LZ-52 Limbo", undefined, ::give_weapon, "iw5_linegunzm_mp");
	      self add_option("Ohm", undefined, ::give_weapon, "iw5_dlcgun2zm_mp");
	      self add_option("M1 Irons", undefined, ::give_weapon, "iw5_dlcgun3zm_mp");
	    }

	    if(self.map_name == "descent") {
	      self add_option("LZ-52 Limbo", undefined, ::give_weapon, "iw5_linegunzm_mp");
	      self add_option("Ohm", undefined, ::give_weapon, "iw5_dlcgun2zm_mp");
	      self add_option("M1 Irons", undefined, ::give_weapon, "iw5_dlcgun3zm_mp");
	      self add_option("Trident", undefined, ::give_weapon, "iw5_tridentzm_mp");
	      self add_option("Blunderbuss", undefined, ::give_weapon, "iw5_dlcgun4zm_mp");
	      self add_option("Mech Minigun (Blocks View)", undefined, ::give_weapon, "iw5_exominigunzm_mp");
	      self add_option("Mech Rocket (Blocks View)", undefined, ::give_weapon, "playermech_rocket_zm_mp");
	    }

	    if(self.map_name != "infection") {
	      self add_option("iw5_microwavezm_mp", undefined, ::give_weapon, "iw5_microwavezm_mp"); // Maybe?
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
	  iPrintlnBold(color + " Changed to " + value);
	} else if(color == "Green") {
	  self.menu_color_green = value;
	  iPrintlnBold(color + " Changed to " + value);
	} else if(color == "Blue") {
	  self.menu_color_blue = value;
	  iPrintlnBold(color + " Changed to " + value);
	} else {
	  iPrintlnBold(value + " | " + color);
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
	  iPrintlnBold("God Mode [^2ON^7]");
	} else {
	  iPrintlnBold("God Mode [^1OFF^7]");
	}
}

frag_no_clip() {
	self endon("disconnect");
	self endon("game_ended");

	if(!isDefined(self.frag_no_clip)) {
	  self.frag_no_clip = true;
	  iPrintlnBold("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
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
	  iPrintlnBold("Frag No Clip [^1OFF^7]");
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
	  vec = anglesToForward(self getAngles());
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
	  iPrintlnBold("Infinite Ammo [^2ON^7]");
	  self thread infinite_ammo_loop();
	} else {
	  iPrintlnBold("Infinite Ammo [^1OFF^7]");
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

set_points(value) {
	self.moneycurrent = value;
	//givemoney(value);
	//resetmoney(value);
}

// Fun Options

freeze_box() {
	self.freeze_box = !return_toggle(self.freeze_box);
	if(self.freeze_box) {
	  iPrintlnBold("Freeze Box [^2ON^7]");
	  self thread freeze_box_loop();
	} else {
	  iPrintlnBold("Freeze Box [^1OFF^7]");
	  level notify("stop_freeze_box");
	}
}

freeze_box_loop() {
	self endon("death");
	self endon("disconnect");
	self endon("stop_freeze_box");
	for(;;) {
	  flag_clear("magic_box_moved");
	  wait 0.1;
	}
}

fullbright() {
	self.fullbright = !return_toggle(self.fullbright);
	if(self.fullbright) {
	  iPrintlnBold("Fullbright [^2ON^7]");
	  setDvar("r_fullbright", 1);
	  wait 0.01;
	} else {
	  iPrintlnBold("Fullbright [^1OFF^7]");
	  setDvar("r_fullbright", 0);
	  wait 0.01;
	}
}

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
	  iPrintlnBold("Third Person [^2ON^7]");
	  setDvar("camera_thirdPerson", 1);
	  setThirdPersonDOF(1);
	} else {
	  iPrintlnBold("Third Person [^1OFF^7]");
	  setDvar("camera_thirdPerson", 0);
	  setThirdPersonDOF(0);
	}
}

set_speed(value) {
	setDvar("g_speed", value);
}

set_timescale(value) {
	setDvar("timescale", value);
}

set_gravity(value) {
	setDvar("bg_gravity", value);
}

set_vision(vision) {
	self visionSetNakedForPlayer("", 0.1);
	wait 0.25;
	self visionSetNakedForPlayer(vision, 0.1);
}

// Player Options

print_player_name(target) {
	iPrintlnBold(target);
}

commit_suicide(target) {
	target suicide();
}

kick_player(target) {
	kick(target getEntityNumber());
}

// Powerup Options

spawn_powerup(powerup) {
	level maps\mp\gametypes\zombies::createPickup(powerup, self.origin + anglesToForward(self.angles) * 115);
}

shoot_powerups() {
	self.shoot_powerups = !return_toggle(self.shoot_powerups);
	if(self.shoot_powerups) {
	  iPrintlnBold("Shoot Powerups [^2ON^7]");
	  shoot_powerups_loop();
	} else {
	  iPrintlnBold("Shoot Powerups [^1OFF^7]");
	  self notify("stop_shoot_powerups");
	}
}

shoot_powerups_loop() {
	self endon("stop_shoot_powerups");
	self endon("game_ended");

	for(;;) {
	  while(self attackButtonPressed()) {
	    powerup = self.syn["powerups"][0][randomInt(self.syn["powerups"][0].size)];
	    level maps\mp\gametypes\zombies::createPickup(powerup, self.origin + anglesToForward(self.angles) * 115);
	    wait 0.5;
	  }
	  wait 0.05;
	}
}

// Weapon Options

give_packed_weapon() {
	self.give_packed_weapon = !return_toggle(self.give_packed_weapon);
	if(isDefined(self.give_max_packed_weapon) && self.give_max_packed_weapon == true) {
	  self.give_max_packed_weapon = !return_toggle(self.give_max_packed_weapon);
	}
}

give_max_packed_weapon() {
	self.give_max_packed_weapon = !return_toggle(self.give_max_packed_weapon);
	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon == true) {
	  self.give_packed_weapon = !return_toggle(self.give_packed_weapon);
	}
}

give_grenade(grenade) {
	maps\mp\zombies\_wall_buys::giveZombieEquipment(self, grenade, 0);
}

give_weapon(weapon) {
	weapon = getWeaponBaseName(weapon);

	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon == 1 || isDefined(self.pack_weapon) && self.pack_weapon == 1) {

	}

	if(!self hasWeapon(weapon) || isDefined(self.pack_weapon) && self.pack_weapon == 1) {
	  max_weapon_num = 2;
	  saved_weapon = undefined;

	  switch(weapon) {
	    case "frag_grenade_zombies_mp":
	    case "contact_grenade_zombies_mp":
	    case "distraction_drone_zombie_mp":
	    case "teleport_zombies_mp":
	    case "repulsor_zombie_mp":
	    case "dna_aoe_grenade_zombie_mp":
	    case "explosive_drone_zombie_mp":
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

	  if(isDefined(saved_weapon)) {
	    wait 0.5;
	    self giveWeapon(saved_weapon);
	    self switchToWeaponImmediate(saved_weapon);
	    saved_weapon = undefined;
	  } else {
	    self switchToWeaponImmediate(weapon);
	  }
	} else {
	  self switchToWeaponImmediate(weapon);
	}

	self.pack_weapon = 0;
	wait 0.5;
	self giveStartAmmo(weapon);
}

take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

// Zombie Options

no_target() {
	self.no_target = !return_toggle(self.no_target);
	if(self.no_target) {
	  iPrintlnBold("No Target [^2ON^7]");
	  self.ignoreme = 1;
	} else {
	  iPrintlnBold("No Target [^1OFF^7]");
	  self.ignoreme = 0;
	}
}

set_round(value) {
	level.wave_num = value;
}

get_zombies() {
	return maps\mp\zombies\_util::getEnemyAgents();
}

spawn_zombie(archetype) {

}

kill_all_zombies() {
	foreach(zombie in get_zombies()) {
	  zombie doDamage(zombie.health + 999, zombie.origin);
	}
}

teleport_zombies() {
	foreach(zombie in get_zombies()) {
	  zombie setOrigin(self.origin + anglesToForward(self.angles) * 200);
	}
}

one_shot_zombies() {
	if(!isDefined(self.one_shot_zombies)) {
	  iPrintlnBold("One Shot Zombies [^2ON^7]");
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
	  iPrintlnBold("One Shot Zombies [^1OFF^7]");
	  self.one_shot_zombies = undefined;
	  foreach(zombie in get_zombies()) {
	    zombie.maxHealth = level.prevHealth;
	    zombie.health = level.prevHealth;
	  }
	}
}

freeze_zombies() {
	if(!isDefined(self.freeze_zombies)) {
	  iPrintlnBold("Freeze Zombies [^2ON^7]");
	  self.freeze_zombies = true;
	  while(isDefined(self.freeze_zombies)) {
	    foreach(zombie in get_zombies()) {
	      zombie freezeControls(true);
	    }
	    wait 0.01;
	  }
	} else {
	  iPrintlnBold("Freeze Zombies [^1OFF^7]");
	  self.freeze_zombies = undefined;
	  foreach(zombie in get_zombies()) {
	    zombie freezeControls(false);
	  }
	}
}