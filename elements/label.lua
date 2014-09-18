local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local UIElement = require(_PACKAGE..'/elements/ui_element')
local Label = class('Label', UIElement)

function Label:initialize(x, y, w, h, options)
  UIElement.initialize(self, x, y, w, h, options, defaults.label)   
end

return Label
