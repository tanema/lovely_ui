local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local UIElement = require(_PACKAGE..'/elements/ui_element')
local ProgressBar = class('ProgressBar', UIElement)

function ProgressBar:initialize(x, y, w, h, options)
  UIElement.initialize(self, x, y, w, h, options, defaults.progressbar)   
  
  self:setValue(self.value or 0)
end

function ProgressBar:setValue(val)
  self.value = val
  self:checkValue()
  self:trigger('change', self.value)
end

function ProgressBar:getValue()
  return self.value
end

function ProgressBar:checkValue()
  assert(type(self.value) == "number", "slider expects a number between 1 and 0")
  if self.value > 1 then
    self.value = 1
  elseif self.value < 0 then
    self.value = 0
  end
end

function ProgressBar:tick()
  if self.value < 1 then
    self.value = self.value + 0.01
  end
end

function ProgressBar:drawBackground()
  self:setColor('bg')
  love.graphics.roundrectangle('fill', self.x, self.y, self.w*self.value, self.h, self.cornerRadius)
end

return ProgressBar
