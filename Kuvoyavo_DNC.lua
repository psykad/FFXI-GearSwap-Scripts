require 'weaponSkillElements'

function get_sets()
	sets.precast = {}
	sets.precast.Waltz = {
		head = "Etoile tiara",
		body = "Maxixi casaque",
		legs = "Dashing subligar",
		back = "Totapper mantle"
	}   		
	sets.precast.Step = {
		feet = "Horos toe shoes"
	}
	sets.precast["Reverse Flourish"] = {
		hands = "Charis bangles +1"
	}
	
	sets.Base = {
		head = {name="Taeon chapeau",augments={'STR+7 CHR+7','Accuracy+17','"Dual Wield"+4'}},
		body = {name="Taeon tabard",augments={'"Triple Atk."+1'}},
		hands = {name="Taeon gloves",augments={'"Triple Atk."+1'}},
		legs = {name="Taeon tights",augments={'VIT+3','Accuracy+5','"Triple Atk."+1'}},
		feet = {name="Taeon boots",augments={'Weapon Skill Acc.+10'}},
		neck = "Asperity necklace",
		waist = "Windbuffet belt",
		back = "Toetapper mantle",
		ear1 = "Bladeborn earring",
		ear2 = "Steelflash earring",		
		ring1 = "Rajas ring",
		ring2 = "Enlivened ring"
	}
	
	sets.DualWield = {
		neck = "Charis necklace",
		ear1 = "Dudgeon earring",
		ear2 = "Heartseeker earring"
	}
	
	sets.BonusCP = {
		back = "Aptitude mantle"
	}
	
	sets.Tank = {
		feet = "Horos toe shoes"
	}
	
	sets.Active = set_combine(sets.Base, sets.DualWield)
	
	sets.Idle = {
		neck = "Orochi nodowa"
	}
	
	send_command('input /macro book 5')
end

function precast(spell)
	if sets.precast[spell.english] then
		equip(set_combine(sets.Active, sets.precast[spell.english]))
	elseif string.find(spell.english, 'Waltz') then
		equip(set_combine(sets.Active, sets.precast.Waltz))
	elseif string.find(spell.english, 'Step') then
		equip(set_combine(sets.Active, sets.precast.Step))
	elseif spell.type == "WeaponSkill" then
		local wsSet = buildWeaponSkillSet(spell.english)
		equip(set_combine(sets.Active, wsSet))
	end
end

function aftercast(spell)
	if player.status == 'Engaged' then
		equip(sets.Active)
	else
		equip(set_combine(sets.Active, sets.Idle))
	end
end

function status_change(new,old)
    if T{'Idle', 'Resting'}:contains(new) then
        equip(set_combine(sets.Active, sets.Idle))
    elseif new == 'Engaged' then
        equip(sets.Active)
    end
end

function self_command(command)
	command = command:lower()
	
	if string.find(command, 'set_') then
		if command == 'set_tp' then
			sets.Active = set_combine(sets.Active, sets.Base)
			send_command('input /echo TP Gear Enabled')
		elseif command == 'set_dw' then
			sets.Active = set_combine(sets.Active, sets.DualWield)
			send_command('input /echo DualWield Gear Enabled')
		elseif command == 'set_cp' then
			sets.Active = set_combine(sets.Active, sets.BonusCP)
			send_command('input /echo Bonus CP Gear Enabled')		
		elseif command == 'set_tank' then
			sets.Active = set_combine(sets.Active, sets.Tank)
			send_command('input /echo Tank Gear Enabled')
		end
		
		equip(sets.Active)
		send_command('input /echo Gear Equipped')
	end
end