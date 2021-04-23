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
  camera(player.x - 32, player_pos_y)
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
  end
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
  print(camera_x, 0,0)
  map(0, 0, 0, 0, 128, 32)
  player:draw()
  blocks:draw()
end

function increment_t()
  timer += 1
end