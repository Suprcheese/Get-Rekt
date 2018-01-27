data:extend({
	{
		type = "sticker",
		name = "Get-Rekt-sticker",
		--icon = "__base__/graphics/icons/slowdown-sticker.png",
		flags = {},
		animation =
		{
			filename = "__base__/graphics/entity/slowdown-sticker/slowdown-sticker.png",
			priority = "low",
			width = 11,
			height = 11,
			frame_count = 13,
			animation_speed = 0.4
		},
		duration_in_ticks = 3 * 60,
		target_movement_modifier = 0.5
	},
})