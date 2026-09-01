
local function get_weapon()
    local shown_weapon = {}
    for i, j in pairs(G.P_CENTER_POOLS['Weapon']) do
        if G.GAME.available_weapons[j.key] == nil then
            G.GAME.available_weapons[j.key] = false
        end
        if G.GAME.available_weapons[j.key] == true then
			local valid = true
            if valid then
                shown_weapon[#shown_weapon + 1] = {j, true}
            end
        end
    end
    return shown_weapon
end
G.FUNCS.do_nothing = function(e)
end
local function spawn_mob()
    SMODS.add_card{
        set = "Mob_pool",
        area = Minecraft.mobslot    
    }
    G.GAME.mob_arena_values.mob_hp = Minecraft.mobslot.cards[1].config.center.hp
    G.GAME.mob_arena_values.mob_total_hp = Minecraft.mobslot.cards[1].config.center.hp
end
G.FUNCS.mob_fight = function(e)
    G.FUNCS.overlay_menu{
            definition = G.UIDEF.mob_fight(),
            config = {no_esc = true}
        }
        spawn_mob()
end
G.FUNCS.can_LEAVE = function(e)
    if G.GAME.mob_arena_values.timer_started == true then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        e.config.colour = G.C.ORANGE
        e.config.button = "exit_overlay_menu"
    end
end
G.FUNCS.weapon_left = function(e)
    local shown_weapon = get_weapon()
    Minecraft.weaponslot.cards[1]:remove()
    G.GAME.mob_arena_values.current_weapon = G.GAME.mob_arena_values.current_weapon - 1
    local center = shown_weapon[G.GAME.mob_arena_values.current_weapon]
    G.GAME.mob_arena_values.damage = center[1].damage
    G.GAME.mob_arena_values.cooldown = center[1].cooldown
    G.GAME.mob_arena_values.damage_text = "Damage: "..tostring(G.GAME.mob_arena_values.damage)
    G.GAME.mob_arena_values.cooldown_text = "Cooldown: "..tostring(G.GAME.mob_arena_values.cooldown).."s"
    local weapon = Card(0, 0, G.CARD_W, G.CARD_H, nil, center[1])
    Minecraft.weaponslot:emplace(weapon)
end
G.FUNCS.can_weapon_left = function(e)
    if G.GAME.mob_arena_values.current_weapon ~= 1 then
        e.config.colour = G.C.ORANGE
        e.config.button = "weapon_left"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
        
    end
end
G.FUNCS.weapon_right = function(e)
    local shown_weapon = get_weapon()
    Minecraft.weaponslot.cards[1]:remove()
    G.GAME.mob_arena_values.current_weapon = G.GAME.mob_arena_values.current_weapon + 1
    local center = shown_weapon[G.GAME.mob_arena_values.current_weapon]
    G.GAME.mob_arena_values.damage = center[1].damage
    G.GAME.mob_arena_values.cooldown = center[1].cooldown
    G.GAME.mob_arena_values.damage_text = "Damage: "..G.GAME.mob_arena_values.damage
    G.GAME.mob_arena_values.cooldown_text = "Cooldown: "..G.GAME.mob_arena_values.cooldown.."s"
    local weapon = Card(0, 0, G.CARD_W, G.CARD_H, nil, center[1])
    Minecraft.weaponslot:emplace(weapon)
end
G.FUNCS.can_weapon_right = function(e)
   local shown_weapon = get_weapon()
    if shown_weapon[G.GAME.mob_arena_values.current_weapon + 1] ~= nil then
        e.config.colour = G.C.ORANGE
        e.config.button = "weapon_right"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    end
end
G.FUNCS.timer_start = function(e)
    G.GAME.mob_arena_values.timer_started = true
end
G.FUNCS.can_timer_start = function(e)
  
    if G.GAME.mob_arena_values.timer_started ~= true then
        e.config.colour = G.C.ORANGE
        e.config.button = "timer_start"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    end
end
function drop_chance(name, probability, absolute)
	return pseudorandom(name) < (absolute and 1 or G.GAME.probabilities.normal)/probability
end
G.FUNCS.attack = function(e)
    G.GAME.mob_arena_values.mob_hp = G.GAME.mob_arena_values.mob_hp - G.GAME.mob_arena_values.damage
    Minecraft.mobslot.cards[1]:juice_up(0.7)
    G.GAME.mob_arena_values.current_cooldown =  G.GAME.mob_arena_values.cooldown
    if G.GAME.mob_arena_values.mob_hp <= 0 then
        for i, j in pairs(Minecraft.mobslot.cards[1].config.center.drops) do   
            if drop_chance(Minecraft.mobslot.cards[1].config.center.name, j, true) then
                add_craft_resource(i, 1)
                print (i.." Sucess")
            end
        end
        Minecraft.mobslot.cards[1]:start_dissolve()
        spawn_mob()
    end
end
G.FUNCS.can_attack = function(e)
  
    if G.GAME.mob_arena_values.timer_started == true and G.GAME.mob_arena_values.current_cooldown == 0 then
        e.config.colour = G.C.ORANGE
        e.config.button = "attack"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    end
end
function create_horizontal_slider(args)
    return {n=G.UIT.R, config={align = "tl", minw = args.w, r = 0.1, maxh = args.h, minh = args.h, colour = darken(G.C.BLACK, 0.25),emboss = 0.05,func = 'horizontal_slider', refresh_movement = true}, nodes={
        {n=G.UIT.B, config={w=args.w ,h=0.3, r = 0.1, colour = G.C.CLEAR, ref_table = args, refresh_movement = true,}},
    }}
end
function G.FUNCS.horizontal_slider(e)
    local c = e.children[1]
    local rt = c.config.ref_table
    c.T.w = ((rt.ref_table[rt.ref_value] / rt.ref_table["mob_total_hp"]) - rt.min)/(rt.max - rt.min)*rt.w
    c.config.w = c.T.w
    --jank
    if c.config.set_me then
        c.config.colour = G.C.RED
    end
    c.config.set_me = true
end
function G.UIDEF.mob_fight()
    G.GAME.mob_arena_values.timer_started = false
    local place = G.GAME.mob_arena_values.mob_area
    local areas = "Area: "..place
    local shown_weapon = get_weapon()
    local center = shown_weapon[G.GAME.mob_arena_values.current_weapon]
    G.GAME.mob_arena_values.timer = 60
    local m = math.floor(G.GAME.mob_arena_values.timer / 60)
    local s = (G.GAME.mob_arena_values.timer - (60 * m))
    local d = math.floor(100 * (s - math.floor(s)))
    s = tostring(math.floor(s))
    if string.len(s) == 1 then
        s = "0" .. s
    end
    d = tostring(d)
    if string.len(d) == 1 then
        d = "0" .. d
    end
    m = tostring(m)
    G.GAME.mob_arena_values.timer_text = m .. ":" .. s .. "." .. d
    G.GAME.mob_arena_values.damage = center[1].damage
    G.GAME.mob_arena_values.cooldown = center[1].cooldown
    G.GAME.mob_arena_values.damage_text = "Damage: "..G.GAME.mob_arena_values.damage
    G.GAME.mob_arena_values.cooldown_text = "Cooldown: "..G.GAME.mob_arena_values.cooldown.."s"


    --local weapon = Card(0, 0, G.CARD_W, G.CARD_H, nil, shown_weapon[G.GAME.mob_arena_values.current_weapon])
    local weapon = Card(0, 0, G.CARD_W, G.CARD_H, nil, center[1])
    Minecraft.weaponslot = CardArea(0, 0, G.CARD_W, G.CARD_H, {card_limit = 1, type = 'title', highlight_limit = 1, weapon_slot = true})
    Minecraft.mobslot = CardArea(0, 0, G.CARD_W, G.CARD_H, {card_limit = 1, type = 'title', highlight_limit = 1})
    Minecraft.weaponslot:emplace(weapon)



    local t = {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*10, minh = G.ROOM.T.h*10,padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
        {n=G.UIT.R, config={align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, emboss = 0.1}, nodes={
          {n=G.UIT.C, config={ minh = 1,r = 0.2, padding = 0.2, minw = 1, colour = G.C.L_BLACK}, nodes={
            {n=G.UIT.R, config={ minh = 1, minw = 12}, nodes={
                {n=G.UIT.C, config={ align = "tl", minw = 5.5}, nodes={
                    {n=G.UIT.T, config={ text = areas, scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.C, config={align = "tm", minw = 4}, nodes={
                    {n=G.UIT.T, config={ text = "Mob Arena", scale = 1, colour = G.C.UI.TEXT_LIGHT, shadow = true}},  
                }},
                {n=G.UIT.C, config={align = "tr", minw = 4}, nodes={
                    {n=G.UIT.T, config={ text = "Mob:", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},  
                }},
            }},
            {n=G.UIT.R, config={align = "cm", minh = 0.5, minw = 12}, nodes={
                {n=G.UIT.C, config={align = "cm", minw = 4}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {{ ref_table = G.GAME.mob_arena_values, ref_value = "timer_text"}}, colours = {G.C.UI.TEXT_LIGHT}, scale = 0.75 , min_cycle_time = 0})}},  
                }},
            }},  
            {n=G.UIT.R, config={ align = "cl", minh = 6, minw = 4.5}, nodes={
                {n=G.UIT.C, config={ align = "cm", minw = 1,  hover = true, shadow = true, colour = HEX('966a2c'), r = 0.08, padding = 0.05, button = "weapon_left" ,func = "can_weapon_left"}, nodes={
                    {n=G.UIT.T, config={ text = "<", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.C, config={r = 0.08, colour = G.C.BLACK, align = "cm", minw = 3    }, nodes={
                    {n=G.UIT.O, config={colour = G.C.BLUE, object = Minecraft.weaponslot , hover = false, can_collide = false}},
                }},
                {n=G.UIT.C, config={align = "cm", minw = 1,  hover = true, shadow = true, colour = HEX('966a2c'), r = 0.08, padding = 0.05, button = "weapon_right" ,func = "can_weapon_right"}, nodes={
                    {n=G.UIT.T, config={ text = ">", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},  
                }},
                {n=G.UIT.C, config={align = "cm", minw = 1}, nodes={
                    {n=G.UIT.R, config={ align = "tm", minh = 2, minw = 5}, nodes={
                        {n=G.UIT.C, config={ align = "cm", minw = 1}, nodes={
                            {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "cm", minw = 3, minh = 1, hover = true, shadow = true, colour = HEX('966a2c'), button = 'timer_start',func = "can_timer_start"}, nodes={
                                {n=G.UIT.T, config={text = "Start",colour = G.C.UI.TEXT_LIGHT, scale = 1, shadow = true}}
                            }},
                        }},
                    }},
                    {n=G.UIT.R, config={ align = "tm", minh = 2, minw = 5}, nodes={
                        {n=G.UIT.C, config={ align = "cm", minw = 1}, nodes={
                            {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "cm", minw = 3, minh = 1, hover = true, shadow = true, colour = HEX('966a2c'), button = "exit_overlay_menu" ,func = "can_LEAVE"}, nodes={
                                {n=G.UIT.T, config={text = "Exit",colour = G.C.UI.TEXT_LIGHT, scale = 1, shadow = true}}
                            }},
                        }},
                    }}  
                }},
                {n=G.UIT.C, config={ align = "cl", minw = 1}, nodes={
                    {n=G.UIT.T, config={ text = "", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.C, config={r = 0.08, colour = G.C.BLACK, align = "cm", minw = 3}, nodes={
                    {n=G.UIT.O, config={colour = G.C.BLUE, object = Minecraft.mobslot, hover = false, can_collide = false}},
                }},
                {n=G.UIT.C, config={align = "cl", minw = 1}, nodes={
                    {n=G.UIT.T, config={ text = "", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},  
                }},
            }},
            {n=G.UIT.R, config={align = "cr", padding = 0.05, colour = G.C.CLEAR}, nodes={
                create_horizontal_slider({
                    ref_table = G.GAME.mob_arena_values,
                    ref_value = "mob_hp",
                    w = 3,
                    h = 0.25,
                    min = 0,
                    max = 1,
                    colour = G.C.RED,
                }),
                {n=G.UIT.C, config={align = "cr", minw = 1}, nodes={
                    {n=G.UIT.T, config={ text = "", scale = 0.75, colour = G.C.UI.TEXT_LIGHT, shadow = true}},  
                }},
            }},

            {n=G.UIT.R, config={align = "tl", minh = 0, minw = 4.5}, nodes={
                {n=G.UIT.C, config={ padding = 0.05, align = "bl", minw = 6}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {{ ref_table = G.GAME.mob_arena_values, ref_value = "damage_text"}}, colours = {G.C.UI.TEXT_LIGHT}, scale = 0.75 , min_cycle_time = 0})}},
                }},
                {n=G.UIT.C, config={ align = "cm", minw = 1}, nodes={
                    {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "cm", minw = 3, minh = 1, hover = true, shadow = true, colour = HEX('966a2c'), button = 'attack',func = "can_attack"}, nodes={
                        {n=G.UIT.T, config={text = "Attack",colour = G.C.UI.TEXT_LIGHT, scale = 1, shadow = true}}
                    }},
                }},
            }},
            {n=G.UIT.R, config={align = "tl", minh = 0, minw = 4.5}, nodes={
                {n=G.UIT.C, config={ padding = 0.05, align = "bl", minw = 6}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {{ ref_table = G.GAME.mob_arena_values, ref_value = "cooldown_text"}}, colours = {G.C.UI.TEXT_LIGHT}, scale = 0.75 , min_cycle_time = 0})}},
                }},
            }},        




          }},
        }}, 
      }}
    return t
end
local upd = Game.update
function Game:update(dt)
	upd(self, dt)
    if G.GAME and G.GAME.mob_arena_values and G.GAME.mob_arena_values.timer and G.GAME.mob_arena_values.timer_started == true then
        G.GAME.mob_arena_values.timer = G.GAME.mob_arena_values.timer and math.max(0, (G.GAME.mob_arena_values.timer) - dt) or nil
        local m = math.floor(G.GAME.mob_arena_values.timer / 60)
        local s = (G.GAME.mob_arena_values.timer - (60 * m))
        local d = math.floor(100 * (s - math.floor(s)))
        s = tostring(math.floor(s))
        if string.len(s) == 1 then
            s = "0" .. s
        end
        d = tostring(d)
        if string.len(d) == 1 then
            d = "0" .. d
        end
        m = tostring(m)
        if G.GAME.mob_arena_values.timer == 0 then
            G.FUNCS.exit_overlay_menu()
            G.GAME.mob_arena_values.timer_started = false
            G.GAME.mob_arena_values.timer = 0
        end
        G.GAME.mob_arena_values.timer_text = m .. ":" .. s .. "." .. d
    end
    if G.GAME and G.GAME.mob_arena_values and G.GAME.mob_arena_values.current_cooldown and G.GAME.mob_arena_values.timer_started == true then
        G.GAME.mob_arena_values.current_cooldown = G.GAME.mob_arena_values.current_cooldown and math.max(0, (G.GAME.mob_arena_values.current_cooldown) - dt) or nil
    end
    
end

