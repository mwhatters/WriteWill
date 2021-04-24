 timer = 0
 
 audio = {
   tracks = {
     intro = 0
   },
   sounds = {
     snare = 0,
     kick = 1,
     hat = 2,
     drum_groove = 10,
     jump = 60,
     wall_jump = 61,
     foot_step = 62,
     slide = 59,
     die = 5,
     checkpoint = 6,
   },
 }

buttons = {
  left = 0,
  right = 1,
  up = 2,
  down = 3,
  z = 4,
  x = 5,
}

sprites = {
  block = 1,
}

game_mode = {
  intro = 1,
  game = 2,
}

flags = {
  ground = 0,
  jump_through = 1,
  checkpoint = 2,
}

player_states = {
  normal = 0,
  slide = 1,
  wallslide = 2,
  dead = 99,
}

game_state = {
  intro = {
    level = false
  },
  level_1 = {
    level = true,
    spawn_x = 64,
    spawn_y = 64,
    camera_y_offset = 70,
    camera_x_offset = 32,
    bounds_top = 0,
    bounds_bottom = 0,
    bounds_left = -30,
    bounds_right = 900,
  },
}


-- helpers

function approach(x, target, max_delta)
	return x < target and min(x + max_delta, target) or max(x - max_delta, target)
end

function tile_y(py) 
  return max(0, min(flr(py / 8), 200 - 1)) 
end