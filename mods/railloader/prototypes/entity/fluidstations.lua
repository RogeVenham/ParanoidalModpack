---@diagnostic disable: undefined-global

local circuitconnectors = require "prototypes.entity.circuitconnectors"
local pictures = require "prototypes.entity.pictures"

local fluid_wagon = data.raw["fluid-wagon"]["fluid-wagon"]

local function make_pipe_connections()
  return {
    { position = { -1.5, -2.5 } },
    { position = { 1.5, -2.5 } },
    { position = { 2.5, -1.5 } },
    { position = { 2.5, 1.5 } },
    { position = { 1.5, 2.5 } },
    { position = { -1.5, 2.5 } },
    { position = { -2.5, 1.5 } },
    { position = { -2.5, -1.5 } },
  }
end

local function make_proxy(name, item_name, animations)
  return {
    type = "pump",
    name = name,
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    minable = { mining_time = 0.1, result = item_name },
    flags = {"player-creation", "placeable-neutral"},
    max_health = 800,
    collision_box = {{-1.8, -1.8}, {1.8, 1.8}},
    selection_box = {{-1.8, -1.8}, {1.8, 1.8}},
    fluid_box = {
      pipe_connections = {},
    },
    energy_usage = "0kW",
    energy_source = {
      type = "void",
    },
    pumping_speed = 0,
    animations = animations,
    circuit_wire_connection_points = circuitconnectors["railloader-placement-proxy"].points,
    circuit_connector_sprites = circuitconnectors["railloader-placement-proxy"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance + 1.5,
  }
end

local function make_buffer(name, item_name)
  local tank = util.table.deepcopy(data.raw["storage-tank"]["storage-tank"])
  tank.name = name
  tank.icon = fluid_wagon.icon
  tank.icon_size = fluid_wagon.icon_size
  tank.icon_mipmaps = fluid_wagon.icon_mipmaps
  tank.flags = {"player-creation"}
  tank.minable = { mining_time = 0.5, result = item_name }
  tank.placeable_by = { item = item_name, count = 1 }
  tank.max_health = 800
  tank.collision_box = {{-2, -2}, {2, 2}}
  tank.selection_box = {{-2, -2}, {2, 2}}
  tank.collision_mask = {"item-layer", "object-layer", "water-tile"}
  tank.selection_priority = 255
  tank.fluid_box.base_area = 4000
  tank.fluid_box.pipe_connections = make_pipe_connections()
  tank.fluid_box.hide_connection_info = false
  tank.fluid_box.pipe_covers = pipecoverspictures()
  tank.fast_replaceable_group = "railloader-fluid"
  tank.next_upgrade = nil
  return tank
end

data:extend{
  make_proxy("railloader-fluid-placement-proxy", "railloader-fluid", pictures.railloader_proxy_animations),
  make_proxy("railunloader-fluid-placement-proxy", "railunloader-fluid", pictures.railunloader_proxy_animations),
  make_buffer("railloader-fluid-buffer", "railloader-fluid"),
  make_buffer("railunloader-fluid-buffer", "railunloader-fluid"),

  {
    type = "simple-entity",
    name = "railloader-fluid-structure-horizontal",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    flags = {},
    collision_mask = {},
    render_layer = "higher-object-under",
    picture = pictures.railloader_structure_horizontal,
  },
  {
    type = "simple-entity",
    name = "railloader-fluid-structure-vertical",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    flags = {},
    collision_mask = {},
    render_layer = "higher-object-under",
    picture = pictures.railloader_structure_vertical,
  },
  {
    type = "simple-entity",
    name = "railunloader-fluid-structure-horizontal",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    flags = {},
    collision_mask = {},
    render_layer = "floor",
    picture = pictures.railunloader_horizontal,
  },
  {
    type = "simple-entity",
    name = "railunloader-fluid-structure-vertical",
    icon = fluid_wagon.icon,
    icon_size = fluid_wagon.icon_size,
    icon_mipmaps = fluid_wagon.icon_mipmaps,
    flags = {},
    collision_mask = {},
    render_layer = "floor",
    picture = pictures.railunloader_vertical,
  },
}