local old_hud = CoD.DemoUtility.AddHUDWidgets

CoD.DemoUtility.AddHUDWidgets = function(HudRef, InstanceRef)
	local self = HudRef
	local controller = InstanceRef

	self:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function (model)
		if CoD.ModelUtility.IsParamModelEqualToHashString(model, @"synergy_menu") then
			local scriptData = CoD.GetScriptNotifyData(model)
			local element

			if scriptData[1] < 100100 then
				element = LUI.UIImage.new(0, 0, scriptData[2], scriptData[3], 0, 0, scriptData[4], scriptData[5])

				element:setAlpha(scriptData[6])
				if scriptData[7] ~= nil then
					element:setRGB(scriptData[7] / 255, scriptData[7] / 255, scriptData[7] / 255)
				end
			elseif scriptData[1] >= 100101 and scriptData[1] < 100130 then
				element = LUI.UIText.new(0, 0, scriptData[2], scriptData[2] + 500, 0, 0, scriptData[3], scriptData[3] + 25)
				element:setAlpha(scriptData[7])
			elseif scriptData[1] >= 100130 and scriptData[1] < 100150 then
				element = LUI.UIText.new(0, 0, scriptData[2], scriptData[2] + 500, 0, 0, scriptData[3], scriptData[3] + 22)
				element:setAlpha(scriptData[7])
			end

			if scriptData[1] >= 100001 and scriptData[1] <= 100020 then
				local elements = element
				elements:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function (model)
					if CoD.ModelUtility.IsParamModelEqualToHashString(model, @"synergy_element_" .. tostring(scriptData[1] - 100000)) then
						local scriptData = CoD.GetScriptNotifyData(model)
						if scriptData[1] == 200001 then
							elements:setRGB(scriptData[2] / 255, scriptData[3] / 255, scriptData[4] / 255)
						elseif scriptData[1] == 200002 then
							elements:setAlpha(scriptData[2])
						elseif scriptData[1] == 200003 then
							elements:setHeight(scriptData[2])
						elseif scriptData[1] == 200005 then
							elements:setLeftRight(0, 0, scriptData[2], 0)
							if scriptData[3] ~= nil then
								elements:setWidth(scriptData[3])
							end
						elseif scriptData[1] == 200006 then
							elements:setTopBottom(0, 0, scriptData[2], 0)
							if scriptData[3] ~= nil then
								elements:setHeight(scriptData[3])
							end
						end
					end
				end)
				self:addElement(elements)
			end

			if scriptData[1] >= 100021 and scriptData[1] < 100030 then
				local toggles = element
				toggles:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function (model)
					if CoD.ModelUtility.IsParamModelEqualToHashString(model, @"synergy_toggle_" .. tostring(scriptData[1] - 100020)) then
						local scriptData = CoD.GetScriptNotifyData(model)
						if scriptData[1] == 200001 then
							toggles:setRGB(scriptData[2] / 255, scriptData[3] / 255, scriptData[4] / 255)
						elseif scriptData[1] == 200002 then
							toggles:setAlpha(scriptData[2])
						elseif scriptData[1] == 200003 then
							toggles:setHeight(scriptData[2])
						elseif scriptData[1] == 200005 then
							toggles:setLeftRight(0, 0, scriptData[2], 0)
							toggles:setWidth(16)
						elseif scriptData[1] == 200006 then
							toggles:setTopBottom(0, 0, scriptData[2], 0)
							toggles:setHeight(16)
						end
					end
				end)
				self:addElement(toggles)
			end

			if scriptData[1] >= 100030 and scriptData[1] < 100040 then
				local sliders = element
				sliders:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function (model)
					if CoD.ModelUtility.IsParamModelEqualToHashString(model, @"synergy_slider_" .. tostring(scriptData[1] - 100030)) then
						local scriptData = CoD.GetScriptNotifyData(model)
						if scriptData[1] == 200001 then
							sliders:setRGB(scriptData[2] / 255, scriptData[3] / 255, scriptData[4] / 255)
						elseif scriptData[1] == 200002 then
							sliders:setAlpha(scriptData[2])
						elseif scriptData[1] == 200004 then
							sliders:setWidth(scriptData[2])
						elseif scriptData[1] == 200005 then
							sliders:setLeftRight(0, 0, scriptData[2], 0)
						elseif scriptData[1] == 200006 then
							sliders:setTopBottom(0, 0, scriptData[2], 0)
							sliders:setHeight(32)
						end
					end
				end)
				self:addElement(sliders)
			end

			if scriptData[1] >= 100101 and scriptData[1] < 100200 then
				local text = element

				local text_name = ""

				if scriptData[1] == 100101 then
					text:setRGB(1, 1, 1)
					text_name = "title"
				elseif scriptData[1] == 100102 then
					text:setRGB(0.75, 0.75, 0.75)
					text_name = "description"
					text:setScale(0.9)
				else
					text:setRGB(0.5, 0.5, 0.5)
				end

				if scriptData[1] >= 100110 and scriptData[1] < 100120 then
					text_name = "option_" .. tostring(scriptData[1] - 100109)
				elseif scriptData[1] >= 100120 and scriptData[1] < 100130 then
					text_name = "slider_text_" .. tostring(scriptData[1] - 100119)
				elseif scriptData[1] >= 100130 and scriptData[1] < 100140 then
					text_name = "submenu_icon_" .. tostring(scriptData[1] - 100129)
				elseif scriptData[1] >= 100140 and scriptData[1] < 100150 then
					text_name = "extra_text_" .. tostring(scriptData[1] - 100139)
				end

				text:setTTF("ttmussels_demibold")

				text:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function (model)
					if CoD.ModelUtility.IsParamModelEqualToHashString(model, @"synergy_" .. text_name) then
						local scriptData = CoD.GetScriptNotifyData(model)
						if scriptData[1] == 200001 then
							text:setRGB(scriptData[2] / 255, scriptData[3] / 255, scriptData[4] / 255)
						elseif scriptData[1] == 200002 then
							text:setAlpha(scriptData[2])
						elseif scriptData[1] == 200007 then
							if scriptData[2] == 0 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_title"))
							elseif scriptData[2] == 1 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_description"))
							elseif scriptData[2] == 2 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_option_" .. tostring(scriptData[3])))
							elseif scriptData[2] == 3 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_slider_text_" .. tostring(scriptData[3])))
							elseif scriptData[2] == 4 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_submenu_icon_" .. tostring(scriptData[3])))
							elseif scriptData[2] == 5 then
								text:setText(Engine[@"getdvarstring"]("laboratory_special_offer_extra_text_" .. tostring(scriptData[3])))
							end
						elseif scriptData[1] == 200005 then
							text:setLeftRight(0, 0, scriptData[2], 0)
							text:setWidth(500)
						elseif scriptData[1] == 200006 then
							text:setTopBottom(0, 0, scriptData[2], 0)
							text:setHeight(25)
						elseif scriptData[1] == 200008 then
							text:setScale(tonumber(scriptData[2] .. "." .. tostring(scriptData[3])), tonumber(scriptData[2] .. "." .. tostring(scriptData[3])))
						elseif scriptData[1] == 200009 then
							text:setHeight(25 * tonumber("0." .. tostring(scriptData[2])))
						end
					end
				end)
				self:addElement(text)
			end

			element = nil
		end
	end)
	old_hud(HudRef, InstanceRef)
	return self
end