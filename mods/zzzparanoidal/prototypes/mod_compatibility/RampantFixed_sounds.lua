if not mods["RampantFixed"] then return end

local sounds = require("__base__.prototypes.entity.sounds")

local blood_fountains_by_tier = {
    "blood-explosion-small-rampant",
    "blood-explosion-small-rampant",
    "blood-explosion-small-rampant",
    "blood-explosion-small-rampant",
    "blood-explosion-big-rampant",
    "blood-explosion-big-rampant",
    "blood-explosion-big-rampant",
    "blood-explosion-huge-rampant",
    "blood-explosion-huge-rampant",
    "blood-explosion-huge-rampant",
}

local function make_immersive_sound(prefix, count)
    local result = {}
    for index = 1, count do
        result[#result + 1] = {
            filename = "__immersive-sounds__/sound/creatures/" .. prefix .. index .. ".ogg",
            volume = 0.5,
        }
    end
    return result
end

local function make_biter_dying_sound(tier)
    if mods["immersive-sounds"] then
        if tier >= 4 then
            return make_immersive_sound("biter-death-big-", 5)
        end
        return make_immersive_sound("biter-death-", 5)
    end

    local volume = 0.3 + (0.05 * tier)
    if tier >= 4 then
        return sounds.biter_dying_big(volume)
    end
    return sounds.biter_dying(volume)
end

local function make_spitter_dying_sound(tier)
    if mods["immersive-sounds"] then
        return make_immersive_sound("spitter-death-", 5)
    end

    local volume = 0.3 + (0.05 * tier)
    if tier >= 8 then
        return sounds.spitter_dying_big(volume)
    elseif tier >= 4 then
        return sounds.spitter_dying_mid(volume)
    end
    return sounds.spitter_dying(volume)
end

local function existing_explosion(name)
    return data.raw["explosion"] and data.raw["explosion"][name] and name or nil
end

local function make_dying_explosion(faction, tier)
    local rampant_name = faction .. "-" .. (blood_fountains_by_tier[tier] or "blood-explosion-big-rampant")
    if existing_explosion(rampant_name) then
        return rampant_name
    end

    if tier >= 8 then
        return existing_explosion("blood-explosion-huge") or existing_explosion("blood-explosion-big") or existing_explosion("blood-explosion-small")
    elseif tier >= 5 then
        return existing_explosion("blood-explosion-big") or existing_explosion("blood-explosion-small")
    end
    return existing_explosion("blood-explosion-small") or existing_explosion("blood-explosion-big")
end

local function patch_unit(unit, faction, tier, sound)
    unit.dying_sound = sound
    unit.dying_explosion = unit.dying_explosion or make_dying_explosion(faction, tier)
end

for name, unit in pairs(data.raw["unit"] or {}) do
    local biter_faction, biter_tier = name:match("^(.-)%-biter%-v%d+%-t(%d+)%-rampant$")
    if biter_faction then
        local tier = tonumber(biter_tier) or 1
        patch_unit(unit, biter_faction, tier, make_biter_dying_sound(tier))
    else
        local spitter_faction, spitter_tier = name:match("^(.-)%-spitter%-v%d+%-t(%d+)%-rampant$")
        if spitter_faction then
            local tier = tonumber(spitter_tier) or 1
            patch_unit(unit, spitter_faction, tier, make_spitter_dying_sound(tier))
        end
    end
end
