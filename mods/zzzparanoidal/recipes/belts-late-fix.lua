---@diagnostic disable: undefined-global

local function set_recipe_result_count(recipe, result_count)
    if not recipe or result_count == nil then
        return
    end

    recipe.result_count = result_count
    if recipe.results and #recipe.results == 1 then
        recipe.results[1].amount = result_count
    end
end

local function set_belt_recipe(recipe_name, ingredients, result_count)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then
        return
    end

    bobmods.lib.recipe.set_ingredients(recipe_name, ingredients)
    set_recipe_result_count(recipe, result_count)
    set_recipe_result_count(recipe.normal, result_count)
    set_recipe_result_count(recipe.expensive, result_count)
end

set_belt_recipe("transport-belt", {
    { "basic-transport-belt", 2 },
    { "tin-plate", 2 },
    { "motor", 2 },
}, 2)


set_belt_recipe("fast-transport-belt", {
    { "transport-belt", 2 },
    { "bronze-alloy", 2 },
    { "steel-bearing", 2 },
}, 2)

set_belt_recipe("express-transport-belt", {
    { "fast-transport-belt", 2 },
    { "aluminium-plate", 2 },
    { "titanium-bearing", 2 },
}, 2)

set_belt_recipe("turbo-transport-belt", {
    { "express-transport-belt", 2 },
    { "plastic-bar", 2 },
    { "cobalt-steel-bearing", 2 },
}, 2)

set_belt_recipe("ultimate-transport-belt", {
    { "turbo-transport-belt", 2 },
    { "nitinol-gear-wheel", 2 },
    { "nitinol-bearing", 2 },
}, 2)

set_belt_recipe("underground-belt", {
    { "basic-underground-belt", 1 },
    { "transport-belt", 5 },
    { "tin-plate", 2 },
    { "motor", 2 },
}, 2)

set_belt_recipe("fast-underground-belt", {
    { "underground-belt", 1 },
    { "fast-transport-belt", 11 },
    { "bronze-alloy", 2 },
    { "steel-bearing", 2 },
}, 2)


set_belt_recipe("express-underground-belt", {
    { "fast-underground-belt", 1 },
    { "express-transport-belt", 17 },
    { "aluminium-plate", 2 },
    { "titanium-bearing", 2 },
}, 2)


set_belt_recipe("turbo-underground-belt", {
    { "express-underground-belt", 1 },
    { "turbo-transport-belt", 23 },
    { "plastic-bar", 2 },
    { "cobalt-steel-bearing", 2 },
}, 2)


set_belt_recipe("ultimate-underground-belt", {
    { "turbo-underground-belt", 1 },
    { "ultimate-transport-belt", 27 },
    { "nitinol-gear-wheel", 2 },
    { "nitinol-bearing", 2 },
}, 2)

set_belt_recipe("basic-splitter", {
    { "basic-transport-belt", 2 },
    { "wood", 4 },
    { "iron-gear-wheel", 2 },
    { "copper-cable", 4 },
}, 1)

set_belt_recipe("splitter", {
    { "basic-splitter", 1 },
    { "transport-belt", 2 },
    { "tin-plate", 4 },
    { "motor", 2 },
    { "basic-circuit", 4 },
}, 1)

set_belt_recipe("fast-splitter", {
    { "splitter", 1 },
    { "fast-transport-belt", 2 },
    { "bronze-alloy", 4 },
    { "steel-bearing", 2 },
    { "electronic-circuit", 4 },
}, 1)

set_belt_recipe("express-splitter", {
    { "fast-splitter", 1 },
    { "express-transport-belt", 2 },
    { "aluminium-plate", 4 },
    { "titanium-bearing", 2 },
    { "advanced-circuit", 4 },
}, 1)

set_belt_recipe("turbo-splitter", {
    { "express-splitter", 1 },
    { "turbo-transport-belt", 2 },
    { "plastic-bar", 4 },
    { "cobalt-steel-bearing", 2 },
    { "processing-unit", 4 },
}, 1)

set_belt_recipe("ultimate-splitter", {
    { "turbo-splitter", 1 },
    { "ultimate-transport-belt", 2 },
    { "nitinol-alloy", 4 },
    { "nitinol-bearing", 2 },
    { "advanced-processing-unit", 4 },
}, 1)