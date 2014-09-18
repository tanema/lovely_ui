local _PACKAGE = (...):match("^(.+)[%./][^%./]+")

local class = require(_PACKAGE..'/middleclass')

local FocusableElement = require(_PACKAGE..'/elements/focusable_element')
local ClickableElement = require(_PACKAGE..'/elements/clickable_element')
local KeyableElement   = require(_PACKAGE..'/elements/keyable_element')
local UIElement        = require(_PACKAGE..'/elements/ui_element')

local element_types = {
  button      = require(_PACKAGE..'/elements/button'),
  checkbox    = require(_PACKAGE..'/elements/checkbox'),
  label       = require(_PACKAGE..'/elements/label'),
  textinput   = require(_PACKAGE..'/elements/text_input'),
  slider      = require(_PACKAGE..'/elements/slider'),
  colorpicker = require(_PACKAGE..'/elements/color_picker'),
  progressbar = require(_PACKAGE..'/elements/progress_bar'),
  selector    = require(_PACKAGE..'/elements/selector'),
}

local UI = class('UI', UIElement)

function UI:initialize(x, y, w, h, options)
  UIElement.initialize(self, x, y, w, h, options) 

  self.x = x and x or 0
  self.y = y and y or 0
  self.w = w and w or love.graphics.getWidth()
  self.h = h and h or love.graphics.getHeight()

  self.focus_index = 1
  self.elements = {}
  self:registerEvents()
end

function UI:addButton(x, y, w, h, options)      return self:addElement('button', x, y, w, h, options)      end
function UI:addLabel(x, y, w, h, options)       return self:addElement('label', x, y, w, h, options)       end
function UI:addCheckbox(x, y, w, h, options)    return self:addElement('checkbox', x, y, w, h, options)    end
function UI:addTextInput(x, y, w, h, options)   return self:addElement('textinput', x, y, w, h, options)   end
function UI:addSlider(x, y, w, h, options)      return self:addElement('slider', x, y, w, h, options)      end
function UI:addColorPicker(x, y, options)       return self:addElement('colorpicker', x, y, 0, 0, options) end
function UI:addProgressBar(x, y, w, h, options) return self:addElement('progressbar', x, y, w, h, options) end
function UI:addSelector(x, y, w, h, options)    return self:addElement('selector', x, y, w, h, options)    end

function UI:addElement(element_name, x, y, w, h, options) 
  local new_element = element_types[element_name]:new(x, y, w, h, options)
  self.elements[#self.elements+1] = new_element
  return new_element
end

function UI:removeElement(remove_element) 
  for i, element in ipairs(self.elements) do
    if remove_element == element then
      table.remove(self.elements, i)
      break
    end
  end
end
 
function UI:gamepadpressed(joystick, button) 
  if self:gamepadEvent('gamepadpressed', joystick, button) ~= false then
    if button == "dpdown" or button == "dpright" or button == "a" then
      self:focusNext()
    elseif button == "dpup" or button == "dpleft" then
      self:focusPrev()
    end
  end
end
function UI:gamepadreleased(joystick, button) self:gamepadEvent('gamepadreleased', joystick, button) end

function UI:gamepadEvent(event, joystick, button)
  local focused_element = self.elements[self.focus_index]
  if focused_element ~= nil and focused_element:isInstanceOf(KeyableElement) then
    return focused_element[event](focused_element, key, isrepeat)
  end
end

function UI:keypressed(key, isrepeat)
  if self:keyboardEvent('keypressed', key, isrepeat) ~= false then
    if key == "down" or key == "right" or key == "tab" or key == "return" then
      self:focusNext()
    elseif key == "up" or key == "left" then
      self:focusPrev()
    end
  end
end
function UI:textinput(text)  self:keyboardEvent('textinput', text)  end
function UI:keyreleased(key) self:keyboardEvent('keyreleased', key) end

function UI:keyboardEvent(event, key, isrepeat)
  local focused_element = self.elements[self.focus_index]
  if focused_element ~= nil and focused_element:isInstanceOf(KeyableElement) then
    return focused_element[event](focused_element, key, isrepeat)
  end
end

function UI:mousepressed(x, y)  self:mouseEvent('mousepressed', x, y)  end
function UI:mousereleased(x, y) self:mouseEvent('mousereleased', x, y) end

function UI:mouseEvent(event, x, y)
  --translate mouse coords to ours
  local mx, my = (x-self.x), (y-self.y)
  for i, element in ipairs(self.elements) do
    if element:isInstanceOf(ClickableElement) and element:isInside(mx,my) then
      element[event](element, event, x, y)
      if element:isInstanceOf(FocusableElement) then
        element:focus()
        self.focus_index = i
      end
    elseif element:isInstanceOf(FocusableElement) then
      element:blur()
    end
  end
end

function UI:update(dt)
  local mx, my = love.mouse.getPosition()
  local cursor = love.mouse.getCursor()

  --translate mouse coords to ours
  mx, my = (mx-self.x), (my-self.y)

  for i, element in ipairs(self.elements) do
    if element:isInside(mx,my) then
      element:onHover(cursor)
    elseif element.hasHover then
      element:onHoverEnd()
    end
    element:update(dt, mx, my)
  end
end

function UI:draw()
  love.graphics.push()
    love.graphics.setScissor(self.x, self.y, self.w, self.h)
    love.graphics.translate(self.x, self.y)

    if self.is_visible then
      UIElement.draw(self) 
    end
    for i, element in ipairs(self.elements) do
      if element.is_visible then
        element:draw()
      end
    end

    love.graphics.setScissor()
  love.graphics.pop()
end

function UI:focusNext()
  local focused_element = self.elements[self.focus_index]
  if focused_element ~= nil and focused_element:isInstanceOf(FocusableElement) then
    focused_element:blur()
  end

  for i = self.focus_index + 1, #self.elements do
    focused_element = self.elements[i]
    if i == self.focus_index then
      return  -- stop infinite loops
    elseif focused_element:isInstanceOf(FocusableElement) and focused_element.is_visible then
      self.focus_index = i
      focused_element:focus()
      return
    end
  end

  self.focus_index = 0
  self:focusNext()
end

function UI:focusPrev()
  local focused_element = self.elements[self.focus_index]
  if focused_element ~= nil and focused_element:isInstanceOf(FocusableElement) then
    focused_element:blur()
  end

  for i = self.focus_index - 1, 1, -1 do
    focused_element = self.elements[i]
    if i == self.focus_index then
      return -- stop infinite loops
    elseif focused_element:isInstanceOf(FocusableElement) and focused_element.is_visible then
      self.focus_index = i
      focused_element:focus()
      return
    end
  end

  self.focus_index = #self.elements + 1
  self:focusPrev()
end

local all_callbacks = {
  'draw', 'focus', 'quit', 'resize', 'update', 'visible', 
  'keypressed', 'keyreleased', 'textinput', 
  'mousefocus', 'mousepressed', 'mousereleased', 
  'gamepadpressed', 'gamepadreleased'
}

function UI:registerEvents()
  self.oldKeyRepeat = love.keyboard.hasKeyRepeat()
  love.keyboard.setKeyRepeat(true)

  self.registry = {}
  for _, f in ipairs(all_callbacks) do
    if self[f] ~= nil then
      self.registry[f] = love[f] or __NULL__
      love[f] = function(...)
        self.registry[f](...)
        return self[f](self, ...)
      end
    end
  end
end

function UI:unregisterEvents()
  for _, f in ipairs(all_callbacks) do
    if self[f] ~= nil then
      love[f] = self.registry[f]
    end
  end
end

function UI:dispose()
  self:unregisterEvents()
  love.keyboard.setKeyRepeat(self.oldKeyRepeat)
end

return UI
