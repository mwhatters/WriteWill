player_pos_y = 0
function _init()
  music(audio.tracks.intro)
  player_pos_y = player.y - 70
end

function _update()
  input:update()
  player:update()
  blocks:update()
  camera(player.x - 32, player_pos_y)
end

function _draw()
  cls(12)
  map(0,0,0,0,128,32)
  player:draw()
  blocks:draw()
  increment_t()
end

function increment_t()
  timer += 1
end

function lines_overlapping(min1,max1,min2,max2)
  return max1 > min2 and max2 < min1
end

function rects_overlapping(left1,top1,right1,bottom1, left2,top2,right2,bottom2)
  return lines_overlapping(left1,right1,left2,right2) and lines_overlapping(top1,bottom1,top2,bottom2)
end

function bounding_boxes_overlapping(obj1,obj2)
end