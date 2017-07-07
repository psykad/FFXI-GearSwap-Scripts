require 'weapon_skill_elements'
res = require 'resources'

function get_sets()
	sets.precast = {}
    sets.precast.fast_cast = {
        head={ name="Telchine Cap", augments={'"Fast Cast"+3',}},
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Fast Cast"+3',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+2',}},
        back="Swith Cape"
    }

    sets.midcast = {}
    sets.midcast['Blue Magic'] = {}
    sets.midcast['Healing Magic'] = {
        hands={ name="Telchine Gloves", augments={'"Cure" spellcasting time -3%',}},
        back="Tempered Cape"
    }

    sets.aftercast = {}    
    sets.aftercast.idle = {
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Fast Cast"+3',}},
        neck="Orochi Nodowa"
    }
    
    sets.base_tp = {
        head={ name="Taeon Chapeau", augments={'Accuracy+17','"Dual Wield"+4','STR+7 CHR+7',}},
        body={ name="Taeon Tabard", augments={'Evasion+8','"Triple Atk."+1',}},
        hands={ name="Taeon Gloves", augments={'"Triple Atk."+1',}},
        legs={ name="Taeon Tights", augments={'Accuracy+5','"Triple Atk."+1','VIT+3',}},
        feet={ name="Taeon Boots", augments={'Weapon Skill Acc.+10',}},
        neck="Asperity Necklace",
        waist="Windbuffet Belt",
        left_ear="Suppanomimi",
        right_ear="Heartseeker Earring",
        left_ring="Rajas Ring",
        right_ring="Enlivened Ring",
        back={ name="Cornflower Cape", augments={'MP+25','Accuracy+3','Blue Magic skill +5',}}
    }
    sets.base_magic = {
        head={ name="Telchine Cap", augments={'"Fast Cast"+3',}},
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Fast Cast"+3',}},
        hands="Helios Gloves",
        legs={ name="Helios Spats", augments={'Magic crit. hit rate +3',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+2',}},
        neck="Orochi Nodowa",
        waist="Windbuffet Belt",
        left_ear="Lifestorm Earring",
        right_ear="Psystorm Earring",
        left_ring="Shiva Ring",
        right_ring="Shiva Ring",
        back={ name="Cornflower Cape", augments={'MP+25','Accuracy+3','Blue Magic skill +5',}}
    }
    sets.base_cp = {
        back="Nomad's Mantle"
    }
    
    sets.misc = {}
    sets.misc.learning = {
        hands = "Magus Bazubands"
    }
    
    sets.weaponskills = {}
    sets.weaponskills['Requiescat'] = {
        head={ name="Telchine Cap", augments={'"Fast Cast"+3',}},
        body="Telchine Chas.",
        hands={ name="Telchine Gloves", augments={'"Cure" spellcasting time -3%',}},
        legs={ name="Helios Spats", augments={'Magic crit. hit rate +3',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+2',}},
        right_ear="Lifestorm Earring",
        back={ name="Cornflower Cape", augments={'MP+25','Accuracy+3','Blue Magic skill +5',}}
    }
    
    sets.elements = {}
	sets.elements['Light'] = {waist="Korin obi"}
	sets.elements['Dark'] = {waist="Anrin obi"}
	sets.elements['Fire'] = {wait="Karin obi"}
	sets.elements['Ice'] = {waist="Hyorin obi"}
	sets.elements['Wind'] = {waist="Furin obi"}
	sets.elements['Earth'] = {waist="Dorin obi"}
	sets.elements['Lightning'] = {waist="Rairin obi"}
	sets.elements['Water'] = {waist="Suirin obi"}
	
	sets.active = set_combine(sets.base_tp)
    
    spells = {}
    spells.healing = T{'Pollen','Wild Carrot','Magic Fruit','Healing Breeze','Exuviation'}
    
	send_command('input /macro book 7')
end

function precast(spell)
    if spell.skill == '(N/A)' then return end
    
	if spell.action_type == 'Magic' then
		-- Set gear for Fast Cast
		local fastcast_set = sets.precast.fast_cast
		
		-- Equip precast set.
		equip(sets.active, fastcast_set)
	elseif spell.type == "WeaponSkill" then
        local weaponskill_main_set = sets.weaponskills[spell.english] ~= nil and sets.weaponskills[spell.english] or {}
		local weaponskill_element_set = build_weapon_skill_set(spell.english)

		equip(sets.active, weaponskill_main_set, weaponskill_element_set)
	end    
end

function midcast(spell)
    if spell.skill == '(N/A)' then return end
    
	if spell.action_type == 'Magic' then
        -- Set gear for current skill.
        local skill_set = sets.midcast[spell.skill] ~= nil and sets.midcast[spell.skill] or {}

        -- Set elemental obi.
        local spell_element = res.elements[res.spells[spell.id].element].english
        local elemental_set = sets.elements[spell_element] ~= nil and sets.elements[spell_element] or {}
        
        -- Set misc gear.
        local misc_set = {}
        
        -- Set cure potency.
        if spells.healing:contains(spell.english) then
            misc_set = set_combine(misc_set, sets.midcast['Healing Magic'])
        end

	    equip(sets.active, skill_set, elemental_set, misc_set)
	end	
end 

function aftercast(spell)
    if spell.skill == '(N/A)' then return end
    
	if player.status == 'Engaged' then
		equip(sets.active)
	else
		equip(sets.active, sets.aftercast.idle)
	end
end

function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
        equip(sets.active, sets.aftercast.idle)
    elseif new == 'Engaged' then
        equip(sets.active)
    end
end

function self_command(command)
	command = command:lower()
	
	if string.find(command, 'set_') then
		if command == 'set_tp' then
			sets.active = sets.base_tp
			send_command('input /echo TP Gear Enabled')
        elseif command == 'set_magic' then
            sets.active = sets.base_magic
            send_command('input /echo Magic Gear Enabled')
        elseif command == 'set_cp' then
            sets.active = sets.base_cp
            send_command('input /echo CP Gear Enabled')
        elseif command == 'set_learning' then
            sets.active = set_combine(sets.active, sets.misc.learning)
            send_command('input /echo Learning Gear Enabled')
		end
		
		equip(sets.active)
		send_command('input /echo Gear Equipped')
	end
end