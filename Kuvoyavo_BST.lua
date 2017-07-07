res = require 'resources'
require 'weapon_skill_elements'

function get_sets()
	sets.base = {}
	sets.base["TP"] = {
		head = {name="Taeon chapeau",augments={'STR+7 CHR+7','Accuracy+17','"Dual Wield"+4'}},
		body={ name="Taeon Tabard", augments={'Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: "Regen"+3',}},
		hands = {name="Taeon gloves",augments={'"Triple Atk."+1'}},
		legs = {name="Taeon tights",augments={'VIT+3','Accuracy+5','"Triple Atk."+1'}},
		feet = {name="Taeon boots",augments={'Weapon Skill Acc.+10'}},
		neck="Asperity Necklace",
		waist="Windbuffet Belt",
		left_ear="Steelflash Earring",
		right_ear="Bladeborn Earring",
		left_ring="Rajas Ring",
		right_ring="Enlivened Ring",
		back={ name="Pastoralist's Mantle", augments={'STR+3 DEX+3','Accuracy+2','Pet: Accuracy+19 Pet: Rng. Acc.+19','Pet: Damage taken -1%',}}
	}
	sets["Pet DD"] = {
		head = {name="Taeon chapeau",augments={'STR+7 CHR+7','Accuracy+17','"Dual Wield"+4'}},
		body={ name="Taeon Tabard", augments={'Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: "Regen"+3',}},
		hands={name="Taeon gloves",augments={'Evasion+7','Pet: "Dbl. Atk."+3','STR+5'}},
		legs={name="Taeon tights",augments={'Pet: Evasion+16','Pet: "Dbl. Atk."+4','STR+4 CHR+4'}},
		feet={name="Taeon Boots",augments={'Pet: Attack+9 Pet: Rng.Atk.+9','Pet: "Dbl. Atk."+3','STR+5 VIT+5'}},
		neck="Asperity Necklace",
		waist="Kuku Stone",
		left_ear="Steelflash Earring",
		right_ear="Handler's Earring",
		left_ring="Rajas Ring",
		right_ring="Enlivened Ring",
		back={ name="Pastoralist's Mantle", augments={'STR+3 DEX+3','Accuracy+2','Pet: Accuracy+19 Pet: Rng. Acc.+19','Pet: Damage taken -1%',}}
	}		

	sets.misc = {}
	sets.misc.bastok = {
		body="Republic aketon"
	}
	sets.misc.pet_food = {
		ammo="Pet Food Theta"
	}
	sets.misc.bonus_cp = {			
		back = "Aptitude mantle"	
	}

	sets.precast = {}
	sets.precast.JA = {}
	sets.precast.JA["Call Beast"] = {
		hands="Monster Gloves"
	}
	sets.precast.JA["Charm"] = {
		head='Monster Helm',
		body='Monster Jackcoat',
		hands='Monster Gloves',
		feet='Monster Gaiters'
	}
	sets.precast.JA["Reward"] = {
		body='Monster Jackcoat',
		feet='Monster Gaiters'
	}
	
	sets.aftercast = {}
	sets.aftercast.idle = {
		neck="Orochi Nodowa"
	}
	
	sets.active = sets["Pet DD"]
	equip(sets.active)
	
	send_command('input /macro book 8')
end

function precast(spell)
	if spell.type == 'WeaponSkill' then
		local weapon_skill_set = build_weapon_skill_set(spell.english)
		equip(sets.active, weapon_skill_set)
	elseif spell.type == 'JobAbility' then
		if sets.precast.JA[spell.name] then
			equip(sets.precast.JA[spell.name])
		end

		-- Equip food before Rewarding pet.
		if spell.name == 'Reward' then
			equip(sets.misc.pet_food)
		elseif spell.name == 'Gauge' then
			equip(sets.precast.JA['Charm'])
		end
	end
end

function aftercast(spell)
	if player.status == 'Engaged' then
		equip(sets.active)
	else
		equip(set_combine(sets.active, sets.aftercast.idle))
	end
end

function status_change(new, old)
    if T{'Idle', 'Resting'}:contains(new) then
		local idle_set = sets.aftercast.idle
		
		-- Check if in Bastok to wear aketon.
		local player_info = windower.ffxi.get_info()

		if T{234,235,236,237}:contains(player_info.zone) then
			idle_set = set_combine(idle_set, sets.misc.bastok)
		end

        equip(idle_set)
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
		elseif command == 'set_pet_dd' then		
			sets.active = set_combine(sets.active, sets["Pet DD"])
			send_command('input /echo Pet DD Gear Enabled')
		elseif command == 'set_cp' then
			sets.active = set_combine(sets.active, sets.misc.bonus_cp)
			send_command('input /echo CP Gear Enabled')
		else
			windower.console.write('Unknown set: '..command)
			return
		end
		
		equip(sets.active)
		send_command('input /echo Gear Equipped')	
	end
end