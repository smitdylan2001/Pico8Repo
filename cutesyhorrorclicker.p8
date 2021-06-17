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
	init_sprite()
end

function _update60()
    update_mouse()
	click_sprite()
    update_clicker()
end

function _draw()
    cls(black)

	draw_sprite_64()
    draw_upgrade_buttons()

	-- these have to always be drawn last!
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
    clicktimeout=180     -- update is 60 fps, so divide this by 60 to get timeout in seconds
    clicktimeouttimer=clicktimeout
    clickcounter=0
    clickspersecond=0
    clickvalue=0
    clicktotal=0
    clicks=0
end

function update_clicker()
    clickcounter += 1

	if clickcounter >= 32766 then clickcounter = 0 end	-- handle overflow

    if spriteclicked == true then 
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
    points = "points: "..tostring(clicktotal)
    print(clickstext,hcenter("cps: "),6,white)
    print(points,hcenter(points),16,white)
end
-->8
function init_sprite()
	spriteindeces = {128, 136}
	spriteindex = 1
	spriteclicked = false
end

function click_sprite()
	if msx >= 32 and msx <= 96 and msy >= 32 and msy <= 96 and nmck then
		spriteclicked = true
	else
		spriteclicked = false
	end
end

function draw_sprite_64()
	if	spriteclicked == false then 
		spr(spriteindeces[spriteindex],32,32,8,8)
	else
		enlarge_sprite_on_click()
	end
end

function enlarge_sprite_on_click()
	sspr((spriteindeces[spriteindex] % 16) * 8,(spriteindeces[spriteindex] / 16) * 8,64,64,30,30,68,68)
end
-->8
function draw_upgrade_buttons()
    print("upgrades", hcenter("upgrades"), 96)
    print("100", 26, 104)
    print("500", 58, 104)
    print("2500", 88, 104)
    spr(3,24,110,2,2)
    spr(5,56,110,2,2)
    spr(7,88,110,2,2)
end
__gfx__
00000000550000005500000077777777777777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000
00000000575000005850000073333333333333377222222222222227711111111111111700000000000000000000000000000000000000000000000000000000
00700700577500005885000073333377777333377222222227772227711111777711111700000000000000000000000000000000000000000000000000000000
00077000577750005888500073337773337733377222222277772227711117111171111700000000000000000000000000000000000000000000000000000000
00077000577775005888850073377333333773377222222777772227711117111171111700000000000000000000000000000000000000000000000000000000
00700700577777505888885073373333333773377222227772772227711117111171111700000000000000000000000000000000000000000000000000000000
00000000577555005885550073333333377733377222277722772227711111777711111700000000000000000000000000000000000000000000000000000000
00000000055750000558500073333337773333377222777222772227711117111171111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073333777733333377227772222772227711171111117111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073337733333333377227777777772227711171111117111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073377333333333377227777777772227711171111117111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073377777777773377222222222772227711117111171111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073377777777773377222222222772227711111777711111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073333333333333377222222222222227711111111111111700000000000000000000000000000000000000000000000000000000
00000000000000000000000073333333333333377222222222222227711111111111111700000000000000000000000000000000000000000000000000000000
00000000000000000000000077777777777777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000005200000000000001161100000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000052500000000000000676100000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000542500000000000001d7fd51000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000005225000000000000001d50661100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000052000000000000000001d52166110000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000540050000000000000001554406615000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000054251000000000000000001d5e40671000100000000000000000000000000000000000000
000000000000000511111500000000000000000000000000000001542555000000000000000001d14f41651dd111100000000000000000000000000000000000
000000510000511555555511100000000000000000000000000054224410000000000000000001504ff0d75d6ddd101000000000000000000000000000000000
000000025151555ddddddd55511000000000000000000000001144044550000000001000000010d04ff40d10d666dd1500000000000000000000000000000000
000000044155ddddddddddddd5511000000000000000000005444054d00000000d66100000101710000000d610d666d110000000000000000000000000000000
000000124411ddddddddddddddd55500000000000000000554840544550000000656d66111166fd6666ddd6fd65d666d11000000000000000000000000000000
00000000482215ddddddddddddddd5500000000000005154480054fd000000001121567d5d6500155555151056616666d1100000000000000000000000000000
00000055044402dddddddddddddddd55000000000515444840554fd550000000011241155515ddd5555ddddd51551d666d100000000000000000000000000000
0000055d500002dddddddddddddddd50000111111444e8400544ffd10000000000014e400dd6666dddd666666d500d6666010000000000000000000000000000
0000015dd52122ddddddddddddddddd5100044444884000444ffffd1000000000000545d6666666666dd6666666ddd6666d10000000000000000000000000000
051155ddddddddddddddddddddd22dd50000284100000544ffffffd100000000000001d1d66666666666d66666666dd666601000000000000000000000000000
0145052005ddddddddddddddddd5222d5500024422244001444ffffd50000000000001d006666666666666666666666d666d0100000000000000000000000000
01440520d105dddddddd22dddddd2222d0011028840084440001444d0000000000001dd055d666666666666666666666666d0100000000000000000000000000
0142521df66115dddddd2222dddd22222100250884220002222400055500000000001dd0d600d6666666666666666666666d0100000000000000000000000000
0110520ff776611dddddd52222ddd2222250240188422205000422440011500000001d55f7dd11666666666666666666666d0100000000000000000000000000
0010520ff777ddd105dddd222222d2222200142088422421545000242224450000001d16f777645d6666666666666666666dd110000000000000000000000000
0001520f77f5ef55d115dd5222222222221002408404204214fd44500000010000001d1d777777d01666666666d66666666dd010000000000000000000000000
0001520f77f2e124ffd15dd2222222222221014084044008404ffffd4501110000001d1d7777776dd11d666666dd6666666dd010000000000000000000000000
0001520f777fe1effffd15d22222222222200142140040504204ffffd50000000000110677777d6f5000d666666dd6666666d010000000000000000000000000
0001520e5f7ffeff77ffd15522222222222001240400404504204ffd100000000000111d77f77665d5155d66666ddd666666dd11000000000000000000000000
00015202eff7f777777ffd1522222222222000020400404f504204fd0111500000001dd0ddd6f7fdfffff1d66666dddd6666dd05000000000000000000000000
0001150df51f7777777fff052222222222200002040512144504214d0244450000001dd0d66d6777777fff1d6666ddddd666dd05000000000000000000000000
0000152115df77777777ffd1222222222220001004040404f45044150841010000001150d5006777777fffd0d666dddddd66dd05000000000000000000000000
0000152024f7ff777777fff0222222222222100004040404ff450440025511000000005d5d1067777777fff05dd66dddddd6dd05000000000000000000000000
000011520e7f56f77777ffe00000022222220000040404044ff4504400100000000000dd077677777777fffd1ddd6dddddd6dd05000000000000000000000000
000001520677ffff7777fe16ffff600222220000040440204fff450841000000000001dd1f77ffff7777ffff0dddddddddddddd1100000000000000000000000
0000011221f7fffeef77f5677777fed122220000040440404ffff450445000000000001dd1f75dffffffffff61ddddddddddddd0500000000000000000000000
0000001220677fe4f77fe1f777777ffd02222100040440404fffffd5044500000000000dd0f7d6fffffffffff05dddd1ddddddd1500000000000000000000000
00000011221677ffff7f167777777ffe022220000404d04044ffd100004100000000000dd0677ffffffffffff0dddddd1ddddddd110000000000000000000000
0000000112216f77f7fe1f7777777ffe022222500404d14044d11421002450000000001d6d0f7f4444ffffff601ddddd00dddddd010000000000000000000000
000000001122016fffe1677777777fffe12222014404f402041248845001100000000011dd067feffeffffff5001001d151dddddd11000000000000000000000
00000000012222000000f77777777ffff0222210404ff4040048844445110000000000005dd0efff1006fff0d66600d10d1dddddd51000000000000000000000
00000000001222222220f77777777ffff02222204046fd040048e40014500000000000005dd51ff5d665565577776655d151dddddd5150000000000000000000
00000000001222222220f77777777ffff022220205001d140448e41000100000000000005dddd10d677dd1d777777765dd10ddddddd511110000000000000000
00000000001122222206777777777ffff0222044010120040400141001100000000000005dddd5011d0050677777777d1d00dddddddddd501000000000000000
0000000000015222200f777777777ffff022200010001200215155450000000000000000dddd11666100d6f777777fff1dd0dddddddddddd1500000000000000
0000000000015222200f77777777fffff025222220000200400005221000000000000000d6d1d777f66d067777777fffd141ddddddddddddd010000000000000
0000000000001522041f77777777fffe022d222222101151400000501000000000000000d6d067ddd5550d777777ffff604d1dd6dddd1dddd551000000000000
0000000000001521480677777777fffe022d22222200010511000001000000000000001d6dd0d5001dd666f77777ffff604e0dd6dddd00dddd50100000000000
0000000000001504e80677777777fffe022dd2222210000000000000000000000000000d6dd00666611f77777777fffff6520d66dddd121dddd0100000000000
0000000000001108e40f77777777fffe022dd2222211000000000000000000000000001d6d16677ff6d167777777ffffff120d66ddd12e40dddd100000000000
000000000000004ee40f7777777ffffe022dd2022221000000000000000000000000001d6d06776ee510d7777777ffff5d520d66ddd04eed1ddd010000000000
00000000000014ee840f7777777fffe1402dd2022220000000000000000000000000001d6d06776e15dd6f777777fff60d520d6dddd02fefd1ddd10000000000
0000000000154ee8840f777777ffffe0402d20202220000000000000000000000000001d6d06776d0677ff777777ffff5d520d6ddd12eeeefe11505000000000
000000000054eee8840f777777ffff60440220402220000000000000000000000000000d6d06776ed16777777777ffff60040d6ddd0dfeeeefd2000100000000
00000000054eeee8840677777fffffd0440220402220000000000000000000000000001ddd067776e06777777777fffff00d1d66dd14eeeeeeeeed2111110000
0000000014eeee88841f77777fffff148402204402200000000000000000000000000001ddd16776d067777777777fff600dd1d6ddd0dfeeeeeefeeeddd10000
0000000104eee888406777777fffff04840220440220000000000000000000000000000056d06776ed06777777777fff602ee0d66dd02feeeeeeeeeeffeddddd
000000014eee888840f77777fffffd0484020484022000000000000000000000000000005ddd167efe06777777777fff60dee05d66d02eeeeeeeeeeeeeeffffe
000000118ee888884067777ffffff04840220484022000000000000000000000000000011dddd006fed5677777777ffffd1ded0566dd1eeeeeeeeeeeeeeeeeee
00000014ee8888884067777ffffff04840104884022100000000000000000000000000001dddd055df60677777777fffff02ee21dddd1deeeeeeeeeeeeeeeeee
00000004888888884067777fffffd148401048840211000000000000000000000000000011ddd10111d1677777777ffff604eee15ddd14eeeeeeeeeeeeeeeeee
0000000488888888406777ffffff04884004888401100000000000000000000000000000005d15001115167777777ffff614eeed1ddd1deeeeeeeeeeeeeeeeee
0000000488888888406777ffffff04884048888401000000000000000000000000000000011d010000110d77777777ffffd1deee0dd12eeeeeeeeeeeeeeeeeee
0000000488888888406777fffffd048884888882110000000000000000000000000000000010010000010d77777777fffff02eee1d12eeeeeeeeeeeeeeeeeeee
000000528888888840f77ffffff0488888888841000000000000000000000000000000000000010000000d77777777ffff602ee5112eeedeeeeeeeeeeeeeeeee
00000000000000000000000000000000000000000000000000000000000000000000000000000100000005d7ffffffffff602ee1114eddddddeeeeeeeeeeeeee
