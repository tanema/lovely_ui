local UI = require 'ui'
local ui
local titleFont = love.graphics.newFont(35)
local labelFont = love.graphics.newFont(25)

function love.load()
  ui = UI:new(50,50,love.graphics.getWidth(), love.graphics.getHeight(), {
    borderColor = {255,255,255}
  })     

  local startButton = ui:addButton(30, 30, 200, 80, {
    text = 'start',
    font = titleFont,
  }):on('selected', function(button)
    print('start')
  end)

  ui:addButton(30, 120, 200, 80, {
    text = 'quit',
    font = titleFont,
  }):on('selected', function(button)
    love.event.quit()
  end)

  ui:addLabel(250, 30, 300, 80, {
    text = 'Lovely_UI',
    font = titleFont,
  })

  ui:addCheckbox(30, 210, 40, 40, {
    value = true
  }):on('change', function(checkbox, value) 
    if value == true then
      startButton:show()
    else
      startButton:hide()
    end
  end)
  ui:addLabel(90, 210, 300, 80, {
    text = 'Add awesome',
    font = labelFont,
  })

  ui:addTextInput(30, 260, 200, 40, {
    value = "anon",
  })
  ui:addLabel(250, 260, 300, 80, {
    text = 'Your name',
    font = labelFont,
  })

  local progressBar = ui:addProgressBar(30, 355, 200, 40, {
    value = 0.3
  })
  local scaleLabel = ui:addLabel(250, 305, 300, 80, {
    text = '30',
    font = labelFont,
  })
  ui:addSlider(30, 305, 200, 40, {
    value = 0.30
  }):on('change', function(button, value) 
    scaleLabel.text = math.floor(value*100)
    progressBar:setValue(value)
  end)

  ui:addSelector(30, 410, 200, 40, {
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

  ui:addColorPicker(400, 120)
end

function love.quit()
  ui:dispose()
  love.graphics.clear()
end

return Menu

