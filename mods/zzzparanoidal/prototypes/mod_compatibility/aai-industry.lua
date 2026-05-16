if not mods["aai-industry"] then return end

-- Reduce excessive mining times for ship wrecks.
local patches = {
    { type = "container",     name = "aai-big-ship-wreck-1",    time = 1   },
    { type = "container",     name = "aai-big-ship-wreck-2",    time = 1   },
    { type = "container",     name = "aai-big-ship-wreck-3",    time = 1   },
    { type = "container",     name = "aai-medium-ship-wreck-1", time = 0.5 },
    { type = "container",     name = "aai-medium-ship-wreck-2", time = 0.5 },
    { type = "simple-entity", name = "aai-small-ship-wreck",    time = 0.5 },
}
for _, p in ipairs(patches) do
    local e = data.raw[p.type][p.name]
    if e and e.minable then e.minable.mining_time = p.time end
end
