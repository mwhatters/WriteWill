function _init()
  music(audio.tracks.intro)
end

function _update()
  input:update()
  player:update()
  blocks:update()
end

function _draw()
  cls(1)
  player:draw()
  blocks:draw()
  increment_t()
  map(0,0,0,0,16,16)
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