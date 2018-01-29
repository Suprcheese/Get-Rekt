script.on_load(function() On_Load() end)

function On_Load()
	if global.jammed_turrets then
		script.on_event(defines.events.on_tick, process_tick)
	end
end

function process_tick()
	local current_tick = game.tick
	for i = #global.jammed_turrets, 1, -1 do -- Loop over table backwards because some entries get removed within the loop
		local vehicle = global.jammed_turrets[i][1]
		if vehicle and vehicle.valid then
			if current_tick == global.jammed_turrets[i][3] - 84 then
				vehicle.surface.play_sound{path = "turret-repaired", position = vehicle.position}
				vehicle.relative_turret_orientation = global.jammed_turrets[i][2]
			elseif current_tick == global.jammed_turrets[i][3] then
				vehicle.surface.create_entity{name = "tutorial-flying-text", position = vehicle.position, text = {"turret-repaired"}}
				table.remove(global.jammed_turrets, i)
			else
				vehicle.relative_turret_orientation = global.jammed_turrets[i][2]
			end
		else
			table.remove(global.jammed_turrets, i)
		end
	end
	if #global.jammed_turrets == 0 then
		global.jammed_turrets = nil
		script.on_event(defines.events.on_tick, nil)
	end
end

script.on_event(defines.events.on_entity_damaged, function(event)
	local entity = event.entity
	if entity.type == "car" then
	-- if entity.type == "car" and event.force and not event.force.name == "neutral" then
		local damage_ratio = event.original_damage_amount / entity.prototype.max_health
		if damage_ratio > 0.1 then
			game.players[1].print("Beep1!")
			-- if math.random(7) == 7 then
			if true then
				applyMalfunction(entity, math.random(2))
			end
		end
	end
end)

function applyMalfunction(vehicle, type)
	if type == 1 then
		-- vehicle.surface.create_entity({name = "vehicle-damage-projectile", target = vehicle, force = game.forces.enemy, position = vehicle.position, speed = 1})
		global.jammed_turrets = global.jammed_turrets or {}
		table.insert(global.jammed_turrets, {vehicle, vehicle.relative_turret_orientation, game.tick + 5 * 60 + math.random(10 * 60)})
		vehicle.surface.create_entity{name = "tutorial-flying-text", position = vehicle.position, text = {"turret-jammed"}, color = {r = 1}}
		script.on_event(defines.events.on_tick, process_tick)
		game.players[1].print("Beep2!")
		return
	elseif type == 2 then
		vehicle.surface.create_entity({name = "vehicle-damage-slowdown-projectile", target = vehicle, force = game.forces.enemy, position = vehicle.position, speed = 1})
		return
	end
end

script.on_event(defines.events.on_player_changed_position, function(event)
	local player = game.players[event.player_index]
	local vehicle = player.vehicle
	if vehicle and vehicle.valid and vehicle.type == "car" then
		local health_ratio = vehicle.health / vehicle.prototype.max_health
		if health_ratio >= 0.85 then
			vehicle.effectivity_modifier = 1
			vehicle.friction_modifier = 1
			return
		elseif health_ratio < 0.85 then
			health_ratio = health_ratio + 0.15
			vehicle.effectivity_modifier = health_ratio
			vehicle.friction_modifier = 2 - health_ratio
			makeRattleNoise(player, math.random(10))
			return
		elseif health_ratio < 0.1 then
			vehicle.effectivity_modifier = 0.25
			vehicle.friction_modifier = 1.75
			makeRattleNoise(player, math.random(10))
		end
	end
end)

function makeRattleNoise(player, chance)
	if chance == 7 then
		player.play_sound{path = "vehicle-damaged-rattle"}
	end
end

-- function findEntity(entity)
	-- for i,t in pairs(global.jammed_turrets) do
		-- if t[1] == entity then
			-- return i
		-- end
	-- end
	-- return false
-- end

-- function entityRemoved(entity)
	-- local z = findEntity(entity)
	-- if z then
		-- table.remove(global.jammed_turrets, z)
	-- end
-- end

-- script.on_event(defines.events.on_pre_player_mined_item, function(event)
	-- if not global.jammed_turrets then return end
	-- if event.entity.type == "car" then
		-- entityRemoved(event.entity)
	-- end
-- end)
