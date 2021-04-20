function _init()
  music(audio.tracks.intro)
  blocks.create(50,50)
end

function _update()
  player:update()
  blocks:update()
end

function _draw()
  cls(1)
  player:draw()
  blocks:draw()
  increment_t()
end

function increment_t()
  timer += 1
end