local gorgets = {}
gorgets.Light = { neck = "Light gorget" }
gorgets.Dark = {} -- { neck = "Shadow gorget" }
gorgets.Fire = {} -- { neck = "Flame gorget" }
gorgets.Ice = {} -- { neck = "Snow gorget" }
gorgets.Wind = {} -- { neck = "Breeze gorget" }
gorgets.Earth = {} -- { neck = "Soil gorget" }
gorgets.Thunder = {} -- { neck = "Thunder gorget" }
gorgets.Water = {} -- { neck = "Aqua gorget" }

local belts = {}
belts.Light = {} -- { waist = "Light belt" }
belts.Dark = {} -- { waist = "Shadow belt" }
belts.Fire = { waist = "Flame belt" }
belts.Ice = {} -- { waist = "Snow belt" }
belts.Wind = { waist = "Breeze belt" }
belts.Earth = {} -- { waist = "Soil belt" }
belts.Thunder = {} -- { waist = "Thunder belt" }
belts.Water = {} -- { waist = "Aqua belt" }

local weaponSkills = {}
-- Daggers
weaponSkills['Viper Bite'] = { 'Earth' }
weaponSkills['Dancing Edge'] = { 'Wind', 'Earth' }
weaponSkills['Shark Bite'] = { 'Wind', 'Thunder' }
weaponSkills['Evisceration'] = { 'Light', 'Dark', 'Earth' }
weaponSkills['Exenterator'] = { 'Wind', 'Earth', 'Thunder' }
-- Hand-to-hand
weaponSkills['Raging Fists'] = { 'Thunder' }
weaponSkills['Howling Fist'] = { 'Light', 'Thunder' }
weaponSkills['Dragon Kick'] = { 'Wind', 'Thunder' }
weaponSkills['Asuran Fists'] = { 'Dark', 'Fire', 'Earth' }
weaponSkills['Shijin Spiral'] = { 'Light', 'Fire', 'Water' }
-- Swords
weaponSkills['Vorpal Blade'] = { 'Earth', 'Thunder' }
weaponSkills['Seraph Blade'] = { 'Earth' }
weaponSkills['Savage Blade'] = { 'Wind', 'Thunder', 'Earth' }
weaponSkills['Requiescat'] = { 'Dark', 'Earth' }

function buildWeaponSkillSet(weaponSkillName)
	if not weaponSkills[weaponSkillName] then return {} end
	
	local wsSet = {}
	local weaponSkillElements = weaponSkills[weaponSkillName]
	
	-- Iterate through each element.
	for i=0, #weaponSkillElements do
		local gorget = gorgets[weaponSkillElements[i]]
		local belt = belts[weaponSkillElements[i]]
		
		if gorget ~= nil then wsSet = set_combine(wsSet, gorget) end
		if belt ~= nil then wsSet = set_combine(wsSet, belt) end
	end
	
	return wsSet
end