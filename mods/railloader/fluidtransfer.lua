---@diagnostic disable: undefined-global

local Event = require "Event"
local util = require "util"

local M = {}

local DISABLE_SIGNAL = { type = "virtual", name = "railloader-disable" }
local TRANSFER_PER_TICK = 200
local ACTIVE_STATIONS = "active_fluid_stations"

local function active_stations()
  global[ACTIVE_STATIONS] = global[ACTIVE_STATIONS] or {}
  return global[ACTIVE_STATIONS]
end

local function update_tick_registration()
  local active = global[ACTIVE_STATIONS]
  if active and next(active) then
    Event.register_nth_tick(1, M.on_tick)
  else
    Event.unregister_nth_tick(1, M.on_tick)
  end
end

local function station_prefix(station)
  return string.match(station.name, "^(railu?n?loader)")
end

local function first_fluidbox_contents(entity)
  for i = 1, #entity.fluidbox do
    local fluid = entity.fluidbox[i]
    if fluid and fluid.name and fluid.amount > 0 then
      return fluid
    end
  end
end

local function first_fluid_name(entity)
  return next(entity.get_fluid_contents())
end

local function is_disabled(station)
  for _, wire_type in ipairs{defines.wire_type.red, defines.wire_type.green} do
    local network = station.get_circuit_network(wire_type)
    if network and (network.get_signal(DISABLE_SIGNAL) or 0) ~= 0 then
      return true
    end
  end
  return false
end

local function transfer_fluid(source, target)
  local source_fluid = first_fluidbox_contents(source)
  if not source_fluid then
    return 0
  end

  local target_fluid = first_fluid_name(target)
  if target_fluid and target_fluid ~= source_fluid.name then
    return 0
  end

  local moved = target.insert_fluid{
    name = source_fluid.name,
    amount = math.min(source_fluid.amount, TRANSFER_PER_TICK),
    temperature = source_fluid.temperature,
  }
  if moved > 0 then
    source.remove_fluid{ name = source_fluid.name, amount = moved }
  end
  return moved
end

local function should_unregister(station)
  if not station or not station.valid then
    return true
  end

  local wagon = util.find_fluid_wagons_from_station(station)[1]
  if not wagon then
    return true
  end

  if is_disabled(station) then
    return false
  end

  if station_prefix(station) == "railloader" then
    transfer_fluid(station, wagon)
  else
    transfer_fluid(wagon, station)
  end

  return false
end

function M.register(station)
  if not station or not station.valid or not util.is_fluid_station_name(station.name) then
    return
  end

  active_stations()[station.unit_number] = station
  update_tick_registration()
end

function M.unregister(station)
  local unit_number = station
  if type(station) ~= "number" then
    unit_number = station and station.unit_number
  end
  if not unit_number then
    return
  end

  active_stations()[unit_number] = nil
  update_tick_registration()
end

function M.register_if_wagon_present(station)
  if util.find_fluid_wagons_from_station(station)[1] then
    M.register(station)
  end
end

function M.on_train_changed_state(event)
  local train = event.train
  if train.state ~= defines.train_state.wait_station and
    event.old_state ~= defines.train_state.wait_station then
    return
  end

  for _, wagon in ipairs(train.fluid_wagons) do
    for _, station in ipairs(util.find_fluid_stations_from_wagon(wagon)) do
      if train.state == defines.train_state.wait_station then
        M.register(station)
      else
        M.unregister(station)
      end
    end
  end
end

function M.on_tick()
  local active = active_stations()
  local to_unregister = {}

  for unit_number, station in pairs(active) do
    if should_unregister(station) then
      to_unregister[#to_unregister+1] = unit_number
    end
  end

  for _, unit_number in ipairs(to_unregister) do
    active[unit_number] = nil
  end

  update_tick_registration()
end

function M.on_init()
  active_stations()
end

function M.on_load()
  update_tick_registration()
end

return M