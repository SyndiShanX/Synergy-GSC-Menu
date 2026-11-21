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
	clientfield::register("world", "timer_hours", 1, 8, "int");
	clientfield::register("world", "timer_minutes", 1, 8, "int");
	clientfield::register("world", "timer_seconds", 1, 8, "int");
	callback::on_spawned(&player_connect);
}

player_connect() { //1f26b6eb
	level flag::wait_till("initial_blackscreen_passed");

	if(self isHost()) {
		self load_settings();

		if(!level.start_on_load) {
			level flag::wait_till("gameplay_started");
		}

		level.timer = 0;
		level thread start_timer();
	}

	while(!isDefined(level.timer)) {
		wait 0.05;
	}

	self thread update_timer();
}

load_settings() { //9b11a3b0
	level.start_on_load = true;

	settings = shieldFromJson("timer");

	if(!isDefined(settings)) {
		shieldToJson("timer", {#start_on_load: true});
	}

	if(isDefined(settings)) {
		if(isDefined(settings.start_on_load)) {
			level.start_on_load = settings.start_on_load;
		}
	}
}

start_timer() { //881eb500
	level endon("game_ended");

	for(;;) {
		wait 1;
		level.timer++;
	}
}

update_timer() { //9ed0e6e9
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		hours = int(level.timer / 3600);
		minutes = int((level.timer % 3600) / 60);
		seconds = int(level.timer % 60);

		if(!isDefined(level.timer_hours) || (isDefined(level.timer_hours) && hours != level.timer_hours)) {
			level clientfield::set("timer_hours", hours);
			level.timer_hours = hours;
		}
		if(!isDefined(level.timer_minutes) || minutes != level.timer_minutes) {
			level clientfield::set("timer_minutes", minutes);
			level.timer_minutes = minutes;
		}
		if(!isDefined(level.timer_seconds) || seconds != level.timer_seconds) {
			level clientfield::set("timer_seconds", seconds);
			level.timer_seconds = seconds;
		}

		wait 0.5;
	}
}