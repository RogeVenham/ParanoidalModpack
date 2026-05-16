script.on_nth_tick(60, function()
  local pregen_radius = settings.global["pregen-radius"].value

  for _, player in pairs(game.connected_players) do
    if player.valid and player.position then
      local surface = player.surface

      local center_x = math.floor(player.position.x / 32)
      local center_y = math.floor(player.position.y / 32)

      for x = -pregen_radius, pregen_radius do
        for y = -pregen_radius, pregen_radius do
          local chunk_pos = { center_x + x, center_y + y }

          if not surface.is_chunk_generated(chunk_pos) then
            local world_x = chunk_pos[1] * 32
            local world_y = chunk_pos[2] * 32

            surface.request_to_generate_chunks({ world_x, world_y }, 0)
          end
        end
      end
    end
  end
end)
