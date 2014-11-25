local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local CheckBox = class('Button', KeyableElement)

function CheckBox:initialize(options)
  KeyableElement.initialize(self, options, defaults.checkbox)  

  if self.value == true then
    self.isActive = self.value
  end
end

function CheckBox:mousereleased(event, x, y)
  KeyableElement.mousereleased(self, event, x, y)
  self:setValue(not self.isActive)
end

function CheckBox:selected()
  self:setValue(not self.isActive)
  return KeyableElement.selected(self)
end

function CheckBox:setValue(val)
  self.isActive = val
  self:trigger('change', self.isActive)
end

function CheckBox:getValue()
  return self.isActive
end

function CheckBox:drawCheck()
  local eigthw, eigthh = self.w/8, self.h/8
  local x, y, w, h = self.x, self.y, self.w, self.h

  self:setColor('font')
  love.graphics.roundrectangle('fill', 
    self.x + (2 * eigthw), self.y + (2 * eigthh), 
    self.w - (4 * eigthw), self.h - (4 * eigthh), 
    self.cornerRadius)
end

function CheckBox:drawText()
  if self.isActive or self.hasHover then
    self:drawCheck()
  end
end

return CheckBox
