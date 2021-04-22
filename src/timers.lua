-- this aint used

timers = {}

function timers.update()
  for timer in all(timers) do
    timer:update()
  end
end

function timers.new(time)
  local timer = {}

  timer.init_time = time
  timer.time = time
  timer.running = true
  timer.stopped = false

  timer.init = function(self)
    self.time = 0
    self.running = false
    self.stopped = true
  end

  timer.update = function(self)
    self.time = max(0, time - 1)
    self.running = self.time > 0
    self.stopped = self.time == 0
  end

  timer.reset = function(self)
    self.time = self.init_time
  end

  timer.clear = function(self)
    self.time = 0
  end

  timer:init()
  add(timers, timer)
  return timer
end
