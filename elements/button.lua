local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local Button = class('Button', KeyableElement)

function Button:initialize(x, y, w, h, options)
  KeyableElement.initialize(self, x, y, w, h, options, defaults.button)   
end

function Button:mousepressed(event, x, y)
  KeyableElement.mousepressed(self, event, x, y)
  self.isActive = true
end

function Button:mousereleased(event, x, y)
  KeyableElement.mousereleased(self, event, x, y)
  self.isActive = false
end

function Button:onHoverEnd()
  KeyableElement.onHoverEnd(self)
  self.isActive = false
end

return Button
