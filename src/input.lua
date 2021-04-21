input = {}
input.move_x = 0
input.left = false
input.right = false
input.jump = false
input.jump_held = false
input.buffer_default = 5
input.jump_buffer = 0

function input.update(self)
  self:decrement_buffers()
  self:update_move_x()
  self.jump = self:get_jump()
  self.jump_held = btn(buttons.z)
end

function input.update_move_x(self)
  self.move_x = 0
  if btn(buttons.right) then self.move_x += 1 end
  if btn(buttons.left)  then self.move_x -= 1 end
  self.left = self.move_x < 0
  self.right = self.move_x > 0
end

function input.get_jump(self)
  if btnp(buttons.z) then self.jump_buffer = self.buffer_default end
  return self.jump_buffer > 0
end

function input.decrement_buffers(self)
  self.jump_buffer = max(0, self.jump_buffer - 1)
end

function input.consume_jump(self)
  self.jump_buffer = 0
end