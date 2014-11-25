local UI = require 'ui'
local ui
local titleFont = love.graphics.newFont(35)
local labelFont = love.graphics.newFont(25)

function love.load()
  ui = UI:new({
    x = 50,
    y = 50,
    w = love.graphics.getWidth(), 
    h = love.graphics.getHeight(),
    borderColor = {255,255,255}
  })     

  local startButton = ui:addButton({
    x = 30,
    y = 30,
    w = 200, 
    h = 80,
    text = 'start',
    font = titleFont,
  }):on('selected', function(button)
    print('start')
  end)

  ui:addButton({
    x = 30,
    y = 120,
    w = 200, 
    h = 80,
    text = 'quit',
    font = titleFont,
  }):on('selected', function(button)
    love.event.quit()
  end)

  ui:addLabel({
    x = 250,
    y = 30,
    w = 300, 
    h = 80,
    text = 'Lovely_UI',
    font = titleFont,
  })

  ui:addCheckbox({
    x = 30,
    y = 210,
    value = true
  }):on('change', function(checkbox, value) 
    if value == true then
      startButton:show()
    else
      startButton:hide()
    end
  end)
  ui:addLabel({
    x = 90,
    y = 210,
    w = 300, 
    h = 80,
    text = 'Add awesome',
    font = labelFont,
  })

  ui:addTextInput({
    x = 30,
    y = 260,
    w = 200, 
    h = 40,
    value = "anon",
  })
  ui:addLabel({
    x = 250,
    y = 260,
    w = 300, 
    h = 80,
    text = 'Your name',
    font = labelFont,
  })

  local progressBar = ui:addProgressBar({
    x = 30,
    y = 355,
    w = 200, 
    h = 40,
    value = 0.3
  })
  local scaleLabel = ui:addLabel({
    x = 250,
    y = 305,
    w = 300, 
    h = 80,
    text = '30',
    font = labelFont,
  })
  ui:addSlider({
    x = 30,
    y = 305,
    w = 200, 
    h = 40,
    value = 0.30
  }):on('change', function(button, value) 
    scaleLabel.text = math.floor(value*100)
    progressBar:setValue(value)
  end)

  ui:addSelector({
    x = 30,
    y = 410,
    w = 200, 
    h = 40,
    value = 2,
    values = {
      "1024 x 768",  
      "1152 x 864",  
      "1280 x 720",  
      "1280 x 768",  
      "1280 x 800",  
      "1280 x 960",  
      "1280 x 1024",
    }
  })

  ui:addColorPicker({x = 400, y = 120})
end

function love.quit()
  ui:dispose()
  love.graphics.clear()
end

return Menu

