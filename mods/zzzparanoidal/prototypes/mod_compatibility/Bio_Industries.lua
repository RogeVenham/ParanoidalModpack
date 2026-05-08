if not mods["Bio_Industries"] then return end

-- Bio_Industries: нерф турели и винтовки
-- Базовые значения слишком сильны: cooldown=4 (15 выстрелов/сек) и cooldown=5 (12 в/с)
-- при урастании через стандартные технологии оружия это даёт абсурдный DPS.
-- Приводим к уровню обычной пулемётной турели (~6 в/сек).

local dart_turret = data.raw["ammo-turret"]["bi-dart-turret"]
if dart_turret then
    dart_turret.attack_parameters.cooldown = 10  -- было 4; теперь ~6 в/сек
    dart_turret.attack_parameters.range = 12     -- было 15; короче пулемётной турели (18)
end

local dart_rifle = data.raw.gun["bi-dart-rifle"]
if dart_rifle then
    dart_rifle.attack_parameters.cooldown = 15   -- было 5; теперь ~4 в/сек
    dart_rifle.attack_parameters.range = 14      -- было 17
end
