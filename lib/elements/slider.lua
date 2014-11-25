local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local Slider = class('Slider', KeyableElement)

function Slider:initialize(options)
  KeyableElement.initialize(self, options, defaults.slider)   

  self:setValue(self.value and self.value or 0)
end

function Slider:checkValue()
  assert(type(self.value) == "number", "slider expects a number between 1 and 0")
  if self.value > 1 then
    self.value = 1
  elseif self.value < 0 then
    self.value = 0
  end
end

function Slider:getValue()
  return self.value
end

function Slider:setValue(val)
  self.value = val
  self:checkValue()
  self:trigger('change', self.value)
end

function Slider:isInside(x, y)
  local handlex, handley = self.x + (self.w * self.value), self.y + (self.h/2)
  return x > handlex-self.handleRadius and y > handley-self.handleRadius and 
         x < handlex+self.handleRadius and y < handley+self.handleRadius
end

function Slider:mousepressed(event, mx, my)
  KeyableElement.mousepressed(self, event, mx, my)
  self.isActive = true
end

function Slider:left()
  self:setValue(self.value-0.05)
  return false
end

function Slider:right()
  self:setValue(self.value+0.05)
  return false
end

function Slider:update(dt, mx, my)
  KeyableElement.update(self, dt, mx, my)
  if self.isActive == true and love.mouse.isDown("l") then
    self:setValue(((mx - self.x) / self.w)) --check and trigger change
  else
    self.isActive = false
  end
end

function Slider:drawText()
  self:drawBar()
  self:drawHandle()
end

function Slider:drawBar()
  self:setColor('bar')
  love.graphics.roundrectangle('fill', 
    self.x, self.y + (self.h/2) - (self.barHeight/2), 
    self.w, self.barHeight, self.cornerRadius)
end

function Slider:drawHandle()
  self:setColor('handle')
  love.graphics.circle( "fill", 
    self.x + (self.w * self.value), self.y + (self.h/2), 
    self.handleRadius)
end

return Slider
