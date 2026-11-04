#include maps\mp\gametypes\_hud_util;

init() {
	level thread get_remaining_zombies();
	level thread zombie_counter();
}

create_text(text, font, font_scale, align_x, align_y, x_offset, y_offset, color, alpha, z_index, hide_when_in_menu) {
	textElement = self createFontString(font, font_scale);
	textElement setPoint(align_x, align_y, x_offset, y_offset);

	textElement.alpha = alpha;
	textElement.sort = z_index;
	textElement.anchor = self;
	textElement.hideWhenInMenu = false;

	if(isDefined(color)) {
		textElement.color = color;
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

	return textElement;
}

set_text(text) {
	if(!isDefined(self) || !isDefined(text)) {
		return;
	}

	self.text = text;
	self setText(text);
}

get_remaining_zombies() {
	level endon("game_ended");
	
	for(;;) {
		level.remaining_zombies = 0;
		level.zombies_to_spawn_zeroed = false;
		check_remaining_zombies();
    level waittill("zombie_wave_started");
  }
}

check_remaining_zombies() {
	while(zombies_to_spawn == 0) {
		zombies_to_spawn = level._id_AC12 maps\mp\_utility::_id_5DCB();
		level.remaining_zombies = _id_0547::_id_408F().size;
		wait 0.01;
	}
	zombies_to_spawn++;
	level.zombies_to_spawn_zeroed = false;
	level.remaining_zombies = 1;

	while(level.remaining_zombies > 0) {
		if(zombies_to_spawn != 0 && !level.zombies_to_spawn_zeroed) {
			zombies_to_spawn = level._id_AC12 maps\mp\_utility::_id_5DCB();
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
		
    level.remaining_zombies = zombies_to_spawn + spawned_zombies + zombies_to_respawn + var_2;
    wait 0.5;
  }
}

zombie_counter() {
	level endon("game_ended");
	
	for(;;) {
		foreach(player in level.players) {
			count = level.remaining_zombies;
			if(!isDefined(count)) {
				count = 0;
			}
			if(!isDefined(player.gui["counter"])) {
				player.gui["counter"] = player create_text("Zombies Remaining: " + count, "default", 1, "right", "top", 349, -220, (0.65, 0.64, 0.56), 1, 9999);
			} else {
				player.gui["counter"] set_text("Zombies Remaining: " + count);
			}
		}
		wait 0.01;
	}
}