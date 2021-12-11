local mod = get_mod("ranaldsblessing")

mod.randomize = function()
	mod:pcall(function()
			if Managers.state.game_mode:level_key() ~= "inn_level" then
				mod:echo("Can only randomize at the Keep.")
				return
			end
	
			local player = Managers.player:local_player()
			local career_name = player:career_name()
			
			local inventory_extension = ScriptUnit.extension(player.player_unit, "inventory_system")
			
			
			mod:echo("Randomizing talents.")
			Managers.backend:get_interface("talents"):set_talents(career_name, {
				math.random(3),
				math.random(3),
				math.random(3),
				math.random(3),
				math.random(3),
				math.random(3),
			})
			
			
			mod:echo("Randomizing equipment.")
			
			local backend_items = Managers.backend:get_interface("items")
			
			local availableItems = backend_items:get_all_backend_items()
			
			local availableMelee = {}
			local availableRanged = {}
			local availableNecklace = {}
			local availableRing = {}
			local availableTrinket = {}
			
			for _, item in pairs(availableItems) do
				if item.power_level == 300 then
					if table.contains(item.data.can_wield, career_name) then
						if item.data.slot_type == "melee" then
							availableMelee[#availableMelee+1] = item
						end
						if item.data.slot_type == "ranged" then
							availableRanged[#availableRanged+1] = item
						end
						if item.data.slot_type == "necklace" then
							availableNecklace[#availableNecklace+1] = item
						end
						if item.data.slot_type == "ring" then
							availableRing[#availableRing+1] = item
						end
						if item.data.slot_type == "trinket" then
							availableTrinket[#availableTrinket+1] = item
						end
					end
				end
			end
			
			local chosenMelee = availableMelee[math.random(#availableMelee)]
			local chosenRanged
			
			if career_name == "es_questingknight" or career_name == "dr_slayer" or career_name == "wh_priest" then --Grail Knight, Slayer, and Warrior Priest use two melee weapons
				chosenRanged = availableMelee[math.random(#availableMelee)]
				attempt = 1
				while chosenRanged.backend_id == chosenMelee.backend_id do --Don't equip same item in both melee slots
					if attempt >= 10 then
						mod:echo("Can't find 2 melee weapons to equip, aborting.")
						return
					end
					attempt = attempt + 1
					chosenRanged = availableMelee[math.random(#availableMelee)]
				end
			else
				chosenRanged = availableRanged[math.random(#availableRanged)]
			end
			
			local chosenNecklace = availableNecklace[math.random(#availableNecklace)]
			local chosenRing = availableRing[math.random(#availableRing)]
			local chosenTrinket = availableTrinket[math.random(#availableTrinket)]
			
			BackendUtils.set_loadout_item(chosenMelee.backend_id, career_name, "slot_melee")
			inventory_extension:create_equipment_in_slot("slot_melee", chosenMelee.backend_id)
			
			BackendUtils.set_loadout_item(chosenRanged.backend_id, career_name, "slot_ranged")
			inventory_extension:create_equipment_in_slot("slot_ranged", chosenRanged.backend_id)
			
			BackendUtils.set_loadout_item(chosenNecklace.backend_id, career_name, "slot_necklace")
			
			BackendUtils.set_loadout_item(chosenRing.backend_id, career_name, "slot_ring")
			
			BackendUtils.set_loadout_item(chosenTrinket.backend_id, career_name, "slot_trinket_1")
			
	end
	)
end

mod:command("random", mod:localize("randomize_command_description"), function() mod.randomize() end)