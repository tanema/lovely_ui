local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]elements", "")
local class = require(_PACKAGE..'/middleclass')
local defaults = require(_PACKAGE..'/elements/defaults')
local KeyableElement = require(_PACKAGE..'/elements/keyable_element')
local ColorPicker = class('ColorPicker', KeyableElement)

function ColorPicker:initialize(options) 
  KeyableElement.initialize(self, options, defaults.colorpicker)   

  self.colorboxData = love.image.newImageData(_PACKAGE:gsub("%.", "/")..'/assets/colorbox.png' ) 
	self.colorbox = love.graphics.newImage( self.colorboxData )
	self.w = self.colorbox:getWidth()
	self.h = self.colorbox:getHeight()

  if self.value ~= nil then
    self:setValue(self.value)
  else
    self:setValue(1,1,255)
  end
end

function ColorPicker:drawBackground()
  self:setColor('bg')
	love.graphics.draw( self.colorbox, self.x, self.y )
end

function ColorPicker:drawText()
  self:drawSelectedColor()
end

function ColorPicker:drawSelectedColor()
  local x, y = self.selectedColor.x + self.x, self.selectedColor.y + self.y
  self:setColor('border')
  love.graphics.rectangle( 'fill', x-24, y-24, 24, 24)
  love.graphics.setColor(self.selectedColor.r,self.selectedColor.g,self.selectedColor.b)
  love.graphics.rectangle( 'fill', x-22, y-22, 20, 20)
end

function ColorPicker:mousepressed(event, mx, my)
  KeyableElement.mousepressed(self, event, mx, my)
  self.mouseDown = true
  self:setSelectedColor(mx - self.x, my - self.y)
end

function ColorPicker:mousereleased(event, mx, my)
  KeyableElement.mousepressed(self, event, mx, my)
  self.mouseDown = false
end

function ColorPicker:onHoverEnd()
  KeyableElement.onHoverEnd(self)
  self.mouseDown = false
end

function ColorPicker:update(dt, mx, my)
  KeyableElement.update(self, dt, mx, my)
  if self.mouseDown == true then
    self:setSelectedColor(mx - self.x, my - self.y)
  end
end

function ColorPicker:setSelectedColor(x, y)
  if x > 1 and x < self.colorboxData:getWidth() - 1 and
    y > 1 and y < self.colorboxData:getHeight() - 1 then
      
    local r,g,b = self.colorboxData:getPixel(x, y)
    self.selectedColor = {
      r = r, 
      g = g, 
      b = b, 
      x = x,
      y = y
    }
    self:trigger('change', self:getValue())
  end
end

function ColorPicker:up()
  local r, g, b, x, y = self:getValue()
  self:setSelectedColor(x, y-1)
  return false
end

function ColorPicker:down()
  local r, g, b, x, y = self:getValue()
  self:setSelectedColor(x, y+1)
  return false
end

function ColorPicker:left()
  local r, g, b, x, y = self:getValue()
  self:setSelectedColor(x-1, y)
  return false
end

function ColorPicker:right()
  local r, g, b, x, y = self:getValue()
  self:setSelectedColor(x+1, y)
  return false
end

function ColorPicker:selected()
  KeyableElement.selected(self)--call event but dont return false
end

function ColorPicker:setValue(r, g, b)
  local x, y = self:findColorPosition(r,g,b)
	self.selectedColor = {
    r = r, 
    g = g, 
    b = b, 
    x = x,
    y = y
  }
  self:trigger('change', self:getValue())
end

function ColorPicker:findColorPosition(r,g,b)
 for x = 1, self.colorboxData:getWidth()-1 do
   for y = 1, self.colorboxData:getHeight()-1 do
	  local pr,pg,pb = self.colorboxData:getPixel(x,y)
    if r == pr and g == pg and b == pb then
      return x, y
    end
   end
 end
 return 0,0
end

function ColorPicker:getValue()
	if not self.selectedColor then return 0,0,0,0,0 end
	return self.selectedColor.r, self.selectedColor.g, self.selectedColor.b, self.selectedColor.x, self.selectedColor.y
end

function ColorPicker:clearSelected()
	self.selectedColor = nil
end

return ColorPicker
