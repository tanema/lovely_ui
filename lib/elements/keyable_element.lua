local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local ClickableElement = require(_PACKAGE..'/elements/clickable_element')
local KeyableElement = class('KeyableElement', ClickableElement)

function KeyableElement:keypressed(key, isrepeat)
  self:trigger('keydown', key, isrepeat)
  if key == "down" then
    return self:down()
  elseif key == "right" then
    return self:right()
  elseif key == "up" then
    return self:up()
  elseif key == "left" then
    return self:left()
  elseif key == "backspace" then
    return self:backspace()
  elseif key == "return" then
    return self:selected()
  end
end

function KeyableElement:keyreleased(key)
  self:trigger('keyup keypress', key)
end

function KeyableElement:gamepadpressed(joystick, button)
  self:trigger('gamepaddown', joystick, button)
  if button == "dpdown" then
    return self:down()
  elseif button == "dpright" then
    return self:right()
  elseif button == "dpup" then
    return self:up()
  elseif button == "dpleft" then
    return self:left()
  elseif button == "b" then
    return self:backspace()
  elseif button == "a" then
    return self:selected()
  end
end

function KeyableElement:gamepadreleased(joystick, button)
  self:trigger('gamepadup gamepadpress', joystick, button)
end

function KeyableElement:up()
end

function KeyableElement:down()
end

function KeyableElement:left()
end

function KeyableElement:right()
end

function KeyableElement:backspace()
end

function KeyableElement:selected()
  self:trigger('selected')
  return false --stop bubble of event
end

function KeyableElement:textinput(text)
end

return KeyableElement

