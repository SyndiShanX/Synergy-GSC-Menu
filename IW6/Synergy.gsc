#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
	if(is_aliens()) {
	  executeCommand("sv_cheats 1");

	  level thread player_connect();
	  level thread create_rainbow_color();

	  wait 0.5;

	  level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	  level.callbackPlayerDamage = ::player_damage_callback; // Retropack
	}
}

initial_variables() {
	self.in_menu = false;
	self.hud_created = false;
	self.loaded_offset = false;
	self.option_limit = 11;
	self.current_menu = "Synergy";
	self.structure = [];
	self.previous = [];
	self.saved_index = [];
	self.saved_offset = [];
	self.saved_trigger = [];
	self.slider = [];

	self.font = "default";
	self.font_scale = 0.7;
	self.x_offset = 175;
	self.y_offset = 140;

	self.color_theme = "rainbow";
	self.menu_color_red = 0;
	self.menu_color_green = 0;
	self.menu_color_blue = 0;

	self.cursor_index = 0;
	self.scrolling_offset = 0;
	self.previous_scrolling_offset = 0;
	self.description_height = 0;
	self.previous_option = undefined;

	self.point_increment = 100;
	self.map_name = get_map_name();
	self.outline_aliens = undefined;

	// Visions

	self.syn["visions"][0] = ["", "alien_feral", "near_death", "mp_alien_thermal_trinity", "coup_sunblind", "ac130_inverted", "aftermath", "aftermath_glow", "aftermath_post", "black_bw", "default", "default_night", "default_night_mp", "end_game", "missilecam", "mpintro", "mpoutro", "mpnuke", "mpnuke_aftermath", "nuke_global_flash"];
	self.syn["visions"][1] = ["None", "Feral Vision", "Near Death", "Thermal Trinity", "Sunblind", "AC-130 inverted", "Aftermath", "Aftermath Glow", "Aftermath Post", "Black Screen", "Default", "Default Night", "Night Vision", "Endgame", "Missile Cam", "MP Intro", "MP Outro", "MP Nuke", "MP Nuke Aftermath", "Nuke Flash"];

	self.syn["visions"]["nightfall"][0] = ["mp_alien_armory", "alien_feral_armory", "mp_alien_armory_interior", "mp_alien_armory_heavy", "mp_alien_armory_heavy_extra", "mp_alien_spore_plant"];
	self.syn["visions"]["nightfall"][1] = ["Nightfall Default", "Nightfall Feral Vision", "Nightfall Interior", "Nightfall Heavy", "Nightfall Heavy Extra", "Spore Plant"];

	self.syn["visions"]["mayday"][0] = ["mp_alien_spore_plant", "mp_alien_beacon", "alien_feral_beacon", "mp_alien_beacon_intro", "mp_alien_beacon_helipad", "mp_alien_beacon_cargo", "mp_alien_beacon_labs", "mp_alien_beacon_labgas"];
	self.syn["visions"]["mayday"][1] = ["Spore Plant", "Mayday Default", "Mayday Feral Vision", "Mayday Intro", "Mayday Helipad", "Mayday Cargo", "Mayday Labs", "Mayday Labs Gas"];

	self.syn["visions"]["awakening"][0] = ["mp_alien_spore_plant", "mp_alien_dlc3", "alien_feral_dlc3", "mp_alien_dlc3_intro", "mp_alien_dlc3_landing", "mp_alien_dlc3_caves", "mp_alien_dlc3_cliffs", "mp_alien_dlc3_ark"];
	self.syn["visions"]["awakening"][1] = ["Spore Plant", "Awakening Default", "Awakening Feral Vision", "Awakening Intro", "Awakening Landing", "Awakening Caves", "Awakening Cliffs", "Awakening ARK"];

	// Weapons

	self.syn["weapons"]["category"][0] = ["assault_rifles", "sub_machine_guns", "light_machine_guns", "marksman_rifles", "sniper_rifles", "shotguns", "launchers", "pistols", "equipment", "extras"];
	self.syn["weapons"]["category"][1] = ["Assault Rifles", "Sub Machine Guns", "Light Machine Guns", "Marksman Rifles", "Sniper Rifles", "Shotguns", "Launchers", "Pistols", "Equipment", "Extras"];

	self.syn["weapons"]["pistols"][0] =   ["iw5_alienm9a1_mp", "iw5_alienmp443_mp", "iw6_alienp226_mp", "iw6_alienmagnum_mp"];
	self.syn["weapons"]["equipment"][0] = ["aliensemtex_mp", "alienthrowingknife_mp", "alienmortar_shell_mp", "alienflare_mp", "alientrophy_mp", "alienclaymore_mp", "alienbetty_mp"];
	self.syn["weapons"]["extras"][0] =    ["iw5_alienriotshield_mp", "iw6_alienminigun_mp", "iw6_alienminigun4_mp"];

	self.syn["weapons"]["pistols"][1] =   ["M9A1", "MP-443 Grach", "P226", ".44 Magnum"];
	self.syn["weapons"]["equipment"][1] = ["Semtex Grenades", "Throwing Knife", "Canister Bomb", "Flare", "Trophy", "Claymore", "Bouncing Betty"];
	self.syn["weapons"]["extras"][1] =    ["Riot Shield", "Death Machine", "Death Incinerator"];

	// Point of Contact Weapons

	self.syn["weapons"]["assault_rifles"]["point_of_contact"][0] =   ["iw6_aliensc2010_mp", "iw6_alienbren_mp", "iw6_alienak12_mp", "iw6_alienhoneybadger_mp"];
	self.syn["weapons"]["sub_machine_guns"]["point_of_contact"][0] = ["iw6_alienpp19_mp", "iw6_aliencbjms_mp", "iw6_alienkriss_mp", "iw6_alienvepr_mp", "iw6_alienmicrotar_mp"];
	self.syn["weapons"]["marksman_rifles"]["point_of_contact"][0] =  ["iw6_alieng28_mp", "iw6_alienimbel_mp"];
	self.syn["weapons"]["sniper_rifles"]["point_of_contact"][0] =    ["iw6_alienl115a3_mp_alienl115a3scope", "iw6_alienvks_mp_alienvksscope"];
	self.syn["weapons"]["shotguns"]["point_of_contact"][0] =         ["iw6_alienmaul_mp", "iw6_alienfp6_mp", "iw6_alienmts255_mp"];
	self.syn["weapons"]["launchers"]["point_of_contact"][0] =        ["iw6_alienrgm_mp", "iw6_alienpanzerfaust3_mp", "iw6_alienmk32_mp", "iw6_alienmk324_mp"];
	self.syn["weapons"]["extras"]["point_of_contact"][0] =           ["aliensoflam_mp", "alienpropanetank_mp", "alienbomb_mp"];

	self.syn["weapons"]["assault_rifles"]["point_of_contact"][1] =   ["SC-2010", "SA-805", "AK-12", "Honey Badger"];
	self.syn["weapons"]["sub_machine_guns"]["point_of_contact"][1] = ["Bizon", "CBJ-MS", "Vector CRB", "Vepr", "MTAR-X"];
	self.syn["weapons"]["marksman_rifles"]["point_of_contact"][1] =  ["MR-28", "IA-2"];
	self.syn["weapons"]["sniper_rifles"]["point_of_contact"][1] =    ["L115", "VKS"];
	self.syn["weapons"]["shotguns"]["point_of_contact"][1] =         ["Bulldog", "FP6", "MTS-255"];
	self.syn["weapons"]["launchers"]["point_of_contact"][1] =        ["Kastet", "Panzerfaust", "MK32 Launcher", "MK32 Flame Rounds"];
	self.syn["weapons"]["extras"]["point_of_contact"][1] =           ["SOFLAM", "Propane Tank", "Laser Drill"];

	// Nightfall Weapons

	self.syn["weapons"]["assault_rifles"]["nightfall"][0] =     ["iw6_aliendlc13_mp", "iw6_aliendlc15_mp"];
	self.syn["weapons"]["sub_machine_guns"]["nightfall"][0] =   ["iw6_alienkriss_mp", "iw6_alienvepr_mp"];
	self.syn["weapons"]["light_machine_guns"]["nightfall"][0] = ["iw6_aliendlc12_mp", "iw5_alienkac_mp"];
	self.syn["weapons"]["marksman_rifles"]["nightfall"][0] =    ["iw6_alieng28_mp", "iw6_aliendlc14_mp"];
	self.syn["weapons"]["sniper_rifles"]["nightfall"][0] =      ["iw6_alienl115a3_mp_alienl115a3scope", "iw6_alienvks_mp_alienvksscope"];
	self.syn["weapons"]["shotguns"]["nightfall"][0] =           ["iw6_alienmaul_mp", "iw6_alienmts255_mp"];
	self.syn["weapons"]["launchers"]["nightfall"][0] =          ["iw6_alienrgm_mp", "iw6_alienmk32_mp", "iw6_alienmk324_mp"];
	self.syn["weapons"]["extras"]["nightfall"][0] =             ["aliensoflam_mp", "iw6_aliendlc11_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11sp_mp", "iw6_aliendlc31_mp", "iw6_aliendlc32_mp", "iw6_aliendlc33_mp", "alienbomb_mp"];

	self.syn["weapons"]["assault_rifles"]["nightfall"][1] =     ["ARX-160", "Maverick"];
	self.syn["weapons"]["sub_machine_guns"]["nightfall"][1] =   ["Vector CRB", "Vepr"];
	self.syn["weapons"]["light_machine_guns"]["nightfall"][1] = ["LSAT", "Chain SAW"];
	self.syn["weapons"]["marksman_rifles"]["nightfall"][1] =    ["MR-28", "SVU"];
	self.syn["weapons"]["sniper_rifles"]["nightfall"][1] =      ["L115", "VKS"];
	self.syn["weapons"]["shotguns"]["nightfall"][1] =           ["Bulldog", "MTS-255"];
	self.syn["weapons"]["launchers"]["nightfall"][1] =          ["Kastet", "MK32 Launcher", "MK32 Flame Rounds"];
	self.syn["weapons"]["extras"]["nightfall"][1] =             ["SOFLAM", "Venom-X", "Venom-LX", "Venom-FX", "Venom-SX", "Venom-X Grenade", "Venom-LX Grenade", "Venom-FX Grenade", "Laser Drill"];

	// Mayday Weapons

	self.syn["weapons"]["assault_rifles"]["mayday"][0] =     ["iw6_alienhoneybadger_mp", "iw6_altalienarx_mp"];
	self.syn["weapons"]["sub_machine_guns"]["mayday"][0] =   ["iw6_aliencbjms_mp", "iw6_alienmicrotar_mp", "iw6_arkaliendlc23_mp_dlcweap02scope"];
	self.syn["weapons"]["light_machine_guns"]["mayday"][0] = ["iw6_altalienlsat_mp", "iw6_alienkac_mp"];
	self.syn["weapons"]["marksman_rifles"]["mayday"][0] =    ["iw6_alieng28_mp", "iw6_altaliensvu_mp"];
	self.syn["weapons"]["sniper_rifles"]["mayday"][0] =      ["iw6_alienvks_mp_alienvksscope"];
	self.syn["weapons"]["shotguns"]["mayday"][0] =           ["iw6_alienmaul_mp", "iw6_alienfp6_mp"];
	self.syn["weapons"]["launchers"]["mayday"][0] =          ["iw6_alienrgm_mp", "iw6_alienpanzerfaust3_mp", "iw6_alienmaaws_mp", "iw6_alienmk32_mp", "iw6_alienmk324_mp"];
	self.syn["weapons"]["extras"]["mayday"][0] =             ["iw6_aliendlc11_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11sp_mp", "alienbomb_mp"];

	self.syn["weapons"]["assault_rifles"]["mayday"][1] =     ["Honey Badger", "ARX-160"];
	self.syn["weapons"]["sub_machine_guns"]["mayday"][1] =   ["CBJ-MS", "MTAR-X", "Ripper"];
	self.syn["weapons"]["light_machine_guns"]["mayday"][1] = ["LSAT", "Chain SAW"];
	self.syn["weapons"]["marksman_rifles"]["mayday"][1] =    ["MR-28", "SVU"];
	self.syn["weapons"]["sniper_rifles"]["mayday"][1] =      ["VKS"];
	self.syn["weapons"]["shotguns"]["mayday"][1] =           ["Bulldog", "FP6"];
	self.syn["weapons"]["launchers"]["mayday"][1] =          ["Kastet", "Panzerfaust", "MAAWS", "MK32 Launcher", "MK32 Flame Rounds"];
	self.syn["weapons"]["extras"]["mayday"][1] =             ["Venom-X", "Venom-LX", "Venom-FX", "Venom-SX", "Laser Drill"];

	// Awakening/Exodus Weapons

	self.syn["weapons"]["assault_rifles"]["ark"][0] =     ["iw6_arkalienr5rgp_mp", "iw6_arkaliendlc15_mp"];
	self.syn["weapons"]["sub_machine_guns"]["ark"][0] =   ["iw6_arkalienk7_mp", "iw6_arkaliendlc23_mp_dlcweap02scope"];
	self.syn["weapons"]["light_machine_guns"]["ark"][0] = ["iw6_arkalienameli_mp", "iw6_arkalienkac_mp"];
	self.syn["weapons"]["marksman_rifles"]["ark"][0] =    ["iw6_arkalienimbel_mp", "iw6_arkalienmk14_mp"];
	self.syn["weapons"]["sniper_rifles"]["ark"][0] =      ["iw6_arkalienvks_mp_alienvksscope", "iw6_arkalienusr_mp_usrscope"];
	self.syn["weapons"]["shotguns"]["ark"][0] =           ["iw6_arkalienmaul_mp", "iw6_arkalienuts15_mp"];
	self.syn["weapons"]["launchers"]["ark"][0] =          ["iw6_alienrgm_mp", "iw6_alienmaaws_mp", "iw6_alienmk32_mp", "iw6_alienmk324_mp"];

	self.syn["weapons"]["assault_rifles"]["ark"][1] =     ["Remington R5", "Maverick"];
	self.syn["weapons"]["sub_machine_guns"]["ark"][1] =   ["K7", "Ripper"];
	self.syn["weapons"]["light_machine_guns"]["ark"][1] = ["Ameli", "Chain SAW"];
	self.syn["weapons"]["marksman_rifles"]["ark"][1] =    ["IA-2", "MK14 EBR"];
	self.syn["weapons"]["sniper_rifles"]["ark"][1] =      ["VKS", "USR"];
	self.syn["weapons"]["shotguns"]["ark"][1] =           ["Bulldog", "Tac 12"];
	self.syn["weapons"]["launchers"]["ark"][1] =          ["Kastet", "MAAWS", "MK32 Launcher", "MK32 Flame Rounds"];

	// Awakening Weapons

	self.syn["weapons"]["extras"]["awakening"][0] = ["aliensoflam_mp", "iw6_aliendlc21_mp", "iw6_aliendlc22_mp", "aliencortex_mp", "iw6_aliendlc11_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11sp_mp", "iw6_aliendlc31_mp", "iw6_aliendlc32_mp", "iw6_aliendlc33_mp", "alienbomb_mp"];
	self.syn["weapons"]["extras"]["awakening"][1] = ["SOFLAM", "Sticky Flare", "Pipe Bomb", "Cortex", "Venom-X", "Venom-LX", "Venom-FX", "Venom-SX", "Venom-X Grenade", "Venom-LX Grenade", "Venom-FX Grenade", "Laser Drill"];

	// Exodus Weapons

	self.syn["weapons"]["extras"]["exodus"][0] = ["aliensoflam_mp", "iw6_aliendlc21_mp", "iw6_aliendlc22_mp", "iw6_aliendlc41_mp", "iw6_aliendlc43_mp", "iw6_aliendlc31_mp", "iw6_aliendlc32_mp", "iw6_aliendlc33_mp"];
	self.syn["weapons"]["extras"]["exodus"][1] = ["SOFLAM", "Sticky Flare", "Pipe Bomb", "NX-1 Disruptor", "NX-1 Grenade", "Venom-X Grenade", "Venom-LX Grenade", "Venom-FX Grenade"];

	self.syn["weapons"]["test"][0] = ["iw5_alienriotshield_mp", "iw5_alienriotshield1_mp", "iw5_alienriotshield2_mp", "iw5_alienriotshield3_mp", "iw5_alienriotshield4_mp", "iw6_alienmagnum_mp", "iw5_alienm9a1_mp", "iw6_alienp226_mp", "iw6_alienkriss_mp", "iw6_alienpp19_mp", "iw6_alienvepr_mp", "iw6_alienmicrotar_mp", "iw6_aliencbjms_mp", "iw6_alienbren_mp", "iw6_alienak12_mp", "iw6_alienhoneybadger_mp", "iw6_alienminigun_mp", "iw6_alienminigun1_mp", "iw6_alienminigun2_mp", "iw6_alienminigun3_mp", "iw6_alienminigun4_mp", "iw6_alienmk32_mp", "iw6_alienmk321_mp", "iw6_alienmk322_mp", "iw6_alienmk323_mp", "iw6_alienmk324_mp", "iw6_alienrgm_mp", "iw6_alienpanzerfaust3_mp", "iw6_alienmaaws_mp", "iw6_alienvks_mp", "iw6_alienl115a3_mp", "iw6_alienimbel_mp", "iw6_alieng28_mp", "iw6_alienmts255_mp", "iw6_alienfp6_mp", "iw6_alienmaul_mp", "iw6_alienDLC11_mp", "iw6_aliendlc13_mp", "iw6_aliendlc12_mp", "iw6_aliendlc14_mp", "iw6_aliendlc15_mp", "iw6_altalienarx_mp", "iw6_altalienlsat_mp", "iw6_altaliensvu_mp", "iw6_altalienmaverick_mp", "iw6_aliendlc23_mp", "iw6_alienm27_mp", "alienaxe_mp_mp", "alien_bomb_mp_mp", "aliensoflam_mp_mp", "iw6_alienmp443_mp", "iw6_alienkac_mp", "iw5_alienmagnum_mp", "iw5_alienm9a1_mp", "iw5_alienp226_mp", "iw5_alienmp443_mp", "iw6_aliendlc11fi_mp", "iw6_aliendlc11li_mp", "iw6_aliendlc11sp_mp", "iw6_arkaliendlc15_mp", "iw6_arkalienimbel_mp", "iw6_arkalienkac_mp", "iw6_arkaliendlc23_mp", "iw6_arkalienmaul_mp", "iw6_arkalienvks_mp", "iw6_arkalienusr_mp", "iw6_arkalienr5rgp_mp", "iw6_arkalienk7_mp", "iw6_arkalienuts15_mp", "iw6_arkalienmk14_mp", "iw6_arkalienameli_mp", "iw6_aliendlc41_mp"];
	self.syn["weapons"]["test"][1] = ["Riot Shield", "Riot Shield", "Riot Shield", "Riot Shield", "Riot Shield", ".44 Magnum", "M9A1", "P226", "Vector CRB", "Bizon", "Vepr", "MTAR-X", "CBJ-MS", "SA-805", "AK-12", "Honey Badger", "Death Machine", "Death Machine", "Death Machine", "Death Incinerator", "Death Incinerator", "MK32 Launcher", "MK32 Launcher", "MK32 Launcher", "MK32 Launcher", "MK32 Flame Rounds", "Kastet", "Panzerfaust", "MAAWS", "VKS", "L115", "IA-2", "MR-28", "MTS-255", "FP6", "Bulldog", "Venom-X", "ARX-160", "LSAT", "SVU", "Maverick", "ARX-160", "LSAT", "SVU", "Maverick", "Ripper", "M27", "Axe", "Laser Drill", "SOFLAM", "MP-443 Grach", "Chain SAW", ".44 Magnum", "M9A1", "P226", "MP-443 Grach", "Venom-FX", "Venom-LX", "Venom-SX", "Maverick", "IA-2", "Chain SAW", "Ripper", "Bulldog", "VKS", "USR", "Remington R5", "K7", "Tac 12", "MK14 EBR", "Ameli", "NX-1 Disruptor"];

	// Bullets

	self.syn["bullets"]["point_of_contact"][0] = ["alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp"];
	self.syn["bullets"]["point_of_contact"][1] = ["Vulture Rocket", "Soflam Missile", "Alien Spit", "Alien Spit Gas"];

	self.syn["bullets"]["nightfall"][0] = ["alienvulture_mp", "aliensoflam_missle_mp", "spider_gas_mp"];
	self.syn["bullets"]["nightfall"][1] = ["Vulture Rocket", "Soflam Missile", "Spider Gas"];

	self.syn["bullets"]["mayday"][0] = ["alienvulture_mp", "Alien Spit", "seeder_spit_mp"];
	self.syn["bullets"]["mayday"][1] = ["Vulture Rocket", "Alien Spit", "Seeder Spit"];

	self.syn["bullets"]["awakening"][0] = ["alienvulture_mp", "aliensoflam_missle_mp", "alienspit_mp", "alienspit_gas_mp", "alienvanguard_projectile_mp", "alienvanguard_projectile_mini_mp"];
	self.syn["bullets"]["awakening"][1] = ["Vulture Rocket", "Soflam Missile", "Alien Spit", "Alien Spit Gas", "Vanguard Projectile", "Vanguard Mini Projectile"];

	self.syn["bullets"]["exodus"][0] = ["alienvulture_mp", "aliensoflam_missle_mp", "alienspit_gas_mp", "iw6_aliendlc42_mp", "alien_ancestor_mp"];
	self.syn["bullets"]["exodus"][1] = ["Vulture Rocket", "Soflam Missile", "Alien Spit Gas", "NX-1 Projectile", "Ancestor Projectile"];
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
	          self.introscreen_overlay destroy();

	          self thread input_manager();

	          self.menu["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset - 1), (self.y_offset - 1), 226, 122, self.color_theme, 1, 1);
	          self.menu["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, self.y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
	          self.menu["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
	          self.menu["separator_1"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 5.5), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	          self.menu["separator_2"] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 220), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	          self.menu["cursor"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, 215, 224, 16, (0.15, 0.15, 0.15), 0, 4);

	          self.menu["title"] = self create_text("Synergy", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 94.5), (self.y_offset + 3), (1, 1, 1), 1, 10);
	          self.menu["description"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + (self.option_limit * 17.5)), (0.75, 0.75, 0.75), 0, 10);

	          self.menu["options"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + 19), (0.75, 0.75, 0.75), 1, 10);
	          self.menu["submenu_icons"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 215), ((self.y_offset + 19)), (0.75, 0.75, 0.75), 0, 10);
	          self.menu["slider_texts"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), (self.y_offset + 19), (0.75, 0.75, 0.75), 0, 10);

	          for(i = 1; i <= self.option_limit; i++) {
	            self.menu["toggle_" + i] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 11), ((self.y_offset + 4) + (i * 16.5)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
	            self.menu["slider"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset + (i * 16.5)), 224, 16, (0.25, 0.25, 0.25), 0, 5);
	          }

	          self.hud_created = true;

	          self.menu["title"] set_text("Controls");

	          self.menu["options"] set_text("Open: ^3[{+speed_throw}] ^7and ^3[{+melee}]\n\n^7Scroll: ^3[{+speed_throw}] ^7and ^3[{+attack}]\n\n^7Select: ^3[{+activate}] ^7Back: ^3[{+melee}]\n\n^7Sliders: ^3[{+smoke}] ^7and ^3[{+frag}]");

	          self.menu["border"] set_shader("white", self.menu["border"].width, 83);
	          self.menu["background"] set_shader("white", self.menu["background"].width, 81);
	          self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 66);

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

	      if(isDefined(self.previous[(self.previous.size - 1)])) {
	        self new_menu();
	      } else {
	        self close_menu();
	      }

	      while(self meleeButtonPressed()) {
	        wait 0.2;
	      }
	    } else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {

	      scroll_cursor(set_variable(self attackButtonPressed(), "down", "up"));

	      wait (0.2);
	    } else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {

	      if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
	        scroll_slider(set_variable(self secondaryOffhandButtonPressed(), "left", "right"));
	      }

	      wait (0.2);
	    } else if(self useButtonPressed()) {
	      self.saved_index[self.current_menu] = self.cursor_index;
	      self.saved_offset[self.current_menu] = self.scrolling_offset;
	      self.saved_trigger[self.current_menu] = self.previous_trigger;

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
	  self.menu["description"].alpha = opacity;
	  for(i = 1; i <= self.option_limit; i++) {
	    self.menu["toggle_" + i].alpha = opacity;
	    self.menu["slider"].alpha = opacity;
	  }
	}

	self.menu["title"].alpha = opacity;
	self.menu["separator_1"].alpha = opacity;
	self.menu["separator_2"].alpha = opacity;

	self.menu["options"].alpha = opacity;
	self.menu["submenu_icons"].alpha = opacity;
	self.menu["slider_texts"].alpha = opacity;

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
	  if(isNumber(text)) {
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

	self clearAllTextAfterHudElem();

	self.text = text;
	if(isNumber(text)) {
	  self setValue(text);
	} else {
	  self setText(text);
	}
}

add_text(text, index) {
	if(!isDefined(self) || !isDefined(text)) {
	  return;
	}

	self.text = text;
	self.text_array[index] = text + "\n\n";
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

	self clearAllTextAfterHudElem();

	if(text != self.previous_text) {
	  self.previous_text = text;
	  self setText(text);
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

	self.menu["description"].y = (self.y_offset + (self.option_limit * 17.5));

	self.menu["options"].x = (self.x_offset + 5);
	self.menu["options"].y = (self.y_offset + 19);

	self.menu["submenu_icons"].x = (self.x_offset + 215);
	self.menu["submenu_icons"].y = (self.y_offset + 19);

	self.menu["slider_texts"].x = (self.x_offset + 132.5);
	self.menu["slider_texts"].y = (self.y_offset + 19);

	for(i = 1; i <= self.option_limit; i++) {
	  self.menu["toggle_" + i].x = (self.x_offset + 11);
	  self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 16.5));

	  self.menu["slider"].x = self.x_offset;
	  self.menu["slider"].y = (self.y_offset + (i * 16.5));
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
	if(level.script == "mp_alien_town") return "point_of_contact";
	if(level.script == "mp_alien_armory") return "nightfall";
	if(level.script == "mp_alien_beacon") return "mayday";
	if(level.script == "mp_alien_dlc3") return "awakening";
	if(level.script == "mp_alien_last") return "exodus";
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

isNumber(value) {
	return !isString(value);
}

load_weapons(weapon_category) {
	map = self.map_name;

	if(map == "awakening" || map == "exodus") {
	  map = "ark";
	}

	for(i = 0; i < self.syn["weapons"][weapon_category][map][0].size; i++) {
	  self add_option(self.syn["weapons"][weapon_category][map][1][i], undefined, ::give_weapon, self.syn["weapons"][weapon_category][map][0][i]);
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

	self.menu["title"].x = (self.x_offset + ceil((((-0.000014 * title_width + 0.003832) * title_width - 0.52) * title_width + 110.258) * 10) / 10);
	self.menu["title"].y = (self.y_offset + 3);

	self.current_title = title;
	self.current_title_x = self.menu["title"].x;
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
	  self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 16.5));
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
	  self.menu["cursor"].y = int(self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 16.5));
	}

	if(isDefined(self.structure[self.cursor_index]) && isDefined(self.structure[self.cursor_index].description)) {
	  self.menu["description"] set_text(self.structure[self.cursor_index].description);

	  self.current_description = self.structure[self.cursor_index].description;

	  self.description_height = 15;

	  self.menu["description"].x = (self.x_offset + 5);
	  self.menu["description"].alpha = 1;
	} else {
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
	  self.menu["slider"].alpha = 0;

	  self.menu["options"] add_text("", i);
	  self.menu["submenu_icons"] add_text("", i);
	  self.menu["slider_texts"] add_text("", i);
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

	      self.menu["slider_texts"] add_text(slider_text, i);
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
	      self.menu["slider_texts"] add_text(slider_value, i);
	      self.menu["slider"].alpha = 1;
	    }

	    if(isDefined(self.structure[x].command) && self.structure[x].command == ::new_menu) {
	      self.menu["submenu_icons"] add_text(">", i);
	    }
	  }
	}

	self.menu["options"] set_text_array();
	self.menu["submenu_icons"] set_text_array();
	self.menu["slider_texts"] set_text_array();

	menu_height = int(18 + (self.maximum * 16.5));

	self.menu["description"].y = int((self.y_offset + 4) + ((self.maximum + 1) * 16.5));

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
	    self add_option("Alien Options", undefined, ::new_menu, "Alien Options");
	    self add_option("Menu Options", undefined, ::new_menu, "Menu Options");
	    self add_option("Account Options", undefined, ::new_menu, "Account Options");
	    self add_option("All Players", undefined, ::new_menu, "All Players");

	    break;
	  case "Basic Options":
	    self add_menu(menu);

	    self add_toggle("    God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
	    self add_toggle("    Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);
	    self add_toggle("    Infinite Ammo", "Gives you Infinite Ammo and Infinite Grenades", ::infinite_ammo, self.infinite_ammo);

	    self add_increment("Set Points", undefined, ::set_points, 500, 0, 100000, 500);
	    self add_increment("Set Max Points", undefined, ::set_max_points, 500, 0, 100000, 500);
	    self add_increment("Give Skill Points", undefined, ::give_skill_points, 1, 1, 36, 1);

	    break;
	  case "Weapon Options":
	    self add_menu(menu);

	    self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");

	    self add_option("Take Current Weapon", undefined, ::take_weapon);
	    self add_option("Drop Current Weapon", undefined, ::drop_weapon);

	    self add_option("Magic Bullets", undefined, ::new_menu, "Magic Bullets");

	    break;
	  case "Fun Options":
	    self add_menu(menu);

	    self add_toggle("    Fullbright", "Removes all Shadows and Lighting", ::fullbright, self.fullbright);
	    self add_toggle("    Third Person", undefined, ::third_person, self.third_person);
	    self add_toggle("    LOL Easter Egg", undefined, ::lol_easter_egg, self.lol_easter_egg);

	    self add_option("Visions", undefined, ::new_menu, "Visions");

	    break;
	  case "Alien Options":
	    self add_menu(menu);

	    self add_toggle("    No Target", "Aliens won't Target You", ::no_target, self.no_target);

	    self add_option("Spawn Aliens", undefined, ::new_menu, "Spawn Aliens");
	    self add_option("Kill All Aliens", undefined, ::kill_all_aliens);
	    self add_option("Teleport Aliens to Me", undefined, ::teleport_aliens);

	    self add_toggle("    One Shot Aliens", undefined, ::one_shot_aliens, self.one_shot_aliens);
	    self add_toggle("    Freeze Aliens", undefined, ::freeze_aliens, self.freeze_aliens);
	    self add_toggle("    Disable Alien Spawns", undefined, ::aliens_spawn, self.aliens_spawn);

	    self add_array("Alien ESP", "Set Colored Outlines around Aliens", ::set_outline_color, ["None", "White", "Red", "Green", "Aqua", "Orange", "Yellow"], true);

	    break;
	  case "Account Options":
	    self add_menu(menu);

	    self add_increment("Set Prestige", undefined, ::set_prestige, 0, 0, 25, 1);
	    self add_increment("Set Level", undefined, ::set_rank, 1, 1, 31, 1);
	    self add_increment("Set XP Scale", undefined, ::set_xp_scale, 1, 1, 10, 1);

	    self add_increment("Give Teeth", undefined, ::give_teeth, 1, 1, 100, 1);
	    self add_option("Collect Eggs", undefined, ::collect_eggs);
	    self add_option("Unlock Intel", undefined, ::unlock_intel);

	    break;
	  case "Menu Options":
	    self add_menu(menu);

	    self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 20, 10, "x");
	    self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -150, 50, 10, "y");

	    self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

	    self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
	    self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
	    self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

	    self add_toggle("    Hide UI", undefined, ::hide_ui, self.hide_ui);
	    self add_toggle("    Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

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

	      if(!target isHost()) {
	        self add_option("Kick", "Kick the Player from the Game", ::kick_player, target);
	      }
	    } else {
	      self add_option("Player not found");
	    }

	    break;
	  case "Magic Bullets":
	    self add_menu(menu);

	    map = self.map_name;

	    for(i = 0; i < self.syn["bullets"][map][0].size; i++) {
	      self add_toggle(self.syn["bullets"][map][1][i], undefined, ::modify_bullet, self.bullet[i], self.syn["bullets"][map][0][i], i);
	    }

	    break;
	  case "Give Weapons":
	    self add_menu(menu);

	    map = self.map_name;

	    if(map == "awakening" || map == "exodus") {
	      map = "ark";
	    }

	    for(i = 0; i < self.syn["weapons"]["category"][0].size - 3; i++) {
	      if(isDefined(self.syn["weapons"][self.syn["weapons"]["category"][0][i]][map][0])) {
	        self add_option(self.syn["weapons"]["category"][1][i], undefined, ::new_menu, self.syn["weapons"]["category"][1][i]);
	      }
	    }

	    for(i = 7; i < self.syn["weapons"]["category"][0].size; i++) {
	      self add_option(self.syn["weapons"]["category"][1][i], undefined, ::new_menu, self.syn["weapons"]["category"][1][i]);
	    }

	    break;
	  case "Visions":
	    self add_menu(menu);

	    for(i = 0; i < self.syn["visions"][0].size; i++) {
	      self add_option(self.syn["visions"][1][i], undefined, ::set_vision, self.syn["visions"][0][i]);
	    }

	    map = self.map_name;

	    if(map == "point_of_contact") {
	      self add_option("Point of Contact Default", undefined, ::set_vision, "mp_alien_town");
	      self add_option("Nuke", undefined, ::set_vision, "alien_nuke");
	      self add_option("Nuke Blast", undefined, ::set_vision, "alien_nuke_blast");
	    }

	    if(map == "nightfall" || map == "mayday" || map == "awakening") {
	      for(i = 0; i < self.syn["visions"][map][0].size; i++) {
	        self add_option(self.syn["visions"][map][1][i], undefined, ::set_vision, self.syn["visions"][map][0][i]);
	      }
	    }

	    break;
	  case "Spawn Aliens":
	    self add_menu(menu);

	    map = self.map_name;

	    self add_option("Spawn Scout", undefined, ::spawn_alien, "goon");
	    self add_option("Spawn Seeker", undefined, ::spawn_alien, "minion");
	    self add_option("Spawn Leper", undefined, ::spawn_alien, "leper");
	    self add_option("Spawn Hunter", undefined, ::spawn_alien, "brute");
	    self add_option("Spawn Rhino", undefined, ::spawn_alien, "elite");

	    if(map != "mayday") {
	      self add_option("Spawn Scorpion", undefined, ::spawn_alien, "spitter");
	    }

	    if(map == "nightfall" || map == "awakening" || map == "exodus") {
	      self add_option("Spawn Locust", undefined, ::spawn_alien, "locust");
	    }

	    if(map == "mayday") {
	      self add_option("Spawn Seeder", undefined, ::spawn_alien, "seeder");
	    }

	    if(map == "awakening" || map == "exodus") {
	      self add_option("Spawn Bomber", undefined, ::spawn_alien, "bomber");
	      self add_option("Spawn Gargoyle", undefined, ::spawn_alien, "gargoyle");
	      self add_option("Spawn Mammoth", undefined, ::spawn_alien, "mammoth");
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
	  case "Marksman Rifles":
	    self add_menu(menu);

	    load_weapons("marksman_rifles");

	    break;
	  case "Sniper Rifles":
	    self add_menu(menu);

	    load_weapons("sniper_rifles");

	    break;
	  case "Shotguns":
	    self add_menu(menu);

	    load_weapons("shotguns");

	    break;
	  case "Launchers":
	    self add_menu(menu);

	    load_weapons("launchers");

	    break;
	  case "Pistols":
	    self add_menu(menu);

	    for(i = 0; i < self.syn["weapons"]["pistols"][0].size; i++) {
	      self add_option(self.syn["weapons"]["pistols"][1][i], undefined, ::give_weapon, self.syn["weapons"]["pistols"][0][i]);
	    }

	    break;
	  case "Equipment":
	    self add_menu(menu);

	    for(i = 0; i < self.syn["weapons"]["equipment"][0].size; i++) {
	      self add_option(self.syn["weapons"]["equipment"][1][i], undefined, ::give_weapon, self.syn["weapons"]["equipment"][0][i]);
	    }

	    break;
	  case "Extras":
	    self add_menu(menu);

	    for(i = 0; i < self.syn["weapons"]["extras"][0].size; i++) {
	      self add_option(self.syn["weapons"]["extras"][1][i], undefined, ::give_weapon, self.syn["weapons"]["extras"][0][i]);
	    }

	    map = self.map_name;

	    for(i = 0; i < self.syn["weapons"]["extras"][map][0].size; i++) {
	      self add_option(self.syn["weapons"]["extras"][map][1][i], undefined, ::give_weapon, self.syn["weapons"]["extras"][map][0][i]);
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
	  iPrintln("God Mode [^2ON^7]");
	} else {
	  iPrintln("God Mode [^1OFF^7]");
	}
}

frag_no_clip() {
	self endon("disconnect");
	self endon("game_ended");

	if(!isDefined(self.frag_no_clip)) {
	  self.frag_no_clip = true;
	  iPrintln("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
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
	  iPrintln("Frag No Clip [^1OFF^7]");
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
	  iPrintln("Infinite Ammo [^2ON^7]");
	  self thread infinite_ammo_loop();
	} else {
	  iPrintln("Infinite Ammo [^1OFF^7]");
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
	self setCoopPlayerData("alienSession", "currency", value);
	maps\mp\alien\_persistence::eog_player_update_stat("currency", value, 1);
}

set_max_points(value) {
	self setClientOmnvar("ui_alien_max_currency", value);
	self.maxCurrency = value;
}

give_skill_points(value) {
	self maps\mp\alien\_persistence::give_player_points(int(value));
}

// Fun Options

fullbright() {
	self.fullbright = !return_toggle(self.fullbright);
	if(self.fullbright) {
	  iPrintln("Fullbright [^2ON^7]");
	  setDvar("r_fullbright", 1);
	  wait 0.01;
	} else {
	  iPrintln("Fullbright [^1OFF^7]");
	  setDvar("r_fullbright", 0);
	  wait 0.01;
	}
}

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
	  iPrintln("Third Person [^2ON^7]");
	  setDvar("camera_thirdPerson", 1);
	} else {
	  iPrintln("Third Person [^1OFF^7]");
	  setDvar("camera_thirdPerson", 0);
	}
}

lol_easter_egg() {
	map = self.map_name;
	if(map == "nightfall") {
	  level._effect["arcade_death"] = loadfx("vfx/moments/alien/vfx_alien_arcade_death_dlc1");
	} else if (map == "mayday") {
	  level._effect["arcade_death"] = loadfx("vfx/gameplay/alien/vfx_alien_krak_emp_edge");
	} else if (map == "awakening") {
	  level._effect["arcade_death"] = loadfx("vfx/moments/alien/vfx_alien_arcade_death_dlc2");
	}
	self.lol_easter_egg = !return_toggle(self.lol_easter_egg);
	if(self.lol_easter_egg) {
	  iPrintln("^5L^6O^5L ^7[^2ON^7]");
	  level.easter_egg_lodge_sign_active = true;
	} else {
	  iPrintln("^5L^6O^5L ^7[^1OFF^7]");
	  level.easter_egg_lodge_sign_active = false;
	}
}

set_vision(vision) {
	self visionSetNakedForPlayer("", 0.1);
	wait 0.25;
	self visionSetNakedForPlayer(vision, 0.1);
}

commit_suicide(target) {
	target suicide();
}

kick_player(target) {
	kick(target getEntityNumber());
}

print_player_name(target) {
	iPrintln(target);
}

// Weapon Options

give_weapon(weapon) {
	if(self getCurrentWeapon() != weapon && self getWeaponsListPrimaries()[1] != weapon && self getWeaponsListPrimaries()[2] != weapon && self getWeaponsListPrimaries()[3] != weapon && self getWeaponsListPrimaries()[4] != weapon) {
	  max_weapon_num = 3;
	  if(self getWeaponsListPrimaries().size >= max_weapon_num) {
	    self takeWeapon(self getCurrentWeapon());
	  }

	  self giveWeapon(weapon);
	  self switchToWeapon(weapon);
	} else {
	  self switchToWeaponImmediate(weapon);
	}
	wait 1;
	self setWeaponAmmoClip(self getCurrentWeapon(), 999);
	self setWeaponAmmoClip(self getCurrentWeapon(), 999, "left");
	self setWeaponAmmoClip(self getCurrentWeapon(), 999, "right");
}

take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

modify_bullet(bullet, i) {
	self.bullet[i] = !return_toggle(self.bullet[i]);
	if(self.bullet[i]) {
	  iPrintln(self.syn["bullets"][1][i] + " [^2ON^7]");
	  self thread modify_bullet_loop(bullet);
	} else {
	  iPrintln(self.syn["bullets"][1][i] + " [^1OFF^7]");
	  self notify("stop_modify_bullet_loop");
	}
}

modify_bullet_loop(bullet) {
	self endon("stop_modify_bullet_loop");
	self endon("disconnect");

	for(;;) {
	  self waittill("weapon_fired");

	  start = self getEye();
	  end = start + anglesToForward(self getPlayerAngles()) * 9999;

	  magicBullet(bullet, start, bulletTrace(start, end, false, undefined)["position"], self);
	}
}

// Zombie Options

no_target() {
	self.no_target = !return_toggle(self.no_target);
	if(self.no_target) {
	  iPrintln("No Target [^2ON^7]");
	  self.ignoreme = 1;
	} else {
	  iPrintln("No Target [^1OFF^7]");
	  self.ignoreme = 0;
	}
}

set_round(value) {
	level.wave_num = value;
}

get_aliens() {
	return maps\mp\alien\_spawnlogic::get_alive_enemies();
}

spawn_alien(archetype) {
	team = "axis";
	maps\mp\alien\_spawn_director::spawn_alien(archetype);
}

kill_all_aliens() {
	foreach(alien in get_aliens()) {
	  alien doDamage(alien.health + 999, alien.origin);
	}
}

teleport_aliens() {
	foreach(alien in get_aliens()) {
	  alien setOrigin(self.origin + anglesToForward(self.angles) * 200);
	}
}

one_shot_aliens() {
	if(!isDefined(self.one_shot_aliens)) {
	  iPrintln("One Shot Aliens [^2ON^7]");
	  self.one_shot_aliens = true;
	  aliens = get_aliens();
	  level.prevHealth = aliens[0].health;
	  while(isDefined(self.one_shot_aliens)) {
	    foreach(alien in get_aliens()) {
	      alien.maxHealth = 1;
	      alien.health = alien.maxHealth;
	    }
	    wait 0.01;
	  }
	} else {
	  iPrintln("One Shot Aliens [^1OFF^7]");
	  self.one_shot_aliens = undefined;
	  foreach(alien in get_aliens()) {
	    alien.maxHealth = level.prevHealth;
	    alien.health = level.prevHealth;
	  }
	}
}

freeze_aliens() {
	if(!isDefined(self.freeze_aliens)) {
	  iPrintln("Freeze Aliens [^2ON^7]");
	  self.freeze_aliens = true;
	  while(isDefined(self.freeze_aliens)) {
	    foreach(alien in get_aliens()) {
	      alien freezeControls(true);
	    }
	    wait 0.01;
	  }
	} else {
	  iPrintln("Freeze Aliens [^1OFF^7]");
	  self.freeze_aliens = undefined;
	  foreach(alien in get_aliens()) {
	    alien freezeControls(false);
	  }
	}
}

aliens_spawn() {
	if(!isDefined(self.aliens_spawn)) {
	  iPrintln("Disable Alien Spawns [^2ON^7]");
	  self.aliens_spawn = true;
	  while(isDefined(self.aliens_spawn)) {
	    level notify("end_cycle");
	    level.cycle_spawning_active = 0;
	    level notify("alien_cycle_ended");
	    wait 2.5;
	  }
	} else {
	  iPrintln("Disable Alien Spawns [^1OFF^7]");
	  self.aliens_spawn = undefined;
	  maps\mp\alien\_spawn_director::set_cycle_scalars(level.cycle_count);
	  level.cycle_spawning_active = 1;
	  level thread maps\mp\alien\_spawn_director::spawn_director_loop(level.cycle_count - 1);
	  level notify("alien_cycle_started");
	}
}

set_outline_color(color) {
	if(color == "White") {
	  self.outline_color = 0;
	} else if(color == "Red") {
	  self.outline_color = 1;
	} else if(color == "Green") {
	  self.outline_color = 2;
	} else if(color == "Aqua") {
	  self.outline_color = 3;
	} else if(color == "Orange") {
	  self.outline_color = 4;
	} else if(color == "Yellow") {
	  self.outline_color = 5;
	}

	if(!isDefined(self.outline_aliens) && color != "None") {
	  iPrintln("Alien ESP [^2ON^7]");
	  self.outline_aliens = true;
	  outline_aliens_loop();
	} else if(color == "None") {
	  iPrintln("Alien ESP [^1OFF^7]");
	  self notify("stop_outline_aliens");
	  self.outline_aliens = undefined;
	  foreach(alien in get_aliens()) {
	    maps\mp\alien\_outline_proto::disable_outline_for_players(alien, level.players);
	  }
	}
}

outline_aliens_loop() {
	self endon("stop_outline_aliens");
	self endon("game_ended");

	for(;;) {
	  foreach(alien in get_aliens()) {
	    maps\mp\alien\_outline_proto::enable_outline_for_player(alien, self, self.outline_color, false, "high");
	  }
	  wait 0.2;
	}
}

// Account Options

set_prestige(value){
	self setCoopPlayerData("alienPlayerStats", "prestige", value);
}

set_rank(value) {
	value--;
	self setCoopPlayerData("alienPlayerStats", "experience", int(tableLookup("mp/alien/rankTable.csv", 0, value, (value == int(tableLookup("mp/alien/rankTable.csv", 0, "maxrank", 1))) ? 7 : 2)));
	self setCoopPlayerData("alienPlayerStats", "rank", value);
	self setClientOmnvar("ui_alien_rankup", value);
}

set_xp_scale(xpScale) {
	iPrintln("XP Multiplier Set to [^3" + xpScale + "x^7]");
	self.xpScale = xpScale;
}

give_teeth(value) {
	maps\mp\alien\_persistence::give_player_tokens(value, true);
}

collect_eggs() {
	self maps\mp\gametypes\_hud_message::playerCardSplashNotify("dlc_eggAllFound", self);
	self thread maps\mp\gametypes\_rank::giveRankXP("dlc_egg_hunt_all");
	ch_setState("ch_weekly_1", 2);
}

unlock_intel() {
	self setCoopPlayerData("intel_episode_1_location_1", 1);
	self setCoopPlayerData("intel_episode_1_location_2", 1);
	self setCoopPlayerData("intel_episode_1_location_3", 1);
	self setCoopPlayerData("intel_episode_1_location_4", 1);
	self setCoopPlayerData("intel_episode_1_location_5", 1);
	self setCoopPlayerData("intel_episode_1_location_6", 1);
	self setCoopPlayerData("intel_episode_1_sequenced_count", 6);

	self setCoopPlayerData("intel_episode_2_location_1", 1);
	self setCoopPlayerData("intel_episode_2_location_2", 1);
	self setCoopPlayerData("intel_episode_2_location_3", 1);
	self setCoopPlayerData("intel_episode_2_location_4", 1);
	self setCoopPlayerData("intel_episode_2_location_5", 1);
	self setCoopPlayerData("intel_episode_2_location_6", 1);
	self setCoopPlayerData("intel_episode_2_sequenced_count", 4);

	self setCoopPlayerData("intel_episode_3_location_1", 1);
	self setCoopPlayerData("intel_episode_3_location_2", 1);
	self setCoopPlayerData("intel_episode_3_location_3", 1);
	self setCoopPlayerData("intel_episode_3_location_4", 1);
	self setCoopPlayerData("intel_episode_3_location_5", 1);
	self setCoopPlayerData("intel_episode_3_location_6", 1);
	self setCoopPlayerData("intel_episode_3_sequenced_count", 6);

	self setCoopPlayerData("intel_episode_4_location_1", 1);
	self setCoopPlayerData("intel_episode_4_location_2", 1);
	self setCoopPlayerData("intel_episode_4_location_3", 1);
	self setCoopPlayerData("intel_episode_4_location_4", 1);
	self setCoopPlayerData("intel_episode_4_location_5", 1);
	self setCoopPlayerData("intel_episode_4_location_6", 1);
	self setCoopPlayerData("intel_episode_4_sequenced_count", 6);
	iPrintln("All Intel ^2Unlocked");
}