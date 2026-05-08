---@diagnostic disable: undefined-global

if not mods["miniloader"] then
    return
end

local function set_recipe_result_count(recipe, result_count)
    if not recipe or result_count == nil then
        return
    end

    recipe.result_count = result_count
    if recipe.results and #recipe.results == 1 then
        recipe.results[1].amount = result_count
    end
end

local function set_or_create_loader_recipe(recipe_name, ingredients, result_item, result_count)
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        bobmods.lib.recipe.set_ingredients(recipe_name, ingredients)
        set_recipe_result_count(recipe, result_count)
        set_recipe_result_count(recipe.normal, result_count)
        set_recipe_result_count(recipe.expensive, result_count)
        return
    end

    if not data.raw.item[result_item] then
        return
    end

    data:extend({
        {
            type = "recipe",
            name = recipe_name,
            enabled = false,
            energy_required = 1,
            ingredients = ingredients,
            result = result_item,
            result_count = result_count,
        },
    })
end

-- Standard miniloaders: always 1 *-underground-belt + 8 *-inserter -> 1
set_or_create_loader_recipe("basic-miniloader", {
    { "basic-underground-belt", 1 },
    { "burner-inserter", 8 },
}, "basic-miniloader", 1)

set_or_create_loader_recipe("miniloader", {
    { "underground-belt", 1 },
    { "inserter", 8 },
}, "miniloader", 1)

set_or_create_loader_recipe("fast-miniloader", {
    { "fast-underground-belt", 1 },
    { "long-handed-inserter", 8 },
}, "fast-miniloader", 1)

set_or_create_loader_recipe("express-miniloader", {
    { "express-underground-belt", 1 },
    { "fast-inserter", 8 },
}, "express-miniloader", 1)

set_or_create_loader_recipe("turbo-miniloader", {
    { "turbo-underground-belt", 1 },
    { "turbo-inserter", 8 },
}, "turbo-miniloader", 1)

set_or_create_loader_recipe("ultimate-miniloader", {
    { "ultimate-underground-belt", 1 },
    { "express-inserter", 8 },
}, "ultimate-miniloader", 1)

-- Filter miniloaders: same pattern for filter inserters.
set_or_create_loader_recipe("basic-filter-miniloader", {
    { "basic-underground-belt", 1 },
    { "burner-filter-inserter", 8 },
}, "basic-filter-miniloader", 1)

set_or_create_loader_recipe("filter-miniloader", {
    { "underground-belt", 1 },
    { "yellow-filter-inserter", 8 },
}, "filter-miniloader", 1)

set_or_create_loader_recipe("fast-filter-miniloader", {
    { "fast-underground-belt", 1 },
    { "red-filter-inserter", 8 },
}, "fast-filter-miniloader", 1)

set_or_create_loader_recipe("express-filter-miniloader", {
    { "express-underground-belt", 1 },
    { "filter-inserter", 8 },
}, "express-filter-miniloader", 1)

set_or_create_loader_recipe("turbo-filter-miniloader", {
    { "turbo-underground-belt", 1 },
    { "turbo-filter-inserter", 8 },
}, "turbo-filter-miniloader", 1)

set_or_create_loader_recipe("ultimate-filter-miniloader", {
    { "ultimate-underground-belt", 1 },
    { "express-filter-inserter", 8 },
}, "ultimate-filter-miniloader", 1)
