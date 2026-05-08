if not mods["LootingSpaceshipWrecks"] then return end

-- Reduce excessive mining times for all crash-site entities.
-- Originals: salvaged machines=2s, small wrecks=3s, medium=4s, big/ship=5s.
local patches = {
    -- Salvaged functional buildings
    { type = "assembling-machine",        name = "salvaged-assembling-machine", time = 0.5 },
    { type = "lab",                       name = "salvaged-lab",                time = 0.5 },
    { type = "electric-energy-interface", name = "salvaged-generator",          time = 0.5 },
    -- Small wrecks (debris)
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-1", time = 0.5 },
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-2", time = 0.5 },
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-3", time = 0.5 },
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-4", time = 0.5 },
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-5", time = 0.5 },
    { type = "simple-entity-with-owner",  name = "crash-site-spaceship-wreck-small-6", time = 0.5 },
    -- Medium wrecks (containers)
    { type = "container",                 name = "crash-site-spaceship-wreck-medium-1", time = 1 },
    { type = "container",                 name = "crash-site-spaceship-wreck-medium-2", time = 1 },
    { type = "container",                 name = "crash-site-spaceship-wreck-medium-3", time = 1 },
    -- Big wrecks and main spaceship (containers)
    { type = "container",                 name = "crash-site-spaceship-wreck-big-1", time = 1 },
    { type = "container",                 name = "crash-site-spaceship-wreck-big-2", time = 1 },
    { type = "container",                 name = "crash-site-spaceship",             time = 1 },
}
for _, p in ipairs(patches) do
    local e = data.raw[p.type][p.name]
    if e and e.minable then e.minable.mining_time = p.time end
end
