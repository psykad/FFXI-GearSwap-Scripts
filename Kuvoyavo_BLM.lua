function get_sets()
	sets.base = {
		head = "Kaabnax hat",
		body = "Hagondes coat",
		hands = "Otomi gloves",
		legs = "Wayfarer slops",
		feet = "Wayfarer clogs",
		neck = "Elemental torque",
		back = "Bane cape",
		waist = "Salire belt",
		ear1 = "Moldavite earring",
		ear2 = "Abyssal earring",
		ring1 = "Shiva ring",
		ring2 = "Shiva ring",
		main = "Eminent staff",
		sub = "Elementa grip",		
		ammo = "Witchstone"
	}
	
	sets.obis = {}
	sets.obis["Light"] = { waist = "Korin obi" }
	sets.obis["Dark"] = { waist = "Anrin obi" }
	sets.obis["Fire"] = { waist = "Karin obi" }
	sets.obis["Ice"] = { waist = "Hyorin obi" }
	sets.obis["Wind"] = { waist = "Furin obi" }
	sets.obis["Earth"] = { waist = "Dorin obi" }
	sets.obis["Lightning"] = { waist = "Rairin obi" }
	sets.obis["Water"] = { waist = "Suriin obi" }
	
	sets.skill = {}
	sets.skill['Elemental Magic'] = {
		neck = "Elemental torque",
		sub = "Elementa grip"		
	}
	
	sets.skill['Enfeebling Magic'] = {	
		neck = "Enfeebling torque",
		sub = "Macero grip"
	}
	
	sets.skill['Healing Magic'] = {
		back = "Tempered cape",
		main = "Iradal staff"
	}
	
	sets.skill['Dark Magic'] = {}
	sets.skill['Enhancing Magic'] = {}
	sets.skill['Divine Magic'] = {}

	sets.fastCast = {
		body = "Hagondes coat",
		feet = "Rostrum pumps",
		back = "Swith cape",
		sub = "Vivid strap"
	}
	
	sets.idle = {
		body = "Hagondes coat",
		legs = "Assiduity pants"
	}
	
	sets.resting = {
		body = "Errant houppelande",
		neck = "Grandiose chain",
		waist = "Hierarch belt",
		ear1 = "Antivenom earring",
		main = "Iridal staff"
	}
	
	sets.active = sets.base
	
	send_command('input /macro book 4')
end

function precast(spell)
	if spell.action_type == 'Magic' then	
		equip(set_combine(sets.Active, sets.FastCast))
	end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		local midcastSet = sets.active
		
		-- Build skill set.
		local skillSet = sets.skill[spell.skill] ~= nil and sets.skill[spell.skill] or {} 
				
		-- Build element set.
		local element = world.weather_element ~= 'None' and world.weather_element or world.day_element
		local elementSet = sets.obis[element]		
		
		midcastSet = set_combine(midcastSet, skillSet, elementSet)
		equip(midcastSet)
	end
end

function aftercast(spell)
	equip(set_combine(sets.Active, sets.Idle))
end

function status_change(new,old)
    if new == 'Idle' then	
        equip(set_combine(sets.Active, sets.Idle))
	elseif new == 'Resting' then
		equip(set_combine(sets.Active, sets.Resting))
    end
end

function self_command(command)
	print(world.weather_element or world.day_element)
	if command:lower() == 'macc' then		
		sets.Active = set_combine(sets.Active, sets['Elemental Magic'])
		send_command('input /echo Magic Accuracy Gear Enabled')
	end
	
	equip(sets.Active)
	send_command('input /echo Gear Equipped')
end