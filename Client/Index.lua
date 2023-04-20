

local InventoryKeyBindings = {
	QWERTY = {
		["One"] = 1,
		["Two"] = 2,
		["Three"] = 3,
		["Four"] = 4,
		["Five"] = 5,
		["Six"] = 6,
		["Seven"] = 7,
		["Eight"] = 8,
		["Nine"] = 9,
	},
	AZERTY_FR = {
		["Ampersand"] = 1,
		["E_AccentAigu"] = 2,
		-- Those keys open the console
		--["Quote"] = 3, 
		--["Apostrophe"] = 4,
		["LeftParantheses"] = 3,
		["Hyphen"] = 4,
		["E_AccentGrave"] = 5,
		["Underscore"] = 6,
		["C_Cedille"] = 7,
	}
}

Input.Subscribe("KeyPress", function(key_name, delta)
	local ply = Client.GetLocalPlayer()
	if ply then
		local char = ply:GetControlledCharacter()
		if char then
			local slot
			for k, v in pairs(InventoryKeyBindings) do
				if v[key_name] then
					slot = v[key_name]
					break
				end
			end
			if slot then
				Events.CallRemote("InventorySwitchSlot", slot)
			end
		end
	end
end)

--print(Modularity.AwareOfAllEvents("sandbox"))