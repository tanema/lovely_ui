return {
  base = {
    is_visible = true,
    cornerRadius = 0,
    borderWidth = 1,
    textAlign = 'center',
    fontColor = {255,255,255},-- default to white text
    focusColor = {229, 151, 0},
    cursor = love.mouse.getSystemCursor("arrow")
  },
  button = {
    fontColor = {100,100,100},
    bgColor = {255,255,255},
    borderColor = {100,100,100},

    hoverFontColor = {255,255,255},
    hoverBgColor = {100,100,100},

    activeFontColor = {255,255,255},
    activeBgColor = {156,156,156},

    borderWidth = 4,
    cornerRadius = 8,
    cursor = love.mouse.getSystemCursor("hand"),
  },
  checkbox    = {
    w = 40,
    h = 40,
    bgColor = {61,64,68},
    borderColor = {214,221,207},
    hoverFontColor = {45,91,49},
    activeFontColor = {0,168,0},
    borderWidth = 5,
    cursor = love.mouse.getSystemCursor("hand"),
  },
  label       = {
    textAlign = 'left',
  },
  textinput   = {
    fontColor = {100,100,100},
    textAlign = 'left',
    bgColor = {237,237,237},
    borderColor = {220,220,220},

    hoverBgColor = {235, 233, 233},
    hoverBorderColor = {75,75,75},

    activeBgColor = {156,156,156},
    activeBorderColor = {71,71,71},
    cursor = love.mouse.getSystemCursor("ibeam") 
  },
  slider      = {
    barHeight = 5,
    barColor = {61,64,68},

    handleRadius = 15,
    handleColor = {239,239,239},
    hoverHandleColor = {156,156,156}, 
    activeHandleColor = {100,100,100}, 

    cursor = love.mouse.getSystemCursor("hand"),
  },
  colorpicker = {
    borderColor = {50,50,50},
    bgColor = {255,255,255},
  },
  progressbar = {
    borderColor = {50,50,50},
    bgColor = {255,0,0},
  },
  selector    = {
    values = {},
    cursor = love.mouse.getSystemCursor("hand"),
  },
}
