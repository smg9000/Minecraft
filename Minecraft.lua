
Minecraft = SMODS.current_mod
local data = NFS.newFileData(Minecraft.path .."/assets/texture.png")
local texture = love.graphics.newImage(data)
texture:setWrap("clamp", "clamp")
-- local shard_vertices = {
    
    
--     -- --Back face
--     -- {-0.5, -0.5, -0.5, 0, 0},
--     -- {-0.5, 0.5, -0.5, 1, 0}, 
--     -- {0.5, 0.5, -0.5, 1, 1}, 
--     -- {0.5, -0.5, -0.5, 0, 1},
--     -- {0.5, 0, -0.5, 0, 0},
--     -- {0.5, 0.5, -0.5, 1, 0}, 
--     -- {1, 0.5, -0.5, 1, 1}, 
--     -- {1, 0, -0.5, 0, 1},
--     -- --Front face
--     -- {0, 0, 0, 0, 0},
--     -- {0, 0.5, 0, 1, 0}, 
--     -- {1, 0.5, 0, 1, 1}, 
--     -- {1, 0, 0, 0, 1},
--     -- {-0.5, -0.5, 0, 0, 0},
--     -- {-0.5, 0, 0, 1, 0}, 
--     -- {0.5, 0, 0, 1, 1}, 
--     -- {0.5, -0.5, 0, 0, 1},
--     -- {-0.5, 0, 0.5, 0, 0},
--     -- {-0.5, 0.5, 0.5, 1, 0}, 
--     -- {0, 0.5, 0.5, 1, 1}, 
--     -- {0, 0, 0.5, 0, 1},   
--     -- --Top face
--     -- {-0.5, 0.5, 0, 0, 0},
--     -- {-0.5, 0.5, -0.5, 1, 0}, 
--     -- {1, 0.5, -0.5, 1, 1}, 
--     -- {1, 0.5, 0, 0, 1},
--     -- {-0.5, 0.5, 0.5, 0, 0},
--     -- {-0.5, 0.5, 0, 1, 0}, 
--     -- {0, 0.5, 0, 1, 1}, 
--     -- {0, 0.5, 0.5, 0, 1},
--     -- --Bottom Face
--     -- {-0.5, 0, 0, 0, 0},
--     -- {-0.5, 0, 0.5, 1, 0}, 
--     -- {0, 0, 0.5, 1, 1}, 
--     -- {0, 0, 0, 0, 1},
--     -- {0.5, 0, -0.5, 0, 0},
--     -- {0.5, 0, 0, 1, 0}, 
--     -- {1, 0, 0, 1, 1}, 
--     -- {1, 0, -0.5, 0, 1},
--     -- {-0.5, -0.5, -0.5, 0, 0},
--     -- {-0.5, -0.5,0 , 1, 0}, 
--     -- {0.5, -0.5, 0, 1, 1}, 
--     -- {0.5, -0.5, -0.5, 0, 1},

--     {-0.5, -0.5, 0.5, 0, 0},
--     {0.5, -0.5, 0.5, 1, 0}, 
--     {0.5, 0.5, 0.5, 1, 1}, 
--     {-0.5, 0.5, 0.5, 0, 1}, 
--     -- Back face
--     {0.5, -0.5, -0.5, 0, 0},
--     {-0.5, -0.5, -0.5, 1, 0}, 
--     {-0.5, 0.5, -0.5, 1, 1}, 
--     {0.5, 0.5, -0.5, 0, 1}, 
--     -- top
--     {-0.5, 0.5, 0.5, 0, 0},
--     {0.5, 0.5, 0.5, 1, 0}, 
--     {0.5, 0.5, -0.5, 1, 1}, 
--     {-0.5, 0.5, -0.5, 0, 1}, 
--     -- bottom
--     {-0.5, -0.5, -0.5, 0, 0},
--     {0.5, -0.5, -0.5, 1, 0}, 
--     {0.5, -0.5, 0.5, 1, 1}, 
--     {-0.5, -0.5, 0.5, 0, 1}, 
--     --right
--     {0.5, -0.5, 0.5, 0, 0},
--     {0.5, -0.5, -0.5, 1, 0}, 
--     {0.5, 0.5, -0.5, 1, 1}, 
--     {0.5, 0.5, 0.5, 0, 1}, 
--     -- left
--     {-0.5, -0.5, -0.5, 0, 0},
--     {-0.5, -0.5, 0.5, 1, 0}, 
--     {-0.5, 0.5, 0.5, 1, 1}, 
--     {-0.5, 0.5, -0.5, 0, 1}, 



   

-- }
-- local shardmeshdata = {}
-- for i = 1, #shard_vertices, 4 do
--     local v1, v2, v3, v4 = shard_vertices[i], shard_vertices[i+1], shard_vertices[i+2], shard_vertices[i+3]
--     --Triangle 1
--     table.insert(shardmeshdata, v1)
--     table.insert(shardmeshdata, v2)
--     table.insert(shardmeshdata, v3)
--     --Triangle 2
--     table.insert(shardmeshdata, v1)
--     table.insert(shardmeshdata, v3)
--     table.insert(shardmeshdata, v4)
-- end
-- local shard_mesh = love.graphics.newMesh(shardmeshdata, "triangles")
-- shard_mesh:setTexture(texture)

-- local shardmeshdata1 = {}
-- for i = 1, #shard_vertices, 4 do
--     local v1, v2, v3, v4 = shard_vertices[i], shard_vertices[i+1], shard_vertices[i+2], shard_vertices[i+3]
--     --Triangle 1
--     table.insert(shardmeshdata1, v1)
--     table.insert(shardmeshdata1, v2)
--     table.insert(shardmeshdata1, v3)
--     --Triangle 2
--     table.insert(shardmeshdata1, v1)
--     table.insert(shardmeshdata1, v3)
--     table.insert(shardmeshdata1, v4)
-- end
-- local shard_mesh1 = love.graphics.newMesh(shardmeshdata1, "triangles")
-- shard_mesh1:setTexture(texture)

-- local shardmeshdata2 = {}
-- for i = 1, #shard_vertices, 4 do
--     local v1, v2, v3, v4 = shard_vertices[i], shard_vertices[i+1], shard_vertices[i+2], shard_vertices[i+3]
--     --Triangle 1
--     table.insert(shardmeshdata2, v1)
--     table.insert(shardmeshdata2, v2)
--     table.insert(shardmeshdata2, v3)
--     --Triangle 2
--     table.insert(shardmeshdata2, v1)
--     table.insert(shardmeshdata2, v3)
--     table.insert(shardmeshdata2, v4)
-- end
-- local shard_mesh2 = love.graphics.newMesh(shardmeshdata2, "triangles")
-- shard_mesh2:setTexture(texture)



local vertices = {
    -- Front face
    {-0.5, -0.5, 0.5, 0, 0},
    {0.5, -0.5, 0.5, 1, 0}, 
    {0.5, 0.5, 0.5, 1, 1}, 
    {-0.5, 0.5, 0.5, 0, 1}, 
    -- Back face
    {0.5, -0.5, -0.5, 0, 0},
    {-0.5, -0.5, -0.5, 1, 0}, 
    {-0.5, 0.5, -0.5, 1, 1}, 
    {0.5, 0.5, -0.5, 0, 1}, 
    -- top
    {-0.5, 0.5, 0.5, 0, 0},
    {0.5, 0.5, 0.5, 1, 0}, 
    {0.5, 0.5, -0.5, 1, 1}, 
    {-0.5, 0.5, -0.5, 0, 1}, 
    -- bottom
    {-0.5, -0.5, -0.5, 0, 0},
    {0.5, -0.5, -0.5, 1, 0}, 
    {0.5, -0.5, 0.5, 1, 1}, 
    {-0.5, -0.5, 0.5, 0, 1}, 
    --right
    {0.5, -0.5, 0.5, 0, 0},
    {0.5, -0.5, -0.5, 1, 0}, 
    {0.5, 0.5, -0.5, 1, 1}, 
    {0.5, 0.5, 0.5, 0, 1}, 
    -- left
    {-0.5, -0.5, -0.5, 0, 0},
    {-0.5, -0.5, 0.5, 1, 0}, 
    {-0.5, 0.5, 0.5, 1, 1}, 
    {-0.5, 0.5, -0.5, 0, 1}, 
}

local meshdata = {}
for i = 1, #vertices, 4 do
    local v1, v2, v3, v4 = vertices[i], vertices[i+1], vertices[i+2], vertices[i+3]
    --Triangle 1
    table.insert(meshdata, v1)
    table.insert(meshdata, v2)
    table.insert(meshdata, v3)
    --Triangle 2
    table.insert(meshdata, v1)
    table.insert(meshdata, v3)
    table.insert(meshdata, v4)
end

local mesh = love.graphics.newMesh(meshdata, "triangles")
mesh:setTexture(texture)
local angleX = 0
local angleY = 0
function projectVertex(vertex, width, height)
    local scale = 200
    local fov = 3
    local x, y, z = vertex[1], vertex[2], vertex[3]
    local factor = scale / (z + fov)
    return {x * factor + width, -y * factor + height} 
end

function rotateVertex(x, y, z, ax, ay)
    local cosX, sinX = math.cos(ax), math.sin(ax)
    local cosY, sinY = math.cos(ay), math.sin(ay)
    -- Rotate around the Y-axis
    local x1 = cosY * x - sinY * z
    local z1 = sinY * x + cosY * z

    -- Rotate around the X-axis
    local y1 = cosX * y - sinX * z1
    local z2 = sinX * y + cosX * z1

    return x1, y1, z2
end
local function comparethirdvalue(a, b)  
    local triangleAvea = (a[1][3] + a[2][3]+ a[3][3]) / 3
    local triangleAveb = (b[1][3] + b[2][3]+ b[3][3]) / 3
    return triangleAvea > triangleAveb
end

-- SMODS.DrawStep{
--   	key = "shardcube",
--   	order = 62,
--   	func = function(self, layer)
-- 		if (self.config.center.key == "j_mc_orb_dom_j") or (self.config.center.key == "j_mc_orb_dom_w") or (self.config.center.key == "j_mc_orb_dom_c") or (self.config.center.key == "j_mc_orb_dom_h") or (self.config.center.key == "j_mc_orb_dom_e") then
--             local updatedVertices2 = {}
--             for i, v in ipairs(shardmeshdata) do 
--                 local rx, ry, rz = rotateVertex(v[1], v[2], v[3], angleX, angleY)
--                 local distance = 3
--                 local zOffset = rz + distance
--                 local screenScale = 75

--                 local px = (rx / zOffset) * screenScale + ((self.T.x + (self.T.w/1.7)) * G.TILESCALE*G.TILESIZE)
--                 local py = (ry / zOffset) * screenScale + ((self.T.y + (self.T.h/3)) * G.TILESCALE*G.TILESIZE)
--                 table.insert(updatedVertices2, {px, py, v[4], v[5]})
--             end
--             local updatedVertices3 = {}
--             for i, v in ipairs(shardmeshdata1) do 
--                 local rx, ry, rz = rotateVertex(v[1], v[2], v[3], angleX, angleY)
--                 local distance = 3
--                 local zOffset = rz + distance
--                 local screenScale = 75

--                 local px = (rx / zOffset) * screenScale + ((self.T.x + (self.T.w/4)) * G.TILESCALE*G.TILESIZE)
--                 local py = (ry / zOffset) * screenScale + ((self.T.y + (self.T.h/3)) * G.TILESCALE*G.TILESIZE)
--                 table.insert(updatedVertices3, {px, py, v[4], v[5]})
--             end
--             local updatedVertices4 = {}
--             for i, v in ipairs(shardmeshdata2) do 
--                 local rx, ry, rz = rotateVertex(v[1], v[2], v[3], angleX, angleY)
--                 local distance = 3  
--                 local zOffset = rz + distance
--                 local screenScale = 75

--                 local px = (rx / zOffset) * screenScale + ((self.T.x + (self.T.w/2.5)) * G.TILESCALE*G.TILESIZE)
--                 local py = (ry / zOffset) * screenScale + ((self.T.y + (self.T.h/1.6)) * G.TILESCALE*G.TILESIZE)
--                 table.insert(updatedVertices4, {px, py, v[4], v[5]})
--             end
            
--             shard_mesh:setVertices(updatedVertices2)
--             shard_mesh1:setVertices(updatedVertices3)
--             shard_mesh2:setVertices(updatedVertices4)
--             love.graphics.push()
--             love.graphics.setDepthMode("lequal", true)
--             love.graphics.setMeshCullMode("back")
--             love.graphics.clear(false, false, false, false, false, true)
--             love.graphics.setLineWidth(0)
--             love.graphics.setColor(1, 1, 1)
--             love.graphics.draw(shard_mesh)
--             love.graphics.draw(shard_mesh1)
--             love.graphics.draw(shard_mesh2)
--             love.graphics.setDepthMode()
--             love.graphics.pop()
--         end
--   	end,
--   	conditions = { vortex = false, facing = 'front' },
-- }

SMODS.DrawStep{
  	key = "cube",
  	order = 62,
  	func = function(self, layer)
		if (self.config.center.key == "j_mc_orb_dom") or self.config.center.key == "mc_orb_dom" then
            local updatedVertices = {}
            for i, v in ipairs(meshdata) do 
                local rx, ry, rz = rotateVertex(v[1], v[2], v[3], angleX, angleY)
                local distance = 2.0
                local zOffset = rz + distance
                local screenScale = 150

                local px = (rx / zOffset) * screenScale + ((self.T.x + (self.T.w/2.05)) * G.TILESCALE*G.TILESIZE)
                local py = (ry / zOffset) * screenScale + ((self.T.y + (self.T.h/2.75)) * G.TILESCALE*G.TILESIZE)
                table.insert(updatedVertices, {px, py, v[4], v[5]})
            end
            
            mesh:setVertices(updatedVertices)
            love.graphics.push()
            love.graphics.setDepthMode("lequal", true)
            love.graphics.setMeshCullMode("back")
            love.graphics.clear(false, false, false, false, false, true)
            love.graphics.setLineWidth(0)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(mesh)
            love.graphics.setDepthMode()
            love.graphics.pop()
        end
  	end,
  	conditions = { vortex = false, facing = 'front' },
}
function add_craft_resource(section, amount, card, message_)
    local message = true
    if message_ ~= nil then
        message = message_
    end
    if G.GAME.craftr[section] == nil then
        G.GAME.craftr[section] = 0
    end
    G.GAME.craftr[section] = G.GAME.craftr[section] + amount
    
    if card and message and (amount ~= 0) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='gain_craftr',vars={amount, localize(section)}},colour = HEX("a37c12")	, delay = 0.45})
    end
end

function SMODS.current_mod.process_loc_text()
    G.localization.misc.quips['aww_man'] ={ "Aww Man"}
    G.localization.descriptions.Other["enchant_sharpness"] = {
        text = {
            "{C:purple}Sharpness #1#{}"
        }
        
    }
    G.localization.descriptions.Other["tooltip_sharpness"] = {
        name = "Sharpness",
        text = {
            "{C:red}+#1#{} Mult"
        }
    }
    
end
--Atlas--

SMODS.Atlas({
    key = "resource",
    path = "resource.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "jokeratlas",
    path = "jokeratlas.png",
    px = 71,
    py = 95,
})
SMODS.Atlas({
    key = "resource_sprites",
    path = "resource_sprites.png",
    px = 34,
    py = 34	,
})
SMODS.Atlas({
    key = "resources",
    path = "craft_resources.png",
    atlas_table = "ANIMATION_ATLAS",
    frames = 20,
    --sprite_args = {frame_durations = {[1] = 10}},
    px = 71,
    py = 71	,
})

SMODS.Atlas({
    key = "minesweeper_sprites",
    path = "craftsweeper.png",
    px = 18,
    py = 18,
})
SMODS.Atlas({
    key = "inventory",
    path = "inventory.png",
    px = 20,
    py = 20,
})
SMODS.Atlas({
    key = "minesweeper_number_sprites",
    path = "numbers.png",
    px = 18,
    py = 18,
})

SMODS.Atlas({       
    key = "placeholder",
    path = "j_placeholder.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
	key = "crafted_jokers",
	atlas_table = "ASSET_ATLAS",
	path = "crafted_jokers.png",
	px = 71,
	py = 95
})

SMODS.Atlas({
    key = "mobs",
    path = "mobs.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "weapons",
    path = "weapons.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "enhancement",
    path = "enhancement.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "consumables",
    path = "consumables.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "mc_blinds",
	atlas_table = "ANIMATION_ATLAS",
    path = "mc_blinds.png",
    px = 34,
    py = 34,
	frames = 21,
})

SMODS.Atlas({
    key = "mc_packs",
    path = "mc_packs.png",
    px = 71,
    py = 95,
})
SMODS.Atlas({
    key = "mc_ani_packs",
    path = "Deepslate_Pack.png",
    atlas_table = "ANIMATION_ATLAS",
    frames = 11,
    px = 71,
    py = 95,
})
assert(SMODS.load_file("Objects/Crafts.lua"))()
assert(SMODS.load_file("Objects/Resources.lua"))()
assert(SMODS.load_file("Objects/Blinds.lua"))()
assert(SMODS.load_file("Objects/Boosters.lua"))()
assert(SMODS.load_file("Objects/Consumables.lua"))()
assert(SMODS.load_file("Objects/Enhancements.lua"))()
assert(SMODS.load_file("Objects/Jokers.lua"))()
assert(SMODS.load_file("Objects/Mobs.lua"))()
assert(SMODS.load_file("Objects/Weapons.lua"))()
assert(SMODS.load_file("Ui/Resource.lua"))()
assert(SMODS.load_file("Ui/Mob_Arena.lua"))()
assert(SMODS.load_file("Ui/Crafting.lua"))()
assert(SMODS.load_file("Other/Enchantment.lua"))()
local upd = Game.update
function Game:update(dt)
	upd(self, dt)
    angleX = angleX + 1.2 * dt
    angleY = angleY + 1.5 * dt
    
end
