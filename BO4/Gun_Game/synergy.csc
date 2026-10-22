#include scripts\core_common\system_shared;
#include scripts\core_common\util_shared;

#namespace synergy;

autoexec __init__system__() { //89f2df9
	system::register("synergy", &init, undefined, undefined);
}

init() { //9284135d
	self.model_created = array();
	util::register_system("synergy_text", &set_text);
}

set_text(localClientNum, newVal, oldVal) { //d5ea17f0
	if(newVal != "") {
		if(strTok(newVal, "||").size > 1) {
			element = strTok(newVal, "||")[0];
			string = strTok(newVal, "||")[1];

			if(!isDefined(self.model_created[element])) {
				model = CreateUIModel(GetUIModelForController(localClientNum), element);
				self.model_created[element] = true;
			} else {
				model = GetUIModel(GetUIModelForController(localClientNum), element);
			}
			SetUIModelValue(model, string);
		} else {
			shieldLog("^5 String Error: " + newVal);
		}
	}
}