---@diagnostic disable: undefined-global

local fluid_wagon = data.raw["fluid-wagon"]["fluid-wagon"]

data:extend{
  {
    type = "item",
    name = "railloader-fluid",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    subgroup = "transport",
    order = "a[train-system]-j[railloader-fluid]",
    place_result = "railloader-fluid-placement-proxy",
    stack_size = 10,
  },
  {
    type = "item",
    name = "railunloader-fluid",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    subgroup = "transport",
    order = "a[train-system]-j[railunloader-fluid]",
    place_result = "railunloader-fluid-placement-proxy",
    stack_size = 10,
  },
}