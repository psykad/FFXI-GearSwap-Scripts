res = require 'resources'

local elemental_gorgets = {
	['Fire'] = {}, -- {neck="Flame gorget"},
	['Ice'] = {}, -- {neck="Snow gorget"},
	['Wind'] = {}, -- {neck="Breeze gorget"},
	['Earth'] = {}, -- {neck="Soil gorget"},
	['Thunder'] = {}, -- {neck="Thunder gorget"},
	['Water'] = {}, -- {neck="Aqua gorget"},
	['Light'] = {neck="Light gorget"},
	['Dark'] = {} -- {neck="Shadow gorget"}
}

local elemental_belts = {
	['Fire'] = {waist="Flame belt"},
	['Ice'] = {}, -- {waist="Snow belt"},
	['Wind'] = {waist="Breeze belt"},
	['Earth'] = {}, -- {waist="Soil belt"},
	['Thunder'] = {}, -- {waist="Thunder belt"},
	['Water'] = {}, -- {waist="Aqua belt"},
	['Light'] = {}, -- {waist="Light belt"},
	['Dark'] = {}, -- {waist="Shadow belt"}	
}

local skillchains = {
	['Light'] = {elements={"Light","Fire","Thunder","Wind"}},
	['Darkness'] = {elements={"Dark","Earth","Water","Ice"}},
	['Gravitation'] = {elements={"Dark","Earth"}},
	['Fragmentation'] = {elements={"Thunder","Wind"}},
	['Distortion'] = {elements={"Water","Ice"}},
	['Fusion'] = {elements={"Light","Fire"}},
	['Compression'] = {elements={"Dark"}},
	['Liquefaction'] = {elements={"Fire"}},
	['Induration'] = {elements={"Ice"}},
	['Reverberation'] = {elements={"Water"}},
	['Transfixion'] = {elements={"Light"}},
	['Scission'] = {elements={"Earth"}},
	['Detonation'] = {elements={"Wind"}},
	['Impaction'] = {elements={"Thunder"}}
}

function build_weapon_skill_set(weapon_skill_name)
	local weapon_skill = nil

	-- Find weapon skill from resources.
	for _, item in pairs(res.weapon_skills) do
		if item.en == weapon_skill_name then
			weapon_skill = item
		end
	end
		
	-- Return an empty set if weapon skill was not found.
	if weapon_skill == nil then return {} end
	
	-- Build element list based on weapon skill skill chains.
	local weapon_skill_elements = {}
	extract_skillchain_elements(weapon_skill.skillchain_a, weapon_skill_elements)
	extract_skillchain_elements(weapon_skill.skillchain_b, weapon_skill_elements)
	extract_skillchain_elements(weapon_skill.skillchain_c, weapon_skill_elements)
	
	-- Iterate through each element.
	local weapon_skill_set = {}
	
	for i=1, #weapon_skill_elements do
		local gorget = elemental_gorgets[weapon_skill_elements[i]]
		local belt = elemental_belts[weapon_skill_elements[i]]
						
		weapon_skill_set = set_combine(weapon_skill_set, gorget, belt)
	end
	
	return weapon_skill_set
end

function extract_skillchain_elements(skillchain_name, element_table)
	if skillchain_name == "" then return end
	
	for i=1, #skillchains[skillchain_name].elements do
		local element = skillchains[skillchain_name].elements[i]
		
		table.insert(element_table, element)
	end	
end