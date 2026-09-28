#include scripts\core_common\aat_shared;
#include scripts\core_common\array_shared;
#include scripts\core_common\callbacks_shared;
#include scripts\core_common\clientfield_shared;
#include scripts\core_common\exploder_shared;
#include scripts\core_common\flag_shared;
#include scripts\core_common\perks;
#include scripts\core_common\spawner_shared;
#include scripts\core_common\struct;
#include scripts\core_common\system_shared;
#include scripts\core_common\util_shared;
#include scripts\core_common\values_shared;
#include scripts\core_common\ai\zombie_utility;
#include scripts\zm_common\zm_bgb;
#include scripts\zm_common\zm_laststand;
#include scripts\zm_common\zm_loadout;
#include scripts\zm_common\zm_magicbox;
#include scripts\zm_common\zm_items;
#include scripts\zm_common\zm_pack_a_punch_util;
#include scripts\zm_common\zm_perks;
#include scripts\zm_common\zm_player;
#include scripts\zm_common\zm_powerups;
#include scripts\zm_common\zm_round_logic;
#include scripts\zm_common\zm_score;
#include scripts\zm_common\zm_transformation;
#include scripts\zm_common\zm_utility;
#include scripts\zm_common\zm_utility_zstandard;
#include scripts\zm_common\zm_weapons;

#include scripts\synergy;

#namespace synergy_zm;

autoexec __init__system__() { //89f2df9
	system::register("synergy_zm", &init, undefined, undefined);
	synergy::init();
}

init() { //9284135d
	callback::on_spawned(&player_connect);
}

player_connect() { //1f26b6eb
	if(self isHost()) {
		self.access = "Host";
	} else {
		self.access = "None";
	}

	self initial_variables();

	if(self isHost()) {
		self thread initialize_menu();
	}
}

initial_variables() { //ec264b2e
	self.point_increment = 100;
	self.round_increment = 1;
	self.map_name = get_map_name();

	self.equip_attachment_in_progress = false;

	self.narrative_open = false;

	//if(level.script == "zm_zodt8" || level.script == "zm_towers" || level.script == "zm_mansion") {
	//	zm_loadout::register_lethal_grenade_for_level(#"homunculus_leprechaun");
	//	level.w_homunculus_leprechaun = getweapon(#"homunculus_leprechaun");
	//}


	// Weapons

	self.syn["mastercraft"] = array();

	self.syn["weapons"]["category"][0] = ["assault_rifles", "sub_machine_guns", "tactical_rifles", "light_machine_guns", "sniper_rifles", "shotguns", "pistols", "launchers", "melee", "equipment", "extras"];
	self.syn["weapons"]["category"][1] = ["Assault Rifles", "Sub Machine Guns", "Tactical Rifles", "Light Machine Guns", "Sniper Rifles", "Shotguns", "Pistols", "Launchers", "Melee", "Equipment", "Extras"];

	self.syn["weapons"]["assault_rifles"][0] =     array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_mg1909_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8");
	self.syn["weapons"]["sub_machine_guns"][0] =   array("smg_drum_pistol_t8", "smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_mp40_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8");
	self.syn["weapons"]["tactical_rifles"][0] =    array("tr_longburst_t8", "tr_leveraction_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8");
	self.syn["weapons"]["light_machine_guns"][0] = array("lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_double_t8", "lmg_stealth_t8");
	self.syn["weapons"]["sniper_rifles"][0] =      array("sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8");
	self.syn["weapons"]["shotguns"][0] =           array("shotgun_trenchgun_t8", "shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8");
	self.syn["weapons"]["pistols"][0] =            array("pistol_topbreak_t8", "pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8");
	self.syn["weapons"]["launchers"][0] =          array("launcher_standard_t8", "special_crossbow_t8");
	self.syn["weapons"]["melee"][0] =              array("bowie_knife", "special_ballisticknife_t8_dw");
	self.syn["weapons"]["equipment"][0] =          array("eq_frag_grenade", "eq_acid_bomb", "claymore", "sticky_grenade", "eq_molotov", "eq_wraith_fire", "mini_turret", "proximity_grenade");
	self.syn["weapons"]["extras"][0] =             array("minigun");

	self.syn["weapons"]["assault_rifles"][1] =     array("ICR-7", "Maddox RFB", "KN-57", "Hitchcock M9", "Rampart 17", "VAPR-XKG", "Grav", "Swat RFT", "AN-94", "Doublecross", "Peacekeeper");
	self.syn["weapons"]["sub_machine_guns"][1] =   array("Escargot", "MX9", "Spitfire", "Saug 9mm", "GKS", "Cordite", "MP-40", "VMP", "Daemon 3XB", "Switchblade X9", "MicroMG 9mm");
	self.syn["weapons"]["tactical_rifles"][1] =    array("Swordfish", "Essex Model 07", "ABR 223", "Auger DMR", "S6 Stingray", "M16");
	self.syn["weapons"]["light_machine_guns"][1] = array("Titan", "Hades", "VKM 750", "Zweihänder", "Tigershark");
	self.syn["weapons"]["sniper_rifles"][1] =      array("SDM", "Paladin HB50", "Koshka", "Outlaw", "Locus", "Vendetta", "Havelina AA50");
	self.syn["weapons"]["shotguns"][1] =           array("M1897 Trebuchet", "SG12", "MOG 12", "Argus", "Rampage");
	self.syn["weapons"]["pistols"][1] =            array("Welling", "Mozu", "Strife", "RK 7 Garrison", "KAP 45");
	self.syn["weapons"]["launchers"][1] =          array("Hellion Salvo", "Reaver C86");
	self.syn["weapons"]["melee"][1] =              array("Bowie Knife", "Ballistic Knife");
	self.syn["weapons"]["equipment"][1] =          array("Frag Grenade", "Acid Bomb", "Claymore", "Semtex", "Molotov", "Wraith Fire", "Mini Turret", "Shock Charge");
	self.syn["weapons"]["extras"][1] =             array("Death Machine");

	self.syn["weapons"]["hashes"][0] = array("2580570083c8795a", "44214c17f34996ea", "5fd15d3e3a7a9b0c", "28d36f686569f6db", "1039f66708e1d597", "4ef408b2b3e35377", "3c2d17d2f2c857e1", "70f8f3d92031f6f7", "0f662b8266f6be66", "6009b31eb328208b", "6cb6925ebe3bc0d6", "3d5b6ca92bd02c5c", "5bf4dd6dcf1d24f3", "6436ccb615a2b9c6", "7a398a475f8af4c7", "5f1d38574585b35e", "2f42bb0a766b63b4", "66e6c9c83987136b", "28b38fa134e54223", "62032b32d0d142be", "5d7835133aa2daa1", "2f1f9926e48404f7", "5b3e3bae603f9641", "4328baa07bf1d03b", "0b73b6226aaa80f5", "6dc98fe2dc7c7650", "7b2cb0cda291ae11", "1dd5e58c9eb28af6", "66adeb4d1a0422d2", "5d9abb421c753ff2", "497d3824e705398c", "54c9bab69f2a2d2a", "57f46c2caf1de7fc", "0b75a649c0e85983", "369cff6935966a74", "485d0d5e33d6802b", "6840b7b398f4bb83", "67b5b30f9aa8786c", "59618269d014e1fe", "33d6e545e88450c5", "196b2477923b2f7f", "6f8ae16433fba11c", "5243385728e38aa9", "5f9eb7548cc02363", "7a7bda9ab5e9bf35", "0a9dd31e84aaab4e", "35a57559d3bdc159", "3003d1fc53331a5b", "42f6b4f6dd8585ac", "1f48082b20588e4e", "3b0e53f588197120", "18a2b56939a972ee", "6ab1184700ce0aa6", "7be1faad20a192c8", "181d603caefe4cdb", "957f735864c76c09", "99a4271a5452dc0b", "bbb22e33fa2975ad", "34b7eb9fde56bd35", "4e23def16bca8076", "79110fd100108ab9", "703eb1b835b3361f", "640d88fb13e0421e", "0c78156ba6aeda14", "71a5a304a66b5bc9", "4ccbdb4876f0a027", "10f614b278daaebc", "ab3a2f2eeada34a8", "fa6f01faf5bdba69", "7847b8511647815a", "5a4291956faa97ef", "2605a6745df58840", "3a1959bb039f2be3", "62d7f56331878d18", "5b8d1ff4b772bd85", "095dd69e40d99560", "0539f784146391d2", "5004e2171c2be97d", "7d7f0dbb00201240", "243cd42eb1bd6e10", "4ae11871b1233211", "5203eb1bc7ccee98", "b6392019ff8dc689", "c2a45d43be3dba42", "f8e66b21aa05c753", "19c157f2230454ad", "023882a5729dceca", "25a13b6f6232a985", "617dcc39334959ce", "25f355b5d35b8488", "138efe2bb30be63c", "138f012bb30beb55", "138f002bb30be9a2", "4868d59af21181c9", "a7e4878539bc7f72", "134c05846f7c5c98", "67c8d6a04ecce713", "67c8dba04eccef92", "67c8dea04eccf4ab", "67c8e2a04eccfb77", "09b4f9ecbedf98fb", "09b4f7ecbedf9595", "09b4f6ecbedf93e2", "09b4f5ecbedf922f", "4b7e4696d38d13e3", "1ecb90ddb44096f4", "7b1ab4354f6a9ef4", "cd50a2c4ff4e615d", "8fa49b6dc614ec3e", "7a42b57be462143f", "f264d6f24a950a5b", "a91e1c117ebbf5e6", "579652e2459b8c74", "60f0c0ede97e5741", "7e6386f7403487f5", "13a204ba6887b18f", "6684ea1c92c6b6e4", "4fa72f3aca76724f", "3bce061cf2bc9f98", "50f35c4cfb775a9c", "187a6cbc1c93a177", "18829f56b3fbdac1", "74dd69dd8a46d4aa", "6627899099b8a69d", "1d3a5309fa2c9b80", "4dfeb08c20a14b8b", "2b648e8ce3814bbb", "0e1311542f5782b5", "55330e258be3e3cc", "478e71d96c16eb50", "2c8e9cd5fbd53e70", "3ce59657b420dbb2", "40788017f1c860f0", "56584ced84931c9f", "7c76823f9f06439c", "0e052dd0c54e4a6f", "3477cc89337a5ea5", "0fcb8798a7354324", "435dd4ea9f2fd1bf", "514128f7d058cde0", "757d19cbfbeb94b7", "354b896513d0581d", "552dc81e8f3ba5bc", "35aeae4085f96334", "6184fe412da2bb57", "3041cc761d495272", "42ec1ef8c9536af0", "4bf5a2219b1a65d2", "7f8028bb8adc966c", "44f95b73da64d7ee", "081c373345c076c1", "24c644460c2b5642", "78ae302374d576cf", "1fc7843987e89a83", "1efb82c43276a4e3", "6aadfdc58af04635", "2721c688766673fb", "55ab674fdfba3485", "173040967fe4f754", "16044c4b951b7bdd", "16f590f4c5bbc17c", "749afb2862fc3d54", "65f0a900303f4c55", "62c799cc48d4d897", "6c8b8cf03f3be5de", "485b656efb0fd0f8", "713d1e36bd254b65", "459f15018585edda", "716f4e16d6efbd74", "2f4a72ac7be5902e", "6a0c4101e88a4707", "0c2a620242d1636a", "0cd53ea4d4ee864c", "2df0835a53060b95", "7dc8f3611c942007", "7f6a3674177103f1", "7a3940c928f342e7", "3882e337d28ec4df", "0e992907ddf45c9e", "337a0bfc51449d31", "34415d7a97a7d783", "3b5823adc79b4e56", "2909dcf2d0d6eed1", "5f45cf57e1bee38b", "7c29084c96931c48", "5e450b80e312b0d1", "43b2880f3238b8d2", "38662c868c5d5cee", "491ff8e9d1af03a8", "b9826c972a454fb9", "0cb1cdb5b47f0226", "1b5092cccdb3d65b", "4c157b1aeefae09e", "68bfa6918dc2eb81", "5f8f734c5dd02242", "508ba13614577e04", "403bfa4250f7a743", "7d9d24e1aef966fc", "6fed6a04129cb670", "71707ceac8b47c2c", "932b1b9ca78dc1fb", "2cc459d985c09333", "454db5bc2d8b3088");
	self.syn["weapons"]["hashes"][1] = array("ar_accurate_t8", "ar_fastfire_t8", "ar_modular_t8", "ar_mg1909_t8", "ar_damage_t8", "ar_stealth_t8", "ar_galil_t8", "ar_standard_t8", "ar_an94_t8", "ar_doublebarrel_t8", "ar_peacekeeper_t8", "smg_drum_pistol_t8", "smg_standard_t8", "smg_fastfire_t8", "smg_handling_t8", "smg_accurate_t8", "smg_capacity_t8", "smg_mp40_t8", "smg_vmp_t8", "smg_fastburst_t8", "smg_folding_t8", "smg_minigun_t8", "tr_longburst_t8", "tr_leveraction_t8", "tr_midburst_t8", "tr_powersemi_t8", "tr_flechette_t8", "tr_damageburst_t8", "lmg_standard_t8", "lmg_spray_t8", "lmg_heavy_t8", "lmg_double_t8", "lmg_stealth_t8", "sniper_powersemi_t8", "sniper_powerbolt_t8", "sniper_quickscope_t8", "sniper_fastrechamber_t8", "sniper_locus_t8", "sniper_mini14_t8", "sniper_damagesemi_t8", "shotgun_trenchgun_t8", "shotgun_semiauto_t8", "shotgun_pump_t8", "shotgun_precision_t8", "shotgun_fullauto_t8", "pistol_topbreak_t8", "pistol_revolver_t8", "pistol_standard_t8", "pistol_burst_t8", "pistol_fullauto_t8", "launcher_standard_t8", "special_crossbow_t8", "special_ballisticknife_t8_dw", "minigun", "bowie_knife", "bowie_knife_story_1", "stake_knife", "galvaknuckles_t8", "eq_frag_grenade", "eq_acid_bomb", "claymore", "sticky_grenade", "eq_molotov", "eq_wraith_fire", "mini_turret", "proximity_grenade", "homunculus", "homunculus_leprechaun", "cymbal_monkey", "ray_gun", "ray_gun_mk2", "ww_freezegun_t8", "zhield_dw", "zhield_frost_dw", "ww_tricannon_t8", "ww_tricannon_earth_t8", "ww_tricannon_fire_t8", "ww_tricannon_water_t8", "ww_tricannon_air_t8", "zhield_zword_dw", "ww_crossbow_t8", "tomahawk_t8", "tomahawk_t8_upgraded", "zhield_spectral_dw", "zhield_spectral_dw_upgraded", "ww_blundergat_t8", "ww_blundergat_fire_t8", "ww_blundergat_acid_t8", "ww_blundergat_fire_t8_unfinished", "ww_crossbow_impaler_t8", "ww_random_ray_gun1", "ww_random_ray_gun2", "ww_random_ray_gun3", "equip_sprout", "thunderstorm", "zhield_zpear_dw", "ww_hand_o", "ww_hand_h", "ww_hand_g", "ww_hand_c", "ray_gun_mk2v", "ray_gun_mk2x", "ray_gun_mk2y", "ray_gun_mk2z", "snowball", "snowball_upgraded", "snowball_yellow", "snowball_yellow_upgraded", "music_box", "eq_nesting_doll_grenade", "eq_nesting_doll_grenade_niko", "eq_nesting_doll_grenade_rich", "eq_nesting_doll_grenade_takeo", "thundergun", "tundragun", "ww_tesla_gun_t8", "ww_tesla_sniper_t8", "hero_chakram_lv3", "hero_hammer_lv3", "hero_scepter_lv3", "hero_sword_pistol_lv3", "hero_flamethrower_t8_lv3", "hero_minigun_t8_lv3", "hero_katana_t8_lv3", "hero_gravityspikes_t8_lv3", "ar_accurate_t8_upgraded", "ar_fastfire_t8_upgraded", "ar_modular_t8_upgraded", "ar_mg1909_t8_upgraded", "ar_damage_t8_upgraded", "ar_stealth_t8_upgraded", "ar_galil_t8_upgraded", "ar_standard_t8_upgraded", "ar_an94_t8_upgraded", "ar_doublebarrel_t8_upgraded", "ar_peacekeeper_t8_upgraded", "smg_drum_pistol_t8_upgraded", "smg_standard_t8_upgraded", "smg_fastfire_t8_upgraded", "smg_handling_t8_upgraded", "smg_accurate_t8_upgraded", "smg_capacity_t8_upgraded", "smg_mp40_t8_upgraded", "smg_vmp_t8_upgraded", "smg_fastburst_t8_upgraded", "smg_folding_t8_upgraded", "smg_minigun_t8_upgraded", "tr_longburst_t8_upgraded", "tr_leveraction_t8_upgraded", "tr_midburst_t8_upgraded", "tr_powersemi_t8_upgraded", "tr_flechette_t8_upgraded", "tr_damageburst_t8_upgraded", "lmg_standard_t8_upgraded", "lmg_spray_t8_upgraded", "lmg_heavy_t8_upgraded", "lmg_double_t8_upgraded", "lmg_stealth_t8_upgraded", "sniper_powersemi_t8_upgraded", "sniper_powerbolt_t8_upgraded", "sniper_quickscope_t8_upgraded", "sniper_fastrechamber_t8_upgraded", "sniper_locus_t8_upgraded", "sniper_mini14_t8_upgraded", "sniper_damagesemi_t8_upgraded", "shotgun_trenchgun_t8_upgraded", "shotgun_semiauto_t8_upgraded", "shotgun_pump_t8_upgraded", "shotgun_precision_t8_upgraded", "shotgun_fullauto_t8_upgraded", "pistol_topbreak_t8_upgraded", "pistol_revolver_t8_upgraded", "pistol_standard_t8_upgraded", "pistol_burst_t8_upgraded", "pistol_fullauto_t8_upgraded", "launcher_standard_t8_upgraded", "special_crossbow_t8_upgraded", "special_ballisticknife_t8_dw_upgraded", "ww_tricannon_t8_upgraded", "ww_tricannon_earth_t8_upgraded", "ww_tricannon_fire_t8_upgraded", "ww_tricannon_water_t8_upgraded", "ww_tricannon_air_t8_upgraded", "ray_gun_upgraded", "ray_gun_mk2_upgraded", "ww_freezegun_t8_upgraded", "thundergun_upgraded", "tundragun_upgraded", "ww_tesla_gun_t8_upgraded", "ww_tesla_sniper_upgraded_t8", "ww_blundergat_t8_upgraded", "ww_blundergat_fire_t8_upgraded", "ww_blundergat_acid_t8_upgraded", "zhield_zword_dw_upgraded", "ww_crossbow_t8_upgraded", "ww_hand_o_upgraded", "ww_hand_h_upgraded", "ww_hand_g_upgraded", "ww_hand_c_upgraded", "ray_gun_mk2v_upgraded", "ray_gun_mk2x_dw", "ray_gun_mk2y_upgraded", "ray_gun_mk2z_upgraded");

	self.syn["weapons"]["blacklisted_weapons"] = array("bowie_knife", "stake_knife", "galvaknuckles_t8", "eq_frag_grenade", "eq_acid_bomb", "claymore", "sticky_grenade", "eq_molotov", "eq_wraith_fire", "mini_turret", "proximity_grenade", "homunculus", "homunculus_leprechaun", "cymbal_monkey", "music_box", "eq_nesting_doll_grenade", "eq_nesting_doll_grenade_niko", "eq_nesting_doll_grenade_rich", "eq_nesting_doll_grenade_takeo", "minigun", "zhield_dw", "zhield_frost_dw", "ww_blundergat_fire_t8_unfinished", "ww_crossbow_impaler_t8", "ww_random_ray_gun1", "ww_random_ray_gun2", "ww_random_ray_gun3", "zhield_zpear_dw", "hero_chakram_lv3", "hero_hammer_lv3", "hero_scepter_lv3", "hero_sword_pistol_lv3", "hero_flamethrower_t8_lv3", "hero_minigun_t8_lv3", "hero_katana_t8_lv3", "hero_gravityspikes_t8_lv3");

	// Attachments

	self.syn["attachments"][0] = array("acog", "damage", "damage2", "dualoptic", "dw", "elo", "extbarrel", "extbarrel2", "extclip", "extclip2", "fastreload", "fastreload2", "fmj", "fmj2", "grip", "grip2", "holo", "is", "ir", "mixclip", "mms", "pistolscope", "quickdraw", "quickdraw2", "reflex", "rf", "speedreloader", "stalker", "stalker2", "steadyaim", "steadyaim2", "suppressed", "swayreduc", "uber");
	self.syn["attachments"][1] = array("Acog", "High Caliber", "High Caliber II", "Dual Zoom", "Dual Wield", "Elo", "Long Barrel", "Long Barrel II", "Extended Mags", "Extended Mags II", "Fast Mags", "Fast Mags II", "FMJ", "FMJ II", "Grip", "Grip II", "Holographic", "Iron Sights", "Thermal", "Hybrid Mags", "Threat Detector", "Compact Scope", "Quickdraw", "Quickdraw II", "Reflex", "Rapid Fire", "Speed Loader", "Stock", "Stock II", "Laser Sight", "Laser Sight II", "Suppressor", "Stabilizer", "Operator Mod");
	self.syn["blacklisted_attachments"] = array("none", "null", "clantag", "custom1", "custom2", "killcounter");
	self.syn["optics"] = array("reflex", "elo", "mms", "holo", "acog", "dualoptic", "ir", "is");

	// AATs

	self.syn["aats"][0] = array(#"zm_aat_plasmatic_burst", #"zm_aat_kill_o_watt", #"zm_aat_frostbite", #"zm_aat_brain_decay");
	self.syn["aats"][1] = array("Fire Bomb", "Kill-o-Watt", "Cryofreeze", "Brain Rot");

	// Perks

	self.syn["perks"][0] = array(#"specialty_cooldown", #"specialty_quickrevive", #"specialty_awareness", #"specialty_staminup", #"specialty_etherealrazor", #"specialty_wolf_protector", #"specialty_zombshell", #"specialty_death_dash", #"specialty_electriccherry", #"specialty_berserker", #"specialty_camper", #"specialty_shield", #"specialty_deadshot", #"specialty_extraammo", #"specialty_widowswine", #"specialty_additionalprimaryweapon", #"specialty_phdflopper", #"specialty_mystery");
	self.syn["perks"][1] = array("Timeslip", "Quick Revive", "Death Perception", "Stamin-Up", "Ethereal Razor", "Blood Wolf Bite", "Zombshell", "Blaze Phase", "Electric Cherry", "Dying Wish", "Stone Cold Stronghold", "Victorious Tortoise", "Deadshot Dealer", "Bandolier Bandit", "Winter's Wail", "Mule Kick", "PhD Slider", "Secret Sauce");

	// Powerups

	self.syn["powerup_names"][0] = array("1cf58366f56051a9", "5bb3bdba52958ee0", "65a6e8a720ec27c9", "44139aa5d5d9acfb", "6080366ece401431", "7feb13c572497c4a", "78a69fe66c54a056", "951f1d39fde20f7", "50765381ed09468", "E6ffa040580ae58", "28c684193b1b7640", "356fd3bea40f1fee", "28095af5c98f035a", "5201bc3e92d0e7ee", "49f009410f356e84", "5afab57564fa0eb8", "7c95ffdff695fa09", "3331e35614cf574b", "20f05a40e6dfd271");
	self.syn["powerup_names"][1] = array("Crowd Negative Points", "Nuke", "Insta-Kill", "Max Ammo", "Fire Sale", "Bonfire Sale", "Double Points", "Carpenter", "Full Power", "Free Perk", "Zombie Blood", "Bonus Points (Player)", "Bonus Points (Player Shared)", "Bonus Points (Team)", "Wolf Full Power", "Wolf Bonus Ammo", "Wolf Bonus Points", "Small Ammo (CRASH)", "Classic Mode Specialist Weapon");

	self.syn["powerups"][0] = getArrayKeys(level.zombie_include_powerups);
	self.syn["powerups"][1] = array();
	self.syn["powerups"][2] = array();
	self.syn["powerups"][3] = array();
	for(i = 0; i < self.syn["powerups"][0].size; i++) {
		self.syn["powerups"][1][i] = construct_string(replace_character(self.syn["powerups"][0][i], "_", " "));
		for(e = 0; e < self.syn["powerup_names"][0].size; e++) {
			if(self.syn["powerups"][1][i] == self.syn["powerup_names"][0][e]) {
				self.syn["powerups"][1][i] = self.syn["powerup_names"][1][e];
			}
		}
	}

	// Elixirs

	self.syn["elixirs"][0] = array(#"zm_bgb_aftertaste", #"zm_bgb_alchemical_antithesis", #"zm_bgb_always_done_swiftly", #"zm_bgb_anti_entrapment", #"zm_bgb_anywhere_but_here", #"zm_bgb_arsenal_accelerator", #"zm_bgb_blood_debt", #"zm_bgb_bullet_boost", #"zm_bgb_burned_out", #"zm_bgb_cache_back", #"zm_bgb_conflagration_liquidation", #"zm_bgb_ctrl_z", #"zm_bgb_dead_of_nuclear_winter", #"zm_bgb_dividend_yield", #"zm_bgb_equip_mint", #"zm_bgb_extra_credit", #"zm_bgb_free_fire", #"zm_bgb_head_drama", #"zm_bgb_head_scan", #"zm_bgb_immolation_liquidation", #"zm_bgb_in_plain_sight", #"zm_bgb_join_the_party", #"zm_bgb_kill_joy", #"zm_bgb_licensed_contractor", #"zm_bgb_near_death_experience", #"zm_bgb_newtonian_negation", #"zm_bgb_now_you_see_me", #"zm_bgb_nowhere_but_there", #"zm_bgb_perk_up", #"zm_bgb_perkaholic", #"zm_bgb_phantom_reload", #"zm_bgb_phoenix_up", #"zm_bgb_point_drops", #"zm_bgb_pop_shocks", #"zm_bgb_power_keg", #"zm_bgb_power_vacuum", #"zm_bgb_quacknarok", #"zm_bgb_refresh_mint", #"zm_bgb_reign_drops", #"zm_bgb_secret_shopper", #"zm_bgb_shields_up", #"zm_bgb_shopping_free", #"zm_bgb_stock_option", #"zm_bgb_suit_up", #"zm_bgb_sword_flay", #"zm_bgb_talkin_bout_regeneration", #"zm_bgb_temporal_gift", #"zm_bgb_undead_man_walking", #"zm_bgb_wall_power", #"zm_bgb_wall_to_wall_clearance", #"zm_bgb_whos_keeping_score");
	self.syn["elixirs"][1] = array("Aftertaste", "Alchemical Antithesis", "Always Done Swiftly", "Anti Entrapment", "Anywhere But Here", "Arsenal Accelerator", "Blood Debt", "Bullet Boost", "Burned Out", "Cache Back", "Conflagration Liquidation", "Ctrl-Z", "Dead Of Nuclear Winter", "Dividend Yield", "Equip Mint", "Extra Credit", "Free Fire", "Head Drama", "Head Scan", "Immolation Liquidation", "In Plain Sight", "Join The Party", "Kill Joy", "Licensed Contractor", "Near Death Experience", "Newtonian Negation", "Now You See Me", "Nowhere But There", "Perk Up", "Perkaholic", "Phantom Reload", "Phoenix Up", "Point Drops", "Pop Shocks", "Power Keg", "Power Vacuum", "Quacknarok", "Refresh Mint", "Reign Drops", "Secret Shopper", "Shields Up", "Shopping Free", "Stock Option", "Suit Up", "Sword Flay", "Talkin' Bout Regeneration", "Temporal Gift", "Undead Man Walking", "Wall Power", "Wall To Wall Clearance", "Who's Keeping Score");
	self.syn["elixirs"][2] = array("timed", "instant", "timed", "timed", "instant", "timed", "timed", "instant", "timed", "instant", "instant", "timed", "instant", "timed", "instant", "instant", "timed", "timed", "timed", "instant", "instant", "instant", "instant", "instant", "timed", "timed", "timed", "instant", "instant", "instant", "timed", "instant", "instant", "timed", "instant", "timed", "timed", "instant", "instant", "timed", "instant", "timed", "timed", "instant", "timed", "timed", "timed", "timed", "timed", "timed", "instant");

	// Talismans

	self.syn["talismans"][0] = array("talisman_box_guarantee_box_only", "talisman_box_guarantee_lmg", "talisman_coagulant", "talisman_impatient", "talisman_weapon_reducepapcost", "talisman_shield_price", "talisman_shield_durability_rare", "talisman_shield_durability_legendary", "talisman_perk_reducecost_1", "talisman_perk_reducecost_2", "talisman_perk_reducecost_3", "talisman_perk_reducecost_4", "talisman_perk_permanent_1", "talisman_perk_permanent_2", "talisman_perk_permanent_3", "talisman_perk_permanent_4", "talisman_perk_mod_single", "talisman_special_xp_rate");
	self.syn["talismans"][1] = array("Minor Virtuoso's Charm", "Major Virtuoso's Charm", "Coagulated Crystal", "Charm of Impatience", "Charm of the Miser", "Frugal Fetish", "Minor Reinforced Charm", "Major Reinforced Charm", "Minor Amulet of the 1st Circle", "Minor Amulet of the 2nd Circle", "Minor Amulet of the 3rd Circle", "Minor Amulet of the 4th Circle", "Grand Amulet of the 1st Circle", "Grand Amulet of the 2nd Circle", "Grand Amulet of the 3rd Circle", "Grand Amulet of the 4th Circle", "Sigil of the 4th Circle", "Energized Amulet");
	self.syn["talismans"][2] = array("Next Box Spin will be a Box Only Weapon", "Next Box Spin will be an Lmg", "Respawn near the end of the Round or after 100 Zombies are killed", "Increased Last Stand Duration", "Reduced Pack-a-Punch Price", "Reduced Shield Price", "Increased Shield Durability", "Greatly Increased Shield Durability", "Reduced Danu/Brew Price", "Reduced Ra/Cola Price", "Reduced Zeus/Soda Price", "Reduced Odin/Tonic Price", "Permanent Danu/Brew", "Permanent Ra/Cola", "Permanent Zeus/Soda", "Permanent Odin/Tonic", "Activate Odin/Tonic Modifier without other Perks", "Increased Special Charge Rate");

	// Camos

	self.syn["camos"][0] = array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 332, 198, 199, 45, 195, 194, 193, 192);
	self.syn["camos"][1] = array("Hunt", "Grassland", "Overgrowth", "Patrol", "Desert Fox", "Tundra", "Panther", "Coral Panther", "Rend", "Monsoon", "Radar", "Tropic", "Agitator", "Roll", "Roil", "URD", "Urban", "Mangrove", "Bengal", "Platoon", "Clash", "Massacre", "Frost", "Dune", "Red Tiger", "Blue Tiger", "Green Tiger", "Roller Rink", "Fast Times", "Gutter Ball", "Mother of Pearl", "Red Oyster", "Spore", "Purple Hex", "Stealth Hex", "Red Hex Redux", "Penthouse", "Yacht Club", "Emerald UG", "Spectrum", "Infiltrator", "Silverfish", "Gold", "Diamond", "Diamond Alt", "Purple Diamond", "Rainbow Diamond", "Dark Matter", "Dark Matter Orange", "Dark Matter Red", "Dark Matter Red Alt", "Classic Dark Matter");
	self.syn["camos"][2] = array(146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 280, 281, 282, 283, 284, 74, 75, 76, 77, 78, 345, 394);
	self.syn["camos"][3] = array("Voyage of Despair Blue", "Voyage of Despair Red", "Voyage of Despair Green", "Voyage of Despair Yellow", "Voyage of Despair Purple", "IX Blue", "IX Red", "IX Green", "IX Purple", "IX Yellow", "Blood of the Dead Yellow", "Blood of the Dead Red", "Blood of the Dead Purple", "Blood of the Dead Green", "Blood of the Dead Pink", "Classified White", "Classified Black", "Classified Blue", "Classified Green", "Classified Red", "Dead of the Night Green", "Dead of the Night Purple", "Dead of the Night Red", "Dead of the Night Blue", "Dead of the Night Yellow", "Ancient Evil Purple", "Ancient Evil Blue", "Ancient Evil Red", "Ancient Evil Yellow", "Ancient Evil Green", "Alpha Omega", "Tag Der Toten");
	self.syn["camos"][4] = array(129, 119, 346, 80, 86, 120, 117, 46, 81, 83, 79, 51, 314, 347, 355, 354, 348, 135, 387, 136, 121, 352, 349, 315, 49, 50, 122, 123, 317, 350, 351, 82, 316, 134, 353, 48, 84, 47, 88, 137, 118, 249, 124, 58, 59, 60, 61, 167, 184, 185, 91, 92, 131, 132, 133, 138, 89, 94, 95, 286, 287, 357, 391, 392, 393, 288, 289, 290, 295, 296, 297, 298, 53, 54, 55, 56, 306, 307, 305, 308, 172, 187, 188, 189, 191, 228, 310, 311, 312, 313, 68, 69, 70, 359, 360, 361, 385, 293, 170, 200, 300, 301, 302, 303, 363, 364, 365, 366, 168, 381, 382, 383, 384, 171, 181, 182, 126, 127, 389, 390, 166, 208, 209, 210, 211, 63, 64, 65, 66, 71, 72, 173, 201);
	self.syn["camos"][5] = array("115", "Afterglow", "America", "Armor", "Assassin", "Astronomy", "Bacon", "Bejamins", "Blowfish", "Board Shorts", "Burple", "Carbolicious", "Cherry Blossom", "Citrus", "Connected", "Datamine", "Dino Glyphs", "Fear Haze", "Fractal Flames", "Fractalized", "Goosebumps", "Green Gradient", "Jellymaw", "Killabyte", "Kiss of Death", "Lady Luck", "Paradise", "Picnic Royale", "Rocket Box", "Scratch n’ Sniff", "Sea Flake", "Shark Plaque", "Shimmer", "Smoke Blast", "Speedometer", "Splatter", "Stealth Seal", "Street Race", "Treasure", "Trifecta", "Twitch Prime", "Wrapped", "Zombie Mai Tai", "APB Stage 1", "APB Stage 2", "APB Stage 3", "APB Stage 4", "Access Denied Stage 1", "Access Denied Stage 2", "Access Denied Stage 3", "Afterlife Stage 1", "Afterlife Stage 2", "Brains Stage 1", "Brains Stage 2", "Brains Stage 3", "Brains Stage 4", "Celestial Stage 1", "Celestial Stage 2", "Celestial Stage 3", "Cipher Stage 1", "Cipher Stage 2", "Circle Slice Stage 1", "Circle Slice Stage 2", "Circle Slice Stage 3", "Circle Slice Stage 4", "Cyberpunk Stage 1", "Cyberpunk Stage 2", "Cyberpunk Stage 3", "D-Day Stage 1", "D-Day Stage 2", "D-Day Stage 3", "D-Day Stage 4", "Death Reel Stage 1", "Death Reel Stage 2", "Death Reel Stage 3", "Death Reel Stage 4", "Dogfight Stage 1", "Dogfight Stage 2", "Dogfight Stage 3", "Dogfight Stage 4", "Killathon Stage 1", "Killathon Stage 2", "Killathon Stage 3", "Killathon Stage 4", "Killathon Stage 6", "Killathon Stage 7", "Masked Stage 1", "Masked Stage 2", "Masked Stage 3", "Masked Stage 4", "Party Rock Stage 1", "Party Rock Stage 4", "Party Rock Stage 6", "Incandescent Stage 1", "Incandescent Stage 2", "Incandescent Stage 3", "Incandescent Stage 4", "Plasma Drive Stage 1", "Rampage Stage 4", "Rampage Stage 5", "Roadtrip Stage 1", "Roadtrip Stage 2", "Roadtrip Stage 3", "Roadtrip Stage 4", "Shattered Stage 1", "Shattered Stage 2", "Shattered Stage 3", "Shattered Stage 4", "Skull Cracker Stage 1", "Solar Flare Stage 1", "Solar Flare Stage 2", "Solar Flare Stage 3", "Solar Flare Stage 4", "Soul Eater Stage 1", "Soul Eater Stage 5", "Soul Eater Stage 6", "Spinal Stage 1", "Spinal Stage 2", "Symbiosis Stage 1", "Symbiosis Stage 2", "Take It Personally Stage 1", "Take It Personally Stage 2", "Take It Personally Stage 3", "Take It Personally Stage 4", "Take It Personally Stage 5", "The Strip Stage 1", "The Strip Stage 2", "The Strip Stage 3", "The Strip Stage 4", "The Strip Stage 5", "The Strip Stage 6", "Vanguard Stage 2", "Vanguard Stage 5");
}

initialize_menu() { //15544841
	level endon("game_ended");
	self endon("disconnect");

	while(!self.initialized) {
		if(self isHost()) {
			self.initialized = true;

			level flag::wait_till("all_players_spawned");
			level flag::wait_till("initial_blackscreen_passed");

			if(!self.menu_initialized) {
				self notify("init_menu");
			}

			self.synergy_enabled = true;

			self thread menu_call();
		}
		wait 0.05;
	}
}

initialize_verified_menu() { //8e2077d4
	level endon("game_ended");
	self endon("disconnect");

	while(!self.initialized) {
		if(self.access != "None") {
			self.initialized = true;

			while(!self.menu_initialized) {
				self notify("init_menu");
				wait 0.05;
			}

			self.synergy_enabled = true;

			self thread menu_call();
		}
		wait 0.05;
	}
}

menu_call() { //e63cb8af
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		self waittill("menu_option");
		self menu_option();
		wait 0.1;
	}
}

// Misc Functions

construct_string(input_string) { //366e5f8b
	final = "";
	for(e = 0; e < input_string.size; e++) {
		if(e == 0) {
			final += toUpper(input_string[e]);
		} else if(input_string[e - 1] == " ") {
			final += toUpper(input_string[e]);
		} else {
			final += input_string[e];
		}
	}
	return final;
}

replace_character(input_string, substring, replace) { //2e13fdc2
	input_string = "" + input_string;
	substring = "" + substring;
	replace = "" + replace;
	final = "";
	for(e = 0; e < input_string.size; e++) {
		if(input_string[e] == substring) {
			final += replace;
		} else {
			final += input_string[e];
		}
	}
	return final;
}

get_map_name() { //53bbf9d2
	if(level.script == "zm_zodt8") return "voyage_of_despair";
	if(level.script == "zm_towers") return "ix";
	if(level.script == "zm_escape") return "blood_of_the_dead";
	if(level.script == "zm_office") return "classified";
	if(level.script == "zm_mansion") return "dead_of_the_night";
	if(level.script == "zm_red") return "ancient_evil";
	if(level.script == "zm_white") return "alpha_omega";
	if(level.script == "zm_orange") return "tag_der_toten";
}

load_weapons(weapon_category) { //adb7e2c7
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		if(self.syn["weapons"][weapon_category][0][i] != "equipment") {
			self synergy::add_option(self.syn["weapons"][weapon_category][1][i], undefined, &give_weapon, self.syn["weapons"][weapon_category][0][i]);
		} else {
			self synergy::add_option(self.syn["weapons"][weapon_category][1][i], undefined, &give_grenade, self.syn["weapons"][weapon_category][0][i]);
		}
	}
}

has_weapon(weapon) { //ada8fe01
	foreach(equipped_weapon in self getWeaponsListPrimaries()) {
		if(equipped_weapon.rootWeapon == weapon.rootWeapon) {
			return true;
		}
	}
	return false;
}

impatient_revive() { //5542b8e3
	self endon(#"disconnect");
	self.var_135a4148 = 0;

	while(true) {
		self waittill(#"bled_out");
		self thread special_revive();
	}
}

special_revive() { //49849a2f
	self endon(#"disconnect", #"end_of_round");

	if(self.var_135a4148 == zm_round_logic::get_round_number()) {
		return;
	}

	if(level.zombie_total <= 3) {
		wait 1;
	}

	n_target_kills = level.zombie_player_killed_count + 100;

	while(level.zombie_player_killed_count < n_target_kills && level.zombie_total >= 3) {
		waitframe(1);
	}

	self.var_135a4148 = zm_round_logic::get_round_number();
	self zm_player::spectator_respawn_player();
	self val::set(#"talisman_impatient", "ignoreme");
	wait 5;
	self val::reset(#"talisman_impatient", "ignoreme");
}

set_box_lmg_only(a_keys) { //941de1ca
	a_valid = array();

	foreach(w_key in a_keys) {
		if(w_key.weapclass == "mg") {
			array::add(a_valid, w_key);
		}
	}

	if(a_valid.size == 0) {
		a_valid = a_keys;
	}

	a_valid = array::randomize(a_valid);
	self.var_afb3ba4e = undefined;
	self.var_c21099c0 = undefined;
	return a_valid;
}

set_box_only_box_weapons(a_keys) { //ae215282
	a_wallbuys = array();
	a_valid = array();
	var_52fb84b5 = [];
	var_52fb84b5 = struct::get_array("weapon_upgrade", "targetname");
	var_52fb84b5 = arraycombine(var_52fb84b5, struct::get_array("buildable_wallbuy", "targetname"), 1, 0);

	for(i = 0; i < var_52fb84b5.size; i++) {
		w_wallbuy = getweapon(var_52fb84b5[i].zombie_weapon_upgrade);
		array::add(a_wallbuys, w_wallbuy);
	}

	foreach(w_key in a_keys) {
		if(!zm_weapons::is_wonder_weapon(w_key)) {
			array::add(a_valid, w_key);
		}
	}

	a_keys = array::exclude(a_valid, a_wallbuys);
	a_keys = array::randomize(a_keys);
	self.var_afb3ba4e = undefined;
	self.var_c21099c0 = undefined;
	return a_keys;
}

// Menu Options

menu_option() { //bf384607
	self.structure = array();
	menu = self.current_menu;
	switch(menu) {
		case "Synergy":
			self synergy::set_title(menu);

			self synergy::add_option("Basic Options", undefined, &synergy::new_menu, "Basic Options");
			self synergy::add_option("Fun Options", undefined, &synergy::new_menu, "Fun Options");
			self synergy::add_option("Weapon Options", undefined, &synergy::new_menu, "Weapon Options");
			self synergy::add_option("Zombie Options", undefined, &synergy::new_menu, "Zombie Options");
			self synergy::add_option("Map Options", undefined, &synergy::new_menu, "Map Options");
			self synergy::add_option("Powerup Options", undefined, &synergy::new_menu, "Powerup Options");
			self synergy::add_option("Menu Options", undefined, &synergy::new_menu, "Menu Options");
			self synergy::add_option("All Players", undefined, &synergy::new_menu, "All Players");

			break;
		case "Basic Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("God Mode", "Makes you Invincible", &god_mode, self.god_mode);
			self synergy::add_toggle("Frag No Clip", "Fly through the Map using your ^3Equipment^7 Keybind", &frag_no_clip, self.frag_no_clip);

			self synergy::add_toggle("Infinite Ammo", "Gives you Infinite Ammo, Grenades, and Specialist", &infinite_ammo, self.infinite_ammo);
			self synergy::add_toggle("Infinite Shield", "Gives you Infinite Shield Durability", &infinite_shield, self.infinite_shield);

			self synergy::add_option("Give Perks", undefined, &synergy::new_menu, "Give Perks");
			self synergy::add_option("Take Perks", undefined, &synergy::new_menu, "Take Perks");
			self synergy::add_option("Give Perk Set", undefined, &give_perks);
			self synergy::add_option("Give Perkaholic", undefined, &give_perkaholic);
			self synergy::add_option("Take Perkaholic", undefined, &take_perkaholic);

			self synergy::add_option("Give Self Revive", undefined, &give_self_revive);
			self synergy::add_option("Give Elixirs", undefined, &synergy::new_menu, "Give Elixirs");
			self synergy::add_option("Give Talismans", undefined, &synergy::new_menu, "Give Talismans");

			self synergy::add_option("Point Options", undefined, &synergy::new_menu, "Point Options");

			break;
		case "Fun Options":
			self synergy::set_title(menu);

			self synergy::add_increment("Set Speed", undefined, &set_speed, "set_speed", 1, 1, 15, 1);
			self synergy::add_increment("Set Gravity", undefined, &set_gravity, "set_gravity", 800, 100, 800, 100);

			self synergy::add_toggle("Third Person", undefined, &third_person, self.third_person);

			break;
		case "Weapon Options":
			self synergy::set_title(menu);

			self synergy::add_option("Give Weapons", undefined, &synergy::new_menu, "Give Weapons");
			self synergy::add_option("Give Mastercrafts", undefined, &synergy::new_menu, "Give Mastercrafts");
			self synergy::add_increment("Pack-a-Punch Tier", "Given Weapons will be Pack-a-Punched", &give_packed_weapon, "give_packed_weapon", 0, 0, 4, 1);
			self synergy::add_option("Give AAT", undefined, &synergy::new_menu, "Give AAT");

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				self synergy::add_option("Equip Attachment", undefined, &synergy::new_menu, "Equip Attachment");
			}
			self synergy::add_option("Equip Camo", undefined, &synergy::new_menu, "Equip Camo");

			self synergy::add_option("Take Current Weapon", undefined, &take_weapon);
			self synergy::add_option("Drop Current Weapon", undefined, &drop_weapon);

			self synergy::add_toggle("Max Specialist Points Requirement", "Makes earning the Specialist take 17,500 points", &max_specialist_points, self.max_specialist_points);

			break;
		case "Zombie Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("No Target", "Zombies won't Target You", &no_target, self.no_target);

			self synergy::add_increment("Set Round", undefined, &set_round, "set_round", 1, 1, 935, self.round_increment);
			self synergy::add_array("Set Round Increment", undefined, &set_round_increment, "round_increment", array("1", "5", "10", "20", "30", "40", "50"), false);
			self synergy::add_toggle("Show Real Round", undefined, &show_real_round, self.show_real_round);

			self synergy::add_option("Spawn Zombie", undefined, &spawn_normal_zombie);
			self synergy::add_option("Kill All Zombies", undefined, &kill_all_zombies);
			self synergy::add_option("Teleport Zombies to Me", undefined, &teleport_zombies);

			self synergy::add_toggle("One Shot Zombies", undefined, &one_shot_zombies, self.one_shot_zombies);
			self synergy::add_toggle("Freeze Zombies", undefined, &freeze_zombies, self.freeze_zombies);
			self synergy::add_toggle("Slow Zombies", undefined, &slow_zombies, self.slow_zombies);
			self synergy::add_toggle("Disable Spawns", undefined, &disable_spawns, self.disable_spawns);

			if(self.map_name == "voyage_of_despair" || self.map_name == "ix" || self.map_name == "dead_of_the_night" || self.map_name == "ancient_evil") {
				self synergy::add_toggle("Disable Transformations", "Disables Catalysts and Blightfathers", &disable_transformations, self.disable_transformations);
			}

			self synergy::add_array("Set Zombie Speed", undefined, &set_zombie_speed, "zombie_speed", array("Restore", "Walk", "Run", "Sprint", "Super Sprint"));

			break;
		case "Map Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("Freeze Box", "Locks the Mystery Box, so it can't move", &freeze_box, self.freeze_box);
			self synergy::add_option("Open Doors", undefined, &open_doors);

			if(self.map_name == "voyage_of_despair" || self.map_name == "ix" || self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "dead_of_the_night" || self.map_name == "ancient_evil" || self.map_name == "alpha_omega") {
				self synergy::add_option("Open Narrative Room", undefined, &open_narrative_room);
			}

			if(!level flag::get("power_on")) {
				self synergy::add_option("Turn Power On", undefined, &power_on);
			}

			self synergy::add_option("Pick up all Parts", undefined, &pick_up_parts);

			break;
		case "Powerup Options":
			self synergy::set_title(menu);

			self synergy::add_toggle("Shoot Powerups", undefined, &shoot_powerups, self.shoot_powerups);

			for(i = 0; i < self.syn["powerups"][0].size; i++) {
				switch(self.syn["powerups"][1][i]) {
					case "Small Ammo (CRASH)":
						break;
					default:
						self synergy::add_option("Spawn " + self.syn["powerups"][1][i], undefined, &spawn_powerup, self.syn["powerups"][0][i]);
						break;
				}
			}

			break;
		case "Menu Options":
			self synergy::set_title(menu);

			self synergy::add_increment("Move Menu X", "Move the Menu around Horizontally", &synergy::modify_menu_position, "move_menu_x", 0, -1200, 1200, 50, "x");
			self synergy::add_increment("Move Menu Y", "Move the Menu around Vertically", &synergy::modify_menu_position, "move_menu_y", 0, -250, 250, 25, "y");

			self synergy::add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", &synergy::set_menu_rainbow);

			self synergy::add_increment("Red", "Set the Red Value for the Menu Outline Color", &synergy::set_menu_colors, "set_red", 255, 1, 255, 1, "Red");
			self synergy::add_increment("Green", "Set the Green Value for the Menu Outline Color", &synergy::set_menu_colors, "set_green", 255, 1, 255, 1, "Green");
			self synergy::add_increment("Blue", "Set the Blue Value for the Menu Outline Color", &synergy::set_menu_colors, "set_blue", 255, 1, 255, 1, "Blue");

			self synergy::add_toggle("Hide UI", undefined, &synergy::hide_ui, self.hide_ui);

			break;
		case "All Players":
			self synergy::set_title(menu);

			foreach(player in level.players) {
				self synergy::add_option(player.name, undefined, &synergy::new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self synergy::set_title(menu);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self synergy::add_option("Print", "Print Player Name", &print_name, target);

				if(!target isHost() && target.access == "None") {
					self synergy::add_option("Verify", "Give the Player Mod Menu Access", &verify_player, target);
				}
			} else {
				self synergy::add_option("Player not found");
			}

			break;
		case "Give Perks":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self synergy::add_option(self.syn["perks"][1][i], undefined, &give_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Take Perks":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self synergy::add_option(self.syn["perks"][1][i], undefined, &take_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Give Elixirs":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["elixirs"][0].size; i++) {
				self synergy::add_option(self.syn["elixirs"][1][i], undefined, &give_elixir, self.syn["elixirs"][0][i], self.syn["elixirs"][2][i]);
			}

			break;
		case "Give Talismans":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["talismans"][0].size; i++) {
				self synergy::add_option(self.syn["talismans"][1][i], self.syn["talismans"][2][i], &give_talisman, self.syn["talismans"][0][i]);
			}

			break;
		case "Point Options":
			self synergy::set_title(menu);

			self synergy::add_increment("Set Increment", undefined, &set_point_increment, "set_increment", 100, 100, 10000, 100);

			self synergy::add_increment("Set Points", undefined, &set_points, "set_points", 500, 500, 100000, self.point_increment);
			self synergy::add_increment("Add Points", undefined, &add_points, "add_points", 500, 500, 100000, self.point_increment);
			self synergy::add_increment("Take Points", undefined, &take_points, "take_points", 500, 500, 100000, self.point_increment);

			break;
		case "Equip Attachment":
			self synergy::set_title(menu);

			self.equip_attachment_in_progress = true;

			self.syn["attachment_toggles"] = [];

			while(self getCurrentWeapon() == getWeapon(#"none")) {
				wait 0.05;
			}

			weapon_attachments = get_weapon_attachments();

			if(isDefined(weapon_attachments) && isArray(weapon_attachments) && weapon_attachments.size > 0) {
				for(i = 0; i < weapon_attachments.size; i++) {
					self.syn["attachment_toggles"][i] = weaponHasAttachment(self getCurrentWeapon(), weapon_attachments[i]);
					self synergy::add_toggle(get_attachment_name(weapon_attachments[i]), undefined, &equip_attachment, self.syn["attachment_toggles"][i], weapon_attachments[i], i);
				}
			}

			self.equip_attachment_in_progress = false;

			break;
		case "Equip Camo":
			self synergy::set_title(menu);

			self synergy::add_option("Default Camos", undefined, &synergy::new_menu, "Default Camos");
			self synergy::add_option("Pack-a-Punch Camos", undefined, &synergy::new_menu, "Pack-a-Punch Camos");
			self synergy::add_option("Black Market Camos", undefined, &synergy::new_menu, "Black Market Camos");

			break;
		case "Default Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][0].size; i++) {
				self synergy::add_option(self.syn["camos"][1][i], "" + self.syn["camos"][0][i], &equip_camo, self.syn["camos"][0][i]);
			}

			break;
		case "Pack-a-Punch Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][2].size; i++) {
				self synergy::add_option(self.syn["camos"][3][i], "" + self.syn["camos"][2][i], &equip_camo, self.syn["camos"][2][i]);
			}

			break;
		case "Black Market Camos":
			self synergy::set_title(menu);

			self synergy::add_option("None", "0", &equip_camo, 0);

			for(i = 0; i < self.syn["camos"][4].size; i++) {
				self synergy::add_option(self.syn["camos"][5][i], "" + self.syn["camos"][4][i], &equip_camo, self.syn["camos"][4][i]);
			}

			break;
		case "Give AAT":
			self synergy::set_title(menu);

			self synergy::add_option("None", undefined, &take_aat);

			for(i = 0; i < self.syn["aats"][0].size; i++) {
				self synergy::add_option(self.syn["aats"][1][i], undefined, &give_aat, self.syn["aats"][0][i]);
			}

			break;
		case "Give Mastercrafts":
			self synergy::set_title(menu);

			self synergy::add_array("ICR-7 Variant", undefined, &give_mastercraft_weapon, "icr_mastercrafts", array("Blinding Glory", "Summon", "Gearhead"), undefined, "ar_accurate_t8");
			self synergy::add_array("Maddox RFB Variant", undefined, &give_mastercraft_weapon, "maddox_mastercrafts", array("Carbon Cobra", "$treet"), undefined, "ar_fastfire_t8");
			self synergy::add_array("KN-57 Variant", undefined, &give_mastercraft_weapon, "kn_mastercrafts", array("MkII", "Kuromaku", "Fabergé K"), undefined, "ar_modular_t8");
			self synergy::add_array("Rampart 17 Variant", undefined, &give_mastercraft_weapon, "rampart_mastercrafts", array("MkII", "Afterburner"), undefined, "ar_damage_t8");
			self synergy::add_option("VAPR-XKG - Vampire Hunter", undefined, &give_mastercraft_weapon, undefined, 2, "ar_stealth_t8");
			self synergy::add_array("Swat RFT Variant", undefined, &give_mastercraft_weapon, "swat_mastercrafts", array("MkII", "Temple of Boom"), undefined, "ar_standard_t8");
			self synergy::add_option("Peacekeeper - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "ar_peacekeeper_t8");

			self synergy::add_array("MX9 Variant", undefined, &give_mastercraft_weapon, "mx_mastercrafts", array("MkII Patriot", "Soldier of Fortune"), undefined, "smg_standard_t8");
			self synergy::add_array("Spitfire Variant", undefined, &give_mastercraft_weapon, "spitfire_mastercrafts", array("Deep Voyage", "MkII"), undefined, "smg_fastfire_t8", 1);
			self synergy::add_array("Saug 9mm Variant", undefined, &give_mastercraft_weapon, "saug_mastercrafts", array("Great Lion", "MkII"), undefined, "smg_handling_t8", 1);
			self synergy::add_array("GKS Variant", undefined, &give_mastercraft_weapon, "gks_mastercrafts", array("MkII - Damascus", "Tactical Unicorn", "Black Plague"), undefined, "smg_accurate_t8");
			self synergy::add_array("Cordite Variant", undefined, &give_mastercraft_weapon, "cordite_mastercrafts", array("Zero G", "MkII"), undefined, "smg_capacity_t8", 1);
			self synergy::add_array("Daemon 3XB Variant", undefined, &give_mastercraft_weapon, "daemon_mastercrafts", array("MkII", "Imaginator"), undefined, "smg_fastburst_t8");
			self synergy::add_option("Switchblade X9 - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "smg_folding_t8");

			self synergy::add_array("Swordfish Variant", undefined, &give_mastercraft_weapon, "swordfish_mastercrafts", array("Ahab's Revenge", "MkII"), undefined, "tr_longburst_t8", 1);
			self synergy::add_array("ABR 223 Variant", undefined, &give_mastercraft_weapon, "abr_mastercrafts", array("Fighter Ace", "MkII"), undefined, "tr_midburst_t8", 1);
			self synergy::add_array("S6 Stingray Variant", undefined, &give_mastercraft_weapon, "stingray_mastercrafts", array("Predator", "MkII"), undefined, "tr_flechette_t8");

			self synergy::add_array("Titan Variant", undefined, &give_mastercraft_weapon, "titan_mastercrafts", array("MkII - Sandstorm", "Black Knight"), undefined, "lmg_standard_t8");
			self synergy::add_option("Hades - Venom Cocktail", undefined, &give_mastercraft_weapon, undefined, 1, "lmg_spray_t8");
			self synergy::add_array("VKM 750 Variant", undefined, &give_mastercraft_weapon, "vkm_mastercrafts", array("Magic Carpet Ride", "MkII"), undefined, "lmg_heavy_t8", 1);
			self synergy::add_option("Tigershark - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "lmg_stealth_t8");

			self synergy::add_option("SDM - Lost Patrol", undefined, &give_mastercraft_weapon, undefined, 2, "sniper_powersemi_t8");
			self synergy::add_array("Paladin HB50 Variant", undefined, &give_mastercraft_weapon, "paladin_mastercrafts", array("Unknown", "Valkyrie", "MkII"), undefined, "sniper_powerbolt_t8");
			self synergy::add_array("Koshka Variant", undefined, &give_mastercraft_weapon, "koshka_mastercrafts", array("MkII", "Wundergewehr 115"), undefined, "sniper_quickscope_t8");
			self synergy::add_option("Outlaw - High Noon", undefined, &give_mastercraft_weapon, undefined, 2, "sniper_fastrechamber_t8");
			self synergy::add_option("Vendetta - MkII", undefined, &give_mastercraft_weapon, undefined, 1, "sniper_mini14_t8");

			self synergy::add_array("SG12 Variant", undefined, &give_mastercraft_weapon, "sg_mastercrafts", array("MkII - Killcano", "Boombox"), undefined, "shotgun_semiauto_t8");
			self synergy::add_array("MOG 12 Variant", undefined, &give_mastercraft_weapon, "mog_mastercrafts", array("Enforcer", "MkII"), undefined, "shotgun_pump_t8", 1);
			self synergy::add_array("Rampage Variant", undefined, &give_mastercraft_weapon, "rampage_mastercrafts", array("MkII", "Desecrator"), undefined, "shotgun_fullauto_t8");

			self synergy::add_array("Mozu Variant", undefined, &give_mastercraft_weapon, "mozu_mastercrafts", array("Replicant", "MkII"), undefined, "pistol_revolver_t8", 1);
			self synergy::add_array("Strife Variant", undefined, &give_mastercraft_weapon, "strife_mastercrafts", array("MkII - Divinity", "Divine Justice"), undefined, "pistol_standard_t8");
			self synergy::add_option("RK 7 Garrison - Odin's Song", undefined, &give_mastercraft_weapon, undefined, 2, "pistol_burst_t8");
			self synergy::add_array("KAP 45 Variant", undefined, &give_mastercraft_weapon, "kap_mastercrafts", array("MkII", "Game Over"), undefined, "pistol_fullauto_t8");

			break;
		case "Give Weapons":
			self synergy::set_title(menu);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self synergy::add_option(self.syn["weapons"]["category"][1][i], undefined, &synergy::new_menu, self.syn["weapons"]["category"][1][i]);
			}

			break;
		case "Assault Rifles":
			self synergy::set_title(menu);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self synergy::set_title(menu);

			load_weapons("sub_machine_guns");

			if(self.map_name == "blood_of_the_dead" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
				self synergy::add_option("M1927", undefined, &give_weapon, "smg_thompson_t8");
			}

			break;
		case "Tactical Rifles":
			self synergy::set_title(menu);

			load_weapons("tactical_rifles");

			break;
		case "Light Machine Guns":
			self synergy::set_title(menu);

			load_weapons("light_machine_guns");

			break;
		case "Sniper Rifles":
			self synergy::set_title(menu);

			load_weapons("sniper_rifles");

			break;
		case "Shotguns":
			self synergy::set_title(menu);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self synergy::set_title(menu);

			load_weapons("pistols");

			break;
		case "Launchers":
			self synergy::set_title(menu);

			load_weapons("launchers");

			break;
		case "Melee":
			self synergy::set_title(menu);

			load_weapons("melee");

			if(self.map_name == "dead_of_the_night") {
				self synergy::add_option("Stake Knife", undefined, &give_weapon, "stake_knife");
			}

			if(self.map_name == "blood_of_the_dead") {
				self synergy::add_option("Spoon", undefined, &give_weapon, "spoon_alcatraz");
				self synergy::add_option("Spork", undefined, &give_weapon, "spork_alcatraz");
				self synergy::add_option("Golden Spork", undefined, &give_weapon, "spknifeork");
				self synergy::add_option("Golden Scalpel", undefined, &give_weapon, "golden_knife");
			}

			if(self.map_name == "alpha_omega") {
				self synergy::add_option("Galva Knuckles", undefined, &give_weapon, "galvaknuckles_t8");
				self synergy::add_option("Freezing Ballistic Knife", undefined, &give_weapon, "special_ballisticknife_freezing_t8_dw");
			}

			break;
		case "Equipment":
			self synergy::set_title(menu);

			load_weapons("equipment");

			if(self.map_name == "voyage_of_despair" || self.map_name == "ix" || self.map_name == "dead_of_the_night" || self.map_name == "ancient_evil") {
				self synergy::add_option("Homunculus", undefined, &give_grenade, "homunculus");
				if(self.map_name != "ancient_evil") {
					self synergy::add_option("Homunculus Leprechaun", undefined, &give_grenade, "homunculus_leprechaun");
				}
			}

			if(self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
				self synergy::add_option("Cymbal Monkey", undefined, &give_grenade, "cymbal_monkey");
			}

			if(self.map_name == "blood_of_the_dead") {
				self synergy::add_option("Hell's Retriever", undefined, &give_grenade, "tomahawk_t8");
				self synergy::add_option("Hell's Redeemer", undefined, &give_grenade, "tomahawk_t8_upgraded");
			}

			if(self.map_name == "ancient_evil") {
				self synergy::add_option("Pegasus Strike", undefined, &give_grenade, "thunderstorm");
				self synergy::add_option("Sprout", undefined, &give_grenade, "equip_sprout");
			}

			if(self.map_name == "tag_der_toten") {
				self synergy::add_option("Samantha Box", undefined, &give_grenade, "music_box");
				self synergy::add_option("Matryoska Dolls", undefined, &give_grenade, "eq_nesting_doll_grenade");
			}

			if(isDefined(level.w_quantum_bomb)) {
				self synergy::add_option("QED", undefined, &give_grenade, level.w_quantum_bomb);
			}
			if(isDefined(level.w_black_hole_bomb)) {
				self synergy::add_option("Gersh Device", undefined, &give_grenade, level.w_black_hole_bomb);
			}

			break;
		case "Extras":
			self synergy::set_title(menu);

			load_weapons("extras");

			if(self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
				self synergy::add_option("Ray Gun", undefined, &give_weapon, "ray_gun");
				self synergy::add_option("Ray Gun Mark II", undefined, &give_weapon, "ray_gun_mk2");
			}

			if(self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
				self synergy::add_option("Winter's Howl", undefined, &give_weapon, "ww_freezegun_t8");
			}

			if(self.map_name == "voyage_of_despair") {
				self synergy::add_option("Ballistic Shield", undefined, &give_weapon, "zhield_dw");
				self synergy::add_option("Svalinn Guard", undefined, &give_weapon, "zhield_frost_dw");
				self synergy::add_option("Kraken", undefined, &give_weapon, "ww_tricannon_t8");
				self synergy::add_option("Decayed Kraken", undefined, &give_weapon, "ww_tricannon_earth_t8");
				self synergy::add_option("Plasmatic Kraken", undefined, &give_weapon, "ww_tricannon_fire_t8");
				self synergy::add_option("Purified Kraken", undefined, &give_weapon, "ww_tricannon_water_t8");
				self synergy::add_option("Radiant Kraken", undefined, &give_weapon, "ww_tricannon_air_t8");
			}

			if(self.map_name == "ix") {
				self synergy::add_option("Brazen Bull", undefined, &give_weapon, "zhield_zword_dw");
				self synergy::add_option("Death of Orion", undefined, &give_weapon, "ww_crossbow_t8");
			}

			if(self.map_name == "blood_of_the_dead") {
				self synergy::add_option("Spectral Shield", undefined, &give_weapon, "zhield_spectral_dw");
				self synergy::add_option("Blundergat", undefined, &give_weapon, "ww_blundergat_t8");
				self synergy::add_option("Magmagat", undefined, &give_weapon, "ww_blundergat_fire_t8");
				self synergy::add_option("Acidgat", undefined, &give_weapon, "ww_blundergat_acid_t8");
				self synergy::add_option("Tempered Blundergat", undefined, &give_weapon, "ww_blundergat_fire_t8_unfinished");
			}

			if(self.map_name == "classified") {
				self synergy::add_option("Ballistic Shield", undefined, &give_weapon, "zhield_dw");
			}

			if(self.map_name == "dead_of_the_night") {
				self synergy::add_option("Ballistic Shield", undefined, &give_weapon, "zhield_dw");
				self synergy::add_option("Savage Impaler", undefined, &give_weapon, "ww_crossbow_impaler_t8");
				self synergy::add_option("Alistair's Folly", undefined, &give_weapon, "ww_random_ray_gun1");
				self synergy::add_option("Chaos Theory", undefined, &give_weapon, "ww_random_ray_gun2");
				self synergy::add_option("Alistair's Annihilator", undefined, &give_weapon, "ww_random_ray_gun3");
			}

			if(self.map_name == "ancient_evil") {
				self synergy::add_option("Apollo's Will", undefined, &give_weapon, "zhield_zpear_dw");
				self synergy::add_option("Redeemed Hand of Ouranous", undefined, &give_weapon, "ww_hand_o");
				self synergy::add_option("Redeemed Hand of Hemera", undefined, &give_weapon, "ww_hand_h");
				self synergy::add_option("Redeemed Hand of Gaia", undefined, &give_weapon, "ww_hand_g");
				self synergy::add_option("Redeemed Hand of Charon", undefined, &give_weapon, "ww_hand_c");
			}

			if(self.map_name == "alpha_omega") {
				self synergy::add_option("Ballistic Shield", undefined, &give_weapon, "zhield_dw");
				self synergy::add_option("Ray Gun Mark II-V", undefined, &give_weapon, "ray_gun_mk2v");
				self synergy::add_option("Ray Gun Mark II-X", undefined, &give_weapon, "ray_gun_mk2x");
				self synergy::add_option("Ray Gun Mark II-Y", undefined, &give_weapon, "ray_gun_mk2y");
				self synergy::add_option("Ray Gun Mark II-Z", undefined, &give_weapon, "ray_gun_mk2z");
			}

			if(self.map_name == "tag_der_toten") {
				self synergy::add_option("Ballistic Shield", undefined, &give_weapon, "zhield_dw");
				self synergy::add_option("Snowballs", undefined, &give_weapon, "snowball");
				self synergy::add_option("Yellow Snowballs", undefined, &give_weapon, "snowball_yellow");
				self synergy::add_option("Thundergun", undefined, &give_weapon, "thundergun");
				self synergy::add_option("Tundragun", undefined, &give_weapon, "tundragun");
				self synergy::add_option("Wunderwaffe DG-2", undefined, &give_weapon, "ww_tesla_gun_t8");
				self synergy::add_option("Wunderwaffe DG-Scharfschutze", undefined, &give_weapon, "ww_tesla_sniper_t8");
			}

			if(self.map_name == "voyage_of_despair" || self.map_name == "ix" || self.map_name == "dead_of_the_night" || self.map_name == "ancient_evil") {
				self synergy::add_option("Chakrams of Vengeance", undefined, &give_weapon, "hero_chakram_lv3");
				self synergy::add_option("Hammer of Valhalla", undefined, &give_weapon, "hero_hammer_lv3");
				self synergy::add_option("Scepter of Ra", undefined, &give_weapon, "hero_scepter_lv3");
				self synergy::add_option("Viper and Dragon", undefined, &give_weapon, "hero_sword_pistol_lv3");
			}

			if(self.map_name == "blood_of_the_dead" || self.map_name == "classified" || self.map_name == "alpha_omega" || self.map_name == "tag_der_toten") {
				self synergy::add_option("Hellfire", undefined, &give_weapon, "hero_flamethrower_t8_lv3");
				self synergy::add_option("Overkill", undefined, &give_weapon, "hero_minigun_t8_lv3");
				self synergy::add_option("Path of Sorrows", undefined, &give_weapon, "hero_katana_t8_lv3");
				self synergy::add_option("Ragnarok DG-5", undefined, &give_weapon, "hero_gravityspikes_t8_lv3");
			}

			break;
		default:
			self synergy::add_option(synergy::empty_option());
			break;
	}
}

// Basic Options

god_mode() { //df7ef5e9
	self.god_mode = !synergy::return_toggle(self.god_mode);
	if(self.god_mode) {
		self iPrintlnBold("God Mode [^2ON^7]");
		self enableInvulnerability();
		god_mode_loop();
	} else {
		self iPrintlnBold("God Mode [^1OFF^7]");
		self notify("stop_god_mode");
		self disableInvulnerability();
	}
}

god_mode_loop() { //da01789c
	self endon("stop_god_mode");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		self enableInvulnerability();
		wait 0.1;
	}
}

frag_no_clip() { //b991b337
	level endon("game_ended");
	self endon("disconnect");

	if(!isDefined(self.frag_no_clip)) {
		self.frag_no_clip = true;
		self iPrintlnBold("Frag No Clip [^2ON^7], Press your ^3Equipment^7 Keybind to Enter and ^3Melee^7 to Exit");
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
		self iPrintlnBold("Frag No Clip [^1OFF^7]");
	}
}

frag_no_clip_loop() { //ec65b153
	self endon("noclip_end");
	level endon("game_ended");
	self endon("disconnect");

	self disableWeapons();
	self disableOffHandWeapons();
	self.frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.god_mode) || !self.god_mode) {
		self enableInvulnerability();
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
		self disableInvulnerability();
		self.temp_god_mode = undefined;
	}

	self.frag_no_clip_loop = undefined;
}

infinite_ammo() { //8a006f06
	self.infinite_ammo = !synergy::return_toggle(self.infinite_ammo);
	if(self.infinite_ammo) {
		self iPrintlnBold("Infinite Ammo [^2ON^7]");
		self thread infinite_ammo_loop();
	} else {
		self iPrintlnBold("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

infinite_ammo_loop() { //f4d0adea
	self endon("stop_infinite_ammo");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		weapons = self getWeaponsList();
		for(i = 0; i < weapons.size; i++) {
			self giveMaxAmmo(weapons[i]);
		}
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);

		for(i = 0; i < 3; i++) {
			self gadgetPowerSet(i, 100);
		}

		if(isDefined(self zm_loadout::get_player_tactical_grenade())) {
			self giveMaxAmmo(self zm_loadout::get_player_tactical_grenade());
		}

		if(isDefined(self zm_loadout::get_player_lethal_grenade())) {
			self giveMaxAmmo(self zm_loadout::get_player_lethal_grenade());
		}

		wait 0.05;
	}
}

infinite_shield() { //f636dc3f
	self.infinite_shield = !synergy::return_toggle(self.infinite_shield);
	if(self.infinite_shield) {
		self iPrintlnBold("Infinite Shield [^2ON^7]");
		self thread infinite_shield_loop();
	} else {
		self iPrintlnBold("Infinite Shield [^1OFF^7]");
		self notify("stop_infinite_shield");
	}
}

infinite_shield_loop() { //7efbf7ec
	self endon("stop_infinite_shield");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		self [[self.player_shield_reset_health]]();
		wait 2.5;
	}
}

give_perk(perk) { //47d6a43e
	if(!self hasPerk(perk)) {
		self thread zm_perks::wait_give_perk(perk);
	}
}

take_perk(perk) { //9cba355d
	if(self hasPerk(perk)) {
		self notify(perk + "_stop");
	}
}

give_perks() { //5ac66375
	self thread zm_perks::function_cc24f525(); // Lucy Menu
}

give_perkaholic() { //85f85c7e
	give_perks();
	for(i = 0; i < self.syn["perks"][0].size ; i++) {
		if(!self hasPerk(self.syn["perks"][0][i])) {
			self thread zm_perks::wait_give_perk(self.syn["perks"][0][i]);
		}
	}
}

take_perkaholic() { //88b48e0a
	for(i = 0; i < self.syn["perks"][0].size ; i++) {
		if(self hasPerk(self.syn["perks"][0][i])) {
			self notify(self.syn["perks"][0][i] + "_stop");
		}
	}
}

give_self_revive() { //50edb3e5
	self zm_laststand::function_3a00302e(); // Lucy Menu
}

give_elixir(elixir, type) { //620b4353
	self bgb::bgb_gumball_anim(hash(elixir));
	if(type == "timed") {
		self thread bgb::run_activation_func(elixir); // Lucy Menu
	} else {
		self thread bgb::run_activation_func(elixir); // Lucy Menu
	}
}

give_talisman(talisman) { //6741fec0
	switch(talisman) {
		case "talisman_box_guarantee_box_only":
			self.var_afb3ba4e = &set_box_only_box_weapons;
			self.var_c21099c0 = 1;
			break;
		case "talisman_box_guarantee_lmg":
			self.var_afb3ba4e = &set_box_lmg_only;
			self.var_c21099c0 = 1;
			break;
		case "talisman_coagulant":
			self.var_5c4f1263 = 1.5;
			break;
		case "talisman_impatient":
			self thread impatient_revive();
			break;
		case "talisman_extra_claymore":
			self.b_talisman_extra_claymore = 1;
			zm_loadout::register_lethal_grenade_for_level(#"claymore_extra");
			break;
		case "talisman_extra_frag":
			self.b_talisman_extra_frag = 1;
			zm_loadout::register_lethal_grenade_for_level(#"eq_frag_grenade_extra");
			break;
		case "talisman_extra_miniturret":
			self.b_talisman_extra_miniturret = 1;
			break;
		case "talisman_extra_molotov":
			self.var_ae031eed = 1;
			zm_loadout::register_lethal_grenade_for_level(#"eq_wraith_fire_extra");
			break;
		case "talisman_extra_semtex":
			self.b_talisman_extra_semtex = 1;
			zm_loadout::register_lethal_grenade_for_level(#"eq_acid_bomb_extra");
			break;
		case "talisman_weapon_reducepapcost":
			self.talisman_weapon_reducepapcost = 1000;
			break;
		case "talisman_shield_price":
			self.talisman_shield_price = 500;
			break;
		case "talisman_shield_durability_rare":
			self.var_9c2026aa = 0.2;
			break;
		case "talisman_shield_durability_legendary":
			self.var_9c2026aa = 0.33;
			break;
		case "talisman_perk_reducecost_1":
			self.talisman_perk_reducecost_1 = 1000;
			break;
		case "talisman_perk_reducecost_2":
			self.talisman_perk_reducecost_2 = 1000;
			break;
		case "talisman_perk_reducecost_3":
			self.talisman_perk_reducecost_3 = 1000;
			break;
		case "talisman_perk_reducecost_4":
			self.talisman_perk_reducecost_4 = 1000;
			break;
		case "talisman_perk_permanent_1":
			self.talisman_perk_permanent = 1;
			break;
		case "talisman_perk_permanent_2":
			self.talisman_perk_permanent = 2;
			break;
		case "talisman_perk_permanent_3":
			self.talisman_perk_permanent = 3;
			break;
		case "talisman_perk_permanent_4":
			self.talisman_perk_permanent = 4;
			break;
		case "talisman_perk_mod_single":
			self.talisman_perk_mod_single = 1;
			break;
		case "talisman_special_xp_rate":
			self.talisman_special_xp_rate = 1.3;
			break;
		case "talisman_special_startlv2":
			self.talisman_special_startlv2 = 1;
			break;
		case "talisman_special_startlv3":
			self.talisman_special_startlv3 = 1;
			break;
		default:
			break;
	}
}

set_point_increment(value) { //c9575d65
	self.point_increment = value;
}

set_points(value) { //c5e64d3
	self.score = 0;
	self zm_score::add_to_player_score(value);
}

add_points(value) { //12f6e7df
	self zm_score::add_to_player_score(value);
}

take_points(value) { //8c736c47
	self.score = int(self.score - value);
}

// Fun Options


set_speed(value) { //8b986195
	if(value == 1) {
		self.movement_speed = undefined;
	}
	self setMoveSpeedScale(value);
}

set_gravity(value) {
	setDvar(#"bg_gravity", value);
}

third_person() { //ed855e11
	self.third_person = !synergy::return_toggle(self.third_person);
	if(self.third_person) {
		self iPrintlnBold("Third Person [^2ON^7]");
		self setClientThirdPerson(1);
	} else {
		self iPrintlnBold("Third Person [^1OFF^7]");
		self setClientThirdPerson(0);
	}
}

// Player Options

player_option(menu, player) { //a3b23e83
	if(!isDefined(menu) || !isDefined(player) || !isPlayer(player)) {
		menu = "Error";
	}

	switch (menu) {
		case "Player Option":
			self synergy::set_title(clean_name(player get_name()));
			break;
		case "Error":
			self synergy::set_title();
			self synergy::add_option("Oops, Something Went Wrong!", "Condition: Undefined");
			break;
		default:
			error = true;
			if(error) {
				self synergy::set_title("Critical Error");
				self synergy::add_option("Oops, Something Went Wrong!", "Condition: Menu Index");
			}
			break;
	}
}

get_name() { //c91549ce
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

clean_name(name) { //675b8c0
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = ["^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "^:"];
	new_string = "";
	for(a = 0; a < name.size; a++) {
		if(a < (name.size - 1)) {
			if(array::contains(illegal, (name[a] + name[(a + 1)]))) {
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

print_name(target) { //c4da1a2b
	self iPrintlnBold(target.name);
}

verify_player(target) { //b5373ddb
	target.access = "Verified";
	target thread initialize_verified_menu();
}

// Map Options

freeze_box() { //2adb77b5
	self.freeze_box = !synergy::return_toggle(self.freeze_box);
	if(self.freeze_box) {
		self iPrintlnBold("Freeze Box [^2ON^7]");
		wait 5;
		level.chest_min_move_usage = 999;
	} else {
		self iPrintlnBold("Freeze Box [^1OFF^7]");
		wait 5;
		level.chest_min_move_usage = 4;
	}
}

open_doors() { //42505bef
	types = array("zombie_door", "zombie_airlock_buy", "zombie_debris");
	foreach(type in types) {
		zombie_doors = getEntArray(type, "targetname");
		foreach(door in zombie_doors) {
			if(isDefined(door)) {
				if(isDefined(door.power_door_ignore_flag_wait) && door.power_door_ignore_flag_wait) {
					door notify(#"power_on");
				}
				door.zombie_cost = 0;
				door notify(#"trigger", {#activator: self});
			}
		}
	}
	level notify(#"open_sesame");
}

open_narrative_room() { // Atian Menu - 57ba8289
	if(!self.narrative_open) {
		self thread open_narrative_room_thread();
	}
}

open_narrative_room_thread() { // Atian Menu - 89cd6cce
	level notify(#"fake_waittill");
	if(self.map_name == "voyage_of_despair") {
		level flag::set(#"open_lore_room");
		baphomets_entry_clip = getEnt("baphomets_entry_clip", "targetname");
    baphomets_entry_clip moveTo(baphomets_entry_clip.origin + (0, 0, 160), 1.6);
		baphomets_entry = getEnt("baphomets_entry", "targetname");
		baphomets_entry rotateYaw(125, 1.6);
	} else if(self.map_name == "ix") {
		exploder::exploder("exp_lgt_body_pit_secret_room");
		level clientfield::set("" + #"hash_2383fd01b106ced8", 1);
		lore_room_doors = getEntArray("lore_room", "targetname");
		foreach(door in lore_room_doors) {
			door moveTo(door.origin + (0, 0, -160), 2.2);
		}
	} else if(self.map_name == "blood_of_the_dead") {
    level flag::set(#"activate_infirmury");
    door = getEnt("cr_door", "targetname");
    door rotateYaw(90, 1.6);
    var_3400a741 = getEntArray("cr_door_bar", "targetname");
    var_3400a741[0] moveTo(var_3400a741[0].origin + (0, 0, -80), 0.001);
    var_3400a741[1] moveTo(var_3400a741[1].origin + (0, 0, -80), 0.001);
	} else if(self.map_name == "dead_of_the_night") {
		level util::clientnotify("show_narrative_dotn");
	} else if(self.map_name == "alpha_omega") {
		door = getEnt("bread_door", "targetname");
		door rotateTo(door.angles + (vectorScale((0, -1, 0), 170)), 1);
		door waittill(#"movedone");
		door disconnectPaths();
		blocker = spawn("trigger_box", (-800, -1070, -132), 0, 408, 164, 132);
		blocker disconnectPaths();
  }
	level clientfield::set("" + #"narrative_room", 1);
	self.narrative_open = true;
}

power_on() { //a2ad3104
	if(self.map_name == "blood_of_the_dead") {
		level thread zm_utility::enable_power_switch(1, 1, "power_house_power_switch", "script_noteworthy");
		level thread zm_utility::enable_power_switch(1, 1, "building_64_switches", "script_noteworthy");
	} else {
		level thread zm_utility::enable_power_switch(1, 1);
	}
}

pick_up_parts() { //46d60064
	if(isDefined(level.parts_collected)) {
	  return;
	}

	all_parts = getitemarray();

	foreach(item in all_parts) {
		part = item.item;
		if(isDefined(part) && isDefined(part.craftItem) && part.craftItem) {
			self zm_items::player_pick_up(self, part);
			item delete();
		}
	}

	level.parts_collected = true;
}

// Powerup Options

spawn_powerup(powerup) { //a6188a5c
	zm_powerups::specific_powerup_drop(powerup, self.origin + anglesToForward(self.angles) * 115);
}

shoot_powerups() { //fe39a316
	self.shoot_powerups = !synergy::return_toggle(self.shoot_powerups);
	if(self.shoot_powerups) {
		self iPrintlnBold("Shoot Powerups [^2ON^7]");
		self thread shoot_powerups_loop();
	} else {
		self iPrintlnBold("Shoot Powerups [^1OFF^7]");
		self notify("stop_shoot_powerups");
	}
}

shoot_powerups_loop() { //d38fcbee
	self endon("stop_shoot_powerups");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		while(self attackButtonPressed()) {
			powerup = self.syn["powerups"][0][randomint(self.syn["powerups"][0].size)];
			zm_powerups::specific_powerup_drop(powerup, self.origin + anglesToForward(self.angles) * 115);
			wait 0.1;
		}
		wait 0.05;
	}
}

// Weapon Options

give_grenade(grenade_string) { //9270d7fd
	grenade = getWeapon(grenade_string);
	if(isDefined(self zm_loadout::get_player_lethal_grenade())) {
		self takeWeapon(self zm_loadout::get_player_lethal_grenade());
		self zm_loadout::set_player_lethal_grenade(grenade);
	}

	if(grenade_string == "homunculus") {
		zm_magicbox::give_offhand_weapon(level.w_homunculus);
	}

	self giveWeapon(grenade);
	self giveMaxAmmo(grenade);
}

give_packed_weapon(pap_level) { //e376eef7
	self.give_packed_weapon = pap_level;
}

give_weapon(weapon) { //5be7a94b
	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon >= 1) {
		if(weapon == "ray_gun_mk2x") {
			weapon = "ray_gun_mk2x_dw";
		} else if(weapon == "ww_tesla_sniper_t8") {
			weapon = "ww_tesla_sniper_upgraded_t8";
		} else if(!isInArray(self.syn["weapons"]["blacklisted_weapons"], weapon)) {
			weapon = weapon + "_upgraded";
		}
	}

	weapon = getWeapon(weapon);

	if(!has_weapon(weapon)) {
		max_weapon_num = zm_utility::get_player_weapon_limit(self);

		if(self getWeaponsListPrimaries().size >= max_weapon_num) {
			self takeWeapon(self getCurrentWeapon());
		}

		self zm_weapons::give_build_kit_weapon(weapon);

		if(isDefined(self.give_packed_weapon) && self.give_packed_weapon >= 2) {
			if(!isInArray(self.syn["weapons"]["blacklisted_weapons"], weapon)) {
				self zm_pap_util::repack_weapon(weapon, self.give_packed_weapon);
			}
		}

		wait 0.25;
		self giveStartAmmo(weapon);
	} else {
		if(self getCurrentWeapon().rootWeapon != weapon.rootWeapon) {
			foreach(equipped_weapon in self getWeaponsListPrimaries()) {
				if(equipped_weapon.rootWeapon == weapon.rootWeapon) {
					self switchToWeaponImmediate(equipped_weapon);
					break;
				}
			}
		}
	}

	if(weapon.rootWeapon.name == "zhield_frost_dw") {
		self aat::acquire(getWeapon("zhield_frost_dw"), "zm_aat_frostbite");
		self zm_pap_util::repack_weapon(getWeapon("zhield_frost_dw"), 4);
		self.var_5ba94c1e = 1;
	}
}

give_mastercraft_weapon(null, mastercraft_index, weapon, offset) { //72d8cec0
	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon >= 1) {
		weapon_upgraded = weapon + "_upgraded";
		weapon = weapon_upgraded;
	}

	current_weapon = self getCurrentWeapon();
	if(getWeapon(weapon).rootWeapon.name == current_weapon.rootWeapon.name) {
		weapon = current_weapon;
	} else {
		weapon = getWeapon(weapon);
	}

	if(!isDefined(mastercraft_index)) {
		synergy::scroll_slider();
		mastercraft_index = int(self.slider[(self.current_menu + "_" + self.structure[self.syn["cursor"].index].label + "_" + (self.syn["cursor"].index))] + 1);
	}

	if(isDefined(offset) && isInt(offset)) {
		mastercraft_index = int(mastercraft_index) + offset;
	}

	self.syn["mastercraft"][weapon.rootWeapon.name] = mastercraft_index;

	weapon_options = self calcWeaponOptions(0, 0, mastercraft_index);

	max_weapon_num = zm_utility::get_player_weapon_limit(self);

	if(self getWeaponsListPrimaries().size >= max_weapon_num) {
		self takeWeapon(self getCurrentWeapon());
	}

	self giveWeapon(weapon, weapon_options);

	if(isDefined(self.give_packed_weapon) && self.give_packed_weapon >= 2) {
		self zm_pap_util::repack_weapon(weapon, self.give_packed_weapon);
	}

	wait 0.25;
	self giveStartAmmo(weapon);
}

get_weapon_attachments() { //de099fee
	weapon = self getCurrentWeapon();

	if(weapon == getWeapon(#"none")) {
		return;
	}

	supported_attachments = weapon.supportedAttachments;

	foreach(blacklisted_attachment in self.syn["blacklisted_attachments"]) {
		if(isInArray(supported_attachments, blacklisted_attachment)) {
			supported_attachments = synergy::remove_from_array(supported_attachments, blacklisted_attachment);
		}
	}

	return supported_attachments;
}

function get_attachment_name(attachment) { //44ecc3e9
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
	return attachment;
}

get_equipped_attachments(weapon) { //b04978d6
	attachments = array();
	equipped = strTok(getWeaponName(weapon), "+");

	for (i = 1; i < equipped.size; i++) {
		attachments[attachments.size] = equipped[i];
	}

	return attachments;
}

equip_attachment(attachment, i) { //224c09c9
	weapon = self getCurrentWeapon();

	stock = self getWeaponAmmoStock(weapon);
	clip = self getWeaponAmmoClip(weapon);
	attachments = get_equipped_attachments(weapon);

	if(isArray(attachments)) {
		if(isInArray(attachments, attachment)) {
			attachments = synergy::remove_from_array(attachments, attachment);
		} else {
			if(isInArray(self.syn["optics"], attachment)) {
				foreach(optic in self.syn["optics"]) {
					if(isInArray(attachments, optic)) {
						attachments = synergy::remove_from_array(attachments, optic);
					}
				}
			}

			attachments[attachments.size] = attachment;
		}
		weapon = getWeapon(weapon.rootWeapon.name, attachments);
	}

	camo_index = getCamoIndex(self getBuildKitWeaponOptions(weapon));
	if(!isDefined(camo_index) || !isInt(camo_index)) {
		camo_index = 0;
	}

	mastercraft_index = 0;
	if(isDefined(self.syn["mastercraft"][weapon.rootWeapon.name])) {
		mastercraft_index = self.syn["mastercraft"][weapon.rootWeapon.name];
	}

	self takeWeapon(self getCurrentWeapon());

	weapon_options = self calcWeaponOptions(camo_index, 0, mastercraft_index);

	self giveWeapon(weapon, weapon_options);

	self setWeaponAmmoStock(weapon, stock);
	self setWeaponAmmoClip(weapon, clip);
	self setSpawnWeapon(weapon, true);
}

equip_camo(camo_index) { //52f76807
	weapon = self getCurrentWeapon();
	self setCamo(weapon, camo_index);
}

give_aat(value) { //78647a00
	weapon = self getCurrentWeapon();
	self thread aat::acquire(weapon, value);
}

take_aat() { //a1be53c6
	weapon = self getCurrentWeapon();
	self thread aat::remove(weapon);
}

take_weapon() { //5e8f396d
	self takeWeapon(self getCurrentWeapon());
	self switchToWeapon(self getWeaponsListPrimaries()[0]);
}

drop_weapon() { //84172a80
	self dropItem(self getCurrentWeapon());
}

max_specialist_points() { //1ae20b96
	self.max_specialist_points = !synergy::return_toggle(self.max_specialist_points);
	if(self.max_specialist_points) {
		self iPrintlnBold("Max Specialist Points Requirement [^2ON^7]");
		self.var_d11656b = 100;
		self.var_9f176816 = 17500;
	} else {
		self iPrintlnBold("Max Specialist Points Requirement [^1RESET^7]");
		self.var_d11656b = 0;
		self.var_9f176816 = 3000;
	}
}

// Zombie Options

get_zombies() { //81b284e5
	return getAITeamArray(level.zombie_team);
}

no_target() { //1a890726
	self.no_target = !synergy::return_toggle(self.no_target);
	if(self.no_target) {
		self iPrintlnBold("No Target [^2ON^7]");
		self val::set(#"escort_robot", "ignoreme");
	} else {
		self iPrintlnBold("No Target [^1OFF^7]");
		self val::reset(#"escort_robot", "ignoreme");
	}
}

set_round(value) { //e8352140
	value--;
	self thread zm_utility::zombie_goto_round(value);
	zombie_utility::ai_calculate_health(zombie_utility::get_zombie_var(#"zombie_health_start"), value);
}

set_round_increment(value) { //40a31539
	self.round_increment = int(value);
}

show_real_round() { //69e13f08
	self.show_real_round = !synergy::return_toggle(self.show_real_round);
	if(self.show_real_round) {
		self iPrintlnBold("Show Real Round [^2ON^7]");
		self luinotifyevent(#"synergy_extra_text_1", 2, 200002, 1);
		self luinotifyevent(#"synergy_extra_text_1", 4, 200001, 160, 4, 4);
		self luinotifyevent(#"synergy_extra_text_1", 3, 200008, 3, 0);
		self luinotifyevent(#"synergy_extra_text_1", 2, 200010, 1);
		synergy::set_lui_element_y("extra_text_1", (self.y_offset - 175));
		self thread show_real_round_loop();
	} else {
		self iPrintlnBold("Show Real Round [^1OFF^7]");
		self notify("stop_show_real_round");
		self luinotifyevent(#"synergy_extra_text_1", 2, 200002, 0);
		self luinotifyevent(#"synergy_extra_text_1", 4, 200001, 127, 127, 127);
		self luinotifyevent(#"synergy_extra_text_1", 3, 200008, 1, 0);
		self luinotifyevent(#"synergy_extra_text_1", 2, 200010, 0);
		synergy::set_lui_element_x("extra_text_1", (self.x_offset + 400));
		synergy::set_lui_element_y("extra_text_1", (self.y_offset - 350));
		synergy::set_text("extra_text_1", "");
	}
}

show_real_round_loop() { //9111f303
	self endon("stop_show_real_round");
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		round_number = zm_round_logic::get_round_number();

		if(round_number <= 2) {
			synergy::set_lui_element_x("extra_text_1", (self.x_offset - 1160));
		} else if(round_number == 4 || round_number == 5) {
			synergy::set_lui_element_x("extra_text_1", (self.x_offset - 1135));
		} else if(round_number == 3 || round_number < 10) {
			synergy::set_lui_element_x("extra_text_1", (self.x_offset - 1145));
		} else if(round_number >= 10 && round_number < 100) {
			synergy::set_lui_element_x("extra_text_1", (self.x_offset - 1150));
		} else {
			synergy::set_lui_element_x("extra_text_1", (self.x_offset - 1130));
		}

		synergy::set_text("extra_text_1", round_number);

		level waittill(#"between_round_over", #"end_of_round", #"restart_round", #"start_of_round", #"start_zombie_round_logic");
	}
}


spawn_normal_zombie() { //5237db24
	spawner = array::random(level.zombie_spawners);
	zombie = zombie_utility::spawn_zombie(spawner, spawner.targetName);
}

spawn_zombie(spawner) { //253cbb6e
	zombie = zombie_utility::spawn_zombie(spawner, spawner.targetName);
}

kill_all_zombies() { //57f97468
	level.zombie_total = 0;
	foreach(zombie in get_zombies()) {
		if(isDefined(zombie)) {
			zombie doDamage(zombie.health * 5000, (0, 0, 0));
			wait 0.05;
		}
	}
}

teleport_zombies() { //819e635b
	foreach(zombie in get_zombies()) {
		if(isDefined(zombie)) {
			zombie forceTeleport(self.origin + anglesToForward(self.angles) * 115);
		}
	}
}

one_shot_zombies() { //ad42a823
	if(!isDefined(self.one_shot_zombies)) {
		self iPrintlnBold("One Shot Zombies [^2ON^7]");
		self.one_shot_zombies = true;
		zombies = get_zombies();
		while(!isDefined(zombies) || zombies.size < 1) {
			zombies = get_zombies();
			wait 0.1;
		}
		level.prev_health = zombies[0].health;
		while(isDefined(self.one_shot_zombies)) {
			foreach(zombie in get_zombies()) {
				if(isDefined(zombie)) {
					zombie.maxHealth = 1;
					zombie.health = zombie.maxHealth;
				}
			}
			wait 0.1;
		}
	} else {
		self iPrintlnBold("One Shot Zombies [^1OFF^7]");
		self.one_shot_zombies = undefined;
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie.maxHealth = level.prev_health;
				zombie.health = level.prev_health;
			}
		}
	}
}

freeze_zombies() { //af046923
	if(!isDefined(self.freeze_zombies)) {
		self.freeze_zombies = true;
		while (isDefined(self.freeze_zombies)) {
			foreach(zombie in get_zombies()) {
				if(isDefined(zombie)) {
					if(isAlive(zombie) && !zombie isPaused()) {
						freeze_zombie(zombie);
					}
				}
			}
			wait 0.1;
		}
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				unfreeze_zombie(zombie);
			}
		}
	} else {
		self.freeze_zombies = undefined;
	}
}

freeze_zombie(zombie) { //e29f9dcb
	zombie thread freeze_zombie_death();
	zombie setEntityPaused(1);
	zombie.b_ignore_cleanup = 1;
	zombie.is_inert = 1;
}

freeze_zombie_death() { //f48da8e4
	self waittill(#"death");
	if(isDefined(self) && self isPaused()) {
		self setEntityPaused(0);
		if(!self isRagdoll()) {
			self startRagdoll();
		}
	}
}

unfreeze_zombie(zombie) { //d644a7f7
	zombie setEntityPaused(0);
	zombie.is_inert = 0;
	zombie.b_ignore_cleanup = 0;
}

slow_zombies() { //f386ca4e
	if(!isDefined(self.slow_zombies)) {
		self iPrintlnBold("Slow Zombies [^2ON^7]");
		self.slow_zombies = true;
		while(isDefined(self.slow_zombies)) {
			foreach(zombie in get_zombies()) {
				if(isDefined(zombie)) {
					zombie.b_widows_wine_slow = 1;
					zombie asmSetAnimationRate(0.7);
					zombie clientField::set("winters_wail_freeze", 1);
				}
			}
			wait 0.1;
		}
	} else {
		self iPrintlnBold("Slow Zombies [^1OFF^7]");
		self.slow_zombies = undefined;
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie.b_widows_wine_slow = 0;
				zombie asmSetAnimationRate(1);
				zombie clientField::set("winters_wail_freeze", 0);
			}
		}
	}
}

disable_spawns() { //64827754
	self.disable_spawns = !synergy::return_toggle(self.disable_spawns);
	if(self.disable_spawns) {
		self iPrintlnBold("Disable Spawns [^2ON^7]");
		level flag::clear("spawn_zombies");
	} else {
		self iPrintlnBold("Disable Spawns [^1OFF^7]");
		level flag::set("spawn_zombies");
	}
}

disable_transformations() { //5db4f2f5
	self.disable_transformations = !synergy::return_toggle(self.disable_transformations);
	if(self.disable_transformations) {
		self iPrintlnBold("Disable Transformations [^2ON^7]");
		while(isDefined(self.disable_transformations)) {
			if(!isDefined(level.var_88de5053) || level.var_88de5053 != 0) {
				level.var_88de5053 = 0;
			}
			wait 1;
		}
	} else {
		self iPrintlnBold("Disable Transformations [^1OFF^7]");
		self.disable_transformations = undefined;
		level.var_88de5053 = 3;
	}
}

set_zombie_speed(speed) { //5f4e093d
	speed = toLower(speed);

	if(speed == "super sprint") {
		speed = "super_sprint";
	}

	if(!isDefined(level.run_cycle)) {
		level.run_cycle = "restore";
	}
	if(level.run_cycle != speed) {
		level.run_cycle = speed;
	}

	spawner::remove_global_spawn_function("zombie", &update_zombie_speed);
	if(level.run_cycle != "restore") {
		spawner::add_archetype_spawn_function("zombie", &update_zombie_speed);
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie thread update_zombie_speed();
			}
		}
	} else {
		foreach(zombie in get_zombies()) {
			if(isDefined(zombie)) {
				zombie zombie_utility::set_zombie_run_cycle_restore_from_override();
			}
		}
	}
}

update_zombie_speed() { //772907d2
	if(level.run_cycle == "super_sprint" && !(isDefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area)) {
		self waittill(#"death", #"completed_emerging_into_playable_area");
	}
	if(level.run_cycle != "restore") {
		self zombie_utility::set_zombie_run_cycle(level.run_cycle);
	}
}