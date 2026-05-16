if not mods["bobenemies"] then return end

-- Paranoidal: убираем autoplace у Bob's спавнеров и червей.
-- RSO уже не будет их размещать (fillBobEnemies очищен в rso-mod/resourceconfigs/bobenemies.lua).
-- Этот патч — дополнительная страховка: убирает autoplace из прототипов на случай
-- если RSO отключён или другой мод попытается их разместить нативным способом.
-- Ванильные biter-spawner/spitter-spawner остаются только как seed-сущности:
-- RampantFixed должен апгрейдить их до своих версий, а result_units чистятся отдельно.

local BOB_SPAWNERS = {
    "bob-biter-spawner",
    "bob-spitter-spawner",
    "bob-super-spawner",
}

local BOB_WORM_TURRETS = {
    "bob-big-explosive-worm-turret",
    "bob-big-fire-worm-turret",
    "bob-big-poison-worm-turret",
    "bob-big-piercing-worm-turret",
    "bob-big-electric-worm-turret",
    "bob-giant-worm-turret",
}

for _, name in ipairs(BOB_SPAWNERS) do
    local e = data.raw["unit-spawner"][name]
    if e then e.autoplace = nil end
end

for _, name in ipairs(BOB_WORM_TURRETS) do
    -- Bob's worms are type "turret"
    local e = data.raw["turret"][name]
    if e then e.autoplace = nil end
end
