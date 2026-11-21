#include scripts\core_common\callbacks_shared;
#include scripts\core_common\clientfield_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\system_shared;
#include scripts\core_common\util_shared;

#namespace timer;

autoexec __init__system__() { //89f2df9
	system::register("timer", &init, undefined, undefined);
}

init() { //9284135d
	clientfield::register("world", "timer_hours", 1, 8, "int", &set_hours, 0, 0);
	clientfield::register("world", "timer_minutes", 1, 8, "int", &set_minutes, 0, 0);
	clientfield::register("world", "timer_seconds", 1, 8, "int", &set_seconds, 0, 0);

	callback::on_spawned(&player_connect);
}

player_connect(localClientNum) { //1f26b6eb
	self load_settings();

	level.timer_hours = 0;
	level.timer_minutes = 0;
	level.timer_seconds = 0;

	shieldRegisterHudElem(#"timer", "", 0xC8C6C3, self.timer_x, self.timer_y, 0, 0, 0, 0, self.timer_scale);
	shieldHudElemSetColor(#"timer", (self.timer_color_red, self.timer_color_green, self.timer_color_blue));
}

load_settings(localClientNum) { //9b11a3b0
	level.show_unintialized = true;
	level.timer_padding = true;
	self.timer_x = 25;
	self.timer_y = 200;
	self.timer_scale = 0.75;
	self.timer_color_red = 200;
	self.timer_color_green = 198;
	self.timer_color_blue = 195;

	settings = shieldFromJson("timer");

	if(!isDefined(settings)) {
		shieldToJson("timer", {#show_unintialized: true, #timer_padding: true, #timer_x: 25, #timer_y: 200, #timer_scale: 0.75, #timer_color_red: 200, #timer_color_green: 198, #timer_color_blue: 195});
	}

	if(isDefined(settings)) {
		if(isDefined(settings.show_unintialized)) {
			level.show_unintialized = settings.show_unintialized;
		}
		if(isDefined(settings.timer_padding)) {
			level.timer_padding = settings.timer_padding;
		}
		if(isDefined(settings.timer_x)) {
			self.timer_x = int(settings.timer_x);
		}
		if(isDefined(settings.timer_y)) {
			self.timer_y = int(settings.timer_y);
		}
		if(isDefined(settings.timer_scale)) {
			self.timer_scale = settings.timer_scale;
		}
		if(isDefined(settings.timer_color_red)) {
			self.timer_color_red = int(settings.timer_color_red);
		}
		if(isDefined(settings.timer_color_green)) {
			self.timer_color_green = int(settings.timer_color_green);
		}
		if(isDefined(settings.timer_color_blue)) {
			self.timer_color_blue = int(settings.timer_color_blue);
		}
	}
}

set_hours(localClientNum, old_val, new_val, new_ent, initial_snap, field_name, was_time_jump) { //f8557668
	level.timer_hours = new_val;
	set_time();
}

set_minutes(localClientNum, old_val, new_val, new_ent, initial_snap, field_name, was_time_jump) { //21eb67aa
	level.timer_minutes = new_val;
	set_time();
}

set_seconds(localClientNum, old_val, new_val, new_ent, initial_snap, field_name, was_time_jump) { //c48569e7
	level.timer_seconds = new_val;
	set_time();
}

pad_time(time, override_setting) { //8a07e851
	if(self.timer_padding || (isDefined(override_setting) && override_setting)) {
		if (time < 10) {
			return "0" + time;
		}
	}
	return "" + time;
}

set_time(localClientNum) { //7f9d1ac4
	hours = pad_time(level.timer_hours);
	minutes = level.timer_minutes;
	seconds = level.timer_seconds;

	if(int(hours) > 0) {
		minutes = pad_time(minutes, true);
	} else {
		minutes = pad_time(minutes);
	}

	if(int(minutes) > 0) {
		seconds = pad_time(seconds, true);
	} else {
		seconds = pad_time(seconds);
	}

	if(!level.show_unintialized || !level.timer_padding) {
		if(int(hours) < 1) {
			hours = "";
		} else {
			hours += ":";
		}
		if(int(minutes) < 1 && int(hours) < 1) {
			minutes = "";
		} else {
			minutes += ":";
		}
	} else {
		hours += ":";
		minutes += ":";
	}

	shieldHudElemSetText(#"timer", "" + hours + minutes + seconds);
}