if not mods["RampantFixed"] then return end

local new_enemy_setting = settings.startup["rampantFixed--newEnemies"]
if not (new_enemy_setting and new_enemy_setting.value) then return end

local unit_spawners = data.raw["unit-spawner"] or {}

local VANILLA_UNITS = {
    ["small-biter"] = true,
    ["medium-biter"] = true,
    ["big-biter"] = true,
    ["behemoth-biter"] = true,
    ["small-spitter"] = true,
    ["medium-spitter"] = true,
    ["big-spitter"] = true,
    ["behemoth-spitter"] = true,
}

local function is_bob_enemy_unit(name)
    return type(name) == "string" and (name:match("^bob%-.*%-biter$") or name:match("^bob%-.*%-spitter$"))
end

local function is_forbidden_unit(name)
    return VANILLA_UNITS[name] or is_bob_enemy_unit(name)
end

local function get_result_units(spawner_name)
    local spawner = unit_spawners[spawner_name]
    if not (spawner and spawner.result_units) then
        error("Paranoidal RampantFixed enemy replacement: missing result_units for " .. spawner_name)
    end
    return spawner.result_units
end

local biter_result_units = get_result_units("neutral-biter-spawner-v1-t10-rampant")
local spitter_result_units = get_result_units("neutral-spitter-spawner-v1-t10-rampant")

local function combine_result_units(first, second)
    local result = table.deepcopy(first)
    for _, entry in ipairs(second) do
        result[#result + 1] = table.deepcopy(entry)
    end
    return result
end

local combined_result_units = combine_result_units(biter_result_units, spitter_result_units)

local function replace_result_units(spawner_name, result_units)
    local spawner = unit_spawners[spawner_name]
    if spawner then
        spawner.result_units = table.deepcopy(result_units)
    end
end

local function fallback_result_units(spawner_name)
    if spawner_name:find("spitter", 1, true) then
        return spitter_result_units
    elseif spawner_name:find("biter", 1, true) then
        return biter_result_units
    end
    return combined_result_units
end

local function scrub_forbidden_result_units(spawner_name, spawner)
    if not spawner.result_units then return 0 end

    local cleaned = {}
    local removed = 0
    for _, entry in ipairs(spawner.result_units) do
        local unit_name = entry[1]
        if is_forbidden_unit(unit_name) then
            removed = removed + 1
        else
            cleaned[#cleaned + 1] = entry
        end
    end

    if removed > 0 then
        if #cleaned == 0 then
            spawner.result_units = table.deepcopy(fallback_result_units(spawner_name))
        else
            spawner.result_units = cleaned
        end
    end

    return removed
end

replace_result_units("biter-spawner", biter_result_units)
replace_result_units("spitter-spawner", spitter_result_units)

replace_result_units("spawner-proxy-1-rampant", biter_result_units)
replace_result_units("spawner-proxy-2-rampant", biter_result_units)
replace_result_units("spawner-proxy-3-rampant", biter_result_units)

replace_result_units("bob-biter-spawner", biter_result_units)
replace_result_units("bob-spitter-spawner", spitter_result_units)
replace_result_units("bob-super-spawner", combined_result_units)

local removed_total = 0
for spawner_name, spawner in pairs(unit_spawners) do
    removed_total = removed_total + scrub_forbidden_result_units(spawner_name, spawner)
end

if removed_total > 0 then
    log("Paranoidal RampantFixed enemy replacement: removed " .. removed_total .. " vanilla/Bob result_units entries")
end
