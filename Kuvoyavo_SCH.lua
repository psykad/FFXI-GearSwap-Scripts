function get_sets()
	sets.base = {
		main="Eminent staff",
		sub="Vivid Strap",
		ammo="Witchstone",
		head="Kaabnax hat",
		body={name="Hagondes Coat",augments={'Phys. dmg. taken -3%','"Fast Cast"+3'}},
		hands="Helios Gloves",
		legs="Assiduity Pants",
		feet="Academic's Loafers'",
		neck="Elemental torque",
		waist="Salire Belt",
		left_ear="Lifestorm Earring",
		right_ear="Psystorm Earring",
		left_ring="Shiva Ring",
		right_ring="Shiva Ring",
		back="Swith Cape"
	}
	
	sets.precast = {}
	sets.precast.fast_cast = {
		sub="Vivid strap",
		head={name="Telchine Cap",augments={'"Fast Cast"+3'}},
		body={name="Hagondes Coat",augments={'Phys. dmg. taken -3%','"Fast Cast"+3'}},
		feet={name="Telchine Pigaches",augments={'"Fast Cast"+2'}}
	}
	
	sets.midcast = {}
	sets.midcast['Elemental Magic'] = {
		main="Eminent staff",	
		sub="Elementa grip",
		head="Helios Band",
		body="Hagondes Coat",		
		neck="Elemental torque",
		back="Hecate's cape"
	}
	sets.midcast['Enfeebling Magic'] = {
		main="Eminent staff",
		sub="Macero grip",
		neck="Enfeebling torque"
	}	
	sets.midcast['Enhancing Magic'] = {
		main="Eminent staff",
		head="Kaabnax Hat",
		neck="Enhancing torque",
		body="Telchine Chasuble",
		hands="Telchine Gloves",
		legs="Assiduity Pants",
		feet="Telchine Pigaches"
	}
	sets.midcast['Healing Magic'] = {
		main="Light staff",
		body="Errant houppleande",
		feet="Argute loafers",
		neck="Fylgja torque",
		back="Tempered Cape"
	}	
	sets.midcast['Dark Magic'] = {
		legs="Argute pants"
	}
	
	sets.aftercast = {}
	sets.aftercast.idle = {
		main="Earth staff",
		neck="Orochi nodowa"
	}
	sets.aftercast.idle.no_sub = set_combine(sets.base, sets.aftercast.idle, {
		head="Helios Band",
		body={name="Hagondes Coat",augments={'Phys. dmg. taken -3%','"Fast Cast"+3'}}
	})
	sets.aftercast.idle.sub = set_combine(sets.base, sets.aftercast.idle, {
		head="Scholar's mortarboard",
		body={name="Hagondes Coat",augments={'Phys. dmg. taken -3%','"Fast Cast"+3'}}
	})

	sets.resting = {}

	sets.elements = {}
	sets.elements['Light'] = {main="Light staff",waist="Korin obi"}
	sets.elements['Dark'] = {waist="Anrin obi"}
	sets.elements['Fire'] = {main="Vulcan's staff",waist="Karin obi"}
	sets.elements['Ice'] = {main="Aquilo's staff",waist="Hyorin obi"}
	sets.elements['Wind'] = {waist="Furin obi"}
	sets.elements['Earth'] = {main="Earth staff",waist="Dorin obi"}
	sets.elements['Lightning'] = {main="Jupiter's staff",waist="Rairin obi"}
	sets.elements['Water'] = {waist="Suirin obi"}
	
	sets.arts = {}
	sets.arts['Light'] = {}
	sets.arts['Dark'] = {
		body="Academic's Gown"
	}
	
	arts = {}	
	arts['Light'] = {}
	arts['Light'].types = {'Divine Magic','Healing Magic','Enhancing Magic','Enfeebling Magic'}
	arts['Light'].stratagems = {}
	arts['Light'].stratagems['stratagem_cost'] = "Penury"
	arts['Light'].stratagems['stratagem_speed'] = "Celerity"
	arts['Light'].stratagems['stratagem_aoe'] = "Accession"
	arts['Light'].stratagems['stratagem_potency'] = "Rapture"
	arts['Light'].stratagems['stratagem_accuracy'] = "Altruism"
	arts['Light'].stratagems['stratagem_emnity'] = "Tranquility"
	arts['Light'].stratagems['stratagem_enhance'] = "Perpetuance"
	arts['Dark'] = {}
	arts['Dark'].types = {'Elemental Magic','Dark Magic','Enfeebling Magic'}
	arts['Dark'].stratagems = {}
	arts['Dark'].stratagems['stratagem_cost'] = "Parsimony"
	arts['Dark'].stratagems['stratagem_speed'] = "Alacrity"
	arts['Dark'].stratagems['stratagem_aoe'] = "Manifestation"
	arts['Dark'].stratagems['stratagem_potency'] = "Ebullience"
	arts['Dark'].stratagems['stratagem_accuracy'] = "Focalization"
	arts['Dark'].stratagems['stratagem_emnity'] = "Equanimity"
	arts['Dark'].stratagems['stratagem_enhance'] = "Immanence"

	sets.active = sets.base
	sets.aftercast.idle.current = sets.aftercast.idle.no_sub

	send_command('input /macro book 6')
end

function precast(spell)
	if spell.skill == '(N/A)' then return end
	
	if spell.action_type == 'Magic' then
		-- Reset precast set.
		local precast_set = sets.active
		
		-- Set gear for Fast Cast
		local fastcast_set = sets.precast.fast_cast
		
		-- Equip precast set.
		equip(precast_set, fastcast_set)
	end
end

function midcast(spell)
	if spell.skill == '(N/A)' then return end
	
	if spell.action_type == 'Magic' then		
		-- Reset midacst set.
		local midcast_set = sets.active
		
		-- Set gear for current skill.
		local skill_set = sets[spell.skill] ~= nil and sets[spell.skill] or {}

		-- Set gear for active Art.
		local active_art = get_active_art()	
		local art_set = active_art ~= 'None' and sets.arts[active_art] or {}
		
		-- Set gear for current day.
		local current_day = get_day()
		local day_set = current_day ~= 'None' and sets.elements[current_day] or {}
		
		-- Set gear for active weather.
		local current_weather = get_weather()
		local weather_set = current_weather ~= 'None' and sets.elements[current_weather] or {}
		
		-- Check if speed stratagem is active.
		is_speed_stratagem_active = buffactive['Celerity'] or buffactive['Alacrity']
		
		-- Check if speed stratagem is active for the current spell element.
		if is_speed_stratagem_active and spell.element == current_weather then
			weather_set = set_combine(weather_set, {feet="Argute loafers"})
		end
		
		-- Warn if magic type is not valid for active art.
		if active_art ~= 'None' and T(arts[active_art].types):contains(spell.skill) == false then
			add_to_chat(8,'--------- Wrong Art Active ---------')
		end
		
		-- Equip final precast set.
		-- Note: Weather gear takes priority over day gear.
		midcast_set = set_combine(midcast_set, art_set, skill_set, day_set, weather_set)
		equip(midcast_set)
	end
end 

function aftercast(spell)
	if spell.skill == '(N/A)' then return end
	
	if player.status == 'Engaged' then
		equip(sets.active)
	else
		equip(set_combine(sets.active, sets.aftercast.idle.current))
	end
end

function buff_change(name, gain)
	if name == 'Sublimation: Complete' and gain == true then
		sets.aftercast.idle.current = sets.aftercast.idle.no_sub
		add_to_chat(8,'--------- Sublimation Ready ---------')
	elseif name == 'Sublimation: Activated' then
		sets.aftercast.idle.current = sets.aftercast.idle.sub
	end
	
	equip(set_combine(sets.active, sets.aftercast.idle.current))
end

function status_change(new, old)
    if T{'Idle','Resting'}:contains(new) then
        equip(set_combine(sets.active, sets.aftercast.idle.current))
    elseif new == 'Engaged' then
        equip(sets.active)
    end
	
	-- Check if Sublimation is charging.
	if not buffactive['Sublimation: Complete'] and not buffactive['Sublimation: Activated'] then
		add_to_chat(8, '---------- Sublimation Not Active!!! ----------')
	end
end

function self_command(command)
	input = command:lower()
	
	if string.find(input, 'stratagem_') then				
		active_art = get_active_art()
		
		if active_art ~= 'None' then
			send_command('input /ja "'..arts[active_art].stratagems[input]..'" <me>')
		end
	elseif string.find(input, 'addendum') then
		active_art = get_active_art()
		
		if active_art == 'Light' then
			addendum = "Addendum: White"
		elseif active_art == 'Dark' then
			addendum = "Addendum: Black"
		end

		if active_art ~= 'None' then		
			send_command('input /ja "'..addendum..'" <me>')
		end
	end
end

function get_active_art()
	if buffactive['Light Arts'] or buffactive['Addendum: White'] then
		return "Light"
	elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
		return "Dark"
	else		
		return "None"
	end
end

function get_weather()
	return world.weather_element
end

function get_day()
	return world.day_element
end