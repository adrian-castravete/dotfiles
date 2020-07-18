#!/usr/bin/env lua

function createEmpty(width, height, init)
  local data = {}

  if not init then
    init = 0
  end

  for j=1, height do
    local line = {}
    for i=1, width do
      line[#line+1] = init
    end
    data[#data+1] = line
  end

  data.width = width
  data.height = height

  return data
end

function writeImage(name, image, palette, chars)
  if not chars then
    chars = " .oOxX#M"
  end

  local contents = [[
/* XPM */
static char *{name}[] = {
/* columns rows colors chars-per-pixel */
"{width} {height} {cols} 1",
{palette}
/* pixels */
{data}
};]]
  contents = contents:gsub('{name}', name)
  contents = contents:gsub('{width}', image.width)
  contents = contents:gsub('{height}', image.height)
  contents = contents:gsub('{cols}', #palette)

  local palStr = ""
  for i=1, #palette do
    palStr = palStr .. '"' .. chars:sub(i, i) .. " c " .. palette[i] .. '",'
    if i ~= #palette then
      palStr = palStr .. "\n"
    end
  end
  contents = contents:gsub('{palette}', palStr)

  local data = ""
  for j=1, #image do
    local line = image[j]
    local dataLine = ""
    for i=1, #line do
      local l = line[i]+1
      dataLine = dataLine .. chars:sub(l, l)
    end
    data = data .. '"' .. dataLine .. '"'
    if j ~= #image then
      data = data .. ",\n"
    end
  end
  contents = contents:gsub('{data}', data)

  local fout = io.open(name .. ".xpm", 'w')
  fout:write(contents)
  fout:close()
end

function blit(dest, src, dx, dy)
  local x, y = 0, 0
  if not (src.width or src.height) then
    src.height = #src
    src.width = #src[1]
  end
  for j=1, src.height do
    for i=1, src.width do
      x = dx + i
      y = dy + j
      local cell = src[j][i]
      if cell > 0 and x > 0 and y > 0 and x <= dest.width and y <= dest.height then
        dest[y][x] = cell
      end
    end
  end
end

function drawButton(image, symbol, hi, lo, w, h, x, y)
  if not w then w = image.width end
  if not h then h = image.height end

  if not x then x = 0 end
  if not y then y = 0 end

  local sw, sh = symbol.width, symbol.height

  if not (sw or sh) then
    sh = #symbol
    sw = #symbol[1]
  end

  for i=1, w-1 do
    image[y+1][x+i] = hi
  end
  for i=1, w do
    image[y+h][x+i] = lo
  end
  for i=2, h-1 do
    image[y+i][x+1] = hi
  end
  for i=1, h-1 do
    image[y+i][x+w] = lo
  end

  blit(image, symbol, x+math.floor((w-sw)/2), y+math.floor((h-sh)/2))
end

function createButton(symbol)
  local image = createEmpty(16, 32, 1)
  local w, h = image.width, image.height / 2
  drawButton(image, symbol, 2, 3, w, h)
  drawButton(image, symbol, 3, 2, w, h, 0, 16)

  return image
end

local symbols = {
  fkbm = {
    {4, 4, 4, 4, 4, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {4, 4, 4, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 4, 0, 0, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 0, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 4, 0, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 4, 4, 4, 0, 4, 4, 4, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 4, 0, 4, 4, 0, 0, 4, 4, 4, 4, 4, 0, 0, 0, 0, 4, 4, 0, 4, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {4, 4, 4, 4, 0, 0, 4, 0, 0, 0, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 4, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {4, 0, 0, 0, 4, 0, 4, 4, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0},
    {4, 4, 4, 4, 0, 0, 4, 0, 4, 0, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 0, 0, 4, 4, 4, 4, 4, 0, 0},
    {4, 0, 0, 0, 4, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {4, 4, 4, 4, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  },
  close = {
    {4, 4, 0, 0, 0, 0, 0, 0, 4, 4},
    {4, 4, 4, 0, 0, 0, 0, 4, 4, 4},
    {0, 4, 4, 4, 0, 0, 4, 4, 4, 0},
    {0, 0, 4, 4, 4, 4, 4, 4, 0, 0},
    {0, 0, 0, 4, 4, 4, 4, 0, 0, 0},
    {0, 0, 0, 4, 4, 4, 4, 0, 0, 0},
    {0, 0, 4, 4, 4, 4, 4, 4, 0, 0},
    {0, 4, 4, 4, 0, 0, 4, 4, 4, 0},
    {4, 4, 4, 0, 0, 0, 0, 4, 4, 4},
    {4, 4, 0, 0, 0, 0, 0, 0, 4, 4},
  },
  maximize = {
    {4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
    {4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 0, 0, 0, 4},
    {4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
  },
  restore = {
    {0, 0, 0, 0, 4, 4, 4, 4, 4, 4},
    {0, 0, 0, 0, 4, 4, 4, 4, 4, 4},
    {0, 0, 0, 0, 4, 0, 0, 0, 0, 4},
    {4, 4, 4, 4, 4, 4, 4, 0, 0, 4},
    {4, 4, 4, 4, 4, 4, 4, 0, 0, 4},
    {4, 0, 0, 0, 0, 0, 4, 4, 4, 4},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 0},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 0},
    {4, 0, 0, 0, 0, 0, 4, 0, 0, 0},
    {4, 4, 4, 4, 4, 4, 4, 0, 0, 0},
  },
  minimize = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 4, 4, 4, 4, 4, 4, 4, 0, 0},
    {0, 4, 4, 4, 4, 4, 4, 4, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  },
  invisible = {
    {0, 0, 0, 2},
    {0, 0, 2, 0},
    {0, 2, 0, 0},
    {2, 0, 0, 0},
  },
}

local palettes = {
  red = {
    '#000000',
    '#EE8877',
    '#FFCCCC',
    '#CC3344',
    '#000000',
  },
  redGrey = {
    '#000000',
    '#BB8888',
    '#CCBBBB',
    '#996666',
    '#444444',
  },
  green = {
    '#000000',
    '#88EE77',
    '#CCFFCC',
    '#33CC44',
    '#000000',
  },
  greenGrey = {
    '#000000',
    '#88BB88',
    '#BBCCBB',
    '#669966',
    '#444444',
  },
  blue = {
    '#000000',
    '#7788EE',
    '#CCCCFF',
    '#4433CC',
    '#000000',
  },
  blueGrey = {
    '#000000',
    '#777788',
    '#9999AA',
    '#555566',
    '#000000',
  }
}

os.execute("rm -f *.xpm")
os.execute("mkdir -p taskbar")
os.execute("rm -f taskbar/*.xpm")

local button = createButton(symbols.close)
--local pal = palettes.red
--local palg = palettes.redGrey
local pal = palettes.blue
local palg = palettes.blueGrey
writeImage('closeA', button, pal)
writeImage('closeI', button, palg)

--pal = palettes.green
--palg = palettes.greenGrey
button = createButton(symbols.maximize)
writeImage('maximizeA', button, pal)
writeImage('maximizeI', button, palg)

button = createButton(symbols.restore)
writeImage('restoreA', button, pal)
writeImage('restoreI', button, palg)

button = createButton(symbols.minimize)
writeImage('minimizeA', button, pal)
writeImage('minimizeI', button, palg)

--pal = palettes.blue
--palg = palettes.blueGrey
button = createEmpty(1, 16, 1)
button[1][1] = 2
button[2][1] = 3
button[15][1] = 2
button[16][1] = 3
writeImage('titleAT', button, pal)
writeImage('titleIT', button, palg)
writeImage('titleAS', button, pal)
writeImage('titleIS', button, palg)
writeImage('titleAB', button, pal)
writeImage('titleIB', button, palg)

button = createEmpty(2, 16, 2)
for i=1, 16 do
  button[i][2] = 3
end
button[1][2] = 2
writeImage('titleAL', button, pal)
writeImage('titleIL', button, palg)
button[2][1] = 3
button[16][1] = 3
writeImage('titleAR', button, pal)
writeImage('titleIR', button, palg)

button = createEmpty(1, 25, 1)
button[1][1] = 2
button[25][1] = 3
button[2][1] = 3
button[24][1] = 2
writeImage('taskbarbg', button, pal)
os.rename("taskbarbg.xpm", "taskbar/taskbarbg.xpm")

button = createEmpty(8, 8, 1)
writeImage('taskbuttonbg', button, pal)
os.rename("taskbuttonbg.xpm", "taskbar/taskbuttonbg.xpm")

button = createEmpty(8, 8, 2)
writeImage('taskbuttonactive', button, pal)
os.rename("taskbuttonactive.xpm", "taskbar/taskbuttonactive.xpm")

button = createEmpty(8, 8, 3)
writeImage('taskbuttonminimized', button, pal)
os.rename("taskbuttonminimized.xpm", "taskbar/taskbuttonminimized.xpm")

button = createEmpty(4, 4, 1)
blit(button, symbols.invisible, 0, 0)
writeImage('taskbuttoninvisible', button, pal)
os.rename("taskbuttoninvisible.xpm", "taskbar/taskbuttoninvisible.xpm")

button = createEmpty(52, 16, 1)
blit(button, symbols.fkbm, 3, 3)
writeImage('start', button, pal)
os.rename("start.xpm", "taskbar/start.xpm")
