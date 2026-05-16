---@diagnostic disable: undefined-global

local Recipe = require "prototypes.recipe.Recipe"

local possible_ingredients = {
  {
    {"rail", 3},
    {"pipe", 12},
    {"storage-tank", 1},
    {"pump", 2},
    {"electronic-circuit", 5},
  },
}

data:extend{
  {
    type = "recipe",
    name = "railloader-fluid",
    enabled = false,
    energy_required = 1,
    ingredients = Recipe.select_ingredients(possible_ingredients),
    result = "railloader-fluid",
  },
  {
    type = "recipe",
    name = "railunloader-fluid",
    enabled = false,
    energy_required = 1,
    ingredients = Recipe.select_ingredients(possible_ingredients),
    result = "railunloader-fluid",
  },
}