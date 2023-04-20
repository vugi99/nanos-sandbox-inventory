

local Sandbox_Inventory_Slots = 3


local In_SpawnItem_Call = false
local default_weap_destroy

Package.Subscribe("Load", function()
    local found
    for k, v in pairs(Server.GetPackages(true)) do
        if v.name == "sandbox" then
            found = true
            break
        end
    end
    if found then
        --print(Modularity.AwareOfAllEvents("sandbox"))
        if not Modularity.AwareOfAllEvents("sandbox") then
            Modularity.AccessAllEvents()
        else
            default_weap_destroy = Modularity.OverwriteEntityClassFunction("Weapon", "Destroy", function(weap, ...)
                --print("Overwritten Destroy Call")
                local inv_full = false
                if weap:IsValid() then
                    local handler = weap:GetHandler()
                    if (handler and handler:IsValid()) then
                        local inv = GetCharacterInventory(handler)
                        if (inv and inv.weapons) then
                            inv_full = (#inv.weapons >= Sandbox_Inventory_Slots)
                        end
                    end
                end
                if (not In_SpawnItem_Call or inv_full) then
                    return default_weap_destroy(weap, ...)
                end
            end)
            local kef_remote_spawnitem = Modularity.GetKnownRemoteEventsFunctions("Events", "sandbox", "SpawnItem", "INDEPENDENT_SUBS")
            if kef_remote_spawnitem then
                for k, v in pairs(kef_remote_spawnitem) do
                    if k then
                        Modularity.PreHook(k, function()
                            In_SpawnItem_Call = true
                        end)
                        Modularity.EndHook(k, function()
                            In_SpawnItem_Call = false
                        end)
                    end
                    break
                end
            else
                Console.Warn("sandbox-inventory : Cannot find the SpawnItem remote event")
            end
        end
    else
        Console.Warn("sandbox-inventory : Sandbox is not loaded")
    end
end)

local function _SI_CreateInv(char)
    CreateCharacterInventory(char, Sandbox_Inventory_Slots, true, false)
end

Player.Subscribe("Possess", function(ply, char)
    _SI_CreateInv(char)
end)
for k, v in pairs(Player.GetPairs()) do
    if (v and v:IsValid()) then
        local char = v:GetControlledCharacter()
        if char then
            _SI_CreateInv(char)
        end
    end
end

Events.SubscribeRemote("InventorySwitchSlot", function(ply, slot)
    local char = ply:GetControlledCharacter()
    if char then
        local charInvID = GetCharacterInventoryID(char)
        if charInvID then
            if CharactersInventories[charInvID].slots_nb >= slot then
                EquipSlot(char, slot)
            end
        end
    end
end)

