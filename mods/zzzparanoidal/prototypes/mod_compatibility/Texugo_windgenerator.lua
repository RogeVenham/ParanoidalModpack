if not mods["Texugo_windgenerator"] then return end

-- Fix 1: Reduce excessive mining times.
-- Originals: turbine1=4s, turbine2=10s, turbine3=30s.
-- Vanilla assembling machine mines in 0.5s for reference.
local turbines = {
    { name = "texugo-wind-turbine",  time = 0.5 },
    { name = "texugo-wind-turbine2", time = 1   },
    { name = "texugo-wind-turbine3", time = 2   },
}
for _, t in ipairs(turbines) do
    local e = data.raw["generator"][t.name]
    if e then e.minable.mining_time = t.time end
end

-- Fix 2: Hidden electric poles can "break" turbines.
-- Each turbine spawns a hidden twt-electric-pole* at runtime (control.lua).
-- The poles have a real collision_box, so area-damage queries can hit them.
-- pole3 has max_health=1 in the prototype — one stray explosion kills it.
-- When a pole dies (on_entity_died) the mod deals 6666 damage to the turbine.
-- control.lua does set entity.destructible=false at runtime, but entity.die()
-- can still bypass that and fire on_entity_died.
-- Fix: set max_health=0 (indestructible at prototype level) and clear
-- collision_box/collision_mask so AoE can't even query for these entities.
for _, name in ipairs({"twt-electric-pole", "twt-electric-pole2", "twt-electric-pole3"}) do
    local pole = data.raw["electric-pole"][name]
    if pole then
        pole.max_health    = 1e9  -- max_health=0 is invalid; huge value = effectively indestructible
        pole.collision_box  = {{0, 0}, {0, 0}}
        pole.collision_mask = {}
    end
end
