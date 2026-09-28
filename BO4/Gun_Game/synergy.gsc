#include scripts\core_common\array_shared;
#include scripts\core_common\callbacks_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\system_shared;

#namespace synergy;

init() { //9284135d
	precache("eventstring", #"synergy_menu");
	precache("eventstring", #"synergy_element_1");
	precache("eventstring", #"synergy_element_2");
	precache("eventstring", #"synergy_element_3");
	precache("eventstring", #"synergy_element_4");
	precache("eventstring", #"synergy_element_5");
	precache("eventstring", #"synergy_element_6");

	precache("eventstring", #"synergy_toggle_1");
	precache("eventstring", #"synergy_toggle_2");
	precache("eventstring", #"synergy_toggle_3");
	precache("eventstring", #"synergy_toggle_4");
	precache("eventstring", #"synergy_toggle_5");
	precache("eventstring", #"synergy_toggle_6");
	precache("eventstring", #"synergy_toggle_7");
	precache("eventstring", #"synergy_toggle_8");
	precache("eventstring", #"synergy_toggle_9");

	precache("eventstring", #"synergy_slider_1");
	precache("eventstring", #"synergy_slider_2");
	precache("eventstring", #"synergy_slider_3");
	precache("eventstring", #"synergy_slider_4");
	precache("eventstring", #"synergy_slider_5");
	precache("eventstring", #"synergy_slider_6");
	precache("eventstring", #"synergy_slider_7");
	precache("eventstring", #"synergy_slider_8");
	precache("eventstring", #"synergy_slider_9");

	precache("eventstring", #"synergy_title");
	precache("eventstring", #"synergy_description");

	precache("eventstring", #"synergy_option_1");
	precache("eventstring", #"synergy_option_2");
	precache("eventstring", #"synergy_option_3");
	precache("eventstring", #"synergy_option_4");
	precache("eventstring", #"synergy_option_5");
	precache("eventstring", #"synergy_option_6");
	precache("eventstring", #"synergy_option_7");
	precache("eventstring", #"synergy_option_8");
	precache("eventstring", #"synergy_option_9");

	precache("eventstring", #"synergy_slider_text_1");
	precache("eventstring", #"synergy_slider_text_2");
	precache("eventstring", #"synergy_slider_text_3");
	precache("eventstring", #"synergy_slider_text_4");
	precache("eventstring", #"synergy_slider_text_5");
	precache("eventstring", #"synergy_slider_text_6");
	precache("eventstring", #"synergy_slider_text_7");
	precache("eventstring", #"synergy_slider_text_8");
	precache("eventstring", #"synergy_slider_text_9");

	precache("eventstring", #"synergy_submenu_icon_1");
	precache("eventstring", #"synergy_submenu_icon_2");
	precache("eventstring", #"synergy_submenu_icon_3");
	precache("eventstring", #"synergy_submenu_icon_4");
	precache("eventstring", #"synergy_submenu_icon_5");
	precache("eventstring", #"synergy_submenu_icon_6");
	precache("eventstring", #"synergy_submenu_icon_7");
	precache("eventstring", #"synergy_submenu_icon_8");
	precache("eventstring", #"synergy_submenu_icon_9");

	precache("eventstring", #"synergy_element_7");
	precache("eventstring", #"synergy_element_8");

	precache("eventstring", #"synergy_extra_text_1");
	precache("eventstring", #"synergy_extra_text_2");
	precache("eventstring", #"synergy_extra_text_3");
	precache("eventstring", #"synergy_extra_text_4");
	precache("eventstring", #"synergy_extra_text_5");
	precache("eventstring", #"synergy_extra_text_6");
	precache("eventstring", #"synergy_extra_text_7");

	callback::on_spawned(&player_connect);
	level thread create_rainbow_color();
}

initial_variables() { //ec264b2e
	self.in_menu = false;
	self.initialized = false;
	self.menu_initialized = false;
	self.synergy_enabled = false;
	self.gun_game_enabled = false;
	self.hud_created = false;
	self.loaded_offset = false;
	self.option_limit = 9;
	self.current_menu = "Synergy";
	self.structure = array();
	self.previous = array();
	self.previous_option = undefined;
	self.saved_index = array();
	self.saved_offset = array();
	self.saved_trigger = array();
	self.slider = array();

	self.x_offset = 1220;
	self.y_offset = 400;

	self.rainbow_enabled = true;
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.syn["background"] = spawnStruct();
	self.syn["cursor"] = spawnStruct();
	self.syn["background"].height = 450;
	self.syn["cursor"].y = 430;
	self.syn["cursor"].index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.description_height = 0;
}

initialize_menu() { //15544841
	level endon("game_ended");
	self endon("disconnect");

	while(!self.menu_initialized) {
		if(self.host) {
			level.player_out_of_playable_area_monitor = false;
			self notify("stop_player_out_of_playable_area_monitor");

			self waittill("init_menu");
			self.menu_initialized = true;

			self thread input_manager();

			if(!self.hud_created) {
				luinotifyevent(#"synergy_menu", 7, 100001, (self.x_offset - 2), (self.x_offset + 452), (self.y_offset - 2), (self.y_offset + 244), 1, 255); // Border
				luinotifyevent(#"synergy_menu", 7, 100002, self.x_offset, (self.x_offset + 450), self.y_offset, (self.y_offset + 242), 1, 19); // Background
				luinotifyevent(#"synergy_menu", 7, 100003, self.x_offset, (self.x_offset + 450), (self.y_offset + 30), (self.y_offset + 242), 1, 25); // Foreground
				luinotifyevent(#"synergy_menu", 7, 100004, (self.x_offset + 10), (self.x_offset + 95), (self.y_offset + 15), (self.y_offset + 17), 1, 255); // Separator 1
				luinotifyevent(#"synergy_menu", 7, 100005, (self.x_offset + 355), (self.x_offset + 440), (self.y_offset + 15), (self.y_offset + 17), 1, 255); // Separator 2
				luinotifyevent(#"synergy_menu", 7, 100006, self.x_offset, (self.x_offset + 450), self.syn["cursor"].y, (self.syn["cursor"].y + 32), 0, 38); // Cursor

				luinotifyevent(#"synergy_menu", 7, 100021, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 38), (self.y_offset + 54), 0, 64); // Toggle 1
				luinotifyevent(#"synergy_menu", 7, 100022, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 68), (self.y_offset + 84), 0, 64); // Toggle 2
				luinotifyevent(#"synergy_menu", 7, 100023, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 98), (self.y_offset + 114), 0, 64); // Toggle 3
				luinotifyevent(#"synergy_menu", 7, 100024, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 128), (self.y_offset + 144), 0, 64); // Toggle 4
				luinotifyevent(#"synergy_menu", 7, 100025, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 158), (self.y_offset + 174), 0, 64); // Toggle 5
				luinotifyevent(#"synergy_menu", 7, 100026, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 188), (self.y_offset + 204), 0, 64); // Toggle 6
				luinotifyevent(#"synergy_menu", 7, 100027, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 218), (self.y_offset + 234), 0, 64); // Toggle 7
				luinotifyevent(#"synergy_menu", 7, 100028, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 248), (self.y_offset + 264), 0, 64); // Toggle 8
				luinotifyevent(#"synergy_menu", 7, 100029, (self.x_offset + 6), (self.x_offset + 22), (self.y_offset + 278), (self.y_offset + 294), 0, 64); // Toggle 9

				luinotifyevent(#"synergy_menu", 7, 100031, self.x_offset, (self.x_offset + 450), (self.y_offset + 30), (self.y_offset + 62), 0, 64); // Slider 1
				luinotifyevent(#"synergy_menu", 7, 100032, self.x_offset, (self.x_offset + 450), (self.y_offset + 60), (self.y_offset + 92), 0, 64); // Slider 2
				luinotifyevent(#"synergy_menu", 7, 100033, self.x_offset, (self.x_offset + 450), (self.y_offset + 90), (self.y_offset + 122), 0, 64); // Slider 3
				luinotifyevent(#"synergy_menu", 7, 100034, self.x_offset, (self.x_offset + 450), (self.y_offset + 120), (self.y_offset + 152), 0, 64); // Slider 4
				luinotifyevent(#"synergy_menu", 7, 100035, self.x_offset, (self.x_offset + 450), (self.y_offset + 150), (self.y_offset + 182), 0, 64); // Slider 5
				luinotifyevent(#"synergy_menu", 7, 100036, self.x_offset, (self.x_offset + 450), (self.y_offset + 180), (self.y_offset + 212), 0, 64); // Slider 6
				luinotifyevent(#"synergy_menu", 7, 100037, self.x_offset, (self.x_offset + 450), (self.y_offset + 210), (self.y_offset + 242), 0, 64); // Slider 7
				luinotifyevent(#"synergy_menu", 7, 100038, self.x_offset, (self.x_offset + 450), (self.y_offset + 240), (self.y_offset + 272), 0, 64); // Slider 8
				luinotifyevent(#"synergy_menu", 7, 100039, self.x_offset, (self.x_offset + 450), (self.y_offset + 270), (self.y_offset + 302), 0, 64); // Slider 9

				luinotifyevent(#"synergy_menu", 3, 100101, (self.x_offset + 189), (self.y_offset + 3)); // Title
				luinotifyevent(#"synergy_menu", 3, 100102, (self.x_offset + 10), (self.y_offset + 242)); // Description

				luinotifyevent(#"synergy_menu", 3, 100110, (self.x_offset + 10), (self.y_offset + 34)); // Option Text 1
				luinotifyevent(#"synergy_menu", 3, 100111, (self.x_offset + 10), (self.y_offset + 64)); // Option Text 2
				luinotifyevent(#"synergy_menu", 3, 100112, (self.x_offset + 10), (self.y_offset + 94)); // Option Text 3
				luinotifyevent(#"synergy_menu", 3, 100113, (self.x_offset + 10), (self.y_offset + 124)); // Option Text 4
				luinotifyevent(#"synergy_menu", 3, 100114, (self.x_offset + 10), (self.y_offset + 154)); // Option Text 5
				luinotifyevent(#"synergy_menu", 3, 100115, (self.x_offset + 10), (self.y_offset + 184)); // Option Text 6
				luinotifyevent(#"synergy_menu", 3, 100116, (self.x_offset + 10), (self.y_offset + 214)); // Option Text 7
				luinotifyevent(#"synergy_menu", 3, 100117, (self.x_offset + 10), (self.y_offset + 244)); // Option Text 8
				luinotifyevent(#"synergy_menu", 3, 100118, (self.x_offset + 10), (self.y_offset + 274)); // Option Text 9

				luinotifyevent(#"synergy_menu", 3, 100120, (self.x_offset + 265), (self.y_offset + 34)); // Slider Text 1
				luinotifyevent(#"synergy_menu", 3, 100121, (self.x_offset + 265), (self.y_offset + 64)); // Slider Text 2
				luinotifyevent(#"synergy_menu", 3, 100122, (self.x_offset + 265), (self.y_offset + 94)); // Slider Text 3
				luinotifyevent(#"synergy_menu", 3, 100123, (self.x_offset + 265), (self.y_offset + 124)); // Slider Text 4
				luinotifyevent(#"synergy_menu", 3, 100124, (self.x_offset + 265), (self.y_offset + 154)); // Slider Text 5
				luinotifyevent(#"synergy_menu", 3, 100125, (self.x_offset + 265), (self.y_offset + 184)); // Slider Text 6
				luinotifyevent(#"synergy_menu", 3, 100126, (self.x_offset + 265), (self.y_offset + 214)); // Slider Text 7
				luinotifyevent(#"synergy_menu", 3, 100127, (self.x_offset + 265), (self.y_offset + 244)); // Slider Text 8
				luinotifyevent(#"synergy_menu", 3, 100128, (self.x_offset + 265), (self.y_offset + 274)); // Slider Text 9

				luinotifyevent(#"synergy_menu", 3, 100130, (self.x_offset + 425), (self.y_offset + 32)); // Submenu Icon Text 1
				luinotifyevent(#"synergy_menu", 3, 100131, (self.x_offset + 425), (self.y_offset + 62)); // Submenu Icon Text 2
				luinotifyevent(#"synergy_menu", 3, 100132, (self.x_offset + 425), (self.y_offset + 92)); // Submenu Icon Text 3
				luinotifyevent(#"synergy_menu", 3, 100133, (self.x_offset + 425), (self.y_offset + 122)); // Submenu Icon Text 4
				luinotifyevent(#"synergy_menu", 3, 100134, (self.x_offset + 425), (self.y_offset + 152)); // Submenu Icon Text 5
				luinotifyevent(#"synergy_menu", 3, 100135, (self.x_offset + 425), (self.y_offset + 182)); // Submenu Icon Text 6
				luinotifyevent(#"synergy_menu", 3, 100136, (self.x_offset + 425), (self.y_offset + 212)); // Submenu Icon Text 7
				luinotifyevent(#"synergy_menu", 3, 100137, (self.x_offset + 425), (self.y_offset + 242)); // Submenu Icon Text 8
				luinotifyevent(#"synergy_menu", 3, 100138, (self.x_offset + 425), (self.y_offset + 272)); // Submenu Icon Text 9

				luinotifyevent(#"synergy_menu", 7, 100007, (self.x_offset + 296), (self.x_offset + 683), (self.y_offset - 358), (self.y_offset - 317), 0, 19); // Status Border
				luinotifyevent(#"synergy_menu", 7, 100008, (self.x_offset + 298), (self.x_offset + 681), (self.y_offset - 356), (self.y_offset - 319), 0, 19); // Status Background
				luinotifyevent(#"synergy_menu", 3, 100140, (self.x_offset + 400), (self.y_offset - 350)); // Status Text 1
				luinotifyevent(#"synergy_menu", 3, 100141, (self.x_offset + 350), (self.y_offset - 325)); // Status Text 2
				luinotifyevent(#"synergy_menu", 3, 100142, (self.x_offset + 350), (self.y_offset - 300)); // Status Text 3
				luinotifyevent(#"synergy_menu", 3, 100143, (self.x_offset + 350), (self.y_offset - 275)); // Status Text 4
				luinotifyevent(#"synergy_menu", 3, 100144, (self.x_offset + 350), (self.y_offset - 250)); // Status Text 5
				luinotifyevent(#"synergy_menu", 3, 100145, (self.x_offset + 350), (self.y_offset - 225)); // Status Text 6
				luinotifyevent(#"synergy_menu", 3, 100146, (self.x_offset + 350), (self.y_offset - 200)); // Status Text 7

				for(i = 3; i <= 9; i++) {
					self.menu["synergy_text_" + string(i)] = spawnStruct();
					self.menu["synergy_text_" + string(i)].x = (self.x_offset + 10);
				}

				self.hud_created = true;
			}

			set_text("title", "Controls", 0);
			set_text("option_1", "Open: ^3[{+speed_throw}] ^7and ^3[{+melee}]", 2);
			set_text("option_2", "Scroll: ^3[{+speed_throw}] ^7or ^3[{+attack}]", 2);
			set_text("option_3", "Select: ^3[{+activate}] ^7Back: ^3[{+melee}]", 2);
			set_text("option_4", "Sliders: ^3[{+smoke}]^7 ^7or ^3[{+frag}]", 2);

			set_shader_height("element_1", 156);
			set_shader_height("element_2", 152);
			set_shader_height("element_3", 122);

			self.controls_menu_open = true;
			self thread start_rainbow();

			wait 8;

			if(self.controls_menu_open) {
				close_controls_menu();
			}
		}
		wait 0.05;
	}
}

input_manager() { //fb500cd3
	level endon("game_ended");
	self endon("disconnect");

	while(self.host) {
		if(!self.in_menu) {
			if(self adsButtonPressed() && self meleeButtonPressed()) {
				if(self.controls_menu_open) {
					close_controls_menu();
				}

				if(self.synergy_enabled) {
					if(self.gun_game_enabled && self.gun_game_started) {
						self.current_menu = "Synergy";
					}
				} else if(self.gun_game_enabled && self.gun_game_started) {
					self notify("open_gun_game_menu");
				}

				open_menu();

				while(self adsButtonPressed() && self meleeButtonPressed()) {
					wait 0.2;
				}
			}
			if(self changeSeatButtonPressed() && self.gun_game_enabled && self.gun_game_started) {
				if(self.controls_menu_open) {
					close_controls_menu();
				}

				self notify("open_gun_game_menu");

				while(self changeSeatButtonPressed()) {
					wait 0.2;
				}
			}
		} else {
			if(self meleeButtonPressed()) {
				self.saved_index[self.current_menu] = self.syn["cursor"].index;
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
				
				if(self.gun_game_enabled && (self.current_menu == "Setup Options" || self.current_menu == "Gun Game Options")) {
					self notify("menu_option_gun_game");
				} else {
					self notify("menu_option");
				}

				scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

				wait (0.2);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {
				if(isDefined(self.structure[self.syn["cursor"].index].array) || isDefined(self.structure[self.syn["cursor"].index].increment)) {
					scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
				}

				wait (0.2);
			} else if(self useButtonPressed()) {
				self.saved_index[self.current_menu] = self.syn["cursor"].index;
				self.saved_offset[self.current_menu] = self.scrolling_offset;
				self.saved_trigger[self.current_menu] = self.previous_trigger;

				if(self.structure[self.syn["cursor"].index].command == &new_menu) {
					self.previous_option = self.structure[self.syn["cursor"].index].text;
				}

				if(isDefined(self.structure[self.syn["cursor"].index].array) || isDefined(self.structure[self.syn["cursor"].index].increment)) {
					if(isDefined(self.structure[self.syn["cursor"].index].array)) {
						cursor_selected = self.structure[self.syn["cursor"].index].array[self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + self.syn["cursor"].index)]];
					} else {
						cursor_selected = self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))];
					}
					self thread execute_function(self.structure[self.syn["cursor"].index].command, cursor_selected, self.structure[self.syn["cursor"].index].parameter_1, self.structure[self.syn["cursor"].index].parameter_2, self.structure[self.syn["cursor"].index].parameter_3);
				} else if(isDefined(self.structure[self.syn["cursor"].index]) && isDefined(self.structure[self.syn["cursor"].index].command)) {
					self thread execute_function(self.structure[self.syn["cursor"].index].command, self.structure[self.syn["cursor"].index].parameter_1, self.structure[self.syn["cursor"].index].parameter_2, self.structure[self.syn["cursor"].index].parameter_3);
				}

				if(self.gun_game_enabled && (self.current_menu == "Setup Options" || self.current_menu == "Gun Game Options")) {
					self notify("menu_option_gun_game");
				} else {
					self notify("menu_option");
				}

				wait 0.05;
				set_options();

				while(self useButtonPressed()) {
					wait 0.2;
				}
			}
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

open_menu() { //fec2e2ad
	self.in_menu = true;

	set_menu_visibility(1);

	if(self.gun_game_enabled && !self.gun_game_started) {
		self notify("menu_option_gun_game");
	} else {
		self notify("menu_option");
	}

	wait 0.05;
	scroll_cursor();
	set_options();
}

close_menu() { //cc09e153
	set_menu_visibility(0);

	self.in_menu = false;
}

close_controls_menu() { //1ca8a22d
	set_shader_height("element_1", 246);
	set_shader_height("element_2", 242);
	set_shader_height("element_3", 212);

	self.controls_menu_open = false;

	set_menu_visibility(0);

	set_text("title", "", 0);
	set_text("option_1", "", 2);
	set_text("option_2", "", 2);
	set_text("option_3", "", 2);
	set_text("option_4", "", 2);

	self.in_menu = false;
}

set_menu_visibility(opacity) { //40a7558d
	for(i = 1; i < 7; i++) {
		luinotifyevent(#"synergy_element_" + string(i), 2, 200002, opacity);
	}

	luinotifyevent(#"synergy_title", 2, 200002, opacity);
	luinotifyevent(#"synergy_description", 2, 200002, opacity);

	for(i = 1; i <= self.option_limit; i++) {
		luinotifyevent(#"synergy_option_" + string(i), 2, 200002, opacity);
		luinotifyevent(#"synergy_slider_text_" + string(i), 2, 200002, opacity);
		luinotifyevent(#"synergy_submenu_icon_" + string(i), 2, 200002, opacity);
	}

	if(opacity == 0) {
		for(i = 1; i <= self.option_limit; i++) {
			luinotifyevent(#"synergy_toggle_" + string(i), 2, 200002, opacity);
			luinotifyevent(#"synergy_slider_" + string(i), 2, 200002, opacity);
		}
	}
}

set_text(element, text, variant) { //d5ea17f0
	setDvar("laboratory_special_offer_" + string(element), "" + text);
	if(variant == 0) {
		luinotifyevent(#"synergy_title", 2, 200007, 0);
	} else if(variant == 1) {
		luinotifyevent(#"synergy_description", 2, 200007, 1);
	} else if(variant == 2) {
		luinotifyevent(#"synergy_" + string(element), 3, 200007, 2, int(strTok(element, "_")[1]));
	} else if(variant == 3) {
		luinotifyevent(#"synergy_" + string(element), 3, 200007, 3, int(strTok(element, "_")[2]));
	} else if(variant == 4) {
		luinotifyevent(#"synergy_" + string(element), 3, 200007, 4, int(strTok(element, "_")[2]));
	} else if(variant == 5) {
		luinotifyevent(#"synergy_" + string(element), 3, 200007, 5, int(strTok(element, "_")[2]));
	}
}

set_shader_height(element, height) { //e2dacb2b
	luinotifyevent(#"synergy_" + string(element), 2, 200003, height);
}

set_lui_element_x(element, x_pos, extra) { //28744bf9
	if(isDefined(extra)) {
		luinotifyevent(#"synergy_" + string(element), 3, 200005, x_pos, extra);
	} else {
		luinotifyevent(#"synergy_" + string(element), 2, 200005, x_pos);
	}
}

set_lui_element_y(element, y_pos, extra) { //caab9069
	if(isDefined(extra)) {
		luinotifyevent(#"synergy_" + string(element), 3, 200006, y_pos, extra);
	} else {
		luinotifyevent(#"synergy_" + string(element), 2, 200006, y_pos);
	}
}

update_element_positions() { //69453e2e
	set_lui_element_x("element_1", int(self.x_offset - 2), 454);
	set_lui_element_y("element_1", int(self.y_offset - 2));

	set_lui_element_x("element_2", int(self.x_offset), 450);
	set_lui_element_y("element_2", int(self.y_offset));

	set_lui_element_x("element_3", int(self.x_offset), 450);
	set_lui_element_y("element_3", int(self.y_offset + 30));

	set_lui_element_x("element_4", int(self.x_offset + 10), 85);
	set_lui_element_y("element_4", int(self.y_offset + 15), 2);

	set_lui_element_x("element_5", int(self.x_offset + 355), 85);
	set_lui_element_y("element_5", int(self.y_offset + 15), 2);

	set_lui_element_x("element_6", int(self.x_offset), 450);

	for(i = 1; i <= self.option_limit; i++) {
		set_lui_element_x("toggle_" + string(i), int(self.x_offset + 6));
		set_lui_element_y("toggle_" + string(i), int(self.y_offset + (i * 30) + 8));
		set_lui_element_x("slider_" + string(i), int(self.x_offset));
		set_lui_element_y("slider_" + string(i), int(self.y_offset + (i * 30)));

		set_lui_element_y("option_" + string(i), int(((self.y_offset + 4) + (i * 30))));
		set_lui_element_x("slider_text_" + string(i), int(self.x_offset + 265));
		set_lui_element_y("slider_text_" + string(i), int(((self.y_offset + 4) + (i * 30))));
		set_lui_element_x("submenu_icon_" + string(i), int(self.x_offset + 425));
		set_lui_element_y("submenu_icon_" + string(i), int(((self.y_offset + 2) + (i * 30))));
	}
}

// Colors

set_menu_color(color) { //d5163d06
	if(self.in_menu || self.controls_menu_open) {
		luinotifyevent(#"synergy_element_1", 4, 200001, int(color[0] * 255), int(color[1] * 255), int(color[2] * 255));
		luinotifyevent(#"synergy_element_4", 4, 200001, int(color[0] * 255), int(color[1] * 255), int(color[2] * 255));
		luinotifyevent(#"synergy_element_5", 4, 200001, int(color[0] * 255), int(color[1] * 255), int(color[2] * 255));
		luinotifyevent(#"synergy_element_7", 4, 200001, int(color[0] * 255), int(color[1] * 255), int(color[2] * 255));
	}
}

create_rainbow_color() { //f26b389
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

		level.rainbow_color = (r / 255, g / 255, b / 255);
		wait 0.05;
	}
}

start_rainbow() { //f0d557b3
	level endon("game_ended");
	self endon("disconnect");

	while(self.in_menu || self.controls_menu_open) {
		if(self.rainbow_enabled) {
			set_menu_color(level.rainbow_color);
			wait 0.05;
		} else {
			set_menu_color(self.menu_color);
			break;
		}
	}
}

// Misc Functions

return_toggle(variable) { //df47a93e
	return isDefined(variable) && variable;
}

set_variable(check, option_1, option_2) { //ccd7591c
	if(check) {
		return option_1;
	} else {
		return option_2;
	}
}

remove_from_array(array, object) { //4a82c16f
	if(!isDefined(array) || !isDefined(object)) {
		return;
	}
	new_array = array();
	foreach(item in array) {
		if(item != object) {
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

// Custom Structure

execute_function(command, parameter_1, parameter_2, parameter_3, parameter_4) { //42a328b2
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

add_option(text, description, command, parameter_1, parameter_2, parameter_3) { //58d27b23
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = &empty_function;
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

	array::add(self.structure, option);
}

add_toggle(text, description, command, variable, parameter_1, parameter_2) { //4b7ea67
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = &empty_function;
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

	array::add(self.structure, option);
}

add_array(text, description, command, label, array, parameter_1, parameter_2, parameter_3) { //ad88d2ff
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = &empty_function;
	} else {
		option.command = command;
	}
	if(isDefined(label) && isString(label)) {
		option.label = label;
	} else {
		option.label = "";
	}
	if(!isDefined(array)) {
		option.array = array();
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

	array::add(self.structure, option);
}

add_increment(text, description, command, label, start, minimum, maximum, increment, parameter_1, parameter_2) { //628281e1
	option = spawnStruct();
	option.text = text;
	if(isDefined(description)) {
		option.description = description;
	}
	if(!isDefined(command)) {
		option.command = &empty_function;
	} else {
		option.command = command;
	}
	if(isDefined(label) && isString(label)) {
		option.label = label;
	} else {
		option.label = "";
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

	array::add(self.structure, option);
}

get_title_width(title) { //2bc4de7b
	letter_index = array(" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
	letter_width = array(5, 15, 14, 13, 15, 12, 12, 14, 14, 10, 9, 14, 13, 18, 14, 15, 14, 15, 14, 14, 14, 14, 15, 21, 15, 14, 13, 12, 12, 10, 12, 12, 9, 15, 12, 5, 6, 12, 5, 17, 13, 12, 12, 12, 8, 12, 9, 12, 12, 19, 11, 12, 11);

	title_width = 0;

	for(i = 1; i < title.size; i++) {
		for(x = 1; x < letter_index.size; x++) {
			if(title[i] == letter_index[x]) {
				title_width = int(title_width) + int(letter_width[x]);
			}
		}
	}

	return title_width;
}

set_title(title) { //28ccc05d
	set_text("title", title, 0);

	title_width = get_title_width(title);

	set_lui_element_x("title", int(self.x_offset + ceil((1.71631e-8  * pow(title_width, 5)) + (-1.02115e-5 * pow(title_width, 4)) + (0.00232560  * pow(title_width, 3)) + (-0.25214795 * pow(title_width, 2)) + (12.4154567  * title_width) + -27.5886621)));
	set_lui_element_y("title", int(self.y_offset + 3));
}

new_menu(menu) { //30112462
	if(!isDefined(menu)) {
		menu = self.previous[(self.previous.size - 1)];
		self.previous[(self.previous.size - 1)] = undefined;
	} else {
		self.previous[self.previous.size] = self.current_menu;
	}

	if(isDefined(self.structure[self.syn["cursor"].index].label) && !isDefined(self.slider[(menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))])) {
		self.slider[(menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))] = 0;
	}

	if(self.synergy_enabled) {
		self.current_menu = set_variable(isDefined(menu), menu, "Synergy");
	}

	if(self.gun_game_enabled) {
		if(self.gun_game_started) {
			self.current_menu = set_variable(isDefined(menu), menu, "Gun Game Options");
		} else {
			self.current_menu = set_variable(isDefined(menu), menu, "Setup Options");
		}
	}

	if(isDefined(self.saved_index[self.current_menu])) {
		self.syn["cursor"].index = self.saved_index[self.current_menu];
		self.scrolling_offset = self.saved_offset[self.current_menu];
		self.previous_trigger = self.saved_trigger[self.current_menu];
		self.loaded_offset = true;
	} else {
		self.syn["cursor"].index = 0;
		self.scrolling_offset = 0;
		self.previous_trigger = 0;
	}

	if(self.gun_game_enabled && (self.current_menu == "Setup Options" || self.current_menu == "Gun Game Options")) {
		self notify("menu_option_gun_game");
	} else {
		self notify("menu_option");
	}

	wait 0.05;
	scroll_cursor();
}

empty_function() {} //20c470db

empty_option() { //a3ed0f9e
	option = array("Nothing To See Here!", "Quiet Here, Isn't It?", "Oops, Nothing Here Yet!", "Bit Empty, Don't You Think?");
	return option[randomInt(option.size)];
}

scroll_cursor(direction) { //1cf9a91c
	maximum = self.structure.size - 1;
	fake_scroll = false;

	if(maximum < 0) {
		maximum = 0;
	}

	if(isDefined(direction)) {
		if(direction == "down") {
			self.syn["cursor"].index++;
			if(self.syn["cursor"].index > maximum) {
				self.syn["cursor"].index = 0;
				self.scrolling_offset = 0;
			}
		} else if(direction == "up") {
			self.syn["cursor"].index--;
			if(self.syn["cursor"].index < 0) {
				self.syn["cursor"].index = maximum;
				if(((self.syn["cursor"].index) + int((self.option_limit / 2))) >= (self.structure.size - 2)) {
					self.scrolling_offset = (self.structure.size - self.option_limit);
				}
			}
		}
	} else {
		while(self.syn["cursor"].index > maximum) {
			self.syn["cursor"].index--;
		}
		self.syn["cursor"].y = int(self.y_offset + (((self.syn["cursor"].index + 1) - self.scrolling_offset) * 30));
		luinotifyevent(#"synergy_element_6", 3, 200006, self.syn["cursor"].y, 32);
	}

	self.previous_scrolling_offset = self.scrolling_offset;

	if(!self.loaded_offset) {
		if(self.syn["cursor"].index >= int(self.option_limit / 2) && self.structure.size > self.option_limit) {
			if((self.syn["cursor"].index + int(self.option_limit / 2)) >= (self.structure.size - 2)) {
				self.scrolling_offset = (self.structure.size - self.option_limit);
				if(self.previous_trigger == 2) {
					self.scrolling_offset--;
				}
				if(self.previous_scrolling_offset != self.scrolling_offset) {
					fake_scroll = true;
					self.previous_trigger = 1;
				}
			} else {
				self.scrolling_offset = (self.syn["cursor"].index - int(self.option_limit / 2));
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
		self.syn["cursor"].y = int(self.y_offset + (((self.syn["cursor"].index + 1) - self.scrolling_offset) * 30));
		luinotifyevent(#"synergy_element_6", 3, 200006, self.syn["cursor"].y, 32);
	}

	if(isDefined(self.structure) && self.structure.size > 0 && isDefined(self.structure[self.syn["cursor"].index]) && isDefined(self.structure[self.syn["cursor"].index].description)) {
		set_text("description", self.structure[self.syn["cursor"].index].description, 1);
		self.description_height = 30;

		luinotifyevent(#"synergy_description", 3, 200008, 0, 9);
		set_lui_element_x("description", int((self.x_offset + 11) - (self.structure[self.syn["cursor"].index].description.size * 0.5)));

		if(self.structure[self.syn["cursor"].index].description.size > 52) {
			luinotifyevent(#"synergy_description", 3, 200008, 0, 675);
			set_lui_element_x("description", int((self.x_offset + 11) - (self.structure[self.syn["cursor"].index].description.size * 1.55)));
		}
	} else {
		set_text("description", "", 1);
		self.description_height = 0;
	}

	self.loaded_offset = false;
	set_options();
}

scroll_slider(direction) { //6e2f9762
	current_slider_index = self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))];
	if(isDefined(direction)) {
		if(isDefined(self.structure[self.syn["cursor"].index].array)) {
			if(direction == "left") {
				current_slider_index--;
				if(current_slider_index < 0) {
					current_slider_index = (self.structure[self.syn["cursor"].index].array.size - 1);
				}
			} else if(direction == "right") {
				current_slider_index++;
				if(current_slider_index > (self.structure[self.syn["cursor"].index].array.size - 1)) {
					current_slider_index = 0;
				}
			}
		} else {
			if(direction == "left") {
				current_slider_index -= self.structure[self.syn["cursor"].index].increment;
				if(current_slider_index < self.structure[self.syn["cursor"].index].minimum) {
					current_slider_index = self.structure[self.syn["cursor"].index].maximum;
				}
			} else if(direction == "right") {
				current_slider_index += self.structure[self.syn["cursor"].index].increment;
				if(current_slider_index > self.structure[self.syn["cursor"].index].maximum) {
					current_slider_index = self.structure[self.syn["cursor"].index].minimum;
				}
			}
		}
	}
	self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))] = current_slider_index;
	set_options();
}

set_options() { //a0d8ccb6
	if(isDefined(self.equip_attachment_in_progress)) {
		while(self.equip_attachment_in_progress) {
			wait 0.05;
		}
	}

	for(i = 1; i <= self.option_limit; i++) {
		luinotifyevent(#"synergy_toggle_" + string(i), 2, 200002, 0);
		luinotifyevent(#"synergy_slider_" + string(i), 2, 200002, 0);
		set_text("option_" + string(i), "", 2);
		set_text("slider_text_" + string(i), "", 3);
		set_text("submenu_icon_" + string(i), "", 4);
	}

	update_element_positions();

	if(isDefined(self.structure)) {
		if(self.structure.size == 0) {
			self add_option(empty_option());
		}

		maximum = int(min(self.structure.size, self.option_limit));

		if(self.structure.size <= self.option_limit) {
			self.scrolling_offset = 0;
		}

		for(i = 1; i <= maximum; i++) {
			x = ((i - 1) + self.scrolling_offset);

			set_text("option_" + string(i), self.structure[x].text, 2);

			if(isDefined(self.structure[x].command) && self.structure[x].command == &new_menu) {
				set_text("submenu_icon_" + string(i), ">", 4);
			}

			if(isDefined(self.structure[x].toggle)) {
				set_lui_element_x("option_" + string(i), int(self.x_offset + 27));
				luinotifyevent(#"synergy_toggle_" + string(i), 2, 200002, 1);

				if(self.structure[x].toggle) {
					luinotifyevent(#"synergy_toggle_" + string(i), 4, 200001, 255, 255, 255);
				} else {
					luinotifyevent(#"synergy_toggle_" + string(i), 4, 200001, 64, 64, 64);
				}
			} else {
				set_lui_element_x("option_" + string(i), int(self.x_offset + 10));
			}

			if(isDefined(self.structure[x].label)) {
				if(!isDefined(self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)])) {
					self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] = set_variable(isDefined(self.structure[x].array), 0, self.structure[x].start);
				}
			}

			if(isDefined(self.structure[x].array) && (self.syn["cursor"].index) == x && isDefined(self.structure[x].label)) {
				if(self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] > (self.structure[x].array.size - 1) || self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] < 0) {
					self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] = set_variable(self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] > (self.structure[x].array.size - 1), 0, (self.structure[x].array.size - 1));
				}

				slider_text = string(self.structure[x].array[self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)]] + " [" + (self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] + 1) + "/" + self.structure[x].array.size + "]");

				if(slider_text.size > 13) {
					slider_scale = 7;
					set_lui_element_y("slider_text_" + string(i), int((self.y_offset + 10) + (i * 30)));
				} else if(slider_text.size > 14) {
					slider_scale = 55;
					set_lui_element_y("slider_text_" + string(i), int((self.y_offset + 10) + (i * 30)));
				} else {
					slider_scale = 8;
					set_lui_element_y("slider_text_" + string(i), int((self.y_offset + 9) + (i * 30)));
				}
				luinotifyevent(#"synergy_slider_text_" + string(i), 2, 200009, int(slider_scale));

				set_text("slider_text_" + string(i), slider_text, 3);
			} else if(isDefined(self.structure[x].increment) && (self.syn["cursor"].index) == x && isDefined(self.structure[x].label)) {
				value = abs((self.structure[x].minimum - self.structure[x].maximum)) / 450;
				width = ceil((self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)] - self.structure[x].minimum) / value);
				if(width >= 0) {
					luinotifyevent(#"synergy_slider_" + string(i), 2, 200004, int(width));
				} else {
					luinotifyevent(#"synergy_slider_" + string(i), 2, 200004, 0);
				}

				slider_value = self.slider[(self.current_menu + "_" + self.structure[x].label + "_" + x)];
				set_text("slider_text_" + string(i), "" + slider_value, 3);
				luinotifyevent(#"synergy_slider_" + string(i), 2, 200002, 1);
			}

			if(!isDefined(self.structure[x].command)) {
				luinotifyevent(#"synergy_option_" + string(i), 4, 200001, 191, 191, 191);
			} else {
				if((self.syn["cursor"].index) == x) {
					luinotifyevent(#"synergy_option_" + string(i), 4, 200001, 191, 191, 191);
					luinotifyevent(#"synergy_submenu_icon_" + string(i), 4, 200001, 191, 191, 191);
				} else {
					luinotifyevent(#"synergy_option_" + string(i), 4, 200001, 127, 127, 127);
					luinotifyevent(#"synergy_submenu_icon_" + string(i), 4, 200001, 127, 127, 127);
				}
			}
		}
	}

	menu_height = int(36 + (maximum * 30));

	set_lui_element_y("description", int((self.y_offset + 5) + ((maximum + 1) * 30)));

	set_shader_height("element_1", int(menu_height + self.description_height));
	set_shader_height("element_2", int((menu_height - 4) + self.description_height));
	set_shader_height("element_3", int(menu_height - 34));
}

// Menu Options

modify_menu_position(offset, axis) { //e4288074
	if(axis == "x") {
		self.x_offset = 1220 + offset;
	} else {
		self.y_offset = 400 + offset;
	}
	scroll_cursor();
}

set_menu_rainbow() { //e709099e
	self.rainbow_enabled = true;
	self thread start_rainbow();
}

set_menu_colors(value, color) { //55638223
	self.rainbow_enabled = false;
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
	self.menu_color = (self.menu_color_red / 255, self.menu_color_green / 255, self.menu_color_blue / 255);

	set_menu_color(self.menu_color);
}

hide_ui() { //a7e74c75
	self.hide_ui = !return_toggle(self.hide_ui);
	if(self.hide_ui) {
		self setClientUIVisibilityFlag("hud_visible", 0);
	} else {
		self setClientUIVisibilityFlag("hud_visible", 1);
	}
}

hide_weapon() { //6395585f
	self.hide_weapon = !return_toggle(self.hide_weapon);
	setDvar(#"cg_drawgun", !self.hide_weapon);
}