---@diagnostic disable: undefined-global

if not mods["ReStack"] then return end
if not mods["bobplates"] then return end

local restack_plates_setting = settings.startup["ReStack-plates"]
if not restack_plates_setting or restack_plates_setting.value <= 0 then return end

local plate_stack_size = restack_plates_setting.value

local metallurgy_subgroups = {
  ["bob-material"] = true,
  ["bob-alloy"] = true,
}

local base_plate_items = {
  "iron-plate",
  "copper-plate",
  "steel-plate",
}

local function has_flag(prototype, flag)
  if not prototype.flags then return false end

  for _, existing_flag in pairs(prototype.flags) do
    if existing_flag == flag then return true end
  end

  return false
end

local function apply_plate_stack_size(item)
  if not item or not item.stack_size then return end
  if has_flag(item, "not-stackable") then return end

  item.stack_size = plate_stack_size
end

for _, item in pairs(data.raw.item or {}) do
  if metallurgy_subgroups[item.subgroup] then
    apply_plate_stack_size(item)
  end
end

for _, item_name in pairs(base_plate_items) do
  apply_plate_stack_size(data.raw.item and data.raw.item[item_name])
end