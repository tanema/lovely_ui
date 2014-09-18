local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local FocusableElement = require(_PACKAGE..'/elements/focusable_element')
local ClickableElement = class('ClickableElement', FocusableElement)

function ClickableElement:mousepressed(event, x, y)
  self:trigger('mousedown', event, x, y)
end

function ClickableElement:mousereleased(event, x, y)
  self:trigger('mouseup click selected', event, x, y)
  self:focus()
end

return ClickableElement
