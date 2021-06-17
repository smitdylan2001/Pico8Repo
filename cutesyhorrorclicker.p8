pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

-- cutesy horror clicker
-- by jayde alkema and dylan smit

function _init()
    init_mouse()
    init_clicker()
end

function _update60()
    update_mouse()
    update_clicker()
end

function _draw()
    cls(black)
    draw_cursor()
    draw_clicker()
end

function hcenter(s)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  return 64-#s*2
end

-- converts anything to string, even nested tables
function tostring(any)
    if type(any)=="function" then 
        return "function" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k).."->"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end
-->8
function init_mouse()
    poke(0x5f2d, 1)
	mousestate=0 -- default, clicked
end

function draw_cursor()
	if (mousestate==0)	spr(1,msx,msy)
	if (mousestate==1)	spr(2,msx,msy)
end

function update_mouse()
	msx=stat(32)-1
	msy=stat(33)-1
	omck=mck
	mck=band(stat(34),1)==1
	nmck=mck and not omck
	if (stat(34)==0) mousestate=0
	if (stat(34)==1) mousestate=1
end
-->8
function init_clicker()
    clicktimeout=180     -- update is 60 fps, so dividie this by 60 to get timeout in seconds
    clicktimeouttimer=clicktimeout
    clickcounter=0
    clickspersecond=0
    clickvalue=0
    clicktotal=0
    clicks=0
end

function update_clicker()
    clickcounter += 1

    if nmck then 
        clicks += 1
        clicktotal += 1
        clicktimeouttimer = clicktimeout
    else
        clicktimeouttimer -= 1
    end

    if clicktimeouttimer <= 0 then 
        clicks = 0
        clickcounter = 0
        clickspersecond = 0
    else
        clickspersecond = clicks / (clickcounter / 60)
    end
end

function draw_clicker()
    clickstext = "cps: "..tostring(clickspersecond)
    score = "score: "..tostring(clicktotal)
    print(clickstext,hcenter(clickstext),6,white)
    print(score,hcenter(score),16,white)
end
__gfx__
00000000550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000575000005850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700577500005885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000577750005888500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000577775005888850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700577777505888885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000577555005885550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055750000558500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
