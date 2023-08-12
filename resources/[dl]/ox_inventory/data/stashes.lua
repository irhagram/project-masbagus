---wip types

---@class OxStash
---@field name string
---@field label string
---@field owner? boolean | string | number
---@field slots number
---@field weight number
---@field groups? string | string[] | { [string]: number }
---@field blip? { id: number, colour: number, scale: number }
---@field coords? vector3
---@field target? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }

return {
	{
		coords = vec3(480.46, -994.53, 30.69),
		target = {
			loc = vec3(480.46, -994.53, 30.69),
			length = 1.0,
			width = 1.0,
			heading = 0,
			minZ = 29.69,
			maxZ = 33.69,
			label = 'Loker Pribadi'
		},
		name = 'policelocker',
		label = 'Loker Pribadi',
		owner = true,
		slots = 100,
		weight = 1000000,
		groups = shared.police
	},

	{
		coords = vec3(-1832.53, -387.72, 49.39),
		target = {
			loc = vec3(-1832.53, -387.72, 49.39),
			length = 1,
			width = 1,
			heading = 45,
			minZ = 48.47,
			maxZ = 52.47,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},
	{
		coords = vec3(-634.58, 225.02, 81.88),
		target = {
			loc = vec3(-634.58, 225.02, 81.88),
			length = 1,
			width = 2,
			heading = 0,
			minZ = 80.88,
			maxZ = 84.88,
			label = 'Loker Pribadi'
		},
		name = 'pedagangloker',
		label = 'Loker  Pribadi',
		owner = true,
		slots = 15,
		weight = 300000,
		groups = {['pedagang'] = 0}
	},
	{
		coords = vec3(80.59, 6575.07, 31.75),
		target = {
			loc = vec3(80.59, 6575.07, 31.75),
			length = 1,
			width = 3,
			heading = 315,
			minZ = 30.75,
			maxZ = 34.75,
			label = 'Loker Pribadi'
		},
		name = 'mekanikloker',
		label = 'Loker  Pribadi',
		owner = true,
		slots = 15,
		weight = 150000,
		groups = {['mechanic'] = 0}
	},
}