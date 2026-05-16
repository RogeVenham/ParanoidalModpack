---@diagnostic disable: undefined-global

if not mods["ReStack"] then return end
if not mods["bobplates"] then return end

local restack_plates_setting = settings.startup["ReStack-plates"]
local plate_stack_size = restack_plates_setting and restack_plates_setting.value or nil
local gear_bearing_stack_size = 200

local metallurgy_items = {
  ["iron-plate"] = true,
  ["copper-plate"] = true,
  ["steel-plate"] = true,
  ["tin-plate"] = true,
  ["silver-plate"] = true,
  ["lead-plate"] = true,
  ["gold-plate"] = true,
  ["nickel-plate"] = true,
  ["zinc-plate"] = true,
  ["aluminium-plate"] = true,
  ["titanium-plate"] = true,
  ["tungsten-plate"] = true,
  ["silicon"] = true,
  ["lithium"] = true,
  ["cobalt-plate"] = true,
  ["bronze-alloy"] = true,
  ["brass-alloy"] = true,
  ["copper-tungsten-alloy"] = true,
  ["tungsten-carbide"] = true,
  ["gunmetal-alloy"] = true,
  ["invar-alloy"] = true,
  ["nitinol-alloy"] = true,
  ["cobalt-steel-alloy"] = true,
  ["solder-alloy"] = true,
}

local metallurgy_subgroups = {
  ["bob-material"] = true,
  ["bob-alloy"] = true,
}

local fixed_stack_sizes = {
  ["bob-gears"] = gear_bearing_stack_size,
}

local function has_flag(prototype, flag)
  if not prototype.flags then return false end

  for _, existing_flag in pairs(prototype.flags) do
    if existing_flag == flag then return true end
  end

  return false
end

local function apply_stack_size(item, stack_size)
  if not item or not item.stack_size then return end
  if has_flag(item, "not-stackable") then return end

  item.stack_size = stack_size
end

for _, item in pairs(data.raw.item or {}) do
  if plate_stack_size and plate_stack_size > 0 and (metallurgy_items[item.name] or metallurgy_subgroups[item.subgroup]) then
    apply_stack_size(item, plate_stack_size)
  elseif fixed_stack_sizes[item.subgroup] then
    apply_stack_size(item, fixed_stack_sizes[item.subgroup])
  elseif item.subgroup == "bob-bearings" and item.name:sub(-8) == "-bearing" then
    apply_stack_size(item, gear_bearing_stack_size)
  end
end