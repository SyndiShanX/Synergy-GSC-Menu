#include scripts\core_common\callbacks_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\system_shared;
#include scripts\zm_common\zm_pack_a_punch_util;
#include scripts\zm_common\zm_weapons;

#namespace havelina_damage_patch;

autoexec __init__system__() { //89f2df9
	system::register("havelina_damage_patch", &init, undefined, undefined);
}

init() { //9284135d
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("initial_blackscreen_passed");
	
	wait 5;
	
	callback::on_ai_damage(&patch_damage);
	callback::on_ai_killed(&patch_hitmarker);
}

patch_damage(params) { //c61b72d9
	if(isDefined(self.havelina_patching) && self.havelina_patching) {
		return;
	}
	
	if(!isDefined(self) || !isAlive(self)) {
		return;
	}

	attacker = params.eattacker;
  weapon = params.weapon;
	damage = params.idamage;
	hit_location = params.shitloc;

	if(isPlayer(attacker)) {
		damage_weapon = zm_weapons::get_base_weapon(weapon);
		havelina = zm_weapons::get_base_weapon(getweapon("sniper_damagesemi_t8"));
		
		if(damage_weapon == havelina && zm_weapons::is_weapon_upgraded(weapon)) {
			self.havelina_patching = true;
			
			pap_level = attacker zm_pap_util::function_83c29ddb(weapon);
			pap_multiplier = (600 / (49 * (pap_level + 4)));
			damage_modified = int((((pap_level * 0.45) + 1.8) * damage) * pap_multiplier);

			if(isInArray(array("head", "neck", "helmet"), hit_location)) {
				final_damage = int(ceil(1.16677 * damage_modified));
			} else if(isInArray(array("left_hand", "left_arm_lower", "left_arm_upper", "right_hand", "right_arm_lower", "right_arm_upper"), hit_location)) {
				final_damage = int(0.778 * damage_modified);
			} else if(isInArray(array("left_leg_upper", "right_leg_upper"), hit_location)) {
				final_damage = int(ceil(1.16677 * damage_modified));
			} else if(isInArray(array("left_leg_lower", "left_foot", "right_leg_lower", "right_foot"), hit_location)) {
				if(pap_level == 0) {
					final_damage = int(1.556 * damage_modified);
				} else {
					final_damage = int(ceil(1.559 * damage_modified));
				}
			} else {
				final_damage = damage_modified;
			}
			
			self doDamage((final_damage - damage), self.origin, attacker);
			
			wait 0.05;
			
			if(isDefined(self)) {
				self.havelina_patching = undefined;
			}
		}
	}
}

patch_hitmarker(params) { //4acf7d02
	if(isDefined(self.havelina_patching) && self.havelina_patching) {
		params.eattacker playHitmarker(undefined, 5, undefined, 1, 0);
	}
}