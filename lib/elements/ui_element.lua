local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local base_defaults = require(_PACKAGE..'/elements/defaults')
local UIElement = class('UIElement')

function UIElement:initialize(options, defaults)
  self.x, self.y, self.w, self.h = 0, 0, 100, 50

  for k, v in pairs(base_defaults.base) do self[k] = v end

  defaults = defaults and defaults or {}
  for k,v in pairs(defaults) do self[k] = v end

  self.options = options and options or {}
  for key, val in pairs(self.options) do self[key] = val end

  self.event_handlers = {}
  self.hasHover = false
  --used for button down styles and focused inputs
  self.isActive = false 
end

function UIElement:isInside(x, y)
  return x > self.x and y > self.y and x < self.x + self.w and y < self.y + self.h
end

function UIElement:onHover(cursor)
  if not self.hasHover then
    self:trigger('hover', true)
  end
  love.mouse.setCursor(self.cursor)
  self.hasHover = true
end

local arrow = love.mouse.getSystemCursor("arrow")
function UIElement:onHoverEnd()
  self.hasHover = false
  love.mouse.setCursor(arrow)-- reset any hover cursor
  self:trigger('hover', false)
end

function UIElement:hide()
  self.is_visible = false
end

function UIElement:show()
  self.is_visible = true
end

function UIElement:setValue(val)
end

function UIElement:getValue()
end

function UIElement:on(events, callback)
  for event_name in string.gmatch(events, "([%S]+)") do
    if self.event_handlers[event_name] == nil then
      self.event_handlers[event_name] = {}
    end
    self.event_handlers[event_name][#self.event_handlers[event_name]+1] = callback
  end
  return self
end

function UIElement:trigger(events, ...)
  for event_name in string.gmatch(events, "([%S]+)") do
    if self.event_handlers[event_name] ~= nil then
      for _, handler in ipairs(self.event_handlers[event_name]) do
        handler(self, ...)
      end
    end
  end
end

function UIElement:update(dt, mx, my)
end

function UIElement:draw()
  love.graphics.push()
    self:drawBackground()
    self:drawFocus()
    self:drawBorder()
    self:drawText()
  love.graphics.pop()
end
 
local function capitalize(str)
  return (str:gsub("^%l", string.upper))
end

function UIElement:setColor(attr)
  if self["active"..capitalize(attr).."Color"] ~= nil and self.isActive then
    love.graphics.setColor(unpack(self["active"..capitalize(attr).."Color"]))
  elseif self["hover"..capitalize(attr).."Color"] ~= nil and self.hasHover then
    love.graphics.setColor(unpack(self["hover"..capitalize(attr).."Color"]))
  else
    love.graphics.setColor(unpack(self[attr.."Color"]))
  end
end

function UIElement:hasColor(attr)
  return self[attr.."Color"] ~= nil or 
    (self["hover"..capitalize(attr).."Color"] ~= nil and self.hasHover) or
    (self["active"..capitalize(attr).."Color"] ~= nil and self.isActive)
end

function UIElement:drawBackground()
  if self:hasColor('bg') then
    self:setColor('bg')
    love.graphics.roundrectangle('fill', self.x, self.y, self.w, self.h, self.cornerRadius)
  end
end

function UIElement:drawFocus()
  if self:hasColor('focus') and self.hasFocus then
    self:setColor('focus')
    love.graphics.roundrectangle('line', self.x-2, self.y-2, self.w+4, self.h+4, self.cornerRadius)
  end
end

function UIElement:drawBorder()
  if self:hasColor('border') then
    self:setColor('border')
    love.graphics.setLineWidth(self.borderWidth)
    love.graphics.roundrectangle('line', self.x, self.y, self.w, self.h, self.cornerRadius)
  end
end

function UIElement:drawText()
  if self:hasColor('font') and self.text ~= nil then
    local font = self.font and self.font or love.graphics.getFont()
    local textWidth, textHeight = font:getWidth(self.text), font:getHeight(self.text)

    love.graphics.setFont(font)

    local y
    if self.textAlign == 'center' then
      y = self.y + ((self.h - textHeight) / 1.9) 
    else
      y = self.y + textHeight/2
    end

    self:setColor('font')
    love.graphics.printf(self.text, self.x+5, y, self.w, self.textAlign)
  end
end

return UIElement
