res = require 'resources'
require 'weapon_skill_elements'

function get_sets()
	sets.base = {}
	sets.base["TP"] = {
		head={name="Taeon chapeau",augments={'STR+7 CHR+7','Accuracy+17','"Dual Wield"+4'}},
		body="Foire tobe +1",
		hands={name="Taeon gloves",augments={'"Triple Atk."+1'}},
		legs={name="Taeon tights",augments={'VIT+3','Accuracy+5','"Triple Atk."+1'}},
		feet="Ryuo sune-ate",
		neck="Asperity necklace",
		waist="Windbuffet belt",
		back={name="Dispersal mantle",augments={'STR+2','DEX+3','Pet: TP Bonus+320'}},
		ear1="Bladeborn earring",
		ear2="Steelflash earring",
		ring1="Rajas ring",
		ring2="Enlivened ring"
	}	
	sets.base["Pet Tank"] = {
		head="Pitre taj",
		body="Foire tobe +1",
		hands={name="Taeon gloves",augments={'Evasion+7','Pet: "Dbl. Atk."+3','STR+5'}},
		legs={name="Taeon tights",augments={'Pet: Evasion+16','Pet: "Dbl. Atk."+4','STR+4 CHR+4'}},
		feet={name="Taeon Boots",augments={'Pet: Attack+9 Pet: Rng.Atk.+9','Pet: "Dbl. Atk."+3','STR+5 VIT+5'}},
		neck="Asperity necklace",
		waist="Kuku stone",
		back={name="Dispersal mantle",augments={'STR+2','DEX+3','Pet: TP Bonus+320'}},
		ear1="Handler's earring",
		ear2="Charivari earring",
		ring1="Rajas ring",
		ring2="Enlivened ring"
	}

	sets.misc = {}
	sets.misc["Bonus CP"] = {
		back="Aptitude mantle"
	}	
	
	sets.precast = {}
	sets.precast.maneuver = {
		hands = "Foire dastanas",
		neck = "Buffoon's collar",
		body = "Cirque farsetto +1",
		back = "Dispersal mantle"
	}	
	sets.precast['Repair'] = {
		feet = 'Puppetry babouches'
	}
	
	sets.aftercast = {}
	sets.aftercast.idle = {
		head = "Pitre taj",
		neck = "Orochi nodowa"
	}
	
	sets.active = sets.base["TP"]
	equip(sets.active)
	
	send_command('input /macro book 3')
end

function precast(spell)
	if sets.precast[spell.english] then
		equip(sets.active, sets.precast[spell.english])		
	elseif string.find(spell.english, 'Maneuver') then
		equip(sets.active, sets.precast.maneuver)		
	elseif spell.type == "WeaponSkill" then
		local weapon_skill_set = build_weapon_skill_set(spell.english)
		equip(sets.active, weapon_skill_set)			
	end
end

function aftercast(spell)
	if spell.english == 'Repair' then
		local bags = {'inventory','wardrobe','wardrobe2','wardrobe3','wardrobe4'}
		local repair_oil_id = 19185
		local total_oils = 0
		local player_bags = windower.ffxi.get_items()
		
		-- Loop through each bag looking for oils.
		for bagId=1, 3 do
			local current_bag = player_bags[bags[bagId]]
			local max_items = player_bags['count_'..bags[bagId]]
			
			for i=1, max_items do			
				local current_item = current_bag[i]
				
				if current_item.id == repair_oil_id then
					total_oils = total_oils + current_item.count				
				end
			end
		end		
		
		add_to_chat(8,'Total oils: '..total_oils)
	end
	
	if player.status == 'Engaged' then
		equip(sets.active)
	else
		equip(set_combine(sets.active, sets.aftercast.idle))
	end
end

function status_change(new, old)
    if T{'Idle', 'Resting'}:contains(new) then
        equip(sets.aftercast.idle)
    elseif new == 'Engaged' then
        equip(sets.active)
    end
end

function self_command(command)
	command = command:lower()
	
	if string.find(command, 'set_') then
		if command == 'set_tp' then
			sets.active = set_combine(sets.active, sets.base["TP"])
			send_command('input /echo TP Gear Enabled')		
		elseif command == 'set_cp' then
			sets.active = set_combine(sets.active, sets.misc["Bonus CP"])
			send_command('input /echo Bonus CP Gear Enabled')		
		elseif command == 'set_pet_tank' then
			sets.active = set_combine(sets.active, sets.base["Pet Tank"])
			send_command('input /echo Pet Tank Gear Enabled')
		else
			windower.console.write('Unknown set: '..command)
			return
		end
		
		equip(sets.active)
		send_command('input /echo Gear Equipped')
	end
end