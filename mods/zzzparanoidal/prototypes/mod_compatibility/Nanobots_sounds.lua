---@diagnostic disable: undefined-global

if not mods["Nanobots"] then return end

local repair_sound_filename = "__core__/sound/manual-repair-advanced-1.ogg"

local function is_repair_sound_effect(effect)
  return type(effect) == "table"
    and effect.type == "play-sound"
    and type(effect.sound) == "table"
    and effect.sound.filename == repair_sound_filename
end

local function remove_repair_sound_effects(node)
  if type(node) ~= "table" then return end

  for index = #node, 1, -1 do
    local value = node[index]

    if is_repair_sound_effect(value) then
      table.remove(node, index)
    else
      remove_repair_sound_effects(value)
    end
  end

  for key, value in pairs(node) do
    if type(key) ~= "number" then
      if is_repair_sound_effect(value) then
        node[key] = nil
      else
        remove_repair_sound_effects(value)
      end
    end
  end
end

local repair_cloud = data.raw["smoke-with-trigger"] and data.raw["smoke-with-trigger"]["nano-cloud-small-repair"]

if repair_cloud then
  remove_repair_sound_effects(repair_cloud.action)
end