--https://www.love2d.org/forums/viewtopic.php?t=77599&p=165604
function love.graphics.roundrectangle(mode, x, y, w, h, rd, s)
   local r, g, b, a = love.graphics.getColor()
   local rd = rd or math.min(w, h)/4
   local s = s or 32
   local l = love.graphics.getLineWidth()
   
   local corner = 1
   local function mystencil()
      love.graphics.setColor(255, 255, 255, 255)
      if corner == 1 then
         love.graphics.rectangle("fill", x-l, y-l, rd+l, rd+l)
      elseif corner == 2 then
         love.graphics.rectangle("fill", x+w-rd+l, y-l, rd+l, rd+l)
      elseif corner == 3 then
         love.graphics.rectangle("fill", x-l, y+h-rd+l, rd+l, rd+l)
      elseif corner == 4 then
         love.graphics.rectangle("fill", x+w-rd+l, y+h-rd+l, rd+l, rd+l)
      elseif corner == 0 then
         love.graphics.rectangle("fill", x+rd, y-l, w-2*rd+l, h+2*l)
         love.graphics.rectangle("fill", x-l, y+rd, w+2*l, h-2*rd+l)
      end
   end
   
   love.graphics.setStencil(mystencil)
   love.graphics.setColor(r, g, b, a)
   love.graphics.circle(mode, x+rd, y+rd, rd, s)
   love.graphics.setStencil()
   corner = 2
   love.graphics.setStencil(mystencil)
   love.graphics.setColor(r, g, b, a)
   love.graphics.circle(mode, x+w-rd, y+rd, rd, s)
   love.graphics.setStencil()
   corner = 3
   love.graphics.setStencil(mystencil)
   love.graphics.setColor(r, g, b, a)
   love.graphics.circle(mode, x+rd, y+h-rd, rd, s)
   love.graphics.setStencil()
   corner = 4
   love.graphics.setStencil(mystencil)
   love.graphics.setColor(r, g, b, a)
   love.graphics.circle(mode, x+w-rd, y+h-rd, rd, s)
   love.graphics.setStencil()
   corner = 0
   love.graphics.setStencil(mystencil)
   love.graphics.setColor(r, g, b, a)
   love.graphics.rectangle(mode, x, y, w, h)
   love.graphics.setStencil()
end

function love.graphics.multiprint( ... )
   local r, g, b, a = love.graphics.getColor()
   local args = { ... }
   local temp = { ... }
   table.remove(args, 1)
   local texts = temp[1]
   local colors = temp[2]
   local textdist = ""
   for i = 1, #texts do
      love.graphics.setColor(unpack(colors[i]))
      args[1] = texts[i]
      args[2] = temp[3]+love.graphics.getFont():getWidth(textdist)
      love.graphics.print(unpack(args))
      textdist = textdist .. texts[i]
   end
   love.graphics.setColor(r, g, b, a)
end
 
function love.graphics.roundScissor(x, y, w, h, r, s)
   local r = r or false
   if w and h and not r then
      r = math.min(w, h)/4
   end
   local s = s or 32
   local cr, cg, cb, ca = love.graphics.getColor()
   
   local function myStencil()
      if x and y and w and h then
         love.graphics.setColor(255, 255, 255, 255)
         love.graphics.circle("fill", x+r, y+r, r, s)
         love.graphics.circle("fill", x+w-r, y+r, r, s)
         love.graphics.circle("fill", x+r, y+h-r, r, s)
         love.graphics.circle("fill", x+w-r, y+h-r, r, s)
         love.graphics.rectangle("fill", x+r, y, w-2*r, h)
         love.graphics.rectangle("fill", x, y+r, w, h-2*r)
      end
   end
   
   if x and y and w and h then
      love.graphics.setStencil(myStencil)
   else
      love.graphics.setStencil()
   end
   love.graphics.setColor(cr, cg, cb, ca)
end

