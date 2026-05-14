---@diagnostic disable: undefined-global

local rapid_attack_cooldown_threshold = 20

local turret_sound_limits = {
  aggregation = {
    max_count = 8,
    remove = true,
    count_already_playing = true,
    progress_threshold = 0.35,
  },
  audible_distance_modifier = 0.65,
}

local function copy_table(source)
  local result = {}

  for key, value in pairs(source) do
    if type(value) == "table" then
      result[key] = copy_table(value)
    else
      result[key] = value
    end
  end

  return result
end

local function copy_array(source)
  local result = {}

  for index, value in ipairs(source) do
    result[index] = value
  end

  return result
end

local function apply_limits_to_base_sound(sound, limits)
  if type(sound) ~= "table" then return sound end

  sound = copy_table(sound)

  if not sound.aggregation then
    sound.aggregation = copy_table(limits.aggregation)
  end

  if not sound.audible_distance_modifier then
    sound.audible_distance_modifier = limits.audible_distance_modifier
  end

  return sound
end

local function normalize_variations(sound)
  local normalized_sound = {
    variations = copy_array(sound),
  }

  for key, value in pairs(sound) do
    if type(key) ~= "number" then
      normalized_sound[key] = value
    end
  end

  return normalized_sound
end

local function apply_limits_to_sound(sound, limits)
  if type(sound) ~= "table" then return sound end

  if sound.layers then
    local layered_sound = copy_table(sound)
    layered_sound.layers = {}

    for index, layer in pairs(sound.layers) do
      layered_sound.layers[index] = apply_limits_to_base_sound(layer, limits)
    end

    return layered_sound
  end

  if sound.filename or sound.variations then
    return {
      layers = {
        apply_limits_to_base_sound(sound, limits),
      },
    }
  end

  if sound[1] then
    return {
      layers = {
        apply_limits_to_base_sound(normalize_variations(sound), limits),
      },
    }
  end

  return sound
end

local function patch_attack_parameters(attack_parameters)
  if not attack_parameters then return end
  if attack_parameters.type ~= "projectile" then return end
  if not attack_parameters.sound then return end
  if attack_parameters.cooldown and attack_parameters.cooldown > rapid_attack_cooldown_threshold then return end

  attack_parameters.sound = apply_limits_to_sound(attack_parameters.sound, turret_sound_limits)
end

local function patch_turrets(prototype_type)
  for _, prototype in pairs(data.raw[prototype_type] or {}) do
    patch_attack_parameters(prototype.attack_parameters)
  end
end

patch_turrets("ammo-turret")
patch_turrets("electric-turret")