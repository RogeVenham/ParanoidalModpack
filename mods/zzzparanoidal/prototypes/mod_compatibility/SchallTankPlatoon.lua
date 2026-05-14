---@diagnostic disable: undefined-global

if not mods["SchallTankPlatoon"] then return end

local custom_sniper_ammo_recipes = {
  "Schall-sniper-firearm-magazine",
  "Schall-sniper-piercing-rounds-magazine",
  "Schall-sniper-uranium-rounds-magazine",
}

local custom_sniper_ammo_recipe_lookup = {}
for _, recipe_name in pairs(custom_sniper_ammo_recipes) do
  custom_sniper_ammo_recipe_lookup[recipe_name] = true
end

local function copy_ingredients(ingredients)
  local ingredients_copy = {}

  for index, ingredient in ipairs(ingredients) do
    if type(ingredient) == "table" then
      local ingredient_copy = {}
      for key, value in pairs(ingredient) do
        ingredient_copy[key] = value
      end
      ingredients_copy[index] = ingredient_copy
    else
      ingredients_copy[index] = ingredient
    end
  end

  return ingredients_copy
end

local function set_recipe_fields(recipe_data, ingredients, energy_required, result)
  if not recipe_data then return end

  recipe_data.enabled = false
  recipe_data.energy_required = energy_required
  recipe_data.ingredients = copy_ingredients(ingredients)
  recipe_data.result = result
  recipe_data.result_count = nil
  recipe_data.results = nil
  recipe_data.main_product = nil
end

local function set_recipe(recipe_name, ingredients, energy_required, result)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end

  if recipe.normal or recipe.expensive then
    set_recipe_fields(recipe.normal, ingredients, energy_required, result)
    set_recipe_fields(recipe.expensive, ingredients, energy_required, result)
    recipe.enabled = false
  else
    set_recipe_fields(recipe, ingredients, energy_required, result)
  end
end

local function hide_recipe(recipe_name)
  local recipe = data.raw.recipe and data.raw.recipe[recipe_name]
  if not recipe then return end

  recipe.hidden = true
  recipe.enabled = false

  if recipe.normal then
    recipe.normal.hidden = true
    recipe.normal.enabled = false
  end

  if recipe.expensive then
    recipe.expensive.hidden = true
    recipe.expensive.enabled = false
  end
end

local function add_flag(prototype, flag)
  if not prototype then return end

  prototype.flags = prototype.flags or {}
  for _, existing_flag in pairs(prototype.flags) do
    if existing_flag == flag then return end
  end

  table.insert(prototype.flags, flag)
end

local function should_remove_technology_effect(effect)
  if not effect then return false end

  if effect.type == "unlock-recipe" and custom_sniper_ammo_recipe_lookup[effect.recipe] then
    return true
  end

  if (effect.type == "ammo-damage" or effect.type == "gun-speed") and effect.ammo_category == "Schall-sniper-bullet" then
    return true
  end

  return false
end

local function remove_matching_technology_effects()
  for _, technology in pairs(data.raw.technology or {}) do
    if technology.effects then
      for index = #technology.effects, 1, -1 do
        if should_remove_technology_effect(technology.effects[index]) then
          table.remove(technology.effects, index)
        end
      end
    end
  end
end

local function remove_recipe_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology or not technology.effects then return end

  for index = #technology.effects, 1, -1 do
    local effect = technology.effects[index]
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      table.remove(technology.effects, index)
    end
  end
end

local function add_recipe_unlock(technology_name, recipe_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology then return end

  technology.effects = technology.effects or {}
  for _, effect in pairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then return end
  end

  table.insert(technology.effects, {type = "unlock-recipe", recipe = recipe_name})
end

local schall_sniper_rifle = data.raw.gun and data.raw.gun["Schall-sniper-rifle"]
if schall_sniper_rifle and schall_sniper_rifle.attack_parameters then
  local attack_parameters = schall_sniper_rifle.attack_parameters
  attack_parameters.ammo_category = "bullet"
  attack_parameters.ammo_categories = nil
  attack_parameters.cooldown = 120
  attack_parameters.movement_slow_down_factor = 0.75
  attack_parameters.projectile_creation_distance = 0.6
  attack_parameters.range = 24
  attack_parameters.damage_modifier = 10
  attack_parameters.warmup = nil
  attack_parameters.movement_slow_down_cooldown = nil
  attack_parameters.min_range = nil
  attack_parameters.health_penalty = nil
end

set_recipe(
  "Schall-sniper-rifle",
  {
    {"steel-plate", 10},
    {"wood", 10},
    {"iron-gear-wheel", 10},
  },
  5,
  "Schall-sniper-rifle"
)

for _, recipe_name in pairs(custom_sniper_ammo_recipes) do
  hide_recipe(recipe_name)
  add_flag(data.raw.ammo and data.raw.ammo[recipe_name], "hidden")
end

remove_matching_technology_effects()
remove_recipe_unlock("Schall-sniper-rifle", "Schall-sniper-rifle")
add_recipe_unlock("military-2", "Schall-sniper-rifle")

local schall_sniper_technology = data.raw.technology and data.raw.technology["Schall-sniper-rifle"]
if schall_sniper_technology then
  schall_sniper_technology.hidden = true
end
