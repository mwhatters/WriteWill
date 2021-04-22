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
}

player_states = {
  normal = 0,
  slide = 1,
  wallslide = 2,
}


-- helpers

function approach(x, target, max_delta)
	return x < target and min(x + max_delta, target) or max(x - max_delta, target)
end

function tile_y(py) 
  return max(0, min(flr(py / 8), 128 - 1)) 
end