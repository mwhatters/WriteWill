current_game_state = game_state.intro
player_pos_y = 0
camera_x = 0 
camera_y = 0

function _init()
  music(audio.tracks.intro)
  player_pos_y = player.y - 70
end

function _update()
  camera_x = peek2(0x5f28)
  camera_y = peek2(0x5f2a)
  input:update()
  set_camera()
  if current_game_state == game_state.intro then return update_intro() end
  update_game()
end

function _draw()
  increment_t()
  if current_game_state == game_state.intro then return draw_intro() end
  draw_game()
end

function update_intro()
  if input.jump then
    input:consume_jump()
    current_game_state = game_state.level_1
    start_level(current_game_state)
  end
end

function start_level(level)
  player.x = level.spawn_x
  player.y = level.spawn_y
  set_camera()
end

t_into = 15
t_into_orig = 15
orig_col = 8

function draw_intro()
  cls(0)
  spr(140, 64,64,4,4)

  t_intro = max(0, t_into - 1)
  if t_intro == 0 then
    t_intro = t_into_orig
  end
end

function update_game()
  player:update()
  blocks:update()
end

function draw_game()
  cls(12)
  -- print(input.jump, player.x, player.y - 5,  8)
  -- print(camera_x, player.x, player.y - 10, 8)
  -- print(player.x, player.x, player.y - 15, 9)
  -- print(player.y, player.x, player.y - 20, 9)
  map(0, 0, 0, 0, 128, 32)
  player:draw()
  blocks:draw()
end

function increment_t()
  timer += 1
end

function set_camera()
  if current_game_state.level then
    local target_x = player.x - current_game_state.camera_x_offset or 0
    local target_y = player.y - current_game_state.camera_y_offset or 0
    
    if target_x >= current_game_state.bounds_right or target_x <= current_game_state.bounds_left then
      target_x = camera_x
    end

    if target_y >= current_game_state.bounds_bottom or target_y <= current_game_state.bounds_top then
      target_y = camera_y
    end

    camera(
      target_x, 
      target_y
    )
  else
    camera(0,0)
  end
end