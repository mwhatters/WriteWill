player = {}
player.x = 64
player.y = 64
player.height = 6
player.width = 8
player.speed_x = 2
player.speed_y = 2
player.spr = 0

function player.update(self)
  if btn(buttons.left) then
    self.x -= self.speed_x
    self.x = max(self.x, 0)
  end
  if btn(buttons.right) then
    self.x += self.speed_x
    self.x = min(self.x, 128 - self.width - 1)
  end
  if btn(buttons.up) then
    self.y -= self.speed_y
    self.y = max(self.y, 0)
  end
  if btn(buttons.down) then
    self.y += self.speed_y
    self.y = min(self.y, 129 - self.height - 1)
  end
end

function player.draw(self)
  -- position display
  print("x:"..self.x, self.x - 10, self.y - 10, 15)
  print("y:"..self.y, self.x - 10, self.y - 5, 13)

  -- sprite
  rectfill(self.x, self.y, self.x + self.width, self.y + self.height, 14)
end

-- function player.jump(self):
-- end
