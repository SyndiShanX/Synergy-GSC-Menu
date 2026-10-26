#include scripts\common\system;
#include scripts\common\utility;
#include scripts\common\powerups;
#include scripts\engine\trace;
#include scripts\engine\utility;
#include scripts\mp\hud_util;
#include scripts\mp\gamescore;
#include scripts\mp\equipment;
#include scripts\mp\hud_message;
#include scripts\mp\gametypes\br_pickups;
#include scripts\mp\perks\perkpackage;
#include scripts\mp\utility\perk;
#include scripts\cp_mp\pack_a_punch;
#include scripts\cp_mp\armor;
#include scripts\cp_mp\weapon;
#include scripts\cp_mp\zombie_perks;
#include scripts\cp_mp\loot\common_item;
#include scripts\cp_mp\utility\inventory_utility;
#include scripts\cp_mp\utility\weapon_utility;
#include scripts\ob\points;
#include script_6bffae1b97f70547; //ammo_mod

#namespace synergy;

function private autoexec __init__system__() {
	system::register(#"synergy", undefined, &init, undefined);
}

function init() {
	utility::flag_wait("StartGameTypeCallbackFinished");

	level thread [[&player_connect]]();
	level thread [[&create_rainbow_color]]();

	wait 0.5;

	level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	level.callbackPlayerDamage = &player_damage_callback; // Retropack
}

function player_connect() {
	level endon("game_ended");

	for(;;) {
		level waittill("connected", player);

		player.access = player isHost() ? "Host" : "None";

		if(player isHost()) {
			player initial_variables();
			player thread [[&initialize_menu]]();
		}
	}
}

function initial_variables() {
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
	self.font_scale = 0.7;
	self.x_offset = 175;
	self.y_offset = 160;

	self.map_name = get_map_name();
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

	self.syn = [];

	// Weapons

	self.syn["weapons"]["category"][0] = ["assault_rifles", "battle_rifles", "sub_machine_guns", "shotguns", "light_machine_guns", "marksman_rifles", "sniper_rifles", "pistols", "launchers", "melee", "equipment", "extras"];
	self.syn["weapons"]["category"][1] = ["Assault Rifles", "Battle Rifles", "Sub Machine Guns", "Shotguns", "Light Machine Guns", "Marksman Rifles", "Sniper Rifles", "Pistols", "Launchers", "Melee", "Equipment", "Extras"];

	self.syn["weapons"]["assault_rifles"][0] =     ["jup_jp44_ar_stango44_mp", "jup_jp34_ar_balpha27_mp", "jup_jp02_ar_bromeo805_mp", "jup_jp25_ar_talpha95_mp", "jup_jp36_ar_anov94_mp", "jup_jp05_ar_foxtrot2000_mp", "jup_jp01_ar_golf36_mp", "jup_jp19_ar_acharlie_mp", "jup_jp08_ar_qbravo97_mp", "jup_cp06_ar_falpha_mp", "iw9_ar_scharlie_mp", "iw9_ar_mike4_mp", "iw9_ar_augolf_mp", "iw9_ar_akilo_mp", "iw9_ar_mcharlie_mp", "iw9_ar_mcbravo_mp", "iw9_ar_acharlie300_mp", "iw9_ar_helima_mp", "iw9_ar_fecho_mp", "iw9_ar_ralpha_mp", "iw9_ar_malima_mp", "iw9_ar_kilo53_mp", "iw9_ar_mike16_mp", "iw9_ar_akilo74_mp", "iw9_ar_akilo105_mp"];
	self.syn["weapons"]["battle_rifles"][0] =      ["jup_jp40_br_hcharlie36_mp", "jup_jp03_br_aromeo200_mp", "jup_cp08_br_xmike5_mp", "jup_jp19_br_acharlie450_mp", "jup_jp02_br_bromeo2_mp", "iw9_ar_golf3_mp", "iw9_br_ngsierra_mp", "iw9_br_msecho_mp", "iw9_ar_schotel_mp", "iw9_br_soscar14_mp"];
	self.syn["weapons"]["sub_machine_guns"][0] =   ["jup_jp41_sm_kpappa50_mp", "jup_jp32_pi_mpapa9_mp", "jup_cp01_sm_pcharlie9_mp", "jup_jp25_sm_talpham_mp", "jup_cp01_sm_coscar635_mp", "jup_jp02_sm_scharlie3_mp", "jup_jp03_sm_pmike_mp", "jup_jp04_sm_lwhiskey_mp", "jup_jp04_sm_umike_mp", "jup_jp07_sm_uzulu_mp", "jup_jp07_sm_uzulup_mp", "iw9_sm_sdelta_mp", "iw9_sm_acharlie45_mp", "iw9_sm_acharlie9_mp", "iw9_sm_papa90_mp", "iw9_sm_mpapa7_mp", "iw9_sm_victor_mp", "iw9_sm_mpapax_mp", "iw9_sm_mpapa5_mp", "iw9_sm_alpha57_mp", "iw9_sm_apapa_mp", "iw9_sm_beta_mp", "iw9_sm_aviktor_mp"];
	self.syn["weapons"]["shotguns"][0] =           ["jup_jp38_sh_spapa12_mp", "iw9_sh_vecho_mp", "jup_jp16_sh_recho870_mp", "jup_jp09_sh_oromeo12_mp", "jup_cp01_sh_aromeo410_mp", "iw9_sh_charlie725_mp", "iw9_sh_mike1014_mp", "iw9_sh_mbravo_mp", "iw9_sh_tsierra12_mp", "iw9_sh_mviktor_mp"];
	self.syn["weapons"]["light_machine_guns"][0] = ["jup_jp28_lm_rpapa20_mp", "jup_cp15_lm_mkilo3_mp", "iw9_lm_rkilo_mp", "iw9_lm_slima_mp", "jup_jp20_lm_evictor_mp", "jup_jp06_lm_pkilop_mp", "jup_jp08_lm_qbravo95lsw_mp", "jup_cp05_lm_halpha_mp", "jup_jp01_lm_mgolf36_mp", "iw9_lm_ngolf7_mp", "iw9_lm_foxtrot_mp", "iw9_lm_kilo21_mp", "iw9_lm_ahotel_mp"];
	self.syn["weapons"]["marksman_rifles"][0] =    ["jup_jp37_dm_kappa98", "jup_jp13_dm_svictork_mp", "jup_jp19_dm_acharlied_mp", "jup_jp01_dm_slima8_mp", "jup_jpw02_dm_bromeop_mp", "iw9_dm_mike14_mp", "iw9_dm_mike24_mp", "iw9_dm_sbeta_mp", "iw9_dm_stango25_mp", "iw9_dm_crossbow_mp", "iw9_dm_pgolf1_mp", "iw9_dm_sa700_mp", "iw9_dm_scromeo_mp"];
	self.syn["weapons"]["sniper_rifles"][0] =      ["jup_jp35_sn_moscar_mp", "jup_jp10_sn_cdelta50_mp", "jup_jp17_sn_hsierra_mp", "jup_jp36_sn_boscar_mp", "jup_jp13_sn_svictor_mp", "iw9_sn_mromeo_mp", "iw9_sn_limax_mp", "iw9_sn_alpha50_mp", "iw9_sn_india_mp", "iw9_sn_walpha_mp", "iw9_dm_la700_mp", "iw9_dm_xmike2010_mp"];
	self.syn["weapons"]["pistols"][0] =            ["jup_cp24_pi_glima21_mp", "jup_jp12_pi_mike93_mp", "jup_jp14_pi_rsierra12_mp", "jup_jp07_pi_uzulum_mp", "iw9_pi_papa220_mp", "iw9_pi_decho_mp", "iw9_pi_golf17_mp", "iw9_pi_swhiskey_mp", "iw9_pi_tango9_mp", "iw9_pi_dechoauto_mp", "iw9_pi_mike2011_mp", "iw9_pi_golf18_mp"];
	self.syn["weapons"]["launchers"][0] =          ["jup_jp31_dm_compound_mp", "jup_jp26_la_mike32_mp", "jup_jp22_la_dromeo_mp", "iw9_la_gromeo_mp", "iw9_la_juliet_mp", "iw9_la_rpapa7_mp", "iw9_la_kgolf_mp"];
	self.syn["weapons"]["melee"][0] =              ["iw9_me_riotshield_mp", "jup_jp23_me_spear_mp", "jup_jp23_me_shotel_mp", "jup_jp23_me_kalpha_mp", "jup_jp23_me_pdango_mp", "jup_jp23_me_knife_mp", "iw9_me_tonfa_mp", "iw9_me_knife_mp", "jup_jp23_me_swhiskey_mp", "iw9_me_sword01_mp", "iw9_me_kamas_mp", "iw9_me_pickaxe_mp", "iw9_me_buzzsaw_mp", "jup_me_glassshiv", "iw9_drown"];
	self.syn["weapons"]["lethals"][0] =            ["frag", "claymore", "throwing_knife", "thermite", "thermobaric_grenade", "at_mine", "bunkerbuster", "semtex", "c4" , "breacher_drone", "molotov", "aether_blade", "snowball", "rock"];
	self.syn["weapons"]["tacticals"][0] =          ["concussion", "battlerage", "smoke", "butterfly_mine", "decoy", "flash", "snapshot_grenade", "shockstick", "adrenaline", "gas_grenade", "tracker_grenade", "emp", "blackhole_bomb", "monkey_bomb", "tac_cover", "tracker_mine", "trophy", "hb_sensor", "tac_insert", "deployed_decoy", "munitionsbox", "armorbox", "utilitybox", "blastshieldbox", "hauntedbox", "binoculars", "thermal_phone", "inhibitor", "decon_station", "mutant_emp_ball", "iodine_pills", "geigercounter", "aethercounter"];
	self.syn["weapons"]["extras"][0] =             ["jup_la_humangun_mp", "jup_pi_raygun_mp", "jup_ar_dg2_mp", "jup_la_plasmagun_mp", "iw9_pi_stimpistol_mp"];

	self.syn["weapons"]["assault_rifles"][1] =     ["STG44", "BAL-27", "MTZ-556", "RAM-7", "SVA 545", "BP50", "Holger 556", "MCW", "DG-56", "FR 5.56", "TAQ-56", "M4", "STB 556", "Kastov 762", "M13B", "Chimera", "Iso Hemlock", "Tempus Razorback", "FR Avancer", "M13C", "TR-76 Geist", "Lachmann-556", "M16", "Kastov-74u", "Kastov 545"];
	self.syn["weapons"]["battle_rifles"][1] =      ["DTIR 30-06", "SOA Subverter", "BAS-B", "Sidewinder", "MTZ-762", "Lachmann-762", "Cronen Squall", "FTAC Recon", "TAQ-V", "SO-14"];
	self.syn["weapons"]["sub_machine_guns"][1] =   ["Static-HV", "FJX Gorus", "Superi 46", "RAM-9", "AMR9", "Rival-9", "HRM-9", "Striker 9", "Striker", "WSP-9", "WSP Swarm", "Lachmann Shroud", "ISO 45", "ISO 9mm", "PDSW 528", "VEL 46", "Fennec 45", "BAS-P", "Lachmann Sub", "FSS Huricane", "MX9", "Minibak", "Vaznev-9K"];
	self.syn["weapons"]["shotguns"][1] =           ["Reclaimer 18", "KV Broadside", "Lockwood 680", "Haymaker", "Riveter", "Lockwood 300", "Expedite 12", "Bryson 800", "MX Guardian", "Bryson 890"];
	self.syn["weapons"]["light_machine_guns"][1] = ["Kastov LSW", "Bruen Mk9", "RPK", "RAAL MG", "TAQ Evolvere", "Pulemyot 762", "DG-58 LSW", "TAQ Eradicator", "Holger 26", "Sakin MG38", "556 Icarus", "Rapp H", "HCR 56"];
	self.syn["weapons"]["marksman_rifles"][1] =    ["Kar98k", "KVD Enforcer", "MCW 6.8", "DM56", "MTZ Interceptor", "EBR-14", "SP-R 208", "Lockwood Mk2", "Tempus Torrent", "Crossbow", "LM-S", "SA-B 50", "TAQ-M"];
	self.syn["weapons"]["sniper_rifles"][1] =      ["MORS", "XRK Stalker", "Katt-AMR", "Longbow", "KV Inhibitor", "MCPR-300", "Signal 50", "Victus XMR", "FJX Imperium", "Carrack .300", "LA-B 330", "SP-X 80"];
	self.syn["weapons"]["pistols"][1] =            ["COR-45", "Renetti", "TYR", "WSP Stinger", "P890", ".50 GS", "X12", "Basilisk", "FTAC Siege", "GS Magna", "9mm Daemon", "X13 Auto"];
	self.syn["weapons"]["launchers"][1] =          ["Torque 35", "RGL-80", "Stormender", "PILA", "JOKR", "RPG-7", "Strela-P"];
	self.syn["weapons"]["melee"][1] =              ["Riot Shield", "Spear", "Sledgehammer", "Karambit", "Gladiator", "Gutter Knife", "Tonfa", "Combat Knife", "Soulrender", "Dual Kodachis", "Dual Kamas", "Pickaxe", "Buzzsaw", "Glass Shiv", "Fists"];
	self.syn["weapons"]["lethals"][1] =            ["Frag Grenade", "Claymore", "Throwing Knife", "Thermite", "Thermobaric Grenade", "Proximity Mine", "Drill Charge", "Sticky Grenade", "C4", "Breacher Drone", "Molotov", "Aether Blade", "Snowball", "Rock"];
	self.syn["weapons"]["tacticals"][1] =          ["Stun Grenade", "Battle Rage", "Smoke Grenade", "Scatter Mine", "Decoy Grenade", "Flash Grenade", "Snapshot Grenade", "Shock Stick", "Stim", "Tear Gas", "EMD Grenade", "EMP Grenade", "Kazamir", "Monkey Bomb", "Deployable Cover", "Suppression Mine", "Trophy System", "Heartbeast Sensor", "Tactical insertion", "Inflatable Decoy", "Munitions Box", "Armor Box", "Equipment Box", "Blast Shield Armor Box", "Haunted Box", "Binoculars", "Thermal Phone", "Inhibitor", "Decon Station", "Mutant EMP Ball", "Iodine Pills", "Geiger Counter", "Aether Counter"];
	self.syn["weapons"]["extras"][1] =             ["V-R11", "Ray Gun", "Wunderwaffe DG-2", "Scorcher", "Revive Pistol"];

	// Bullets

	self.syn["bullets"][0] = ["chopper_gunner_proj_dmz", "hellstorm_cluster_bomb_proj_mp", "gunship_hellfire_mp", "iw9_la_rpapa7_mp"];
	self.syn["bullets"][1] = ["Chopper Gunner Missile", "Cluster Bomb Missile", "Gunship Missile", "RPG-7 Rocket"];

	// Killstreaks

	self.syn["killstreaks"][0] = ["uav", "switchblade_drone", "missile_turret", "assault_drone", "airdrop", "lrad", "scrambler_drone_guard", "precision_airstrike", "cruise_predator", "cluster_spike", "ims", "fuel_airstrike", "toma_strike", "remote_turret", "loitering_munition", "auto_drone", "airdrop_multiple", "pac_sentry", "missile_drone", "emp", "directional_uav", "gunship", "chopper_gunner", "drone_swarm", "juggernaut", "uav_bigmap", "sentry_gun", "dna_nuke", "radar_drone_recon", "multi_airstrike", "bunker_buster", "white_phosphorus", "nuke_select_location"];
	self.syn["killstreaks"][1] = ["UAV", "Mosquito Drone", "SAM Turret", "Bomb Drone", "Care Package", "Guardian-SC", "Counter UAV", "Precision Airstrike", "Cruise Missile", "Cluster Mine", "I.M.S.", "SAE", "Mortar Strike", "Remote Turret", "Loitering Munition", "Carpet Bomb", "Emergency Airdrop", "Wheelson-HS", "Missile Drone", "EMP", "Advanced UAV", "Gunship", "Chopper Gunner", "Swarm", "Juggernaut", "UAV Bigmap", "Sentry Gun", "DNA Bomb", "Recon Drone", "Multi Airstrike", "Bunker Buster", "White Phosphorus", "Nuke Select Location"];

	// Powerups

	self.syn["powerups"][0] = ["nuke", "full_ammo", "insta_kill", "double_points", "full_power", "bonus_points_team", "free_perk", "full_armor"];
	self.syn["powerups"][1] = ["Nuke", "Max Ammo", "Instakill", "Double Points", "Full Power", "Bonus Points", "Free Perk", "Full Armor"];

	// AATs

	self.syn["aats"][0] = ["brainrot", "deadwire", "cryofreeze", "napalmburst", "shatterblast"];
	self.syn["aats"][1] = ["Brain Rot", "Dead Wire", "Cryofreeze", "Napalm Burst", "Shatter Blast"];

	// Perks

	self.syn["perks"][0] = ["specialty_quickrevive", "specialty_deadshot", "specialty_juggernog", "specialty_speedcola", "specialty_staminup", "specialty_tombstone", "specialty_death_perception", "specialty_elemental_pop", "specialty_phd_flopper"];
	self.syn["perks"][1] = ["Quick Revive", "Deadshot", "Juggernog", "Speed Cola", "Stamin-Up", "Tombstone", "Death Perception", "Elemental Pop", "PhD Flopper"];

	// Acquisitions

	self.syn["acquisitions"][0] = ["ob_jup_item_perk_quickrevive", "ob_jup_item_perk_deadshot", "ob_jup_item_perk_juggernog", "ob_jup_item_perk_speedcola", "ob_jup_item_perk_staminup", "ob_jup_item_perk_tombstone", "ob_jup_item_perk_death_perception", "ob_jup_item_perk_elemental_pop", "ob_jup_item_perk_phd_flopper", "ob_jup_item_aether_tool", "ob_jup_item_aether_tool_2", "ob_jup_item_aether_tool_3", "ob_jup_item_aether_tool_4", "ob_jup_item_aether_crystal", "ob_jup_item_aether_crystal_2", "ob_jup_item_aether_crystal_3", "ob_jup_item_ammomod_brainrot", "ob_jup_item_ammomod_deadwire", "ob_jup_item_ammomod_cryofreeze", "ob_jup_item_ammomod_napalmburst", "ob_jup_item_ammomod_shatterblast", "ob_jup_item_weaponcase_raygun", "ob_jup_item_weaponcase_plasmagun", "ob_jup_item_weaponcase_vr11", "ob_jup_item_weaponcase_dg2", "ob_jup_item_weaponcase_aetherblade", "ob_jup_item_warlord_maestro_mod", "ob_jup_item_disciple_bottle", "ob_jup_item_dog_whistle", "ob_jup_item_golden_armor_plate", "ob_jup_item_warlord_chemist_mask", "ob_jup_item_grenade_bandolier", "ob_jup_item_golden_ammo", "ob_jup_item_warlord_afo_beret", "ob_jup_item_backpack_medium", "ob_jup_item_backpack_large", "ob_jup_item_revive_self_revive", "ob_jup_item_gasmask", "ob_jup_item_gasmask_durable", "ob_jup_item_armor_plate", "ob_jup_item_plate_carrier_2", "ob_jup_item_plate_carrier_3", "ob_jup_item_key_human_stronghold", "ob_jup_item_tactical_monkey_bomb", "ob_jup_item_tactical_blackhole_bomb", "ob_jup_item_thermal_phone", "ob_jup_item_generic_valuable_turret_trap_circuit", "ob_jup_item_killstreak_sentrygun", "ob_jup_item_killstreak_cluster_spike", "ob_jup_item_killstreak_precision_airstrike", "ob_jup_item_killstreak_juggernaut", "ob_jup_item_killstreak_clusterstrike"];
	self.syn["acquisitions"][1] = ["Quick Revive", "Deadshot", "Juggernog", "Speed Cola", "Stamin-Up", "Tombstone", "Death Perception", "Elemental Pop", "PhD Flopper", "Uncommon Aether Tool", "Rare Aether Tool", "Epic Aether Tool", "Legendary Aether Tool", "Raw Aetherium Crystal", "Refined Aetherium Crystal", "Flawless Aetherium Crystal", "Brain Rot", "Dead Wire", "Cryofreeze", "Napalm Burst", "Shatter Blast", "Ray Gun", "Scorcher", "V-R11", "Wunderwaffe DG-2", "Aether Blade case", "Dead Wire Detonators", "Disciple Bottle", "Dog Bone", "Golden Armor plate", "Golden Mask Filter", "Grenade Bandolier", "Mag of Holding", "Sergeant's Beret", "Medium Backpack", "Large Backpack", "Self Revive", "Gas Mask", "Durable Gas Mask", "Armor Plate", "2-Plate Armor Vest", "3-Plate Armor Vest", "Stronghold Keycard", "Monkey Bomb", "LT53 Kazimir", "Thermal Phone", "Turret Trap Circuit", "Sentry Gun", "Cluster Mine", "Precision Airstrike", "Juggernaut", "Mortar Strike"];

	// Field Upgrades

	self.syn["field_upgrades"][0] = ["none", "super_energy_mine", "super_frenzied_guard", "super_healing_aura", "super_frost_blast", "super_aether_shroud", "super_tesla_storm"];
	self.syn["field_upgrades"][1] = ["None", "Energy Mine", "Frenzied Guard", "Healing Aura", "Frost Blast", "Aether Shroud", "Tesla Storm"];
}

function create_menu() {
	self freezeControls(false);

	self thread [[&input_manager]]();

	if(utility::flag_exist("ob_systems_init_complete")) {
		level utility::flag_wait("ob_systems_init_complete");
	}

	wait 10;

	self.menu["border"] = self create_shader("white", "left", "middle", ((self.x_offset + 320) - 1), (self.y_offset - 1), 226, 122, self.color_theme, 1, 1);
	self.menu["background"] = self create_shader("white", "left", "middle", (self.x_offset + 320), self.y_offset, 224, 121, (0.075, 0.075, 0.075), 1, 2);
	self.menu["foreground"] = self create_shader("white", "left", "middle", (self.x_offset + 320), (self.y_offset + 15), 224, 106, (0.1, 0.1, 0.1), 1, 3);
	self.menu["separator_1"] = self create_shader("white", "left", "middle", ((self.x_offset + 320) + 5), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	self.menu["separator_2"] = self create_shader("white", "right", "middle", (self.x_offset + 540), (self.y_offset + 7.5), 42, 1, self.color_theme, 1, 10);
	self.menu["cursor"] = self create_shader("white", "left", "middle", (self.x_offset + 320), 215, 224, 16, (0.15, 0.15, 0.15), 0, 4);

	self.menu["title"] = self create_text("Title", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 94.5), (self.y_offset + 3), (1, 1, 1), 1, 10);
	self.menu["description"] = self create_text("Description", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), (self.y_offset + (self.option_limit * 17.5)), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider_text"] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 132.5), (self.y_offset + 19), (0.75, 0.75, 0.75), 0, 10);
	self.menu["slider"] = self create_shader("white", "left", "middle", (self.x_offset + 320), (self.y_offset + 15), 224, 16, (0.25, 0.25, 0.25), 0, 5);

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i] = self create_shader("white", "right", "middle", ((self.x_offset + 320) - 4), ((self.y_offset + 4) + (i * 15)), 8, 8, (0.25, 0.25, 0.25), 0, 9);
		self.menu["option_" + i] = self create_text("", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 5), ((self.y_offset + 4) + (i * 15)), (0.75, 0.75, 0.75), 1, 10);
		self.menu["submenu_icon_" + i] = self create_text(">", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 215), ((self.y_offset + 1) + (i * 15)), (0.75, 0.75, 0.75), 0, 10);
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

	update_element_positions();

	self.controls_menu_open = true;

	wait 30;

	if(self.controls_menu_open) {
		close_controls_menu();
	}
}

function initialize_menu() {
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		event_name = self utility::waittill_any_return_4("spawned_player", "player_downed", "death", "joined_spectators");
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

function input_manager() {
	level endon("game_ended");
	self endon("disconnect");

	while(self.access != "None") {
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

				self menu_option();

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


				if(self.structure[self.cursor_index].command == &new_menu) {
					self.previous_option = self.structure[self.cursor_index].text;
				}

				if(isDefined(self.structure[self.cursor_index].array) || isDefined(self.structure[self.cursor_index].increment)) {
					if(isDefined(self.structure[self.cursor_index].array)) {
						if(!isDefined(self.structure[self.cursor_index].use_array_index)) {
							cursor_selected = self.structure[self.cursor_index].array[self.slider[(self.current_menu + "_" + self.cursor_index)]];
						} else {
							cursor_selected = self.slider[(self.current_menu + "_" + (self.cursor_index))];
						}
					} else {
						cursor_selected = self.slider[(self.current_menu + "_" + (self.cursor_index))];
					}
					self thread [[&execute_function]](self.structure[self.cursor_index].command, cursor_selected, self.structure[self.cursor_index].parameter_1, self.structure[self.cursor_index].parameter_2, self.structure[self.cursor_index].parameter_3);
				} else if(isDefined(self.structure[self.cursor_index]) && isDefined(self.structure[self.cursor_index].command)) {
					self thread [[&execute_function]](self.structure[self.cursor_index].command, self.structure[self.cursor_index].parameter_1, self.structure[self.cursor_index].parameter_2, self.structure[self.cursor_index].parameter_3);
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
	self.in_menu = true;

	set_menu_visibility(1);

	self menu_option();
	scroll_cursor();
	set_options();
}

function close_menu() {
	set_menu_visibility(0);

	self.in_menu = false;
}

function close_controls_menu() {
	set_menu_visibility(0);

	self.menu["border"] set_shader("white", self.menu["border"].width, 123);
	self.menu["background"] set_shader("white", self.menu["background"].width, 121);
	self.menu["foreground"] set_shader("white", self.menu["foreground"].width, 106);

	self.controls_menu_open = false;

	self.menu["title"] set_text("");
	self.menu["option_1"] set_text("");
	self.menu["option_2"] set_text("");
	self.menu["option_3"] set_text("");
	self.menu["option_4"] set_text("");

	self.in_menu = false;
}

function set_menu_visibility(opacity) {
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

function create_text(text, font, font_scale, align_x, align_y, x_offset, y_offset, color, alpha, z_index, hide_when_in_menu) {
	textElement = hud_util::createFontString(font, font_scale);
	textElement hud_util::setPoint(align_x, align_y, x_offset, y_offset);

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
			textElement thread [[&start_rainbow]]();
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

	shaderElement.alignx = "left";
  shaderElement.aligny = "top";
	shaderElement.xoffset = x_offset;
	shaderElement.yoffset = y_offset;

	shaderElement.hideWhenInMenu = false;

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
			shaderElement thread [[&start_rainbow]]();
		}
	} else {
		shaderElement.color = (0, 1, 1);
	}

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

	if(!isAlive(self) || self.element_result > 22) {
		return true;
	}

	return false;
}

function update_element_positions() {
	self.menu["border"].x = ((self.x_offset + 320) - 1);
	self.menu["border"].y = (self.y_offset - 1);

	self.menu["background"].x = (self.x_offset + 320);
	self.menu["background"].y = self.y_offset;

	self.menu["foreground"].x = (self.x_offset + 320);
	self.menu["foreground"].y = (self.y_offset + 15);

	self.menu["separator_1"].x = ((self.x_offset + 320) + 5);
	self.menu["separator_1"].y = (self.y_offset + 7.5);

	self.menu["separator_2"].x = ((self.x_offset + 320) + 177.5);
	self.menu["separator_2"].y = (self.y_offset + 7.5);

	self.menu["cursor"].x = (self.x_offset + 320);

	self.menu["description"].y = (self.y_offset + (self.option_limit * 17.5));

	self.menu["slider_text"].x = (self.x_offset + 132.5);
	self.menu["slider_text"].y = ((self.y_offset + 4) + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	self.menu["slider"].x = (self.x_offset + 320);
	self.menu["slider"].y = (self.y_offset + (((self.cursor_index + 1) - self.scrolling_offset) * 15));

	for(i = 1; i <= self.option_limit; i++) {
		self.menu["toggle_" + i].x = ((self.x_offset + 320) + 3);
		self.menu["toggle_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["option_" + i].y = ((self.y_offset + 4) + (i * 15));

		self.menu["submenu_icon_" + i].x = (self.x_offset + 215);
		self.menu["submenu_icon_" + i].y = ((self.y_offset + 3) + (i * 15));
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

		level.rainbow_color = ((r / 255), (g / 255), (b / 255));
		wait 0.05;
	}
}

function start_rainbow() {
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
	map_name = getDvar("ui_mapname");
	if(map_name == "mp_jup_bigmap") return "Urzikstan";
}

function in_array(array, item) {
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

function player_damage_callback(inflictor, attacker, damage, flags, death_reason, distance, weapon, point, direction, hit_location, time_offset, model_index, part_name, var_b0fc59ff15058522, var_be4285b26ed99ab1) {
	self endon("disconnect");

	if((isDefined(self.god_mode) && self.god_mode) || (isDefined(self.temp_god_mode) && self.temp_god_mode)) {
		return;
	}

  [[level.originalCallbackPlayerDamage]](inflictor, attacker, damage, flags, death_reason, distance, weapon, point, direction, hit_location, time_offset, model_index, part_name, var_b0fc59ff15058522, var_be4285b26ed99ab1);
}

function vector_scale(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

function get_bullet_trace_position() {
	start = self getEye();
	end = vector_scale(anglesToForward(self getPlayerAngles()), 9999);

	return trace::_bullet_trace(start, start + end, false, self)["position"];
}

function load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		self add_option(self.syn["weapons"][weapon_category][1][i], self.syn["weapons"][weapon_category][0][i], &give_weapon, self.syn["weapons"][weapon_category][0][i]);
	}
}

function load_equipment(weapon_category) {
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		if(weapon_category == "lethals") {
			self add_option(self.syn["weapons"][weapon_category][1][i], self.syn["weapons"][weapon_category][0][i], &give_lethal, self.syn["weapons"][weapon_category][0][i]);
		} else {
			self add_option(self.syn["weapons"][weapon_category][1][i], self.syn["weapons"][weapon_category][0][i], &give_tactical, self.syn["weapons"][weapon_category][0][i]);
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
		return self thread [[command]](parameter_1, parameter_2, parameter_3, parameter_4);
	}

	if(isDefined(parameter_3)) {
		return self thread [[command]](parameter_1, parameter_2, parameter_3);
	}

	if(isDefined(parameter_2)) {
		return self thread [[command]](parameter_1, parameter_2);
	}

	if(isDefined(parameter_1)) {
		return self thread [[command]](parameter_1);
	}

	self thread [[command]]();
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

	self.structure[self.structure.size] = option;
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

	self.structure[self.structure.size] = option;
}

function add_array(text, description, command, array, show_options, use_array_index, parameter_1, parameter_2, parameter_3) {
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
	if(isDefined(use_array_index)) {
		option.use_array_index = use_array_index;
	} else {
		option.use_array_index = undefined;
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

function get_title_width(title) {
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

function set_title(title) {
	self.menu["title"] set_text(title);

	title_width = get_title_width(title);

	self.menu["title"].x = (self.x_offset + ceil((((-0.0000124 * title_width + 0.003832) * title_width - 0.52) * title_width + 115.258) * 10) / 10);
	self.menu["title"].y = (self.y_offset + 3);
}

function new_menu(menu) {
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

function empty_function() {}

function empty_option() {
	option = ["Nothing To See Here!", "Quiet Here, Isn't It?", "Oops, Nothing Here Yet!", "Bit Empty, Don't You Think?"];
	return option[randomInt(option.size)];
}

function scroll_cursor(direction) {
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
				if(self.previous_scrolling_offset != self.scrolling_offset && self.previous_trigger != 1) {
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

function scroll_slider(direction) {
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

function set_options() {
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

				self.menu["slider_text"] set_text(slider_text);
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

			if(isDefined(self.structure[x].command) && self.structure[x].command == &new_menu) {
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

function menu_option() {
	self.structure = [];
	menu = self.current_menu;
	switch(menu) {
		case "Synergy":
			self set_title(menu);

			self add_option("Basic Options", undefined, &new_menu, "Basic Options");
			self add_option("Weapon Options", undefined, &new_menu, "Weapon Options");
			self add_option("Perk Options", undefined, &new_menu, "Perk Options");
			self add_option("Zombie Options", undefined, &new_menu, "Zombie Options");
			self add_option("Powerup Options", undefined, &new_menu, "Powerup Options");
			self add_option("Give Killstreaks", undefined, &new_menu, "Give Killstreaks");
			self add_option("Give Acquisitions", undefined, &new_menu, "Give Acquisitions");
			self add_option("Give Field Upgrades", undefined, &new_menu, "Give Field Upgrades");
			self add_option("Menu Options", undefined, &new_menu, "Menu Options");

			break;
		case "Basic Options":
			self set_title(menu);

			self add_toggle("God Mode", "Makes you Invincible", &god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", &frag_no_clip, self.frag_no_clip);
			self add_toggle("Infinite Ammo", undefined, &infinite_ammo, self.infinite_ammo);
			self add_increment("Set Plate Carrier Level", undefined, &set_plate_carrier_level, 1, 1, 3, 1);
			self add_option("Point Options", undefined, &new_menu, "Point Options");

			break;
		case "Weapon Options":
			self set_title(menu);

			self add_option("Give Weapons", undefined, &new_menu, "Give Weapons");
			self add_option("Pack-a-Punch Current Weapon", "Held Weapon will be Pack-a-Punched", &pack_weapon);
			self add_option("Un-Pack-a-Punch Current Weapon", "Held Weapon will be Un-Pack-a-Punched", &unpack_weapon);
			self add_option("Give AAT", undefined, &new_menu, "Give AAT");

			self add_option("Take Current Weapon", undefined, &take_weapon);
			self add_option("Drop Current Weapon", undefined, &drop_weapon);

			self add_option("Magic Bullets", undefined, &new_menu, "Magic Bullets");

			break;
		case "Perk Options":
			self set_title(menu);

			self add_option("Give Perks", undefined, &new_menu, "Give Perks");
			self add_option("Take Perks", undefined, &new_menu, "Take Perks");
			self add_option("Give Perkaholic", undefined, &give_perkaholic);
			self add_option("Take Perkaholic", undefined, &take_perkaholic);

			break;
		case "Zombie Options":
			self set_title(menu);

			self add_toggle("No Target", "Zombies/Soldiers won't Target You", &no_target, self.no_target);
			self add_option("Kill All Nearby Zombies", undefined, &kill_all_zombies);
			self add_option("Teleport Nearby Zombies to Me", undefined, &teleport_zombies);

			break;
		case "Give Killstreaks":
			self set_title(menu);

			for(i = 0; i < self.syn["killstreaks"][0].size; i++) {
				self add_option(self.syn["killstreaks"][1][i], undefined, &give_killstreak, self.syn["killstreaks"][0][i]);
			}

			break;
		case "Menu Options":
			self set_title(menu);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", &modify_menu_position, 0, -600, 600, 5, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", &modify_menu_position, 0, -100, 100, 5, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", &set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", &set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Hide UI", undefined, &hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, &hide_weapon, self.hide_weapon);

			break;
		case "Powerup Options":
			self set_title(menu);

			self add_toggle("Shoot Powerups", undefined, &shoot_powerups, self.shoot_powerups);

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				self add_option("Spawn " + self.syn["powerups"][1][i], undefined, &spawn_powerup, self.syn["powerups"][0][i]);
			}

			break;
		case "Point Options":
			self set_title(menu);

			self add_increment("Set Point Increment", undefined, &set_point_increment, 100, 100, 10000, 100);

			self add_increment("Set Points", undefined, &set_points, 500, 0, 100000, self.point_increment);
			self add_increment("Add Points", undefined, &add_points, 500, 500, 100000, self.point_increment);
			self add_increment("Take Points", undefined, &take_points, 500, 500, 100000, self.point_increment);

			break;
		case "Give Perks":
			self set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, &give_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Take Perks":
			self set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, &take_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Give Acquisitions":
			self set_title(menu);

			for(i = 0; i < self.syn["acquisitions"][0].size; i++) {
				self add_option(self.syn["acquisitions"][1][i], undefined, &give_acquisition, self.syn["acquisitions"][0][i]);
			}

			break;
		case "Give Field Upgrades":
			self set_title(menu);

			for(i = 0; i < self.syn["field_upgrades"][0].size; i++) {
				self add_option(self.syn["field_upgrades"][1][i], undefined, &give_field_upgrade, self.syn["field_upgrades"][0][i]);
			}

			break;
		case "Give AAT":
			self set_title(menu);

			for(i = 0; i < self.syn["aats"][0].size; i++) {
				self add_option(self.syn["aats"][1][i], undefined, &give_aat, self.syn["aats"][0][i]);
			}

			break;
	  case "Magic Bullets":
			self set_title(menu);

			for(i = 0; i < self.syn["bullets"][0].size; i++) {
				self add_toggle(self.syn["bullets"][1][i], undefined, &modify_bullet, self.bullet[i], self.syn["bullets"][0][i], i);
			}

			break;
		case "Give Weapons":
			self set_title(menu);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self add_option(self.syn["weapons"]["category"][1][i], undefined, &new_menu, self.syn["weapons"]["category"][1][i]);
			}

			break;
		case "Assault Rifles":
			self set_title(menu);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self set_title(menu);

			load_weapons("sub_machine_guns");

			break;
		case "Battle Rifles":
			self set_title(menu);

			load_weapons("battle_rifles");

			break;
		case "Light Machine Guns":
			self set_title(menu);

			load_weapons("light_machine_guns");

			break;
		case "Marksman Rifles":
			self set_title(menu);

			load_weapons("marksman_rifles");

			break;
		case "Sniper Rifles":
			self set_title(menu);

			load_weapons("sniper_rifles");

			break;
		case "Shotguns":
			self set_title(menu);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self set_title(menu);

			load_weapons("pistols");

			break;
		case "Launchers":
			self set_title(menu);

			load_weapons("launchers");

			break;
		case "Melee":
			self set_title(menu);

			load_weapons("melee");

			break;
		case "Equipment":
			self set_title(menu);

			load_equipment("lethals");
			load_equipment("tacticals");

			break;
		case "Extras":
			self set_title(menu);

			load_weapons("extras");

			self add_option("Explosive Mors", undefined, &give_special_weapon, "mors");
			self add_option("Rocket Riveter", undefined, &give_special_weapon, "riveter");
			self add_option("Incendiary Tyrs", undefined, &give_special_weapon, "tyr");
			self add_option("Minigun", undefined, &give_special_weapon, "minigun");
			self add_option("Arcade Sledgehammer", undefined, &give_special_weapon, "sledgehammer");

			break;
		default:
			break;
	}
}

// Basic Options

function god_mode() {
	self.god_mode = !return_toggle(self.god_mode);
	if(self.god_mode) {
		iPrintString("God Mode [^2ON^7]");
	} else {
		iPrintString("God Mode [^1OFF^7]");
	}
}

function frag_no_clip() {
	self endon("disconnect");
	self endon("game_ended");

	if(!isDefined(self.frag_no_clip)) {
		self.frag_no_clip = true;
		iPrintString("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
		while (isDefined(self.frag_no_clip)) {
			if(self fragButtonPressed()) {
				if(!isDefined(self.frag_no_clip_loop)) {
					self thread [[&frag_no_clip_loop]]();
				}
			}
			wait 0.05;
		}
	} else {
		self.frag_no_clip = undefined;
		iPrintString("Frag No Clip [^1OFF^7]");
	}
}

function frag_no_clip_loop() {
	self endon("disconnect");
	self endon("noclip_end");

	self disableWeapons();
	self disableOffHandWeapons();
	self.frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.god_mode) || !self.god_mode) {
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
		self.temp_god_mode = undefined;
	}

	self.frag_no_clip_loop = undefined;
}

function infinite_ammo() {
	self.infinite_ammo = !return_toggle(self.infinite_ammo);
	if(self.infinite_ammo) {
		self iPrintString("Infinite Ammo [^2ON^7]");
		self thread [[&infinite_ammo_loop]]();
	} else {
		self iPrintString("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

function infinite_ammo_loop() {
	self endon("stop_infinite_ammo");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		weapons = self getWeaponsListAll();
		for(i = 0; i < weapons.size; i++) {
			self giveMaxAmmo(weapons[i]);
		}
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);
		self setWeaponAmmoClip(self getCurrentWeapon(), 999, "left");
		self setWeaponAmmoClip(self getCurrentWeapon(), 999, "right");

		self.has_power = 1;

		wait 0.05;
	}
}

function set_plate_carrier_level(value) {
	self.plateCarrierLevel = value;
	self.maxArmorHealth = (value * 50);
	armor::setArmorHealth((value * 50));
	self setClientOmnvar("ui_armor_current_level", value);
}

// Weapon Options

function give_weapon(weapon) {
	weapon = weapon::buildWeapon(weapon);

	if(!self hasWeapon(weapon)) {
		if(self getWeaponsListPrimaries().size >= 5) {
			self takeWeapon(self getCurrentWeapon());
		}

		self giveWeapon(weapon);
		self setSpawnWeapon(weapon);

		wait 0.25;
		self giveStartAmmo(weapon);
	} else {
		self switchToWeaponImmediate(weapon);
	}
}

function give_lethal(grenade) {
	equipment::takeEquipment("primary");
	wait 0.5;
  equipment::giveEquipment("equip_" + grenade, "primary");
	equipment::setEquipmentSlotAmmo("primary", 8);
}

function give_tactical(grenade) {
	equipment::takeEquipment("secondary");
	wait 0.5;
  equipment::giveEquipment("equip_" + grenade, "secondary");
	equipment::setEquipmentSlotAmmo("secondary", 8);
}

function give_special_weapon(weapon_name) {
	explosive_mors = weapon::buildWeapon("jup_jp35_sn_moscar", ["jup_moscar_rec", "jup_jp35_sn_moscar_stock", "jup_jp35_sn_moscar_pgrip", "jup_moscar_bipod", "jup_ammo_rail_std", "jup_moscar_scope", "jup_jp35_sn_moscar_bar_explode", "jup_jp35_sn_moscar_bolt_hvy"], "jup_camo_17c", "none");
  rocket_riveter = weapon::buildWeapon("jup_cp01_sh_aromeo410", ["jup_ammo_410g_vortex", "jup_cp01_sh_aromeo410_pgrip_tac", "jup_reflex04"], "jup_camo_17c", "none");
  incendiary_tyrs = weapon::buildWeapon("jup_jp14_pi_rsierra12", ["jup_ammo_127_db_arcade", "jup_rsierra12_akimbo", "jup_jp14_pi_rsierra12_bar_hvylong"], "jup_camo_17c", "none");
	minigun = makeWeapon("iw9_lm_dblmg_jup_mp", ["ammo_762n_vortex"], undefined, "jup_camo_17c", 0);
  sledgehammer = makeWeapon("jup_jp23_me_shotel_arcade_mp", ["jup_me_shotel"], undefined, "jup_camo_17c", 0);

	switch(weapon_name) {
		case "mors":
			weapon = explosive_mors;
			break;
		case "riveter":
			weapon = rocket_riveter;
			break;
		case "tyr":
			weapon = incendiary_tyrs;
			break;
		case "minigun":
			weapon = minigun;
			break;
		case "sledgehammer":
			weapon = sledgehammer;
			break;
	}

	if(self getWeaponsListPrimaries().size >= 5) {
		self takeWeapon(self getCurrentWeapon());
	}

	self inventory_utility::_giveWeapon(weapon, undefined, undefined, 0);
  self inventory_utility::_switchToWeapon(weapon);
}

function pack_weapon() {
	weapon = self getCurrentWeapon();
	if(pack_a_punch::can_pap(weapon)) {
		current_pap_level = pack_a_punch::get_pap_level(weapon);
		pack_a_punch::pap_weapon(weapon, current_pap_level);
	}
}

function unpack_weapon() {
	weapon = self getCurrentWeapon();
	current_pap_level = pack_a_punch::get_pap_level(weapon);
	if(isDefined(current_pap_level) && current_pap_level >= 1) {
		pack_a_punch::pap_weapon(weapon, (current_pap_level - 2));
	}
}

function give_aat(aat) {
	weapon = self getCurrentWeapon();
	self ammo_mod::add_ammo_mod_to_weapon(weapon, aat);
}

function take_weapon() {
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

function drop_weapon() {
	self dropItem(self getCurrentWeapon());
}

function modify_bullet(bullet, i) {
	self.bullet[i] = !return_toggle(self.bullet[i]);
	if(self.bullet[i]) {
		self iPrintString(self.syn["bullets"][1][i] + " [^2ON^7]");
		self thread [[&modify_bullet_loop]](bullet);
	} else {
		self iPrintString(self.syn["bullets"][1][i] + " [^1OFF^7]");
		self notify("stop_modify_bullet_loop");
	}
}

function modify_bullet_loop(bullet) {
	self endon("stop_modify_bullet_loop");
	self endon("disconnect");

	for(;;) {
		self waittill("weapon_fired");

		magicBullet(makeWeapon(bullet), self getEye(), get_bullet_trace_position(), self);

		wait 0.05;
	}
}

// Killstreaks

function give_killstreak(streak) {
	self br_pickups::forceGiveKillstreak(streak, 0, 0, 0, 0, 0, undefined);
	self hud_message::showKillstreakSplash(streak, undefined, 1);
}

// Menu Options

function iPrintString(string, font_scale) {
	if(!isDefined(font_scale)) {
		font_scale = 0.5;
	}
	if(!isDefined(self.syn["string"])) {
		self.syn["string"] = self create_text(string, "bigfixed", font_scale, "center", "top", 0, -100, (1, 1, 1), 1, 9999, true);
	} else {
		self.syn["string"] set_text(string);
		self.syn["string"].fontScale = font_scale;
	}
	self.syn["string"] notify("stop_hud_fade");
	self.syn["string"].alpha = 1;
	self.syn["string"] setText(string);
	self.syn["string"] thread [[&fade_hud]](0, 2.5);
}

function fade_hud(alpha, time) {
	self endon("stop_hud_fade");
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

function modify_menu_position(offset, axis) {
	if(axis == "x") {
		self.x_offset = 175 + offset;
	} else {
		self.y_offset = 160 + offset;
	}
	self close_menu();
	self open_menu();
}

function set_menu_rainbow() {
	if(!isString(self.color_theme)) {
		self.color_theme = "rainbow";
		self.menu["border"] thread [[&start_rainbow]]();
		self.menu["separator_1"] thread [[&start_rainbow]]();
		self.menu["separator_2"] thread [[&start_rainbow]]();
		self.menu["border"].color = self.color_theme;
		self.menu["separator_1"].color = self.color_theme;
		self.menu["separator_2"].color = self.color_theme;
	}
}

function set_menu_color(value, color) {
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

function hide_ui() {
	self.hide_ui = !return_toggle(self.hide_ui);
	setDvar("cg_draw2d", !self.hide_ui);
}

function hide_weapon() {
	self.hide_weapon = !return_toggle(self.hide_weapon);
	setDvar("cg_drawgun", !self.hide_weapon);
}

// Point Options

function set_point_increment(value) {
	self.point_increment = value;
}

function set_points(value) {
	gamescore::_setplayerscore(self, value);
  essence = points::function_b86115649d705017();
  self.currency["essence"] = essence;
  self setclientomnvar("zm_essence", essence);
}

function add_points(value) {
	current_points = gamescore::_getPlayerScore(self);
	gamescore::_setPlayerScore(self, (current_points + value));
  essence = points::function_b86115649d705017();
  self.currency["essence"] = essence;
  self setClientOmnvar("zm_essence", essence);
}

function take_points(value) {
	current_points = gamescore::_getPlayerScore(self);
	gamescore::_setPlayerScore(self, (current_points - value));
  essence = points::function_b86115649d705017();
  self.currency["essence"] = essence;
  self setClientOmnvar("zm_essence", essence);
}

// Perk Options

give_perk(perk) {
	if(!self perk::_hasperk(perk)) {
		zombie_perks::give_perk(perk, 0);
	}
}

take_perk(perk) {
	self notify(perk + "_stop");
}

function give_perkaholic() {
	foreach(perk in self.syn["perks"][0]) {
		give_perk(perk);
	}
}

function take_perkaholic() {
	foreach(perk in self.syn["perks"][0]) {
		take_perk(perk);
	}
}

// Acquisition Options

function give_acquisition(item) {
	itembundle = getscriptbundle("itemspawnentry:" + item);

	if(isDefined(itembundle)) {
		common_item::function_c465d27f3f6066b4(itembundle, (self.origin + anglesToForward(self.angles) * 25));
	}
}

// Field Upgrade Options

function give_field_upgrade(field_upgrade) {
	perkpackage::perkPackage_giveDebug(field_upgrade);
	self.has_power = 1;
}

// Zombie Options

function no_target() {
	self.no_target = !return_toggle(self.no_target);
	if(self.no_target) {
		iPrintString("No Target [^2ON^7]");
		self.ignoreMe = 1;
	} else {
		iPrintString("No Target [^1OFF^7]");
		self.ignoreMe = 0;
	}
}

function kill_all_zombies() {
	radius = 3000;

  zombies = getAIArrayInRadius(self.origin, radius);

	foreach(zombie in zombies) {
		zombie doDamage(zombie.health * 5000, (0, 0, 0));
		wait 0.05;
	}
}

function teleport_zombies() {
	radius = 3000;

  zombies = getAIArrayInRadius(self.origin, radius);

	foreach(zombie in zombies) {
		zombie forceTeleport(self.origin + anglesToForward(self.angles) * 115);
	}
}

// Powerup Options

function spawn_powerup(powerup) {
	powerups::powerup_drop(powerup, self.origin + ((anglesToForward(self.angles) * 115) + (0, 0, 40)));
}

function shoot_powerups() {
	self.shoot_powerups = !return_toggle(self.shoot_powerups);
	if(self.shoot_powerups) {
		iPrintString("Shoot Powerups [^2ON^7]");
		shoot_powerups_loop();
	} else {
		iPrintString("Shoot Powerups [^1OFF^7]");
		self notify("stop_shoot_powerups");
	}
}

function shoot_powerups_loop() {
	self endon("stop_shoot_powerups");
	self endon("game_ended");

	for(;;) {
		while(self attackButtonPressed()) {
			powerup = self.syn["powerups"][0][randomint(self.syn["powerups"][0].size)];
			powerups::powerup_drop(powerup, (get_bullet_trace_position() + (0, 0, 40)));
			wait 0.5;
		}
		wait 0.05;
	}
}