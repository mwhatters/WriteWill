input = {}
input.buffer_default = 5

input.move_x = 0
input.left = false
input.right = false

input.jump = false
input.jump_just_pressed = false
input.jump_just_pressed_held = false
input.jump_held = false
input.jump_buffer = 0
input.jump_cooldown = input.buffer_default

input.slide = false
input.slide_just_pressed = false
input.slide_just_pressed_held = false
input.slide_buffer = 0
input.slide_cooldown = input.buffer_default

function input.update(self)
  self:decrement_buffers()
  self:update_move_x()
  self.jump = self:get_jump()
  self.slide = self:get_slide()
end

function input.update_move_x(self)
  self.move_x = 0
  if btn(buttons.right) then self.move_x += 1 end
  if btn(buttons.left)  then self.move_x -= 1 end
  self.left = self.move_x < 0
  self.right = self.move_x > 0
end

function input.get_jump(self)
  if self.jump_cooldown > 0 then return false end
  if btn(buttons.z) then
    input.jump_held = true

    if not input.jump_just_pressed_held then
      input.jump_just_pressed = true
    end

    if input.jump_just_pressed then
      input.jump_just_pressed = false
      input.jump_just_pressed_held = true
      self.jump_buffer = self.buffer_default 
    end
  else
    input.jump_held = false
    input.jump_just_pressed = false
    input.jump_just_pressed_held = false
  end

  return self.jump_buffer > 0
end

function input.get_slide(self)
  if self.slide_cooldown > 0 then return false end
  if btn(buttons.x) then 
    if not input.slide_just_pressed_held then
      input.slide_just_pressed = true
    end

    if input.slide_just_pressed then
      input.slide_just_pressed = false
      input.slide_just_pressed_held = true
      self.slide_buffer = self.buffer_default 
    end
  else
    input.slide_just_pressed = false
    input.slide_just_pressed_held = false
  end

  return self.slide_buffer > 0
end

function input.decrement_buffers(self)
  self.jump_buffer = max(0, self.jump_buffer - 1)
  self.slide_buffer = max(0, self.slide_buffer - 1)
  self.jump_cooldown = max(0, self.jump_cooldown - 1)
  self.slide_cooldown = max(0, self.slide_cooldown - 1)

end

function input.consume_jump(self)
  self.jump_buffer = 0
  self.jump_cooldown = input.buffer_default
end

function input.consume_slide(self)
  self.slide_buffer = 0
  self.slide_cooldown = input.buffer_default
end