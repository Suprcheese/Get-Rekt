local null =
{
		filename = "__core__/graphics/empty.png",
		priority = "low",
		width = 1,
		height = 1,
		-- scale = 1,
		-- shift = {0, 0},
		frame_count = 1,
		-- direction_count = 1
}

local vehicle_slowdown_projectile = util.table.deepcopy(data.raw["projectile"]["slowdown-capsule"])

vehicle_slowdown_projectile.name = "vehicle-damage-slowdown-projectile"
vehicle_slowdown_projectile.acceleration = 1
vehicle_slowdown_projectile.action =
{
	type = "direct",
	action_delivery =
	{
		type = "instant",
		target_effects =
		{
			{
				type = "create-sticker",
				entity_name = "vehicle-damaged-sticker"
			},
			{
				type = "create-entity",
				entity_name = "vehicle-damage-explosion"
			},
		}
	}
}
vehicle_slowdown_projectile.light = {}
vehicle_slowdown_projectile.animation = null
vehicle_slowdown_projectile.shadow = null

local vehicle_damage_explosion = util.table.deepcopy(data.raw["explosion"]["medium-explosion"])

vehicle_damage_explosion.name = "vehicle-damage-explosion"
vehicle_damage_explosion.animations = null
vehicle_damage_explosion.light = {intensity = 1, size = 10, color = {r=1.0, g=1.0, b=1.0}}
vehicle_damage_explosion.sound =
{
	aggregation =
	{
		max_count = 1,
		remove = true
	},
	variations =
	{
		{
			filename = "__base__/sound/fight/large-explosion-1.ogg",
			volume = 0.8
		},
		{
			filename = "__base__/sound/fight/large-explosion-2.ogg",
			volume = 0.8
		}
	}
}
vehicle_damage_explosion.created_effect =
{
	type = "direct",
	action_delivery =
	{
		type = "instant",
		target_effects =
		{
			{
				type = "create-particle",
				repeat_count = 10,
				entity_name = "explosion-remnants-particle",
				initial_height = 0.5,
				speed_from_center = 0.04,
				speed_from_center_deviation = 0.08,
				initial_vertical_speed = 0.04,
				initial_vertical_speed_deviation = 0.08,
				offset_deviation = {{-0.1, -0.1}, {0.1, 0.1}}
			}
		}
	}
}
vehicle_damage_explosion.smoke = "smoke-fast"
vehicle_damage_explosion.smoke_count = 1
vehicle_damage_explosion.smoke_slow_down_factor = 1


local vehicle_damaged_sticker = util.table.deepcopy(data.raw["sticker"]["vehicle-damaged-sticker"])

vehicle_damaged_sticker.duration_in_ticks = 3 * 60

data:extend({vehicle_slowdown_projectile, vehicle_damage_explosion, vehicle_damaged_sticker})
