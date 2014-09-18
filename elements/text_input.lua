local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local TextInput = class('TextInput', KeyableElement)

function TextInput:initialize(x, y, w, h, options) 
  KeyableElement.initialize(self, x, y, w, h, options, defaults.textinput)

  if self.value ~= nil then
    self.text = self.value
  end
end

function TextInput:setValue(val)
  local font = self.font and self.font or love.graphics.getFont()
  local textWidth = font:getWidth(val)
  if textWidth < self.w - 6 then
    self.text = val
  end
end

function TextInput:getValue()
  return self.text
end

function TextInput:focus()
  KeyableElement.focus(self)
  love.keyboard.setTextInput(true)
end

function TextInput:blur()
  KeyableElement.blur(self)
  love.keyboard.setTextInput(false)
end

function TextInput:backspace()
  self:setValue(self.text:sub(1, -2))
end

function TextInput:textinput(text)
  self:setValue(self.text .. text)
end

return TextInput
