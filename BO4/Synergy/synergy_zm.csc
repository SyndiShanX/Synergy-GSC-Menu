#include scripts\core_common\system_shared;

#namespace synergy_zm;

autoexec __init__sytem__() { //607fee8
	system::register("synergy_zm", &init, undefined, undefined);
}

init() { //9284135d
	level waittill("show_narrative_dotn");

	function_a5777754(0, "narrative_room");
  function_a5777754(1, "narrative_room");
  function_a5777754(2, "narrative_room");
  function_a5777754(3, "narrative_room");
}