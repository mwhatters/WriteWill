player = {}
player.state = player_states.normal
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
player.previously_on_ground = false
player.landing = false
player.facing = 1

player.t_jump_grace = 4
player.t_jump_grace_y = player.y
player.t_var_jump = 0
player.var_jump_speed = 0

function player.update(self)
  self.on_ground = self:check_solid(0,1)

  -- landing
  if self.on_ground and not self.previously_on_ground then
    self.landing = true
    sfx(audio.sounds.foot_step)
  end

  self.previously_on_ground = self.on_ground

  if input.move_x ~= 0 then
    self.facing = input.move_x
  end

  if player.state == player_states.normal then
    player:normal_update()
  end

  self:move()
end

function player.normal_update(self)
  local accel = 0.4
  if self.on_ground then
    accel = 0.7
  end

  self.speed_x = approach(self.speed_x, self.move_speed * input.move_x, accel)

  self.speed_y += self.gravity
  self.speed_y = min(self.speed_y, self.fall_speed)

  if self.on_ground then
    self.t_jump_grace = 4
    self.t_jump_grace_y = self.y
  else
    self.t_jump_grace = max(0, self.t_jump_grace - 1)
  end

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
  sfx(audio.sounds.wall_jump)
end

function player.walljump(self)
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

tile_y = function(py) return max(0, min(flr(py / 8), 128 - 1)) end


-- Animation

player.a_idle = {rate = 0.5, a = {64,65}}
player.a_move = {rate = 0.06, a = {66,67,68,69}}
player.a_rise = {rate = 0.5, a = {71}}
player.a_fall = {rate = 0.5, a = {70}}

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

  if self.state == player_states.normal then
    self.animation = self:normal_animate()
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
  spr(current_frame, self.x, self.y, 1, 1, self.facing ~= 1)
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



-- helpers

function approach(x, target, max_delta)
	return x < target and min(x + max_delta, target) or max(x - max_delta, target)
end