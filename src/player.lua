player = {}
player.state = player_states.normal
player.next_state = player_states.normal

player.x = 64
player.y = 64
player.spr = 64
player.hitbox = nil

player.speed_x = 0
player.speed_y = 0
player.hit_x = 2
player.hit_y = 1
player.hit_w = 5
player.hit_h = 7
player.remainder_x = 0
player.remainder_y = 0

player.move_speed = 2
player.jump_speed = -3.5
player.fall_speed = 2
player.walljump_speed = 5

player.gravity = 0.7
player.on_ground = true
player.on_wall = false
player.previously_on_ground = true
player.landing = false
player.facing = 1
player.t_facing_locked = 0
player.facing_locked = false

player.t_jump_grace = 4
player.t_jump_grace_y = player.y
player.t_var_jump = 0
player.var_jump_speed = 0

player.t_slide = 0

function player.update(self)
  self.on_ground = self:check_solid(0,1)
  self:set_landing()

  self:set_facing()
  self.on_wall = self:check_solid(self.facing)

  self:state_update()
  self:move()
end

function player.state_update(self)
  if self.state ~= self.next_state then
    self:exit_state()
    self:enter_next_state()
  end

  self.state = self.next_state

  if self.state == player_states.normal then
    self.next_state = self:normal_update()
    return
  end

  if self.state == player_states.slide then
    self.next_state = self:slide_update()
    return
  end

  if self.state == player_states.wallslide then
    self.next_state = self:wallslide_update()
    return
  end
end

function player.exit_state(self)
  if self.state == player_states.normal then
  end

  if self.state == player_states.slide then
    self.facing_locked = false
    self.t_slide = 0
    sfx(-1)
  end

  if self.state == player_states.wallslide then
    self.facing_locked = false
    self.t_slide = 0
    sfx(-1)
  end
end

function player.enter_next_state(self)
  if self.next_state == player_states.normal then
  end

  if self.next_state == player_states.slide then
    self.facing_locked = true
    self.t_slide = 15
    sfx(audio.sounds.slide)
  end

  if self.next_state == player_states.wallslide then
    self.facing_locked = true
    self.t_slide = 15
    sfx(audio.sounds.slide)
  end
end

function player.set_landing(self)
  if self.on_ground and not self.previously_on_ground then
    self.landing = true
    sfx(audio.sounds.foot_step)
  else
    self.landing = false
  end

  self.previously_on_ground = self.on_ground
end

function player.set_facing(self)
  self.t_facing_locked = max(0, self.t_facing_locked - 1)
  if self.t_facing_locked > 0 or self.facing_locked then return end
  if input.move_x ~= 0 then
    self.facing = input.move_x
  end
end

function player.normal_update(self)
  -- acceleration, jump grace
  local accel = 0.2
  if self.on_ground then
    accel = 0.7
    self.t_jump_grace = 4
    self.t_jump_grace_y = self.y
  else
    self.t_jump_grace = max(0, self.t_jump_grace - 1)
  end

  -- move_x
  self.speed_x = approach(self.speed_x, self.move_speed * input.move_x, accel)

  -- gravity
  self.speed_y += self.gravity
  self.speed_y = min(self.speed_y, self.fall_speed)

  -- variable jump
  if self.t_var_jump > 0 then
    if input.jump_held then
      self.speed_y = self.var_jump_speed
      self.t_var_jump -= 1
    else
      self.t_var_jump = 0
    end
  end

  -- jump
  if input.jump then
    if self.t_jump_grace > 0 then
      self:jump()
    elseif self:check_solid(2) then
      self:wall_jump(-1)
    elseif self:check_solid(-2) then
      self:wall_jump(1)
    end
  end

  --slide
  if input.slide then
    if self.on_ground then
      input:consume_slide()
      return player_states.slide
    end

    if self.on_wall then
      input:consume_slide()
      return player_states.wallslide
    end
  end

  return player_states.normal
end

function player.slide_update(self)
  -- acceleration, jump grace
  local accel = 0.3
  if self.on_ground then
    accel = 0.8
    self.t_jump_grace = 4
    self.t_jump_grace_y = self.y
  else
    self.t_jump_grace = max(0, self.t_jump_grace - 1)
  end

  -- slide timer
  self.t_slide = max(0, self.t_slide - 1)

  -- move_x
  self.speed_x = approach(self.speed_x, self.move_speed * self.facing * 1.5, accel)

  if input.jump then
    self:slide_jump()
    return player_states.normal
  end

  if self.t_slide == 0 or self.t_jump_grace == 0 then
    return player_states.normal
  end

  if self.on_wall then
    return player_states.wallslide
  end

  return player_states.slide
end

function player.wallslide_update(self)
  -- acceleration, jump grace
  local accel = 0.3
  if self.on_wall then
    accel = 0.8
    self.t_jump_grace = 4
    self.t_jump_grace_y = self.y
  else
    self.t_jump_grace = max(0, self.t_jump_grace - 1)
  end

  -- slide timer
  self.t_slide = max(0, self.t_slide - 1)

  -- move_y
  self.speed_x = 0
  self.speed_y = approach(self.speed_y, self.move_speed * -1 * 1.5, accel)

  if input.jump then
    self:wallslide_jump(-self.facing)
    return player_states.normal
  end

  if self.t_slide == 0 or self.t_jump_grace == 0 then
    return player_states.normal
  end

  return player_states.wallslide
end

-- Actions

function player.jump(self)
    input:consume_jump()
    self.speed_y = self.jump_speed
    self.y = self.t_jump_grace_y
    self.t_var_jump = 3
    self.var_jump_speed = -3
    sfx(audio.sounds.jump)
end

function player.wall_jump(self, dir)
  input:consume_jump()
  self.facing = dir
  self.speed_y = self.jump_speed
  self.speed_x = 2.5 * dir
  self.t_var_jump = 3
  self.var_jump_speed = -3
  self.t_facing_locked = 5
  sfx(audio.sounds.wall_jump)
end

function player.slide_jump(self)
    input:consume_jump()
    self.speed_y = self.jump_speed * 1.5
    self.y = self.t_jump_grace_y
    self.t_var_jump = 4
    self.var_jump_speed = -4
    sfx(audio.sounds.jump)
end

function player.wallslide_jump(self, dir)
    input:consume_jump()
    self.speed_y = self.jump_speed * 1.7
    self.t_var_jump = 4
    self.var_jump_speed = -4
    self.speed_x = 2.5 * dir
    self.t_facing_locked = 5
    sfx(audio.sounds.jump)
end

-- Movement & Collision

function player.move(self)
  self:move_x(self.speed_x)
  self:move_y(self.speed_y)
end

function player.move_x(self, x)	
	self.remainder_x += x
	local mx = flr(self.remainder_x + 0.5)
	self.remainder_x -= mx

	local total = mx
	local mxs = sgn(mx)
	while mx != 0
	do
		if self:check_solid(mxs, 0) then
			return self:on_collide_x()
		else
			self.x += mxs
			mx -= mxs
		end
	end

	return false
end

function player.move_y(self, y, on_collide)
	self.remainder_y += y
	local my = flr(self.remainder_y + 0.5)
	self.remainder_y -= my

	local total = my
	local mys = sgn(my)
	while my != 0
	do
		if self:check_solid(0, mys) then
			return self:on_collide_y()
		else
			self.y += mys
			my -= mys
		end
	end

	return false
end

function player.on_collide_x(self)
	self.remainder_x = 0
	self.speed_x = 0
	return true
end

function player.on_collide_y(self)
	self.remainder_y = 0
	self.speed_y = 0
	return true
end

function player.check_solid(self, ox, oy)
	ox = ox or 0
	oy = oy or 0
	for i = flr((ox + self.x + self.hit_x) / 8),flr((ox + self.x + self.hit_x + self.hit_w - 1) / 8) do
		for j = tile_y(oy + self.y + self.hit_y),tile_y(oy + self.y + self.hit_y + self.hit_h - 1) do
			if fget(mget(i, j), flags.ground) then
				return true
			end
		end
	end
end

-- Animation

player.a_idle = {rate = 0.5, a = {64,65}}
player.a_move = {rate = 0.06, a = {66,67,68,69}}
player.a_rise = {rate = 0.5, a = {71}}
player.a_fall = {rate = 0.5, a = {70}}
player.a_slide = {rate = 0.5, a = {72}}
player.a_wallslide = {rate = 0.5, a = {73}}

player.animation = player.a_idle
player.previous_animation = player.a_idle
player.animation_idx = 1

player.animation_time = time()

function player.draw(self)
  -- hitbox
  -- hitbox = rect(
  --   self.x + self.hit_x, 
  --   self.y + self.hit_y, 
  --   self.x + self.hit_w, 
  --   self.y + self.hit_h, 8
  -- )

  -- print(input.slide, self.x - 5, self.y - 5)

  if self.state == player_states.normal then
    self.animation = self:normal_animate()
  elseif self.state == player_states.slide then
    self.animation = self.a_slide
  elseif self.state == player_states.wallslide then
    self.animation = self.a_wallslide
  end

  if self.animation ~= self.previous_animation then
    self.animation_idx = 1
    self.previous_animation = self.animation
    self.animation_time = time()
  end

  if time() - self.animation_time > self.animation.rate then
    self.animation_time = time()
    self.animation_idx += 1
    if self.animation.a[self.animation_idx] == nil then
      self.animation_idx = 1
    end
  end

  local current_frame = self.animation.a[self.animation_idx]
  if self.animation == self.a_move then
    if current_frame == 66 then
      sfx(audio.sounds.foot_step)
    end
  end

  -- draw
  local offset_x = 0
  if self.state == player_states.wallslide and self.facing == 1 then
    offset_x = 1
  end
  
  spr(current_frame, self.x + offset_x, self.y, 1, 1, self.facing ~= 1)
end

function player.normal_animate(self)
  if self.on_ground then
    if abs(self.speed_x) > 0 then
      return self.a_move
    end
    return self.a_idle
  end

  if self.speed_y < 0 then return self.a_rise end
  if self.speed_y > 0 then return self.a_fall end

  return self.a_idle
end

function player.slide_animate(self)

end