t = 0
music(audio.tracks.intro) -- play music from pattern 0

function _update()
  player:update()
end


function _draw()
  cls(1)
  player:draw()
  t += 1

  -- for i=1,11 do               -- for each letter
  --   for j=0,7 do              -- for each rainbow trail part
  --     t1 = t + i*4 - j*2      -- adjusted time
  --     y = 15-j + cos(t1/25)*5 -- vertical position
  --     pal(7, 14-j)            -- remap colour from white
  --     spr(16+i, 8+i*8, y)     -- draw letter sprite
  --   end
  -- end
  -- print(t, 37, 70, 14)
end