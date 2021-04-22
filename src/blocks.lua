-- this aint used

blocks = {}

function blocks.update(self)
  for block in all(self) do
    block:update(block)
  end
end

function blocks.draw(self)
  for block in all(self) do
    block:draw(block)
  end
end

function blocks.create(x,y)
  local block = {
    x=x,
    y=y,
    update=function(self)
    end,
    draw=function(self)
      spr(sprites.block,self.x,self.y)
    end
  }

  add(blocks, block)
end