#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientField_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;

#namespace clientids;

REGISTER_SYSTEM("clientids", &__init__, undefined)

function __init__() {
	callback::on_start_gametype(&init);
}

function init() {
	setDvar("sv_cheats", "1");

	level thread player_connect();
	level thread create_rainbow_color();

	wait 0.5;
}

function player_connect() {
	level endon("game_ended");

	for(;;) {
		level waittill("connected", player);

		player.syn_access = "None";

		if(player isHost()) {
			player.syn_access = "Host";
			player initial_variables();
			player thread initialize_menu();
		}
	}
}

function initial_variables() {
	self.syn = [];
	self.menu = [];
	self.syn_in_menu = false;
	self.syn_hud_created = false;
	self.syn_loaded_offset = false;
	self.syn_initialized = false;
	self.syn_option_limit = 7;
	self.syn_current_menu = "Synergy";
	self.syn_structure = [];
	self.syn_previous = [];
	self.syn_saved_index = [];
	self.syn_saved_offset = [];
	self.syn_saved_trigger = [];
	self.syn_slider = [];

	self.syn_font = "default";
	self.syn_font_scale = 1;
	self.syn_x_offset = 175;
	self.syn_y_offset = 160;

	self.syn_map_name = get_map_name();
	self.syn_color_theme = "rainbow";
	self.syn_menu_color_red = 0;
	self.syn_menu_color_green = 0;
	self.syn_menu_color_blue = 0;

	self.syn_cursor_index = 0;
	self.syn_scrolling_offset = 0;
	self.syn_previous_scrolling_offset = 0;
	self.syn_description_height = 0;
	self.syn_previous_option = undefined;

	self.syn_point_increment = 100;
	self.syn_round_increment = 1;

	self.syn_equip_attachment_in_progress = false;

	self.syn_speed_cola_fastads = true;
	self.syn_speed_cola_fastweaponswitch = true;
	self.syn_speed_cola_fastequipmentuse = true;

	self.syn_stamin_up_sprintfire = true;
	self.syn_stamin_up_stalker = true;
	self.syn_stamin_up_unlimitedsprint = true;
	self.syn_stamin_up_fastladderclimb = true;
	self.syn_stamin_up_fastmantle = true;
	self.syn_stamin_up_sprintequipment = true;

	// Visions

	self.syn["visions"][0] = array("", "zm_bgb_idle_eyes", "zm_bgb_eye_candy_vs_1", "zm_bgb_eye_candy_vs_2", "zm_bgb_eye_candy_vs_3", "zm_bgb_eye_candy_vs_4", "zm_bgb_now_you_see_me", "zm_bgb_in_plain_sight", "drown_blur", "zm_health_blur");
	self.syn["visions"][1] = array("None", "Idle Eyes", "Eye Candy 1", "Eye Candy 2", "Eye Candy 3", "Eye Candy 4", "Now You See Me", "In Plain Sight", "Drown Blur", "Health Blur");

	self.syn["visions"]["shadows_of_evil"][0] = array("zm_idgun_vortex_visionset", "zm_idgun_vortex_blur", "zod_ritual_dim", "zombie_beast_2", "zombie_noire", "zm_zod_transported");
	self.syn["visions"]["shadows_of_evil"][1] = array("Apothicon Servant Vortex", "Apothicon Servant Vortex Blur", "Low Visibility", "Beast Mode", "Noire", "WIP Teleport");

	self.syn["visions"]["der_eisendrache"][0] = array("zm_factory_teleport", "zm_trap_electric");
	self.syn["visions"]["der_eisendrache"][1] = array("Teleport", "Electric Trap");

	self.syn["visions"]["zetsubou_no_shima"][0] = array("zm_isl_thrasher_stomach_visionset");
	self.syn["visions"]["zetsubou_no_shima"][1] = array("Thrasher Stomach");

	self.syn["visions"]["gorod_krovi"][0] = array("raygun_mark3_vortex_visionset", "raygun_mark3_vortex_blur", "zm_trap_electric");
	self.syn["visions"]["gorod_krovi"][1] = array("Ray Gun Mark 3 Vortex", "Ray Gun Mark 3 Vortex Blur", "Electric Trap");

	self.syn["visions"]["revelations"][0] = array("zm_factory_teleport", "zm_trap_electric", "zm_idgun_vortex_visionset", "zm_idgun_vortex_blur", "zm_chaos_organge");
	self.syn["visions"]["revelations"][1] = array("Teleport", "Electric Trap", "Apothicon Servant Vortex", "Apothicon Servant Vortex Blur", "Chaos Orange");

	self.syn["visions"]["verruckt"][0] = array("zm_trap_electric", "zm_waterfall_postfx", "zm_showerhead_postfx", "zm_showerhead");
	self.syn["visions"]["verruckt"][1] = array("Electric Trap", "Waterfall", "Shower","Bloody Shower");

	self.syn["visions"]["shi_no_numa"][0] = array("zm_trap_electric");
	self.syn["visions"]["shi_no_numa"][1] = array("Electric Trap");

	self.syn["visions"]["kino_der_untoten"][0] = array("zm_trap_electric", "zm_ai_quad_blur");
	self.syn["visions"]["kino_der_untoten"][1] = array("Electric Trap", "Blur");

	self.syn["visions"]["ascension"][0] = array("zm_cosmodrome_no_power", "zm_cosmodrome_power_antic", "zm_cosmodrome_power_flare", "zm_cosmodrome_monkey_on", "zm_idgun_vortex_blur");
	self.syn["visions"]["ascension"][1] = array("No Power", "Dim", "Bright", "Monkey Round", "Vortex Blur");

	self.syn["visions"]["shangri_la"][0] = array("zm_ai_screecher_blur", "zm_temple_eclipse", "zm_waterfall_postfx");
	self.syn["visions"]["shangri_la"][1] = array("Screecher Blur", "Eclipse", "Waterfall");

	self.syn["visions"]["moon"][0] = array("zm_gasmask_postfx", "zm_ai_quad_blur", "zm_idgun_vortex_blur");
	self.syn["visions"]["moon"][1] = array("Gas Mask", "Blur", "Vortex Blur");

	self.syn["visions"]["origins"][0] = array("zm_tomb_in_plain_sight", "zm_factory_teleport");
	self.syn["visions"]["origins"][1] = array("Zombie Blood", "Teleport");

	// Weapons

	self.syn["weapons"] = [];

	self.syn["weapons"]["category"] = array("Assault Rifles", "Sub Machine Guns", "Sniper Rifles", "Shotguns", "Light Machine Guns", "Pistols", "Launchers", "Melee", "Equipment", "Extras");

	self.syn["weapons"]["melee"][0] = array("knife", "knife_widows_wine", "bowie_knife", "bowie_knife_widows_wine");
	self.syn["weapons"]["melee"][1] = array("Knife", "Widow's Wine Knife", "Bowie Knife", "Bowie Knife Widow's Wine");

	self.syn["weapons"]["extras"][0] = array("minigun", "defaultweapon");
	self.syn["weapons"]["extras"][1] = array("Death Machine", "Default Weapon");

	self.syn["weapons"]["extras"]["shadows_of_evil"][0] = array("ar_standard_upgraded_companion", "zod_riotshield", "zod_riotshield_upgraded", "glaive_apothicon_0", "glaive_keeper_0", "hero_gravityspikes");
	self.syn["weapons"]["extras"]["shadows_of_evil"][1] = array("Civil Protector KN-44", "Rocket Shield", "Upgraded Rocket Shield", "Sword", "Upgraded Sword", "Gravity Spikes");

	self.syn["weapons"]["extras"]["the_giant"][0] = array("hero_annihilator", "hero_gravityspikes");
	self.syn["weapons"]["extras"]["the_giant"][1] = array("Annihilator", "Gravity Spikes");

	self.syn["weapons"]["extras"]["zetsubou_no_shima"][0] = array("island_riotshield", "hero_gravityspikes", "controllable_spider");
	self.syn["weapons"]["extras"]["zetsubou_no_shima"][1] = array("Zombie Shield", "Gravity Spikes", "Spider Bait");

	self.syn["weapons"]["extras"]["gorod_krovi"][0] = array("dragonshield", "dragonshield_upgraded");
	self.syn["weapons"]["extras"]["gorod_krovi"][1] = array("Guard of Fafnir", "Upgraded Guard of Fafnir");

	self.syn["weapons"]["extras"]["revelations"][0] = array("dragonshield", "dragonshield_upgraded");
	self.syn["weapons"]["extras"]["revelations"][1] = array("Guard of Fafnir", "Upgraded Guard of Fafnir");

	self.syn["weapons"]["extras"]["origins"][0] = array("tomb_shield");
	self.syn["weapons"]["extras"]["origins"][1] = array("Zombie Shield");

	// Attachments

	self.syn["attachments"][0] = array("reflex", "reddot", "holo", "acog", "dualoptic", "ir", "rf", "damage", "extbarrel", "extclip", "fastreload", "fmj", "grip", "quickdraw", "stalker", "steadyaim", "swayreduc", "suppressed");
	self.syn["attachments"][1] = array("Reflex Sight", "Elo Sight", "BOA 3 Sight", "Acog Scope", "Dual Optic", "Thermal Scope", "Rapid Fire", "High Caliber", "Long Barrel", "Extended Mags", "Fast Mags", "FMJ", "Grip", "Quickdraw", "Stock", "Laser", "Ballistic CPU", "Suppressor");
	self.syn["optics"] = array("reflex", "reddot", "holo", "acog", "dualoptic", "ir");

	// Camos

	self.syn["camos"][0] = [];
	for(i = 153; i <= 291; i++) {
		if(i != 184 && i != 185 && i != 190 && i != 223 && i != 244 && i != 245 && i != 247 && i != 253 && i != 254 && i != 255 && i != 261 && i != 263 && i != 267 && i != 268 && i != 273 && i != 280 && i != 281 && i != 282 && i != 283) {
			self.syn["camos"][0][self.syn["camos"][0].size] = i - 153;
		}
	}

	self.syn["camos"][1] = array("None", "Jungle Tech", "Ash", "Flectarn", "Heat Stroke", "Snow Job", "Dante", "Integer", "6 Speed", "Policia", "Ardent", "Burnt", "Bliss", "Battle", "Chameleon", "Gold", "Diamond", "Dark Matter", "Arctic", "Jungle", "Hunstman", "Woodlums", "Contagious", "Fear", "WMD", "Red Hex", "Ritual", "Black Ops III", "Weaponized 115", "Cyborg", "True Vet", "Take Out", "Urban", "Nuk3town", "Transgression", "Storm", "Wartorn", "Prestige", "Mindful", "Etching", "Ice", "Dust", "Jungle Cat", "Jungle Party", "Contrast", "Verde", "Firebrand", "Field", "Stealth", "Light", "Spark", "Timber", "Inferno", "Hallucination", "Pixel", "Royal", "Infrared", "Heat", "Violet", "Halcyon", "Gem", "Monochrome", "Sunshine", "Swindler", "C.O.D.E. Warriors", "Intensity", "Zebra (Unnamed)", "Couch (Unnamed)", "Forest (Unnamed)", "Rust (Unnamed)", "Emergeon", "Topaz", "Garnet", "Sapphire", "Emerald", "Amethyst", "Quartz", "Overgrowth", "Bloody Valentine", "Haptic", "Dragon Fire", "Dragon Fire Blue", "Dragon Fire Green", "Dragon Fire Red", "Dragon Fire Purple", "COD XP", "CWL Champions", "Excellence", "MindFreak", "Nv", "OrbitGG", "Tainted Minds", "Epsilon eSports", "Team Infused", "Team LDLC", "Millenium", "Splyce", "Supremacy", "Cloud9", "eLevate", "Team EnVy", "Faze Clan", "OpTic Gaming", "Rise Nation", "Loading", "Underworld", "Revelations PAP 1", "Cosmic", "Into the Void", "Revelations PAP 4", "Revelations PAP 5", "Lucid", "Luck of the Irish", "Chronicles PAP", "Origins PAP", "Cherry Fizz", "Empire", "Permafrost", "Hive", "Watermelon");

	// AATs

	self.syn["aats"][0] = array("zm_aat_blast_furnace", "zm_aat_dead_wire", "zm_aat_fire_works", "zm_aat_thunder_wall", "zm_aat_turned");
	self.syn["aats"][1] = array("Blast Furnace", "Dead Wire", "Fireworks", "Thunder Wall", "Turned");

	// Perks

	self.syn["perks"]["common"][0] = array("specialty_quickrevive", "specialty_armorvest", "specialty_doubletap2", "specialty_staminup", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_deadshot", "specialty_widowswine", "specialty_electriccherry", "specialty_phdflopper", "specialty_whoswho", "specialty_reserve", "specialty_vigor_rush", "specialty_bandolier", "specialty_blazephase", "specialty_bloodwolf", "specialty_da_death_perception", "specialty_dyingwish", "specialty_razor", "specialty_slider", "specialty_stronghold", 	"specialty_timeslip", "specialty_victorious", "specialty_winterwail", "specialty_zombshell", "specialty_elementalpop", "specialty_da_phd_slider", "specialty_vulture", "specialty_da_tombstone", "specialty_changechews", "specialty_bloodbullets", "specialty_cashback", "specialty_damnade", "specialty_downersdelight", "specialty_estatic", "specialty_inferno", "specialty_magnet", "specialty_mh_mocha", "specialty_nitrogen", "specialty_nukacola", "specialty_packbox", "specialty_point", "specialty_swarmscotch", "specialty_repairman", "specialty_nobear", "specialty_momentum", "specialty_spectorshot", "specialty_ffyl", "specialty_icu", "specialty_tactiquilla", "specialty_milk", "specialty_banana", "specialty_bull_ice", "specialty_crusade", "specialty_moonshine", "specialty_directionalfire", "specialty_nottargetedbyairsupport", "specialty_loudenemies");
	self.syn["perks"]["common"][1] = array("Quick Revive", "Juggernog", "Double Tap", "Stamin-Up", "Speed Cola", "Mule Kick", "Deadshot", "Widow's Wine", "Electric Cherry", "PhD Slider", "Who's Who", "Reserve Soda", "Vigor Rush", "Bandolier Bandit", "Blaze Phase", "Blood Wolf Bite", "Death Perception", "Dying Wish", "Ethereal Razor", "PhD Slider (BO4)", "Stone Cold Stronghold", "Timeslip", "Victorious Tortoise", "Winter's Wail", "Zombshell", "Elemental Pop", "PhD Slider (Cold War)", "Vulture-Aid", "Tombstone", "Change Chews", "Blood Bullets", "Cashback Cocktail", "Dam-A-Nade", "Downers Delight", "Estatic Elixir", "Inciner-Brandy", "Magnet Margarita", "Miricle Hands Mocha", "Nitrogen Cooled", "Nuka Cola", "Pack-A-Box", "Point Crusher", "Swarm Scotch", "Repairman Rum", "No Bear Brew", "Momentum Mojito", "Spectre Shot", "Fighter's Fizz", "I.C.U", "Tactiquilla Sangria", "Muscle Milk", "Banana Colada", "Bull Ice Blast", "Crusaders Ale", "Madgaz Moonshine", "Directional Fire", "Ethereal Razor", "Timeslip");
	self.syn["perks"]["all"] = getArrayKeys(level._custom_perks);

	// Zombies

	self.syn["zombies"]["zetsubou_no_shima"][0] = array("Thrasher");
	self.syn["zombies"]["zetsubou_no_shima"][1] = array(getEntArray("zombie_thrasher_spawner", "script_noteworthy")[0]);

	self.syn["zombies"]["revelations"][0] = array("Fire Margwa", "Shadow Margwa");
	self.syn["zombies"]["revelations"][1] = array(getSpawnerArray("zombie_margwa_fire_spawner", "script_noteworthy")[0], getSpawnerArray("zombie_margwa_shadow_spawner", "script_noteworthy")[0]);

	self.syn["zombies"]["moon"][0] = array("Astronaut");
	self.syn["zombies"]["moon"][1] = array(getEntArray("astronaut_zombie", "targetname")[0]);

	// Visions

	self.syn["visions"][3] = [];

	foreach(type, v_array in level.vsmgr) {
		foreach(v_name, v_struct in level.vsmgr[type].info) {
			vision = level.vsmgr[type].info[v_name];
			if(vision.state.should_activate_per_player) {
				displayName = construct_string(replace_character(vision.name, "_", " "));
				if(isSubStr(displayName, "Zm")) {
					displayName = getSubStr(displayName, 3);
				}
				if(isSubStr(displayName, "Bgb")) {
					displayName = getSubStr(displayName, 4);
				}
				vision.displayName = displayName;
				array::add(self.syn["visions"][3], vision, 0);
			}
		}
	}

	// Powerups

	self.syn["powerups"][0] = getArrayKeys(level.zombie_include_powerups);
	self.syn["powerups"][1] = [];
	self.syn["powerups"][2] = [];
	self.syn["powerups"][3] = [];
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
	  self.syn["powerups"][1][i] = construct_string(replace_character(self.syn["powerups"][0][i], "_", " "));
		if(self.syn["powerups"][1][i] == "Ww Grenade") {
			self.syn["powerups"][1][i] = "Widow's Wine Grenade";
		}
	}
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
		self.syn["powerups"][2][self.syn["powerups"][2].size] = false;
	}
	foreach(powerup in self.syn["powerups"][0]) {
		self.syn["powerups"][3][self.syn["powerups"][3].size] = level.zombie_powerups[powerup].func_should_drop_with_regular_powerups;
	}

	// Gobblegum

	self.syn["gobblegum"][0] = getArrayKeys(level.bgb);
	self.syn["gobblegum"][1] = [];
	for(i = 0; i < self.syn["gobblegum"][0].size; i++) {
		self.syn["gobblegum"][1][i] = construct_string(replace_character(getSubStr(self.syn["gobblegum"][0][i], 7), "_", " "));
	}

	// Weapons

	weapon_types = array("assault", "smg", "cqb", "lmg", "sniper", "pistol", "launcher");

	weapon_names = [];
	foreach(weapon in getArrayKeys(level.zombie_weapons)) {
		weapon_names[weapon_names.size] = weapon.name;
	}

	for(i = 0; i < weapon_types.size; i++) {
		self.syn["weapons"][i] = [];
		for(e = 1; e < 100; e++) {
			weapon_category = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 2);
			weapon_id = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 4);

			if(weapon_category == "weapon_" + weapon_types[i]) {
				if(isInArray(weapon_names, weapon_id)) {
					weapon = spawnStruct();
					weapon.name = makeLocalizedString(getWeapon(weapon_id).displayName);
					if(weapon_id == "pistol_m1911") {
						weapon.name = "M1911";
					}
					weapon.id = weapon_id;
					weapon.category = weapon_category;
					self.syn["weapons"][i][self.syn["weapons"][i].size] = weapon;
				}
			}
		}
	}

	self.syn["weapons"][7] = [];
	self.syn["weapons"][8] = [];
	self.syn["weapons"][9] = [];
	foreach(weapon in getArrayKeys(level.zombie_weapons)) {
		isInArray = false;
		for(e = 0; e < self.syn["weapons"].size; e++) {
			if(isDefined(self.syn["weapons"][e])) {
				for(i = 0; i < self.syn["weapons"][e].size; i++) {
					if(isDefined(self.syn["weapons"][e][i]) && self.syn["weapons"][e][i].id == weapon.name) {
						isInArray = true;
						break;
					}
				}
			}
		}
		if(!isInArray && weapon.displayName != "") {
			weapons = spawnStruct();
			weapons.name = makeLocalizedString(weapon.displayName);
			weapons.id = weapon.name;

			if(level.script == "zm_pentagon") {
				weapon_table = "gamedata/weapons/zm/zm_pentagon_weapons_t5.csv";
				weapon_table_alt = "gamedata/weapons/zm/zm_pentagon_weapons_t9.csv";
			} else {
				weapon_table = "gamedata/weapons/zm/" + level.script + "_weapons.csv";
				weapon_table_alt = "gamedata/weapons/zm/zm_levelcommon_weapons.csv";
			}

			weapons.class_name = tablelookup(weapon_table, 0, weapons.id, 16);
			weapons.vo_name = tablelookup(weapon_table, 0, weapons.id, 4);

			if(weapons.class_name == "" && isDefined(weapon_table_alt)) {
				weapons.class_name = tablelookup(weapon_table_alt, 0, weapons.id, 16);
			}

			if(weapons.vo_name == "" && isDefined(weapon_table_alt)) {
				weapons.vo_name = tablelookup(weapon_table_alt, 0, weapons.id, 4);
			}

			if(weapons.id == "launcher_dragon_fire") {
				weapons.name = "Dragon Fire Launcher";
			} else if(weapons.id == "launcher_dragon_strike") {
				weapons.name = "Dragon Strike";
			} else if(weapons.id == "bouncingbetty_devil") {
				weapons.name = "Donut Trip Mines";
			} else if(weapons.id == "bouncingbetty_holly") {
				weapons.name = "Cream Cake Trip Mines";
			} else if(weapons.id == "bouncingbetty") {
				weapons.name = "Trip Mines";
			} else if(weapons.id == "octobomb") {
				weapons.name = "Li'l Arnies";
			} else if(weapons.id == "octobomb_upgraded") {
				weapons.name = "Upgraded Li'l Arnies";
			} else if(weapons.id == "cymbal_monkey_upgraded") {
				weapons.name = "Upgraded Cymbal Monkey";
			} else if(weapons.id == "knife_ballistic_no_melee") {
				weapons.name = "Ballistic Knife (No Melee)";
			} else if(weapons.id == "knife_ballistic_bowie" || weapons.id == "t5_bk_bowie_normal") {
				weapons.name = "Ballistic Knife (Bowie)";
			} else if(weapons.id == "bowie_knife_electric") {
				weapons.name = "Electric Bowie Knife";
			} else if(weapons.id == "t9_pi_burst_rdw") {
				weapons.name = "Diamatti Dual Wield";
			}

			// Categorize Extra Weapons (Base Maps, Die Rise, Five)

			if(weapons.id == "s1_mgturret") {
				weapons.category = "weapon_lmg";
				self.syn["weapons"][3][self.syn["weapons"][3].size] = weapons;
			} else if(weapons.id == "t6_xl_war_machine" || weapons.id == "launcher_multi" || weapons.id == "t5_china_lake" || weapons.id == "t5_crossbow" || weapons.id == "t9_sp_crossbow") {
				weapons.category = "weapon_launcher";
				self.syn["weapons"][6][self.syn["weapons"][6].size] = weapons;
			} else if(weapons.id == "t8_tazer_knuckles" || weapons.id == "knife_ballistic" || weapons.id == "knife_ballistic_no_melee" || weapons.id == "knife_ballistic_bowie" ||
								weapons.id == "t5_bk_base_normal" || weapons.id == "t5_bk_bowie_normal" || weapons.id == "t9_sp_ballistic_knife") {
				weapons.category = "weapon_melee";
				self.syn["weapons"][7][self.syn["weapons"][7].size] = weapons;
			} else if(weapons.vo_name == "staff" || weapons.id == "elemental_bow" || weapons.id == "elemental_bow_demongate" || weapons.id == "elemental_bow_rune_prison" ||
								weapons.id == "elemental_bow_storm" || weapons.id == "elemental_bow_wolf_howl" || weapons.id == "launcher_dragon_strike") {
				weapons.category = "weapon_extras";
				self.syn["weapons"][9][self.syn["weapons"][9].size] = weapons;
			} else {
				if(weapons.class_name == "rifle") {
					weapons.category = "weapon_assault";
					self.syn["weapons"][0][self.syn["weapons"][0].size] = weapons;
				} else if(weapons.class_name == "smg") {
					weapons.category = "weapon_smg";
					self.syn["weapons"][1][self.syn["weapons"][1].size] = weapons;
				} else if(weapons.class_name == "shotgun") {
					weapons.category = "weapon_cqb";
					self.syn["weapons"][2][self.syn["weapons"][2].size] = weapons;
				} else if(weapons.class_name == "lmg") {
					weapons.category = "weapon_lmg";
					self.syn["weapons"][3][self.syn["weapons"][3].size] = weapons;
				} else if(weapons.class_name == "sniper") {
					weapons.category = "weapon_sniper";
					self.syn["weapons"][4][self.syn["weapons"][4].size] = weapons;
				} else if(weapons.class_name == "pistol") {
					weapons.category = "weapon_pistol";
					self.syn["weapons"][5][self.syn["weapons"][5].size] = weapons;
				} else if(weapon.weapclass == "rocketlauncher" || weapons.class_name == "launcher") {
					weapons.category = "weapon_launcher";
					self.syn["weapons"][6][self.syn["weapons"][6].size] = weapons;
				} else if(weapon.weapclass == "melee" && weapons.id != "bowie_knife" && weapons.id != "hero_gravityspikes_melee") {
					weapons.category = "weapon_melee";
					self.syn["weapons"][7][self.syn["weapons"][7].size] = weapons;
				} else if(weapons.class_name == "grenade" && weapons.id != "frag_grenade") {
					weapons.category = "weapon_grenade";
					self.syn["weapons"][8][self.syn["weapons"][8].size] = weapons;
				} else {
					//weapons.category = weapons.class_name;
					self.syn["weapons"][9][self.syn["weapons"][9].size] = weapons;
				}
			}
		}
	}
}

function initialize_menu() {
	level endon("game_ended");
	self endon("disconnect");

	while(!self.syn_initialized) {
		if(!self.syn_hud_created) {
			self.syn_initialized = true;
			self freezeControls(false);

			level waittill("initial_blackscreen_passed");

			create_menu();
		}
	}
}

function initialize_verified_menu() {
	level endon("game_ended");
	self endon("disconnect");

	while(!self.syn_initialized) {
		if(self.syn_access != "None") {
			if(!self.syn_hud_created) {
				self initial_variables();
				self.syn_initialized = true;
				self create_menu();
			}
		}
	}
}

function create_menu() {
	level.player_out_of_playable_area_monitor = false;
	self notify("stop_player_out_of_playable_area_monitor");

	self thread input_manager();

	self.menu["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.syn_x_offset - 1), (self.syn_y_offset - 1), 226, 122, self.syn_color_theme, 1, 1);
	self.menu["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.syn_x_offset, self.syn_y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
	self.menu["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.syn_x_offset, (self.syn_y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
	self.menu["separator_1"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 5.5), (self.syn_y_offset + 7.5), 42, 1, self.syn_color_theme, 1, 10);
	self.menu["separator_2"] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.syn_x_offset + 220), (self.syn_y_offset + 7.5), 42, 1, self.syn_color_theme, 1, 10);
	self.menu["cursor"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.syn_x_offset, 215, 224, 16, (0.15, 0.15, 0.15), 0, 4);

	self.menu["title"] = self create_text("Title", self.syn_font, self.syn_font_scale, "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 94.5), (self.syn_y_offset + 1), (1, 1, 1), 1, 10);
	self.menu["description"] = self create_text("Description", self.syn_font, self.syn_font_scale, "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 5), (self.syn_y_offset + (self.syn_option_limit * 17.5)), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider_text"] = self create_text("", self.syn_font, self.syn_font_scale, "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 132.5), (self.syn_y_offset + 19), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.syn_x_offset, (self.syn_y_offset + 15), 224, 16, (0.25, 0.25, 0.25), 0, 5);

	for(i = 1; i <= self.syn_option_limit; i++) {
		self.menu["toggle_" + i] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.syn_x_offset + 11), ((self.syn_y_offset + 4) + (i * 15)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
		self.menu["option_" + i] = self create_text("", self.syn_font, self.syn_font_scale, "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 5), ((self.syn_y_offset + 2) + (i * 15)), (0.75, 0.75, 0.75), 1, 10);
		self.menu["submenu_icon_" + i] = self create_text(">", self.syn_font, self.syn_font_scale, "TOP_LEFT", "TOPCENTER", (self.syn_x_offset + 215), ((self.syn_y_offset + 1) + (i * 15)), (0.75, 0.75, 0.75), 0, 10);
	}

	self.syn_hud_created = true;

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

	self.syn_controls_menu_open = true;

	wait 8;

	if(self.syn_controls_menu_open) {
		close_controls_menu();
	}
}

function input_manager() {
	level endon("game_ended");
	self endon("disconnect");

	while(self.syn_access != "None") {
		if(!self.syn_in_menu) {
			if(self adsButtonPressed() && self meleeButtonPressed()) {
				if(self.syn_controls_menu_open) {
					close_controls_menu();
				}

				self playSoundToPlayer("uin_main_bootup", self);

				open_menu();

				while(self adsButtonPressed() && self meleeButtonPressed()) {
					wait 0.2;
				}
			}
		} else {
			if(self meleeButtonPressed()) {
				self.syn_saved_index[self.syn_current_menu] = self.syn_cursor_index;
				self.syn_saved_offset[self.syn_current_menu] = self.syn_scrolling_offset;
				self.syn_saved_trigger[self.syn_current_menu] = self.syn_previous_trigger;

				self playSoundToPlayer("uin_lobby_leave", self);

				if(isDefined(self.syn_previous[(self.syn_previous.size - 1)])) {
					self new_menu();
				} else {
					self close_menu();
				}

				while(self meleeButtonPressed()) {
					wait 0.2;
				}
			} else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {

				self playSoundToPlayer("uin_main_nav", self);

				self menu_option();

				scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

				wait (0.2);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {

				self playSoundToPlayer("uin_main_nav", self);

				if(isDefined(self.syn_structure[self.syn_cursor_index].array) || isDefined(self.syn_structure[self.syn_cursor_index].increment)) {
					scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
				}

				wait (0.2);
			} else if(self useButtonPressed()) {
				self.syn_saved_index[self.syn_current_menu] = self.syn_cursor_index;
				self.syn_saved_offset[self.syn_current_menu] = self.syn_scrolling_offset;
				self.syn_saved_trigger[self.syn_current_menu] = self.syn_previous_trigger;

				self playSoundToPlayer("uin_main_pause", self);

				if(self.syn_structure[self.syn_cursor_index].command == &new_menu) {
					self.syn_previous_option = self.syn_structure[self.syn_cursor_index].text;
				}

				if(isDefined(self.syn_structure[self.syn_cursor_index].array) || isDefined(self.syn_structure[self.syn_cursor_index].increment)) {
					if(isDefined(self.syn_structure[self.syn_cursor_index].array)) {
						cursor_selected = self.syn_structure[self.syn_cursor_index].array[self.syn_slider[(self.syn_current_menu + "_" + self.syn_cursor_index)]];
					} else {
						cursor_selected = self.syn_slider[(self.syn_current_menu + "_" + (self.syn_cursor_index))];
					}
					self thread execute_function(self.syn_structure[self.syn_cursor_index].command, cursor_selected, self.syn_structure[self.syn_cursor_index].parameter_1, self.syn_structure[self.syn_cursor_index].parameter_2, self.syn_structure[self.syn_cursor_index].parameter_3);
				} else if(isDefined(self.syn_structure[self.syn_cursor_index]) && isDefined(self.syn_structure[self.syn_cursor_index].command)) {
					self thread execute_function(self.syn_structure[self.syn_cursor_index].command, self.syn_structure[self.syn_cursor_index].parameter_1, self.syn_structure[self.syn_cursor_index].parameter_2, self.syn_structure[self.syn_cursor_index].parameter_3);
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

function open_menu() {
	self.syn_in_menu = true;

	set_menu_visibility(1);

	self menu_option();
	scroll_cursor();
	set_options();
}

function close_menu() {
	set_menu_visibility(0);

	self.syn_in_menu = false;
}

function close_controls_menu() {
	set_menu_visibility(0);

	self.menu["border"] set_shader("white", self.menu["border"].width, 123);
	self.menu["background"] set_shader("white", self.menu["background"].width, 121);
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 106);

	self.syn_controls_menu_open = false;

	self.menu["title"] set_text("");
	self.menu["option_1"] set_text("");
	self.menu["option_2"] set_text("");
	self.menu["option_3"] set_text("");
	self.menu["option_4"] set_text("");

	self.syn_in_menu = false;
}

function set_menu_visibility(opacity) {
	if(opacity == 0) {
		self.menu["border"].alpha = opacity;
		self.menu["description"].alpha = opacity;
		self.menu["slider"].alpha = opacity;
		for(i = 1; i <= self.syn_option_limit; i++) {
			self.menu["toggle_" + i].alpha = opacity;
			self.menu["submenu_icon_" + i].alpha = opacity;
		}
	}

	self.menu["title"].alpha = opacity;
	self.menu["separator_1"].alpha = opacity;
	self.menu["separator_2"].alpha = opacity;
	self.menu["slider_text"].alpha = opacity;

	for(i = 1; i <= self.syn_option_limit; i++) {
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

function create_text(text, font, font_scale, align_x, align_y, x_offset, y_offset, color, alpha, z_index, hide_when_in_menu) {
	textElement = self hud::createFontString(font, font_scale);
	textElement hud::setPoint(align_x, align_y, x_offset, y_offset);

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
		if(strisNumber(text)) {
			textElement setValue(text);
		} else {
			textElement set_text(text);
		}
	}

	self.element_result++;
	return textElement;
}

function set_text(text) {
	if(!isDefined(self) || !isDefined(text)) {
		return;
	}

	self.text = text;
	self setText(text);
}

function create_shader(shader, align_x, align_y, x_offset, y_offset, width, height, color, alpha, z_index, hide_when_in_menu) {
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

	shaderElement hud::setParent(level.uiParent);
	shaderElement hud::setPoint(align_x, align_y, x_offset, y_offset);

	shaderElement set_shader(shader, width, height);

	self.element_result++;
	return shaderElement;
}

function set_shader(shader, width, height) {
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

function auto_archive() {
	if(!isDefined(self.element_result)) {
		self.element_result = 0;
	}

	if(!isAlive(self) || self.element_result > 21) {
		return true;
	}

	return false;
}

function update_element_positions() {
	self.menu["border"].x = (self.syn_x_offset - 1);
	self.menu["border"].y = (self.syn_y_offset - 1);

	self.menu["background"].x = self.syn_x_offset;
	self.menu["background"].y = self.syn_y_offset;

	self.menu["foreground"].x = self.syn_x_offset;
	self.menu["foreground"].y = (self.syn_y_offset + 15);

	self.menu["separator_1"].x = (self.syn_x_offset + 5);
	self.menu["separator_1"].y = (self.syn_y_offset + 7.5);

	self.menu["separator_2"].x = (self.syn_x_offset + 220);
	self.menu["separator_2"].y = (self.syn_y_offset + 7.5);

	self.menu["cursor"].x = self.syn_x_offset;

	self.menu["description"].y = (self.syn_y_offset + (self.syn_option_limit * 17.5));

	self.menu["slider_text"].x = (self.syn_x_offset + 132.5);
	self.menu["slider_text"].y = ((self.syn_y_offset + 2) + (((self.syn_cursor_index + 1) - self.syn_scrolling_offset) * 15));

	self.menu["slider"].x = self.syn_x_offset;
	self.menu["slider"].y = (self.syn_y_offset + (((self.syn_cursor_index + 1) - self.syn_scrolling_offset) * 15));

	for(i = 1; i <= self.syn_option_limit; i++) {
		self.menu["toggle_" + i].x = (self.syn_x_offset + 11);
		self.menu["toggle_" + i].y = ((self.syn_y_offset + 4) + (i * 15));

		self.menu["option_" + i].y = ((self.syn_y_offset + 2) + (i * 15));

		self.menu["submenu_icon_" + i].x = (self.syn_x_offset + 215);
		self.menu["submenu_icon_" + i].y = ((self.syn_y_offset + 1) + (i * 15));
	}
}

// Colors

function create_rainbow_color() {
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

function start_rainbow() {
	level endon("game_ended");
	self endon("stop_rainbow");
	self.syn_rainbow_enabled = true;

	while(isDefined(self) && self.syn_rainbow_enabled) {
		self fadeOverTime(.05);
		self.color = level.rainbow_color;
		wait 0.05;
	}
}

// Misc Functions

function return_toggle(variable) {
	return isDefined(variable) && variable;
}

function set_variable(check, option_1, option_2) {
	if(check) {
		return option_1;
	} else {
		return option_2;
	}
}

function get_map_name() {
	if(level.script == "zm_zod") return "shadows_of_evil";
	if(level.script == "zm_factory") return "the_giant";
	if(level.script == "zm_castle") return "der_eisendrache";
	if(level.script == "zm_island") return "zetsubou_no_shima";
	if(level.script == "zm_stalingrad") return "gorod_krovi";
	if(level.script == "zm_genesis") return "revelations";
	if(level.script == "zm_prototype") return "nacht_der_untoten";
	if(level.script == "zm_asylum") return "verruckt";
	if(level.script == "zm_sumpf") return "shi_no_numa";
	if(level.script == "zm_theater") return "kino_der_untoten";
	if(level.script == "zm_cosmodrome") return "ascension";
	if(level.script == "zm_temple") return "shangri_la";
	if(level.script == "zm_moon") return "moon";
	if(level.script == "zm_tomb") return "origins";
}

function construct_string(string) {
	final = "";
	for(e = 0; e < string.size; e++) {
		if(e == 0) {
			final += toUpper(string[e]);
		} else if(string[e - 1] == " ") {
			final += toUpper(string[e]);
		} else {
			final += string[e];
		}
	}
	return final;
}

function replace_character(string, substring, replace) {
	final = "";
	for(e = 0; e < string.size; e++) {
		if(string[e] == substring) {
			final += replace;
		} else {
			final += string[e];
		}
	}
	return final;
}

function remove_duplicate_ent_array(name) {
	new_array = [];
	saved_array = [];
	foreach(item in getEntArray(name, "targetname")) {
		if(!isInArray(new_array, item.script_noteworthy)) {
			new_array[new_array.size] = item.script_noteworthy;
			saved_array[saved_array.size] = item;
		}
	}
	return saved_array;
}

function remove_from_array(array, object) {
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

function get_bullet_trace_position() {
	start = self getEye();
	end = vectorScale(anglesToForward(self getPlayerAngles()), 9999);

	return bulletTrace(start, start + end, false, self)["position"];
}

function load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"].size; i++) {
		foreach(weapon in self.syn["weapons"][i]) {
			if(weapon.category == weapon_category) {
				self add_option(weapon.name, undefined, &give_weapon, weapon.id);
			}
		}
	}
}

function get_category(weapon_id) {
	for(i = 0; i < self.syn["weapons"].size; i++) {
		foreach(weapon in self.syn["weapons"][i]) {
			if(weapon.id == weapon_id || weapon.id + "_upgraded" == weapon_id) {
				return weapon.category;
			}
		}
	}
}

// Custom Structure

function execute_function(command, parameter_1, parameter_2, parameter_3, parameter_4) {
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

function add_option(text, description, command, parameter_1, parameter_2, parameter_3) {
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

	self.syn_structure[self.syn_structure.size] = option;
}

function add_toggle(text, description, command, variable, parameter_1, parameter_2) {
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

	self.syn_structure[self.syn_structure.size] = option;
}

function add_array(text, description, command, array, show_options, parameter_1, parameter_2, parameter_3) {
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

	self.syn_structure[self.syn_structure.size] = option;
}

function add_increment(text, description, command, start, minimum, maximum, increment, parameter_1, parameter_2) {
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
	if(strisNumber(start)) {
		option.start = start;
	} else {
		option.start = 0;
	}
	if(strisNumber(minimum)) {
		option.minimum = minimum;
	} else {
		option.minimum = 0;
	}
	if(strisNumber(maximum)) {
		option.maximum = maximum;
	} else {
		option.maximum = 10;
	}
	if(strisNumber(increment)) {
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

	self.syn_structure[self.syn_structure.size] = option;
}

function get_title_width(title) {
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

function set_title(title) {
	self.menu["title"] set_text(title);

	title_width = get_title_width(title);

	self.menu["title"].x = (self.syn_x_offset + ceil((((-0.0000124 * title_width + 0.003832) * title_width - 0.52) * title_width + 115.258) * 10) / 10);
	self.menu["title"].y = (self.syn_y_offset + 1);
}

function new_menu(menu) {
	if(!isDefined(menu)) {
		menu = self.syn_previous[(self.syn_previous.size - 1)];
		self.syn_previous[(self.syn_previous.size - 1)] = undefined;
	} else {
		self.syn_previous[self.syn_previous.size] = self.syn_current_menu;
	}

	if(!isDefined(self.syn_slider[(menu + "_" + (self.syn_cursor_index))])) {
		self.syn_slider[(menu + "_" + (self.syn_cursor_index))] = 0;
	}

	self.syn_current_menu = set_variable(isDefined(menu), menu, "Synergy");

	if(isDefined(self.syn_saved_index[self.syn_current_menu])) {
		self.syn_cursor_index = self.syn_saved_index[self.syn_current_menu];
		self.syn_scrolling_offset = self.syn_saved_offset[self.syn_current_menu];
		self.syn_previous_trigger = self.syn_saved_trigger[self.syn_current_menu];
		self.syn_loaded_offset = true;
	} else {
		self.syn_cursor_index = 0;
		self.syn_scrolling_offset = 0;
		self.syn_previous_trigger = 0;
	}

	self menu_option();
	scroll_cursor();
}

function empty_function() {}

function empty_option() {
	option = array("Nothing To See Here!", "Quiet Here, Isn't It?", "Oops, Nothing Here Yet!", "Bit Empty, Don't You Think?");
	return option[randomInt(option.size)];
}

function scroll_cursor(direction) {
	maximum = self.syn_structure.size - 1;
	fake_scroll = false;

	if(maximum < 0) {
		maximum = 0;
	}

	if(isDefined(direction)) {
		if(direction == "down") {
			self.syn_cursor_index++;
			if(self.syn_cursor_index > maximum) {
				self.syn_cursor_index = 0;
				self.syn_scrolling_offset = 0;
			}
		} else if(direction == "up") {
			self.syn_cursor_index--;
			if(self.syn_cursor_index < 0) {
				self.syn_cursor_index = maximum;
				if(((self.syn_cursor_index) + int((self.syn_option_limit / 2))) >= (self.syn_structure.size - 2)) {
					self.syn_scrolling_offset = (self.syn_structure.size - self.syn_option_limit);
				}
			}
		}
	} else {
		while(self.syn_cursor_index > maximum) {
			self.syn_cursor_index--;
		}
		self.menu["cursor"].y = int(self.syn_y_offset + (((self.syn_cursor_index + 1) - self.syn_scrolling_offset) * 15));
	}

	self.syn_previous_scrolling_offset = self.syn_scrolling_offset;

	if(!self.syn_loaded_offset) {
		if(self.syn_cursor_index >= int(self.syn_option_limit / 2) && self.syn_structure.size > self.syn_option_limit) {
			if((self.syn_cursor_index + int(self.syn_option_limit / 2)) >= (self.syn_structure.size - 2)) {
				self.syn_scrolling_offset = (self.syn_structure.size - self.syn_option_limit);
				if(self.syn_previous_trigger == 2) {
					self.syn_scrolling_offset--;
				}
				if(self.syn_previous_scrolling_offset != self.syn_scrolling_offset && self.syn_previous_trigger != 1) {
					fake_scroll = true;
					self.syn_previous_trigger = 1;
				}
			} else {
				self.syn_scrolling_offset = (self.syn_cursor_index - int(self.syn_option_limit / 2));
				self.syn_previous_trigger = 2;
			}
		} else {
			self.syn_scrolling_offset = 0;
			self.syn_previous_trigger = 0;
		}
	}

	if(self.syn_scrolling_offset < 0) {
		self.syn_scrolling_offset = 0;
	}

	if(!fake_scroll) {
		self.menu["cursor"].y = int(self.syn_y_offset + (((self.syn_cursor_index + 1) - self.syn_scrolling_offset) * 15));
	}

	if(isDefined(self.syn_structure[self.syn_cursor_index]) && isDefined(self.syn_structure[self.syn_cursor_index].description)) {
		self.menu["description"] set_text(self.syn_structure[self.syn_cursor_index].description);
		self.syn_description_height = 15;

		self.menu["description"].x = (self.syn_x_offset + 5);
		self.menu["description"].alpha = 1;
	} else {
		self.menu["description"] set_text("");
		self.menu["description"].alpha = 0;
		self.syn_description_height = 0;
	}

	self.syn_loaded_offset = false;
	set_options();
}

function scroll_slider(direction) {
	current_slider_index = self.syn_slider[(self.syn_current_menu + "_" + (self.syn_cursor_index))];
	if(isDefined(direction)) {
		if(isDefined(self.syn_structure[self.syn_cursor_index].array)) {
			if(direction == "left") {
				current_slider_index--;
				if(current_slider_index < 0) {
					current_slider_index = (self.syn_structure[self.syn_cursor_index].array.size - 1);
				}
			} else if(direction == "right") {
				current_slider_index++;
				if(current_slider_index > (self.syn_structure[self.syn_cursor_index].array.size - 1)) {
					current_slider_index = 0;
				}
			}
		} else {
			if(direction == "left") {
				current_slider_index -= self.syn_structure[self.syn_cursor_index].increment;
				if(current_slider_index < self.syn_structure[self.syn_cursor_index].minimum) {
					current_slider_index = self.syn_structure[self.syn_cursor_index].maximum;
				}
			} else if(direction == "right") {
				current_slider_index += self.syn_structure[self.syn_cursor_index].increment;
				if(current_slider_index > self.syn_structure[self.syn_cursor_index].maximum) {
					current_slider_index = self.syn_structure[self.syn_cursor_index].minimum;
				}
			}
		}
	}
	self.syn_slider[(self.syn_current_menu + "_" + (self.syn_cursor_index))] = current_slider_index;
	set_options();
}

function set_options() {
	if(isDefined(self.syn_equip_attachment_in_progress)) {
		while(self.syn_equip_attachment_in_progress) {
			wait 0.05;
		}
	}

	self.menu["slider_text"] set_text("");
	self.menu["slider"].alpha = 0;

	for(i = 1; i <= self.syn_option_limit; i++) {
		self.menu["toggle_" + i].alpha = 0;
		self.menu["submenu_icon_" + i].alpha = 0;

		self.menu["option_" + i] set_text("");
	}

	update_element_positions();

	if(isDefined(self.syn_structure)) {
		if(self.syn_structure.size == 0) {
			self add_option(empty_option());
		}

		self.syn_maximum = int(min(self.syn_structure.size, self.syn_option_limit));

		if(self.syn_structure.size <= self.syn_option_limit) {
			self.syn_scrolling_offset = 0;
		}

		for(i = 1; i <= self.syn_maximum; i++) {
			x = ((i - 1) + self.syn_scrolling_offset);

			self.menu["option_" + i] set_text(self.syn_structure[x].text);

			if(isDefined(self.syn_structure[x].toggle)) {
				self.menu["option_" + i].x = (self.syn_x_offset + 13.5);
				self.menu["option_" + i].alpha = 1;
				self.menu["toggle_" + i].alpha = 1;

				if(self.syn_structure[x].toggle) {
					self.menu["toggle_" + i].color = (1, 1, 1);
				} else {
					self.menu["toggle_" + i].color = (0.25, 0.25, 0.25);
				}
			} else {
				self.menu["option_" + i].x = (self.syn_x_offset + 5);
				self.menu["toggle_" + i].alpha = 0;
			}

			if(isDefined(self.syn_structure[x].array) && (self.syn_cursor_index) == x) {
				if(!isDefined(self.syn_slider[(self.syn_current_menu + "_" + x)])) {
					self.syn_slider[(self.syn_current_menu + "_" + x)] = 0;
				}

				if(self.syn_slider[(self.syn_current_menu + "_" + x)] > (self.syn_structure[x].array.size - 1) || self.syn_slider[(self.syn_current_menu + "_" + x)] < 0) {
					self.syn_slider[(self.syn_current_menu + "_" + x)] = set_variable(self.syn_slider[(self.syn_current_menu + "_" + x)] > (self.syn_structure[x].array.size - 1), 0, (self.syn_structure[x].array.size - 1));
				}

				if(self.syn_structure[x].show_options) {
					slider_text = self.syn_structure[x].array[self.syn_slider[(self.syn_current_menu + "_" + x)]] + " [" + (self.syn_slider[(self.syn_current_menu + "_" + x)] + 1) + "/" + self.syn_structure[x].array.size + "]";
				} else {
					slider_text = self.syn_structure[x].array[self.syn_slider[(self.syn_current_menu + "_" + x)]];
				}

				self.menu["slider_text"] set_text(slider_text);
			} else if(isDefined(self.syn_structure[x].increment) && (self.syn_cursor_index) == x) {
				if(!isDefined(self.syn_slider[(self.syn_current_menu + "_" + x)])) {
					self.syn_slider[(self.syn_current_menu + "_" + x)] = 0;
				}
				value = abs((self.syn_structure[x].minimum - self.syn_structure[x].maximum)) / 224;
				width = ceil((self.syn_slider[(self.syn_current_menu + "_" + x)] - self.syn_structure[x].minimum) / value);

				if(width >= 0) {
					self.menu["slider"] set_shader("white", int(width), 16);
				} else {
					self.menu["slider"] set_shader("white", 0, 16);
					self.menu["slider"].alpha = 0;
				}

				if(!isDefined(self.syn_slider[(self.syn_current_menu + "_" + x)]) || self.syn_slider[(self.syn_current_menu + "_" + x)] < self.syn_structure[x].minimum) {
					self.syn_slider[(self.syn_current_menu + "_" + x)] = self.syn_structure[x].start;
				}

				slider_value = self.syn_slider[(self.syn_current_menu + "_" + x)];
				self.menu["slider_text"] set_text("" + slider_value);
				self.menu["slider"].alpha = 1;
			}

			if(isDefined(self.syn_structure[x].command) && self.syn_structure[x].command == &new_menu) {
				self.menu["submenu_icon_" + i].alpha = 1;
			}

			if(!isDefined(self.syn_structure[x].command)) {
				self.menu["option_" + i].color = (0.75, 0.75, 0.75);
			} else {
				if((self.syn_cursor_index) == x) {
					self.menu["option_" + i].color = (0.75, 0.75, 0.75);
					self.menu["submenu_icon_" + i].color = (0.75, 0.75, 0.75);
				} else {
					self.menu["option_" + i].color = (0.5, 0.5, 0.5);
					self.menu["submenu_icon_" + i].color = (0.5, 0.5, 0.5);
				}
			}
		}
	}

	menu_height = int(18 + (self.syn_maximum * 15));

	self.menu["description"].y = int((self.syn_y_offset + 2) + ((self.syn_maximum + 1) * 15));

	self.menu["border"] set_shader("white", self.menu["border"].width, int(menu_height + self.syn_description_height));
	self.menu["background"] set_shader("white", self.menu["background"].width, int((menu_height - 2) + self.syn_description_height));
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, int(menu_height - 17));
}

// Menu Options

function menu_option() {
	self.syn_structure = [];
	menu = self.syn_current_menu;
	switch(menu) {
		case "Synergy":
			self set_title(menu);

			self add_option("Basic Options", undefined, &new_menu, "Basic Options");
			self add_option("Fun Options", undefined, &new_menu, "Fun Options");
			self add_option("Weapon Options", undefined, &new_menu, "Weapon Options");
			self add_option("Perk Options", undefined, &new_menu, "Perk Options");
			self add_option("Zombie Options", undefined, &new_menu, "Zombie Options");
			self add_option("Map Options", undefined, &new_menu, "Map Options");
			self add_option("Powerup Options", undefined, &new_menu, "Powerup Options");
			self add_option("Menu Options", undefined, &new_menu, "Menu Options");
			self add_option("All Players", undefined, &new_menu, "All Players");

			break;
		case "Basic Options":
			self set_title(menu);

			self add_toggle("God Mode", "Makes you Invincible", &god_mode, self.syn_god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", &frag_no_clip, self.syn_frag_no_clip);

			self add_toggle("Infinite Ammo", "Gives you Infinite Ammo, Grenades, and Specialist", &infinite_ammo, self.syn_infinite_ammo);
			self add_toggle("Infinite Shield", "Gives you Infinite Shield Durability", &infinite_shield, self.syn_infinite_shield);

			self add_option("Give Gobblegum", undefined, &new_menu, "Give Gobblegum");

			self add_option("Point Options", undefined, &new_menu, "Point Options");

			break;
		case "Fun Options":
			self set_title(menu);

			self add_toggle("Forge Mode", undefined, &forge_mode, self.syn_forge_mode);

			if(self.syn_map_name != "shadows_of_evil" && self.syn_map_name != "der_eisendrache") {
				self add_toggle("Exo Movement", "Enable/Disable Exo-Suits", &exo_movement, self.syn_exo_movement);
				self add_toggle("Infinite Boost", "Enables Infinite Exo-Boost", &infinite_boost, self.syn_infinite_boost);
			}

			self add_increment("Set Speed", undefined, &set_speed, 1, 1, 15, 1);
			self add_increment("Set Timescale", undefined, &set_timescale, 1, 0.125, 10, 0.125);
			self add_increment("Set Gravity", undefined, &set_gravity, 900, 130, 900, 10);

			self add_toggle("Third Person", undefined, &third_person, self.syn_third_person);

			self add_option("Visions", undefined, &new_menu, "Visions");

			break;
		case "Weapon Options":
			self set_title(menu);

			self add_option("Give Weapons", undefined, &new_menu, "Give Weapons");
			self add_toggle("Give Pack-a-Punched Weapons", "Weapons Given will be Pack-a-Punched", &give_packed_weapon, self.syn_give_packed_weapon);
			self add_option("Pack-a-Punch Current Weapon", "Held Weapon will be Pack-a-Punched", &pack_weapon);
			self add_option("Un-Pack-a-Punch Current Weapon", "Held Weapon will be Un-Pack-a-Punched", &unpack_weapon);
			self add_option("Give AAT", undefined, &new_menu, "Give AAT");

			weapon_name = self getCurrentWeapon().rootWeapon.name;
			category = get_category(weapon_name);

			if(isDefined(category) && weapon_name != "pistol_revolver38" && weapon_name != "smg_sten" || weapon_name == "smg_longrange") {
				if(category != "weapon_launcher" && category != "weapon_melee" && category != "weapon_grenade" && category != "weapon_extras") {
					self add_option("Equip Attachment", undefined, &new_menu, "Equip Attachment");
				}
			}
			self add_option("Equip Camo", undefined, &new_menu, "Equip Camo");

			if(isDefined(category) || weapon_name == "pistol_standard" || weapon_name == "smg_longrange") {
				if(category != "weapon_melee" && category != "weapon_grenade" && category != "weapon_extras") {
					if(self zm_score::can_player_purchase(int(get_ammo_cost()))) {
						price_color = "^2";
					} else {
						price_color = "^1";
					}

					self add_option("Refill Ammo (" + price_color + "$" + get_ammo_cost() + "^7)", undefined, &refill_ammo);
				}
			}

			self add_option("Take Current Weapon", undefined, &take_weapon);
			self add_option("Drop Current Weapon", undefined, &drop_weapon);

			break;
		case "Perk Options":
			self set_title(menu);

			self add_option("Give Perks", undefined, &new_menu, "Give Perks");
			self add_option("Take Perks", undefined, &new_menu, "Take Perks");
			self add_option("Give Perkaholic", undefined, &give_perkaholic);
			self add_option("Take Perkaholic", undefined, &take_perkaholic);

			self add_increment("Set Perk Limit", undefined, &set_perk_limit, 4, 1, 99, 1);

			self add_toggle("Keep Mule Kick Weapon", "Gives Mule Kick Weapon back when Rebuying the Perk", &keep_mule_kick_weapon, self.syn_keep_mule_kick_weapon);
			self add_toggle("Speed Cola Buff", "Speed Cola has bonus Speed Effects", &speed_cola_buff, self.syn_speed_cola_buff);
			self add_option("Speed Cola Buff Options", undefined, &new_menu, "Speed Cola Buff Options");
			self add_toggle("Stamin-Up Buff", "Stamin-Up has bonus Speed Effects", &stamin_up_buff, self.syn_stamin_up_buff);
			self add_option("Stamin-Up Buff Options", undefined, &new_menu, "Stamin-Up Buff Options");

			break;
		case "Zombie Options":
			self set_title(menu);

			self add_option("Round Options", undefined, &new_menu, "Round Options");

			self add_toggle("No Target", "Zombies won't Target You", &no_target, self.syn_no_target);

			self add_toggle("Enable Hitmarkers", undefined, &enable_hitmarkers, self.syn_enable_hitmarkers);
			self add_toggle("Zombie Counter", undefined, &zombie_counter, self.syn_zombie_counter);

			map = self.syn_map_name;

			if(map == "der_eisendrache" || map == "revelations" || map == "origins" || map == "zetsubou_no_shima" || map == "moon") {
				self add_option("Spawn Zombies", undefined, &new_menu, "Spawn Zombies");
			} else {
				self add_option("Spawn Zombie", undefined, &spawn_normal_zombie);
			}
			self add_option("Kill All Zombies", undefined, &kill_all_zombies);
			self add_option("Teleport Zombies to Crosshair", undefined, &teleport_zombies);

			self add_toggle("One Shot Zombies", undefined, &one_shot_zombies, self.syn_one_shot_zombies);
			self add_toggle("Freeze Zombies", undefined, &freeze_zombies, self.syn_freeze_zombies);
			self add_toggle("Slow Zombies", "Gives Zombies the Widow's Wine Effect to Slow them Down", &slow_zombies, self.syn_slow_zombies);
			self add_toggle("Disable Spawns", undefined, &disable_spawns, self.syn_disable_spawns);

			self add_array("Zombie Color", "Set Zombie Color", &color_zombies, array("None", "Orange", "Green", "Purple", "Blue"), true);

			break;
		case "Map Options":
			self set_title(menu);

			self add_toggle("Freeze Box", "Locks the Mystery Box, so it can't move", &freeze_box, self.syn_freeze_box);
			self add_option("Open Doors", undefined, &open_doors);

			if(!level flag::get("power_on") || !level flag::get("all_power_on")) {
				if(self.syn_map_name == "shadows_of_evil") {
					self add_option("Turn Power On", undefined, &shock_all_electrics);
				} else {
					self add_option("Turn Power On", undefined, &power_on);
				}
			}

			if(!isDefined(level.parts_collected)) {
				self add_option("Pick up all Parts", undefined, &pick_up_parts);
			}

			self add_option("Restart Match", undefined, &restart_match);

			break;
		case "Powerup Options":
			self set_title(menu);

			self add_toggle("Shoot Powerups", undefined, &shoot_powerups, self.syn_shoot_powerups);

			self add_option("Remove Powerups", "Disable Select Powerup drops from Zombies", &new_menu, "Remove Powerups");

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				self add_option("Spawn " + self.syn["powerups"][1][i], undefined, &spawn_powerup, self.syn["powerups"][0][i]);
			}

			break;
		case "Remove Powerups":
			self set_title(menu);

			self add_option("Reset", undefined, &reset_powerups);

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				self add_toggle("Disable " + self.syn["powerups"][1][i], undefined, &disable_powerup, self.syn["powerups"][2][i], self.syn["powerups"][0][i], i);
			}

			break;
		case "Menu Options":
			self set_title(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", &modify_menu_position, 0, -600, 20, 10, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", &modify_menu_position, 0, -100, 30, 10, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", &set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, &hide_ui, self.syn_hide_ui);
			self add_toggle("Hide Weapon", undefined, &hide_weapon, self.syn_hide_weapon);

			break;
		case "All Players":
			self set_title(menu);

			foreach(player in level.players) {
				self add_option(player.name, undefined, &new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self set_title(menu);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.syn_previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self add_option("Print", "Print Player Name", &print_player_name, target);

				if(!target isHost() && target.syn_access == "None") {
					self add_option("Verify", "Give the Player Mod Menu Access", &verify_player, target);
				}

				if(!target isHost()) {
					self add_option("Kick", "Kick the Player from the Game", &kick_player, target);
				}
			} else {
				self add_option("Player not found");
			}

			break;
		case "Give Gobblegum":
			self set_title(menu);

			foreach(gobblegum in self.syn["gobblegum"][0]) {
				gobblegum_name = get_gobblegum_name(gobblegum);
				self add_option(gobblegum_name, undefined, &give_gobblegum, gobblegum);
			}

			break;
		case "Point Options":
			self set_title(menu);

			self add_increment("Set Points Increment", undefined, &set_points_increment, 100, 100, 10000, 100);

			self add_increment("Set Points", undefined, &set_points, 500, 500, 100000, self.syn_point_increment);
			self add_increment("Add Points", undefined, &add_points, 500, 500, 100000, self.syn_point_increment);
			self add_increment("Take Points", undefined, &take_points, 500, 500, 100000, self.syn_point_increment);

			break;
		case "Give Perks":
			self set_title(menu);

			foreach(perk in self.syn["perks"]["all"]) {
				perk_name = get_perk_name(perk);
				self add_option(perk_name, undefined, &give_perk, perk);
			}

			break;
		case "Take Perks":
			self set_title(menu);

			foreach(perk in self.syn["perks"]["all"]) {
				perk_name = get_perk_name(perk);
				self add_option(perk_name, undefined, &take_perk, perk);
			}

			break;
		case "Speed Cola Buff Options":
			self set_title(menu);

			self add_toggle("Fast ADS", undefined, &toggle_speed_cola_buff_option, self.syn_speed_cola_fastads, "fastads");
			self add_toggle("Fast Weapon Swap", undefined, &toggle_speed_cola_buff_option, self.syn_speed_cola_fastweaponswitch, "fastweaponswitch)");
			self add_toggle("Fast Equipment Use", undefined, &toggle_speed_cola_buff_option, self.syn_speed_cola_fastequipmentuse, "fastequipmentuse");

			break;
		case "Stamin-Up Buff Options":
			self set_title(menu);

			self add_toggle("Fire while Sprinting", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_sprintfire, "sprintfire");
			self add_toggle("Faster ADS Movement", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_stalker, "stalker");
			self add_toggle("Infinite Sprint", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_unlimitedsprint, "unlimitedsprint");
			self add_toggle("Climb Ladders Faster", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_fastladderclimb, "fastladderclimb");
			self add_toggle("Mantle Faster", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_fastmantle, "fastmantle");
			self add_toggle("Use Equipment while Sprinting", undefined, &toggle_stamin_up_buff_option, self.syn_stamin_up_sprintequipment, "sprintequipment");

			break;
		case "Visions":
			self set_title(menu);

			for(i = 0; i < self.syn["visions"][0].size; i++) {
				self add_option(self.syn["visions"][1][i], undefined, &set_vision, self.syn["visions"][0][i]);
			}

			if(self.syn_map_name == "shadows_of_evil" || self.syn_map_name == "der_eisendrache" || self.syn_map_name == "zetsubou_no_shima" || self.syn_map_name == "gorod_krovi" || self.syn_map_name == "revelations" || self.syn_map_name == "verruckt" || self.syn_map_name == "shi_no_numa" || self.syn_map_name == "kino_der_untoten" || self.syn_map_name == "ascension" || self.syn_map_name == "shangri_la" || self.syn_map_name == "moon" || self.syn_map_name == "origins") {
				for(i = 0; i < self.syn["visions"][self.syn_map_name][0].size; i++) {
					self add_option(self.syn["visions"][self.syn_map_name][1][i], undefined, &set_vision, self.syn["visions"][self.syn_map_name][0][i]);
				}
			}

			foreach(vision in self.syn["visions"][3]) {
				switch(vision.name) {
					case "":
					case "cheat_bw_contrast":
					case "cheat_bw_invert_contrast":
					case "drown_blur":
					case "flare":
					case "mechz_player_burn":
					case "zm_ai_quad_blur":
					case "zm_ai_screecher_blur":
					case "zm_bgb_eye_candy_vs_1":
					case "zm_bgb_eye_candy_vs_2":
					case "zm_bgb_eye_candy_vs_3":
					case "zm_bgb_eye_candy_vs_4":
					case "zm_bgb_idle_eyes":
					case "zm_bgb_in_plain_sight":
					case "zm_bgb_now_you_see_me":
					case "zm_castle_transported":
					case "zm_chaos_organge":
					case "zm_cosmodrome_monkey_off":
					case "zm_cosmodrome_monkey_on":
					case "zm_cosmodrome_no_power":
					case "zm_cosmodrome_power_antic":
					case "zm_cosmodrome_power_flare":
					case "zm_factory_teleport":
					case "zm_gasmask_postfx":
					case "zm_genesis_transported":
					case "zm_health_blur":
					case "zm_health_blur":
					case "zm_idgun_vortex_blur":
					case "zm_idgun_vortex_visionset":
					case "zm_isl_thrasher_stomach_visionset":
					case "raygun_mark3_vortex_blur":
					case "raygun_mark3_vortex_visionset":
					case "zm_showerhead":
					case "zm_showerhead_postfx":
					case "zm_temple_eclipse":
					case "zm_theater_teleport":
					case "zm_tomb_in_plain_sight":
					case "zm_transit_burn":
					case "zm_trap_electric":
					case "zm_waterfall_postfx":
					case "zm_zod_transported":
					case "zod_ritual_dim":
					case "zombie_beast_2":
					case "zombie_cosmodrome_blackhole":
					case "zombie_death":
					case "zombie_last_stand":
					case "zombie_noire":
					case "zombie_turned":
						break;
					default:
						self add_option(vision.displayName, vision.name, &set_vision, vision.name);
				}
			}

			break;
		case "Round Options":
			self add_increment("Set Round Increment", undefined, &set_round_increment, 1, 1, 10, 1);
			self add_increment("Set Round", undefined, &set_round, 1, 1, 255, self.syn_round_increment);

			self add_increment("Set Zombie Cap", undefined, &set_zombie_cap, 24, 1, 31, 1);

			self add_array("Set Zombie Speed", undefined, &set_zombie_speed, array("Restore", "Walk", "Run", "Sprint", "Super Sprint"), true);

			self add_increment("Set Round Health Cap", "Cap Zombies Health to Specified Round", &set_zombie_health_cap, 1, 1, 100, 1);
			self add_option("Reset Zombie Health Cap", "Set Health Cap back to Normal", &reset_zombie_health_cap);

			break;
		case "Spawn Zombies":
			self set_title(menu);

			self add_option("Spawn Zombie", undefined, &spawn_normal_zombie);

			map = self.syn_map_name;

			if(map == "der_eisendrache" || map == "revelations" || map == "origins") {
				self add_option("Spawn Panzer", undefined, &spawn_panzer);
			}

			if(map == "zetsubou_no_shima" || map == "revelations" || map == "moon") {
				for(i = 0; i < self.syn["zombies"][map][0].size; i++) {
					self add_option("Spawn " + self.syn["zombies"][map][0][i], undefined, &spawn_zombie, self.syn["zombies"][map][1][i]);
				}
			}

			break;
		case "Equip Attachment":
			self set_title(menu);

			self.syn_equip_attachment_in_progress = true;

			self.syn["attachment_toggles"] = [];

			while(self getCurrentWeapon() == getWeapon(#"none")) {
				wait 0.05;
			}

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				for(i = 0; i < weapon_attachments.size; i++) {
					self.syn["attachment_toggles"][i] = weaponHasAttachment(self getCurrentWeapon(), weapon_attachments[i]);
					self add_toggle(get_attachment_name(weapon_attachments[i]), undefined, &equip_attachment, self.syn["attachment_toggles"][i], weapon_attachments[i]);
				}
			}

			self.syn_equip_attachment_in_progress = false;

			break;
		case "Equip Camo":
			self set_title(menu);

			for(i = 0; i < self.syn["camos"][0].size; i++) {
				self add_option(self.syn["camos"][1][i], undefined, &equip_camo, self.syn["camos"][0][i]);
			}

			break;
		case "Give AAT":
			self set_title(menu);

			self add_option("None", undefined, &take_aat);

			for(i = 0; i < self.syn["aats"][0].size; i++) {
				self add_option(self.syn["aats"][1][i], undefined, &give_aat, self.syn["aats"][0][i]);
			}

			break;
		case "Give Weapons":
			self set_title(menu);

			for(i = 0; i < self.syn["weapons"]["category"].size; i++) {
				self add_option(self.syn["weapons"]["category"][i], undefined, &new_menu, self.syn["weapons"]["category"][i]);
			}

			break;
		case "Assault Rifles":
			self set_title(menu);

			load_weapons("weapon_assault");

			break;
		case "Sub Machine Guns":
			self set_title(menu);

			load_weapons("weapon_smg");

			if(self.syn_map_name == "shadows_of_evil" || self.syn_map_name == "the_giant" || self.syn_map_name == "der_eisendrache") {
				self add_option("Razorback", undefined, &give_weapon, "smg_longrange");
			}

			break;
		case "Light Machine Guns":
			self set_title(menu);

			load_weapons("weapon_lmg");

			break;
		case "Sniper Rifles":
			self set_title(menu);

			load_weapons("weapon_sniper");

			break;
		case "Shotguns":
			self set_title(menu);

			load_weapons("weapon_cqb");

			break;
		case "Pistols":
			self set_title(menu);

			if(self.syn_map_name == "shadows_of_evil") {
				self add_option("MR6", undefined, &give_weapon, "pistol_standard");
			}

			load_weapons("weapon_pistol");

			break;
		case "Launchers":
			self set_title(menu);

			load_weapons("weapon_launcher");

			break;
		case "Melee":
			self set_title(menu);

			for(i = 0; i < self.syn["weapons"]["melee"][0].size; i++) {
				self add_option(self.syn["weapons"]["melee"][1][i], undefined, &give_weapon, self.syn["weapons"]["melee"][0][i]);
			}

			load_weapons("weapon_melee");

			break;
		case "Equipment":
			self set_title(menu);

			self add_option("Frag Grenades", undefined, &give_weapon, "frag_grenade");
			self add_option("Widow's Wine Grenades", undefined, &give_weapon, "sticky_grenade_widows_wine");

			load_weapons("weapon_grenade");

			break;
		case "Extras":
			self set_title(menu);

			if(self.syn_map_name == "shadows_of_evil" || self.syn_map_name == "the_giant" || self.syn_map_name == "zetsubou_no_shima" || self.syn_map_name == "gorod_krovi" || self.syn_map_name == "revelations" || self.syn_map_name == "origins") {
				for(i = 0; i < self.syn["weapons"]["extras"][self.syn_map_name][0].size; i++) {
					self add_option(self.syn["weapons"]["extras"][self.syn_map_name][1][i], undefined, &give_weapon, self.syn["weapons"]["extras"][self.syn_map_name][0][i]);
				}
			}

			for(i = 0; i < self.syn["weapons"]["extras"][0].size; i++) {
				self add_option(self.syn["weapons"]["extras"][1][i], undefined, &give_weapon, self.syn["weapons"]["extras"][0][i]);
			}

			foreach(weapon in self.syn["weapons"][9]) {
				switch(weapon.id) {
					case "bowie_knife":
					case "frag_grenade":
					case "staff_air_upgraded":
					case "staff_fire_upgraded":
					case "staff_lightning_upgraded":
					case "staff_water_upgraded":
						break;
					default:
						self add_option(weapon.name, "ID: " + weapon.id + " | Category: " + weapon.category, &give_weapon, weapon.id);
						break;
				}
			}

			break;
		default:
			if(!isDefined(self.syn_selected_player)) {
				self.syn_selected_player = self;
			}

			self player_option(menu, self.syn_selected_player);
			break;
	}
}

// Menu Options

function iPrintString(string) {
	if(!isDefined(self.syn["string"])) {
	  self.syn["string"] = self create_text(string, "default", 1.5, "center", "top", 0, -115, (1, 1, 1), 1, 9999, false);
	} else {
	  self.syn["string"] set_text(string);
	}
	self.syn["string"] notify("stop_hud_fade");
	self.syn["string"].alpha = 1;
	self.syn["string"] setText(string);
	self.syn["string"] thread fade_hud(0, 2.5);
}

function fade_hud(alpha, time) {
	self endon("stop_hud_fade");
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

function modify_menu_position(offset, axis) {
	if(axis == "x") {
		self.syn_x_offset = 175 + offset;
	} else {
		self.syn_y_offset = 160 + offset;
	}
	self close_menu();
	self open_menu();
}

function set_menu_rainbow() {
	if(!isString(self.syn_color_theme)) {
		self.syn_color_theme = "rainbow";
		self.menu["border"] thread start_rainbow();
		self.menu["separator_1"] thread start_rainbow();
		self.menu["separator_2"] thread start_rainbow();
		self.menu["border"].color = self.syn_color_theme;
		self.menu["separator_1"].color = self.syn_color_theme;
		self.menu["separator_2"].color = self.syn_color_theme;
	}
}

function set_menu_color(value, color) {
	if(color == "Red") {
		self.syn_menu_color_red = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Green") {
		self.syn_menu_color_green = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Blue") {
		self.syn_menu_color_blue = value;
		iPrintString(color + " Changed to " + value);
	} else {
		iPrintString(value + " | " + color);
	}
	self.syn_color_theme = (self.syn_menu_color_red / 255, self.syn_menu_color_green / 255, self.syn_menu_color_blue / 255);
	self.menu["border"] notify("stop_rainbow");
	self.menu["separator_1"] notify("stop_rainbow");
	self.menu["separator_2"] notify("stop_rainbow");
	self.menu["border"].rainbow_enabled = false;
	self.menu["separator_1"].rainbow_enabled = false;
	self.menu["separator_2"].rainbow_enabled = false;
	self.menu["border"].color = self.syn_color_theme;
	self.menu["separator_1"].color = self.syn_color_theme;
	self.menu["separator_2"].color = self.syn_color_theme;
}

function hide_ui() {
	self.syn_hide_ui = !return_toggle(self.syn_hide_ui);
	setDvar("\ui_enabled", !self.syn_hide_ui);
	setDvar("\cg_draw2d", !self.syn_hide_ui);
}

function hide_weapon() {
	self.syn_hide_weapon = !return_toggle(self.syn_hide_weapon);
	setDvar("\cg_drawgun", !self.syn_hide_weapon);
}

// Basic Options

function god_mode() {
	self.syn_god_mode = !return_toggle(self.syn_god_mode);
	if(self.syn_god_mode) {
		iPrintString("God Mode [^2ON^7]");
		self enableInvulnerability();
		god_mode_loop();
	} else {
		iPrintString("God Mode [^1OFF^7]");
		self notify("stop_god_mode");
		self disableInvulnerability();
	}
}

function god_mode_loop() {
	self endon("stop_god_mode");
	self endon("disconnect");
	level endon("game_ended");

	for(;;) {
		self enableInvulnerability();
		wait 0.1;
	}
}

function frag_no_clip() {
	self endon("disconnect");
	level endon("game_ended");

	if(!isDefined(self.syn_frag_no_clip)) {
		self.syn_frag_no_clip = true;
		iPrintString("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
		while(isDefined(self.syn_frag_no_clip)) {
			if(self fragButtonPressed()) {
				if(!isDefined(self.syn_frag_no_clip_loop)) {
					self thread frag_no_clip_loop();
				}
			}
			wait 0.05;
		}
	} else {
		self.syn_frag_no_clip = undefined;
		iPrintString("Frag No Clip [^1OFF^7]");
	}
}

function frag_no_clip_loop() {
	self endon("disconnect");
	self endon("noclip_end");

	self disableWeapons();
	self disableOffHandWeapons();
	self.syn_frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.syn_god_mode) || !self.syn_god_mode) {
		self enableInvulnerability();
		self.syn_temp_god_mode = true;
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

	if(isDefined(self.syn_temp_god_mode)) {
		self disableInvulnerability();
		self.syn_temp_god_mode = undefined;
	}

	self.syn_frag_no_clip_loop = undefined;
}

function infinite_ammo() {
	self.syn_infinite_ammo = !return_toggle(self.syn_infinite_ammo);
	if(self.syn_infinite_ammo) {
		iPrintString("Infinite Ammo [^2ON^7]");
		self thread infinite_ammo_loop();
	} else {
		iPrintString("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

function infinite_ammo_loop() {
	self endon("stop_infinite_ammo");
	level endon("game_ended");

	for(;;) {
		weapons = self getWeaponsList();
		for(i = 0; i < weapons.size; i++) {
			self giveMaxAmmo(weapons[i]);
		}
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);
		self gadgetPowerSet(0, 100);
		wait 0.05;
	}
}

function infinite_shield() {
	self.syn_infinite_shield = !return_toggle(self.syn_infinite_shield);
	if(self.syn_infinite_shield) {
		iPrintString("Infinite Shield [^2ON^7]");
		self thread infinite_shield_loop();
	} else {
		iPrintString("Infinite Shield [^1OFF^7]");
		self notify("stop_infinite_shield");
	}
}

function infinite_shield_loop() {
	self endon("stop_infinite_shield");
	level endon("game_ended");

	for(;;) {
		if(isDefined(self.player_shield_reset_health)) {
			self[[self.player_shield_reset_health]]();
		}
		wait 2.5;
	}
}

function get_gobblegum_name(gobblegum) {
	for(i = 0; i < self.syn["gobblegum"][0].size; i++) {
		if(gobblegum == self.syn["gobblegum"][0][i]) {
			return self.syn["gobblegum"][1][i];
		}
	}
	return gobblegum;
}

function give_gobblegum(gobblegum) {
	saved_weapon = self getCurrentWeapon();
	weapon = getWeapon("zombie_bgb_grab");
	self giveWeapon(weapon, self calcWeaponOptions(level.bgb[gobblegum].camo_index, 0, 0));
	self switchToWeapon(weapon);
	self playSound("zmb_bgb_powerup_default");

	event = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
	if(event == "weapon_change_complete") {
		self takeWeapon(weapon);
		self zm_weapons::switch_back_primary_weapon(saved_weapon);
		bgb::give(gobblegum);
	}
}

function set_points_increment(value) {
	self.syn_point_increment = value;
}

function set_points(value) {
	self zm_score::minus_to_player_score(9999999);
	self zm_score::add_to_player_score(value);
}

function add_points(value) {
	self zm_score::add_to_player_score(value);
}

function take_points(value) {
	self zm_score::minus_to_player_score(value);
}

// Fun Options

function forge_mode() {
	self.syn_forge_mode = !return_toggle(self.syn_forge_mode);
	if(self.syn_forge_mode) {
		iPrintString("Forge Mode [^2ON^7], Press ^3[{+speed_throw}]^7 to Pick Up/Drop Objects");
		self thread forge_mode_loop();
	} else {
		iPrintString("Forge Mode [^1OFF^7]");
		self notify("stop_forge_mode");
	}
}

function forge_mode_loop() {
	self endon("disconnect");
	self endon("stop_forge_mode");

	while (true) {
		trace = beamTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 1, self);
		if(isDefined(trace["entity"])) {
			if(self adsButtonPressed()) {
				while (self adsButtonPressed()) {
					if(isActor(trace["entity"])) {
						trace["entity"] forceTeleport(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200);
					} else {
						trace["entity"].origin = self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200;
					}
					wait 0.01;
				}
			}
			if(self attackButtonPressed()) {
				while (self attackButtonPressed()) {
					trace["entity"] rotatePitch(1, 0.01);
					wait 0.01;
				}
			}
			if(self fragButtonPressed()) {
				while (self fragButtonPressed()) {
					trace["entity"] rotateYaw(1, 0.01);
					wait 0.01;
				}
			}
			if(self secondaryOffhandButtonPressed()) {
				while (self secondaryOffhandButtonPressed()) {
					trace["entity"] rotateRoll(1, 0.01);
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

function exo_movement() {
	self.syn_exo_movement = !return_toggle(self.syn_exo_movement);
	if(self.syn_exo_movement) {
		iPrintString("Exo Movement [^2ON^7]");
		setDvar("doublejump_enabled", 1);
		setDvar("juke_enabled", 1);
		setDvar("playerEnergy_enabled", 1);
		setDvar("wallrun_enabled", 1);
		setDvar("sprintLeap_enabled", 1);
		setDvar("traverse_mode", 1);
		setDvar("weaponrest_enabled", 1);
		self thread exo_movement_loop();
	} else {
		iPrintString("Exo Movement [^1OFF^7]");
		setDvar("doublejump_enabled", 0);
		setDvar("juke_enabled", 0);
		setDvar("playerEnergy_enabled", 0);
		setDvar("wallrun_enabled", 0);
		setDvar("sprintLeap_enabled", 0);
		setDvar("traverse_mode", 0);
		setDvar("weaponrest_enabled", 0);
		self notify("stop_exo_movement");
	}
}

function exo_movement_loop() {
	self endon("stop_exo_movement");
	level endon("game_ended");

	for(;;) {
    if(self jumpButtonPressed()) {
			exo_blast = self playSoundToPlayer("zmb_bgb_powerup_burnedout", self);
			while(self jumpButtonPressed()) {
				wait 0.1;
			}
		}
		wait 0.1;
	}
}

function infinite_boost() {
	if(self.syn_exo_movement) {
		self.syn_infinite_boost = !return_toggle(self.syn_infinite_boost);
		if(self.syn_infinite_boost) {
			iPrintString("Infinite Boost [^2ON^7]");
			self thread infinite_boost_loop();
		} else {
			iPrintString("Infinite Boost [^1OFF^7]");
			self notify("stop_infinite_boost");
		}
	}
}

function infinite_boost_loop() {
	self endon("stop_infinite_boost");
	level endon("game_ended");

	for(;;) {
		self setDoubleJumpEnergy(100);
		wait 0.1;
	}
}

function set_speed(value) {
	if(value == 1) {
		self.movement_speed = undefined;
	}
	self setMoveSpeedScale(value);
}

function set_timescale(value) {
	setDvar("timescale", value);
}

function set_gravity(value) {
	setDvar("bg_gravity", value);
	if(value < 900) {
		self clientField::set("low_gravity", 1);
	} else {
		self clientField::set("low_gravity", 0);
	}
}

function third_person() {
	self.syn_third_person = !return_toggle(self.syn_third_person);
	if(self.syn_third_person) {
		iPrintString("Third Person [^2ON^7]");
		self setClientThirdPerson(1);
		self setClientThirdPersonAngle(354);
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
	} else {
		iPrintString("Third Person [^1OFF^7]");
		self setClientThirdPerson(0);
		self setClientThirdPersonAngle(0);
		self setDepthOfField(0, 0, 512, 4000, 4, 0);
	}
	self resetFov();
}

function set_vision(vision) {
	if(isDefined(self.syn_prev_vision)) {
		visionset_mgr::deactivate("visionset", self.syn_prev_vision, self);
		visionset_mgr::deactivate("overlay", self.syn_prev_vision, self);
		wait 0.25;
	}
	visionset_mgr::activate("visionset", vision, self);
	visionset_mgr::activate("overlay", vision, self);
	self.syn_prev_vision = vision;
}

// Perk Options

function get_perk_name(perk) {
	for(i = 0; i < self.syn["perks"]["common"][0].size; i++) {
		if(perk == self.syn["perks"]["common"][0][i]) {
			return self.syn["perks"]["common"][1][i];
		}
	}
	return perk;
}

function give_perk(perk) {
	if(!self hasPerk(perk)) {
		self setPerk(perk);
		self zm_perks::vending_trigger_post_think(self, perk);
	}
}

function take_perk(perk) {
	if(self hasPerk(perk)) {
		self notify(perk + "_stop");
	}
}

function give_perkaholic() {
	self zm_utility::give_player_all_perks();
}

function take_perkaholic() {
	foreach(perk in self.syn["perks"]["all"]) {
		if(self hasPerk(perk)) {
			self notify(perk + "_stop");
		}
	}
}

function set_perk_limit(value) {
	level.perk_purchase_limit = value;
}

function keep_mule_kick_weapon() {
	self.syn_keep_mule_kick_weapon = !return_toggle(self.syn_keep_mule_kick_weapon);
	if(self.syn_keep_mule_kick_weapon) {
		iPrintString("Keep Mule Kick Weapon [^2ON^7]");
		self thread keep_mule_kick_weapon_loop();
	} else {
		iPrintString("Keep Mule Kick Weapon [^1OFF^7]");
		self notify("stop_keep_mule_kick_weapon");
	}
}

function keep_mule_kick_weapon_loop() {
	self endon("stop_keep_mule_kick_weapon");
	level endon("game_ended");

	for(;;) {
   if(self hasPerk("specialty_additionalprimaryweapon") && isDefined(self.weapon_taken_by_losing_specialty_additionalprimaryweapon)) {
			if(isDefined(level.return_additionalprimaryweapon)) {
				self[[level.return_additionalprimaryweapon]](self.weapon_taken_by_losing_specialty_additionalprimaryweapon);
			} else {
				self zm_weapons::give_build_kit_weapon(self.weapon_taken_by_losing_specialty_additionalprimaryweapon);
			}
			self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;
		}
		wait 5;
	}
}

function speed_cola_buff() {
	self.syn_speed_cola_buff = !return_toggle(self.syn_speed_cola_buff);
	if(self.syn_speed_cola_buff) {
		iPrintString("Speed Cola Buff [^2ON^7]");
		self thread speed_cola_buff_loop();
	} else {
		iPrintString("Speed Cola Buff [^1OFF^7]");
		self notify("stop_speed_cola_buff");
		wait 1.1;
		self unsetPerk("specialty_fastads");
    self unsetPerk("specialty_fastweaponswitch");
    self unsetPerk("specialty_fastequipmentuse");
    self unsetPerk("specialty_fasttoss");
	}
}

function speed_cola_buff_loop() {
	self endon("stop_speed_cola_buff");
	level endon("game_ended");

	for(;;) {
		if(self hasPerk("specialty_fastreload") && !(self hasPerk("specialty_fastads") || self hasPerk("specialty_fastweaponswitch") || self hasPerk("specialty_fastequipmentuse") || self hasPerk("specialty_fasttoss"))) {
      if(self.syn_speed_cola_fastads) {
				self setPerk("specialty_fastads");
			}
			if(self.syn_speed_cola_fastweaponswitch) {
				self setPerk("specialty_fastweaponswitch");
			}
			if(self.syn_speed_cola_fastequipmentuse) {
				self setPerk("specialty_fastequipmentuse");
				self setPerk("specialty_fasttoss");
			}
    } else if(!self hasPerk("specialty_fastreload")) {
			self unsetPerk("specialty_fastads");
      self unsetPerk("specialty_fastweaponswitch");
      self unsetPerk("specialty_fastequipmentuse");
      self unsetPerk("specialty_fasttoss");
		}
		wait 1;
	}
}

function stamin_up_buff() {
	self.syn_stamin_up_buff = !return_toggle(self.syn_stamin_up_buff);
	if(self.syn_stamin_up_buff) {
		iPrintString("Stamin-Up Buff [^2ON^7]");
		self thread stamin_up_buff_loop();
	} else {
		iPrintString("Stamin-Up Buff [^1OFF^7]");
		self notify("stop_stamin_up_buff");
		wait 1.1;
		self unsetPerk("specialty_sprintfire");
		self unsetPerk("specialty_sprintfirerecovery");
		self unsetPerk("specialty_stalker");
		self unsetPerk("specialty_unlimitedsprint");
		self unsetPerk("specialty_fastladderclimb");
		self unsetPerk("specialty_fastmantle");
		self unsetPerk("specialty_sprintequipment");
		self unsetPerk("specialty_sprintgrenadelethal");
		self unsetPerk("specialty_sprintgrenadetactical");
	}
}

function stamin_up_buff_loop() {
	self endon("stop_stamin_up_buff");
	level endon("game_ended");

	for(;;) {
		if(self hasPerk("specialty_staminup") && !(self hasPerk("specialty_sprintfire") || self hasPerk("specialty_sprintfirerecovery") || self hasPerk("specialty_stalker") || self hasPerk("specialty_unlimitedsprint") || self hasPerk("specialty_fastladderclimb") || self hasPerk("specialty_fastmantle") || self hasPerk("specialty_sprintequipment"))) {
			if(self.syn_stamin_up_sprintfire) {
				self setPerk("specialty_sprintfire");
				self setPerk("specialty_sprintfirerecovery");
			}
			if(self.syn_stamin_up_stalker) {
				self setPerk("specialty_stalker");
			}
			if(self.syn_stamin_up_unlimitedsprint) {
				self setPerk("specialty_unlimitedsprint");
			}
			if(self.syn_stamin_up_fastladderclimb) {
				self setPerk("specialty_fastladderclimb");
			}
			if(self.syn_stamin_up_fastmantle) {
				self setPerk("specialty_fastmantle");
			}
			if(self.syn_stamin_up_sprintequipment) {
				self setPerk("specialty_sprintequipment");
				self setPerk("specialty_sprintgrenadelethal");
				self setPerk("specialty_sprintgrenadetactical");
			}
    } else if(!self hasPerk("specialty_staminup")) {
			self unsetPerk("specialty_sprintfire");
			self unsetPerk("specialty_sprintfirerecovery");
			self unsetPerk("specialty_stalker");
			self unsetPerk("specialty_unlimitedsprint");
			self unsetPerk("specialty_fastladderclimb");
			self unsetPerk("specialty_fastmantle");
			self unsetPerk("specialty_sprintequipment");
			self unsetPerk("specialty_sprintgrenadelethal");
			self unsetPerk("specialty_sprintgrenadetactical");
		}
		wait 1;
	}
}

function toggle_speed_cola_buff_option(option) {
	if(option == "fastads") {
		self.syn_speed_cola_fastads = !return_toggle(self.syn_speed_cola_fastads);
	} else if(option == "fastweaponswitch)") {
		self.syn_speed_cola_fastweaponswitch = !return_toggle(self.syn_speed_cola_fastweaponswitch);
	} else if(option == "fastequipmentuse") {
		self.syn_speed_cola_fastequipmentuse = !return_toggle(self.syn_speed_cola_fastequipmentuse);
	}

	self unsetPerk("specialty_fastads");
	self unsetPerk("specialty_fastweaponswitch");
	self unsetPerk("specialty_fastequipmentuse");
	self unsetPerk("specialty_fasttoss");
}

function toggle_stamin_up_buff_option(option) {
	if(option == "sprintfire") {
		self.syn_stamin_up_sprintfire = !return_toggle(self.syn_stamin_up_sprintfire);
	} else if(option == "stalker") {
		self.syn_stamin_up_stalker = !return_toggle(self.syn_stamin_up_stalker);
	} else if(option == "unlimitedsprint") {
		self.syn_stamin_up_unlimitedsprint = !return_toggle(self.syn_stamin_up_unlimitedsprint);
	} else if(option == "fastladderclimb") {
		self.syn_stamin_up_fastladderclimb = !return_toggle(self.syn_stamin_up_fastladderclimb);
	} else if(option == "fastmantle") {
		self.syn_stamin_up_fastmantle = !return_toggle(self.syn_stamin_up_fastmantle);
	} else if(option == "sprintequipment") {
		self.syn_stamin_up_sprintequipment = !return_toggle(self.syn_stamin_up_sprintequipment);
	}

	self unsetPerk("specialty_sprintfire");
	self unsetPerk("specialty_sprintfirerecovery");
	self unsetPerk("specialty_stalker");
	self unsetPerk("specialty_unlimitedsprint");
	self unsetPerk("specialty_fastladderclimb");
	self unsetPerk("specialty_fastmantle");
	self unsetPerk("specialty_sprintequipment");
	self unsetPerk("specialty_sprintgrenadelethal");
	self unsetPerk("specialty_sprintgrenadetactical");
}

// Player Options

function player_option(menu, player) {
	if(!isDefined(menu) || !isDefined(player) || !isplayer(player)) {
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

function get_name() {
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

function clean_name(name) {
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

function print_player_name(target) {
	iPrintString(target);
}

function verify_player(target) {
	target.access = "Verified";
	target thread initialize_verified_menu();
}

function kick_player(target) {
	kick(target getEntityNumber());
}

// Map Options

function freeze_box() {
	self.syn_freeze_box = !return_toggle(self.syn_freeze_box);
	if(self.syn_freeze_box) {
		iPrintString("Freeze Box [^2ON^7]");
		wait 5;
		level.chest_min_move_usage = 999;
	} else {
		iPrintString("Freeze Box [^1OFF^7]");
		wait 5;
		level.chest_min_move_usage = undefined;
	}
}

function open_doors() {
	types = array("zombie_door", "zombie_airlock_buy", "zombie_debris", "zombie_airlock_hackable", "zombie_door_airlock", "electric_buyable_door", "electric_door");
	foreach(type in types) {
		zombie_doors = getEntArray(type, "targetname");
		foreach(door in zombie_doors) {
			if(type == "zombie_debris") {
	      door.zombie_cost = 0;
	      door notify("trigger", self);
	    } else if(door._door_open != true) {
	      door thread zm_blockers::door_opened(door.zombie_cost, 0);
	      door._door_open = true;

	      all_trigs = getEntArray(door.target, "target");
	      foreach(trig in all_trigs) {
					trig zm_utility::set_hint_string(trig, "");
				}
	    }
		}
	}
}

function get_power_trigger() {
	presets = array("elec", "power", "master");
	foreach(preset in presets) {
		trigger = getEnt("use_" + preset + "_switch", "targetname");
		if(isDefined(trigger)) {
			return trigger;
		}
	}
	return false;
}

function power_on() {
	if(self.syn_map_name == "revelations") {
		for(i = 1; i < 5; i++) {
			level flag::set("power_on" + i);
		}
		level flag::set("all_power_on");
		waittillFrameEnd;

		while(!level flag::get("apothicon_near_trap")) {
			wait 0.1;
		}
		trigger = struct::get("apothicon_trap_trig", "targetName");
		trigger notify("trigger_activated", self);
		return;
	}
	if(self.syn_map_name == "shangri_la") {
		directions = array("power_trigger_left", "power_trigger_right");
		foreach(direction in directions) {
			switch_trigger = getEnt("power_trigger_" + direction, "targetName");
			switch_trigger notify("trigger", self);
		}
		return;
	}
	trigger = get_power_trigger();
	trigger notify("trigger", self);
}

function shock_all_electrics() {
	for(e = 0; e < 50; e++) {
		if(isDefined(level flag::get("power_on" + e))) {
			level flag::set("power_on" + e);
		}
	}
}

function pick_up_parts() {
	if(isDefined(level.parts_collected)) {
	  return;
	}

	foreach(craftable in level.zombie_include_craftables) {
	  foreach(part in craftable.a_piecestubs) {
	    if(isDefined(part.pieceSpawn)) {
	      self zm_craftables::player_take_piece(part.pieceSpawn);
			}
	  }
	}

	level.parts_collected = true;
}

function restart_match() {
	self notify("menuResponse", "", "restart_level_zm");
}

// Powerup Options

function spawn_powerup(powerup) {
	zm_powerups::specific_powerup_drop(powerup, self.origin + anglesToForward(self.angles) * 115);
}

function shoot_powerups() {
	self.syn_shoot_powerups = !return_toggle(self.syn_shoot_powerups);
	if(self.syn_shoot_powerups) {
		iPrintString("Shoot Powerups [^2ON^7]");
		self thread shoot_powerups_loop();
	} else {
		iPrintString("Shoot Powerups [^1OFF^7]");
		self notify("stop_shoot_powerups");
	}
}

function shoot_powerups_loop() {
	self endon("stop_shoot_powerups");
	level endon("game_ended");

	for(;;) {
		while(self attackButtonPressed()) {
			powerup = self.syn["powerups"][0][randomint(self.syn["powerups"][0].size)];
			zm_powerups::specific_powerup_drop(powerup, get_bullet_trace_position());
			wait 0.5;
		}
		wait 0.05;
	}
}

function reset_powerups() {
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
		level.zombie_powerups[self.syn["powerups"][0][i]].func_should_drop_with_regular_powerups = self.syn["powerups"][3][i];
		self.syn["powerups"][2][i] = false;
	}
	if (!level flag::get("zombie_drop_powerups")) {
		level flag::set("zombie_drop_powerups");
	}
}

function disable_powerup(powerup, i) {
	self.syn["powerups"][2][i] = !return_toggle(self.syn["powerups"][2][i]);
	if(self.syn["powerups"][2][i]) {
		level.zombie_powerups[powerup].func_should_drop_with_regular_powerups = false;
	} else {
		level.zombie_powerups[powerup].func_should_drop_with_regular_powerups = true;
	}

	all_powerups_disabled = true;
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
	  if(level.zombie_powerups[self.syn["powerups"][0][i]].func_should_drop_with_regular_powerups) {
			all_powerups_disabled = false;
		}
	}

	self.syn["powerups"][4] = [];
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
		current_powerup = self.syn["powerups"][0][i];
		if(current_powerup == "double_points" || current_powerup == "insta_kill" || current_powerup == "nuke" || current_powerup == "full_ammo") {
			self.syn["powerups"][4][self.syn["powerups"][4].size] = self.syn["powerups"][2][i];
		}
	}

	core_powerups_disabled = true;
	for(i = 0; i < self.syn["powerups"][4].size; i++) {
		if(!self.syn["powerups"][4][i]) {
			core_powerups_disabled = false;
		}
	}

	if(all_powerups_disabled || core_powerups_disabled) {
		level flag::clear("zombie_drop_powerups");
	} else {
		level flag::set("zombie_drop_powerups");
	}
}

// Weapon Options

function give_packed_weapon() {
	self.syn_give_packed_weapon = !return_toggle(self.syn_give_packed_weapon);
}

function pack_weapon() {
	self.syn_pack_weapon = 1;

	weapon = zm_weapons::get_base_weapon(self getCurrentWeapon()).name;

	self takeWeapon(self getCurrentWeapon());

	give_weapon(weapon);
}

function unpack_weapon() {
	self.syn_pack_weapon = undefined;

	weapon = zm_weapons::get_base_weapon(self getCurrentWeapon()).name;

	self takeWeapon(self getCurrentWeapon());

	give_weapon(weapon);
}

function give_weapon(weapon) {
	weapon = getWeapon(weapon);

	if(isDefined(self.syn_give_packed_weapon) && self.syn_give_packed_weapon == 1 || isDefined(self.syn_pack_weapon) && self.syn_pack_weapon == 1) {
		if(weapon == "staff_air" || weapon == "staff_fire" || weapon == "staff_lightning" || weapon == "staff_water") {
			weapon = weapon + "_upgraded";
		} else if(zm_weapons::can_upgrade_weapon(weapon)) {
			weapon = zm_weapons::get_upgrade_weapon(weapon);
		}
	}

	if(!self hasWeapon(weapon) || isDefined(self.syn_pack_weapon) && self.syn_pack_weapon == 1) {
		max_weapon_num = zm_utility::get_player_weapon_limit(self);
		saved_weapon = undefined;

		switch(weapon) {
			case "beacon":
			case "black_hole_bomb":
			case "bowie_knife":
			case "bowie_knife_widows_wine":
			case "bouncingbetty":
			case "bouncingbetty_devil":
			case "bouncingbetty_holly":
			case "castle_riotshield":
			case "cymbal_monkey":
			case "cymbal_monkey_upgraded":
			case "dragon_gauntlet_flamethrower":
			case "dragonshield":
			case "dragonshield_upgraded":
			case "frag_grenade":
			case "glaive_apothicon_0":
			case "glaive_keeper_0":
			case "hero_annihilator":
			case "hero_gravityspikes":
			case "hero_gravityspikes_melee":
			case "island_riotshield":
			case "launcher_dragon_strike":
			case "knife":
			case "knife_widows_wine":
			case "nesting_dolls":
			case "octobomb":
			case "octobomb_upgraded":
			case "quantum_bomb":
			case "sickle_knife":
			case "skull_gun":
			case "sticky_grenade_widows_wine":
			case "tomb_shield":
			case "zod_riotshield":
			case "zod_riotshield_upgraded":
				saved_weapon = self getCurrentWeapon();
				self takeWeapon(self getCurrentWeapon());
				break;
			default:
				if(self getWeaponsListPrimaries().size >= max_weapon_num) {
					self takeWeapon(self getCurrentWeapon());
				}
				break;
		}

		self zm_weapons::weapon_give(weapon, undefined, undefined, undefined, true);

		if(isDefined(saved_weapon)) {
			wait 0.5;
			self zm_weapons::weapon_give(saved_weapon, undefined, undefined, undefined, true);
			self switchToWeaponImmediate(saved_weapon);
			saved_weapon = undefined;
		}
	} else {
		self switchToWeaponImmediate(weapon);
	}

	self.syn_pack_weapon = 0;
	wait 0.5;
	self giveStartAmmo(weapon);
}

function take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[1]);
}

function drop_weapon() {
	self dropItem(self getCurrentWeapon());
}

function get_weapon_attachments() {
	weapon = self getCurrentWeapon().rootWeapon.name;

	if(isSubStr(weapon, "_upgraded")) {
		weapon = strtok2(weapon, "_upgraded")[0];
	}

	attachments = [];

	for(i = 0; i < tableLookupRowCount("gamedata/weapons/mp/mp_gunlevels.csv"); i++) {
		row = tableLookupRow("gamedata/weapons/mp/mp_gunlevels.csv", i);
		if(weapon == row[2]) {
			if(row[3] != "dw" && row[3] != "extclip" && row[3] != "damage") {
				attachments[attachments.size] = row[3];
			}
		}
	}

	return attachments;
}

function get_attachment_name(attachment) {
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
	return attachment;
}

function get_equipped_attachments(weapon) {
	attachments = [];
	equipped = strTok(weapon, "+");

	for (i = 1; i < equipped.size; i++) {
	  attachments[attachments.size] = equipped[i];
	}

	return attachments;
}

function equip_attachment(attachment) {
	weapon = self getCurrentWeapon();

	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);
	attachments = get_equipped_attachments(weapon.name);

	if(isArray(attachments)) {
		if(isInArray(attachments, attachment)) {
			attachments = remove_from_array(attachments, attachment);
		} else {
			if(isInArray(self.syn["optics"], attachment)) {
				foreach(optic in self.syn["optics"]) {
					if(isInArray(attachments, optic)) {
						attachments = remove_from_array(attachments, optic);
					}
				}
			}

			attachments[attachments.size] = attachment;
		}

		weapon = getWeapon(weapon.rootWeapon.name, attachments);
	}

	self takeWeapon(self getCurrentWeapon());

	if(isDefined(self.syn_saved_camo)) {
		self giveWeapon(weapon, self calcWeaponOptions(self.syn_saved_camo, 0, 0), 0);
	} else {
		self giveWeapon(weapon);
	}

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
	self setSpawnWeapon(weapon, true);
}

function equip_camo(camo_index) {
	self.syn_saved_camo = camo_index;
	weapon = self getCurrentWeapon();
	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);

	self takeWeapon(weapon);
	self giveWeapon(weapon, self calcWeaponOptions(camo_index, 0, 0), 0);

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
	self setSpawnWeapon(weapon, true);
}

function give_aat(value) {
	weapon = self getCurrentWeapon();
	self thread aat::acquire(weapon, value);
}

function take_aat() {
	weapon = self getCurrentWeapon();
	self thread aat::remove(weapon);
}

function get_ammo_cost() {
	weapon = self getCurrentWeapon();
	weapon_name = self getCurrentWeapon().rootWeapon.name;

	if(self zm_weapons::is_weapon_upgraded(weapon)) {
		ammo_cost = 4500;
	} else {
		weapon_cost = int(tablelookup("gamedata/weapons/zm/" + level.script + "_weapons.csv", 0, weapon_name, 3));
		if(weapon_cost == 50 || weapon_name == "pistol_standard") {
			weapon_cost = 500;
		} else if(weapon_cost == 5000 || weapon_cost == 10000 || weapon_cost == 0 || !isDefined(weapon_cost)) {
			weapon_cost = 1500;
		}

		ammo_cost = zm_utility::round_up_to_ten(int(weapon_cost * 0.5));
	}

	return ammo_cost + "";
}

function refill_ammo() {
	ammo_cost = int(get_ammo_cost());
	if(self zm_score::can_player_purchase(ammo_cost)) {
		weapon = self getCurrentWeapon();
		self setWeaponAmmoClip(weapon, 999);
		self giveMaxAmmo(weapon);
		take_points(ammo_cost);
	}
}

// Round Options

function set_round_increment(value) {
	self.syn_round_increment = value;
}

function set_round(value) {
	self thread zm_utility::zombie_goto_round(value);
	wait 1;
	zombie_utility::ai_calculate_health(value);
	wait 3;
	if(!isDefined(level.syn_zombie_run_speed)) {
		level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
		self zombie_utility::set_run_speed();
	}
}

function set_zombie_cap(value) {
	level.zombie_ai_limit = int(value);
}

function set_zombie_speed(speed) {
	self.syn_zombie_run_speed_loop = false;

	speed = toLower(speed);

	if(speed == "super sprint") {
		speed = "super_sprint";
	}

	if(!isDefined(level.run_cycle)) {
		level.run_cycle = "restore";
	}

	level.syn_zombie_run_speed = speed;
	level.run_cycle = speed;

	wait 0.25;

	if(level.run_cycle == "restore") {
		level.syn_zombie_run_speed = undefined;
		self thread update_zombie_speed_restore();
	} else {
		self.syn_zombie_run_speed_loop = true;
		self thread update_zombie_speed();
	}
}

function update_zombie_speed_restore() {
  if(level.round_number < 5) {
    level.run_cycle = "walk";
  } else {
    if(level.round_number < 10) {
      level.run_cycle = "run";
    } else {
      level.run_cycle = "sprint";
    }
  }

	foreach(zombie in get_zombies()) {
		zombie.syn_set_speed = undefined;
		zombie zombie_utility::set_zombie_run_cycle(level.run_cycle);
	}
}

function update_zombie_speed() {
	while(self.syn_zombie_run_speed_loop) {
		foreach(zombie in get_zombies()) {
			if(!isDefined(zombie.syn_set_speed) && (isDefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area)) {
				zombie.syn_set_speed = true;
				zombie zombie_utility::set_zombie_run_cycle(level.syn_zombie_run_speed);
			}
		}
		wait 0.5;
	}
}

function calculate_health(round_number) {
	zombie_health = level.zombie_vars["zombie_health_start"];

	for(i = 2; i <= round_number; i++) {
		if(round_number >= 10) {
			zombie_health = zombie_health + (int(zombie_health * level.zombie_vars["zombie_health_increase_multiplier"]));
		} else {
			if(round_number != 1) {
				zombie_health = int(zombie_health + level.zombie_vars["zombie_health_increase"]);
			}
		}
	}

	if(zombie_health < 0) {
		zombie_health = abs(zombie_health);
	}

	if(zombie_health > 11371108) {
		zombie_health = 11371108;
	}

	return zombie_health;
}

function reset_zombie_health_cap() {
	self notify("stop_zombie_health_cap");
	wait 0.75;

	level.zombie_health = calculate_health(zm::get_round_number());

	foreach(zombie in get_zombies()) {
		zombie.syn_set_health = undefined;
		zombie.maxHealth = level.zombie_health;
		if(zombie.health > zombie.maxHealth) {
			zombie.health = level.zombie_health;
		}
	}
}

function set_zombie_health_cap(round) {
	self notify("stop_zombie_health_cap");

	wait 0.5;

	health_cap = calculate_health(round);
	self thread zombie_health_cap_loop(round, health_cap);
}

function zombie_health_cap_loop(round, health_cap) {
	self endon("stop_zombie_health_cap");
	level endon("game_ended");

	for(;;) {
		foreach(zombie in get_zombies()) {
			if(!isDefined(zombie.syn_set_health) && zombie.maxHealth != health_cap && (zombie.maxHealth > health_cap || zombie.health > health_cap) && (isDefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area)) {
				zombie.syn_set_health = true;
				zombie.maxHealth = health_cap;
				if(zombie.health > zombie.maxHealth) {
					zombie.health = health_cap;
				}
			}
		}
		wait 0.5;
	}
}

// Zombie Options

function get_zombies() {
	return getAITeamArray(level.zombie_team);
}

function no_target() {
	self.syn_no_target = !return_toggle(self.syn_no_target);
	if(self.syn_no_target) {
		iPrintString("No Target [^2ON^7]");
		self zm_utility::increment_ignoreMe();
	} else {
		iPrintString("No Target [^1OFF^7]");
		self zm_utility::decrement_ignoreMe();
	}
}

function enable_hitmarkers() {
	self.syn_enable_hitmarkers = !return_toggle(self.syn_enable_hitmarkers);
	if(self.syn_enable_hitmarkers) {
		zm::register_zombie_damage_override_callback(&hitmarker);
		zm_spawner::register_zombie_death_event_callback(&kill_hitmarker);
	} else {
		arrayremovevalue(level.zombie_damage_override_callbacks, &hitmarker);
		arrayremovevalue(level.zombie_death_callbacks, &kill_hitmarker);
	}
}

function hitmarker(willbekilled, inflictor, attacker, damage, flags, meansofdeath, weapon, point, dir, hitloc, offsettime, damagefromunderneath, surfacenormal) {
	if(isDefined(attacker) && isPlayer(attacker)) {
		attacker thread damagefeedback::update_override("damage_feedback", "", undefined);
	}
}

function kill_hitmarker(attacker) {
	if(isDefined(attacker) && isPlayer(attacker)) {
		attacker thread damagefeedback::update_override("damage_feedback_glow_orange", "", undefined);
	}
}

function zombie_counter() {
	if(!isDefined(self.syn_zombie_counter)) {
		self.syn_zombie_counter = true;
		while(isDefined(self.syn_zombie_counter)) {
			count = (zombie_utility::get_current_zombie_count() + level.zombie_total) + level.zombie_respawns;
			if(!isDefined(self.syn["counter"])) {
				self.syn["counter"] = self create_text("Zombies Remaining: " + count, "default", 1.5, "TOP_LEFT", "TOPCENTER", 250, 0, (1, 1, 1), 1, 9999, false);
			} else {
				self.syn["counter"] set_text("Zombies Remaining: " + count);
			}
			wait 0.01;
		}
	} else {
		self.syn_zombie_counter = undefined;
		self.syn["counter"] destroy();
	}
}

function spawn_normal_zombie() {
	spawner = array::random(level.zombie_spawners);
	zombie = zombie_utility::spawn_zombie(spawner, spawner.targetName);
}

function spawn_panzer() {
	player_modifier = 1;
	switch (getPlayers().size) {
		case 1: {
			player_modifier = 1;
			break;
		}
		case 2: {
			player_modifier = 1.33;
			break;
		}
		case 3: {
			player_modifier = 1.66;
			break;
		}
		case 4: {
			player_modifier = 2;
			break;
		}
	}

	zombie_health = level.zombie_health / level.zombie_vars["zombie_health_start"];
	mechz_armor_health = int(player_modifier * (250 + (10 * zombie_health)));

	zombie = zombie_utility::spawn_zombie(level.mechz_spawners[0], "mechz");
	zombie.health = int(player_modifier * (level.mechz_base_health + (level.mechz_health_increase * zombie_health)));
	zombie.maxHealth = zombie.health;
	zombie.faceplate_health = int(player_modifier * (level.var_fa14536d + (level.var_1a5bb9d8 * zombie_health)));
	zombie.powercap_cover_health = int(player_modifier * (level.mechz_powercap_cover_health + (15 * zombie_health)));
	zombie.powercap_health = int(player_modifier * (level.mechz_powercap_health + (15 * zombie_health)));
	zombie.left_knee_armor_health = mechz_armor_health;
	zombie.right_knee_armor_health = mechz_armor_health;
	zombie.left_shoulder_armor_health = mechz_armor_health;
	zombie.right_shoulder_armor_health = mechz_armor_health;

	zombie forceTeleport(self.origin + anglesToForward(self.angles) * 300);
}

function spawn_zombie(spawner) {
	zombie = zombie_utility::spawn_zombie(spawner, spawner.targetName);
	zombie forceTeleport(self.origin + anglesToForward(self.angles) * 300);
}

function kill_all_zombies() {
	level.zombie_total = 0;
	foreach(zombie in get_zombies()) {
		zombie doDamage(abs(zombie.health) + 999, (0, 0, 0));
		wait 0.05;
	}
}

function teleport_zombies() {
	foreach(zombie in get_zombies()) {
		zombie forceTeleport(get_bullet_trace_position());
	}
}

function one_shot_zombies() {
	if(!isDefined(self.syn_one_shot_zombies)) {
		iPrintString("One Shot Zombies [^2ON^7]");
		self.syn_one_shot_zombies = true;
		zombies = get_zombies();
		level.prev_health = zombies[0].health;
		while(isDefined(self.syn_one_shot_zombies)) {
			foreach(zombie in get_zombies()) {
				zombie.maxHealth = 1;
				zombie.health = zombie.maxHealth;
			}
			wait 0.01;
		}
	} else {
		iPrintString("One Shot Zombies [^1OFF^7]");
		self.syn_one_shot_zombies = undefined;
		foreach(zombie in get_zombies()) {
			zombie.maxHealth = level.prev_health;
			zombie.health = level.prev_health;
		}
	}
}

function freeze_zombies() {
	if(!isDefined(self.syn_freeze_zombies)) {
		self.syn_freeze_zombies = true;
		while (isDefined(self.syn_freeze_zombies)) {
			foreach(zombie in get_zombies()) {
				if(isAlive(zombie) && !zombie isPaused()) {
					freeze_zombie(zombie);
				}
			}
			wait 0.1;
		}
		foreach(zombie in get_zombies()) {
			unfreeze_zombie(zombie);
		}
	} else {
		self.syn_freeze_zombies = undefined;
	}
}

function freeze_zombie(zombie) {
	zombie notify(#"hash_4e7f43fc");
	zombie thread freeze_zombie_death();
	zombie setEntityPaused(1);
	zombie.var_70a58794 = zombie.b_ignore_cleanup;
	zombie.b_ignore_cleanup = 1;
	zombie.var_7f7a0b19 = zombie.is_inert;
	zombie.is_inert = 1;
}

function freeze_zombie_death() {
	self endon(#"hash_4e7f43fc");
	self waittill("death");
	if(isDefined(self) && self isPaused()) {
		self setEntityPaused(0);
		if(!self isRagdoll()) {
			self startRagdoll();
		}
	}
}

function unfreeze_zombie(zombie) {
	zombie notify(#"hash_4e7f43fc");
	zombie setEntityPaused(0);
	if(isDefined(zombie.var_7f7a0b19)) {
		zombie.is_inert = zombie.var_7f7a0b19;
	}
	if(isDefined(zombie.var_70a58794)) {
		zombie.b_ignore_cleanup = zombie.var_70a58794;
	} else {
		zombie.b_ignore_cleanup = 0;
	}
}

function slow_zombies() {
	if(!isDefined(self.syn_slow_zombies)) {
		iPrintString("Slow Zombies [^2ON^7]");
		self.syn_slow_zombies = true;
		while(isDefined(self.syn_slow_zombies)) {
			foreach(zombie in get_zombies()) {
				zombie.b_widows_wine_slow = 1;
				zombie asmSetAnimationRate(0.7);
				zombie clientField::set("widows_wine_wrapping", 1);
			}
			wait 0.1;
		}
	} else {
		iPrintString("Slow Zombies [^1OFF^7]");
		self.syn_slow_zombies = undefined;
		foreach(zombie in get_zombies()) {
			zombie.b_widows_wine_slow = 0;
			zombie asmSetAnimationRate(1);
			zombie clientField::set("widows_wine_wrapping", 0);
		}
	}
}

function disable_spawns() {
	self.syn_disable_spawns = !return_toggle(self.syn_disable_spawns);
	if(self.syn_disable_spawns) {
		iPrintString("Disable Spawns [^2ON^7]");
		level flag::clear("spawn_zombies");
	} else {
		iPrintString("Disable Spawns [^1OFF^7]");
		level flag::set("spawn_zombies");
	}
}

function color_zombies(color) {
	if(color == "None") {
		value = 0;
	} else if(color == "Orange") {
		value = 1;
	} else if(color == "Green") {
		value = 2;
	} else if(color == "Purple") {
		value = 3;
	} else if(color == "Blue") {
		value = 4;
	}
	self thread clientField::set_to_player("eye_candy_render", value);
}