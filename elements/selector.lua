local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local Selector = class('Selector', KeyableElement)

function Selector:initialize(x, y, w, h, options)
  KeyableElement.initialize(self, x, y, w, h, options, defaults.selector)   

  self.selectedIndex = self.value and self.value or 1
  assert(#self.values > 0, 'no values provided to selector')
end

function Selector:getValue()
  return self.values[self.selectedIndex]
end

function Selector:setValue(val)
  self.selectedIndex = 1
  for i = 1, #self.values do
    if val == self.values[i] then
      self.selectedIndex = i
    end
  end
  self:trigger('change', self.values[self.selectedIndex])
end

function Selector:isInside(x, y)
  return self:isInsideLeft(x, y) or self:isInsideRight(x, y)
end

function Selector:isInsideLeft(x, y)
  local sixteenth = self.w/16
  return x > self.x and y > self.y and x < self.x + (2*sixteenth) and y < self.y + self.h
end

function Selector:isInsideRight(x, y)
  local sixteenth = self.w/16
  local selfx = self.x+self.w-(2*sixteenth)
  return x > selfx and y > self.y and x < selfx + (2*sixteenth) and y < self.y + self.h
end

function Selector:mousereleased(event, mx, my)
  KeyableElement.mousepressed(self, event, mx, my)
  if self:isInsideLeft(mx, my) then
    self:prevValue()
  elseif self:isInsideRight(mx, my) then
    self:nextValue()
  end
end

function Selector:nextValue()
  if self.selectedIndex < #self.values then
    self.selectedIndex = self.selectedIndex + 1
  else
    self.selectedIndex = 1
  end
end

function Selector:prevValue()
  if self.selectedIndex > 1 then
    self.selectedIndex = self.selectedIndex - 1
  else
    self.selectedIndex = #self.values
  end
end

function Selector:left()
  self:prevValue()
  return false
end

function Selector:right()
  self:nextValue()
  return false
end

function Selector:drawLeftArrow()
  local sixteenth = self.w/16

  love.graphics.polygon('fill', {
    self.x+(2*sixteenth), self.y,
    self.x+(2*sixteenth), self.y + self.h,
    self.x, self.y + self.h/2
  })
end

function Selector:drawRightArrow()
  local sixteenth = self.w/16

  love.graphics.polygon('fill', {
    self.x+self.w-(2*sixteenth), self.y,
    self.x+self.w-(2*sixteenth), self.y + self.h,
    self.x+self.w, self.y + self.h/2
  })
end

function Selector:drawText()
  local sixteenth = self.w/16
  local text = self:getValue()
  local font = self.font and self.font or love.graphics.getFont()
  local textWidth, textHeight = font:getWidth(text), font:getHeight(text)

  self:setColor('font')
  self:drawLeftArrow()
  self:drawRightArrow()
  love.graphics.printf(self:getValue(), 
    self.x + (3*sixteenth), (self.y + (self.h - textHeight) / 1.5), 
    self.w - (6*sixteenth), self.textAlign)
end

return Selector

