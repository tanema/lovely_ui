local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local UIElement = require(_PACKAGE..'/elements/ui_element')
local FocusableElement = class('FocusableElement', UIElement)

function FocusableElement:focus()
  self:trigger('focus')
  self.hasFocus = true
end

function FocusableElement:blur()
  self:trigger('blur')
  self.hasFocus = false
end

return FocusableElement

