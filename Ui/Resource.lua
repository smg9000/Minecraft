local resource_ui = {}
local resource_ui_node = {}
function G.UIDEF.resource_ui_menu(resource_page)
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=resource_ui_node},
      }}
    return t
end
G.FUNCS.your_game_resource_page = function(args)
     local resources_table = G.GAME.craftr
    local adding = 15  * ((args.cycle_config.current_option) - 1)
    local keys = {}
   
    
    local resources_amount = 0
    for k,_ in pairs(resources_table) do
        resources_amount = resources_amount + 1
        table.insert(keys, k)
    end
    local rows = {}	
    for i = 1, 3 do
        table.insert(rows, {})
        for j = 0, 4 do
            if keys[j*5+i+adding] then
                table.insert(rows[i], keys[j*5+i+adding])
            end
        end
    end
    if not args or not args.cycle_config then return end
    resource_ui_node = {}
    for j = 1, math.max(1,math.min(3, math.ceil(resources_amount/5))) do
        
        table.insert(resource_ui_node, 
        {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
        }}
        )
    end


    for j = 1, #resource_ui_node do
        for i = 1, 5 do
            if (i+(j-1)*(5)+adding) <= resources_amount then
                if keys[i+(j-1)*(5)+adding] then
                    local name = localize(keys[i+(j-1)*(5)+adding])
                    local amount = G.GAME.craftr[keys[i+(j-1)*(5)+adding]]
                    table.insert(resource_ui_node[j].nodes, 
                    {n=G.UIT.C, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                            {n=G.UIT.T, config={align = "cm", text = name, scale = 0.35, shadow = true}},
                        }},
                        {n=G.UIT.R, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                            {n=G.UIT.T, config={align = "cm", text = amount, scale = 0.35, shadow = true}},
                        }}
                    }}
                    )
                end
            end
        end
    end

  -- Get the parent of the menu UIBox, because we want to delete and re-create the menu:
    local menu_wrap = resource_ui.parent
    
    -- Delete the current menu UIBox:
    menu_wrap.config.object:remove()
    -- Create the new menu UIBox:
    menu_wrap.config.object = UIBox({
        definition = G.UIDEF.resource_ui_menu(),
        config = {parent = menu_wrap, type = "cm"} -- You MUST specify parent!
    })
    

    resource_ui:recalculate()
end
function G.UIDEF.resources_showing(resource_page)
    local resources_table = G.GAME.craftr
    local keys = {}
    local resources_amount = 0
    for k,_ in pairs(resources_table) do
        resources_amount = resources_amount + 1
        table.insert(keys, k)
    end
    if not use_page then
        resource_page = nil
    end
    local adding = 15  * ((resource_page or 1) - 1)
    local rows = {}	
    for i = 1, 3 do
        table.insert(rows, {})
        for j = 0, 4 do
            if keys[j*5+i+adding] then
                table.insert(rows[i], keys[j*5+i+adding])
            end
        end
    end
    resource_ui_node = {}
    area_table = {}
    for j = 1, math.max(1,math.min(3, math.ceil(resources_amount/5))) do
        
        table.insert(resource_ui_node, 
        {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
        }}
        )
    end

    local resource_options = {}
    for i = 1, math.ceil(math.max(1, math.ceil(resources_amount/15))) do
        table.insert(resource_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(math.max(1, math.ceil(resources_amount/15)))))
    end

    for j = 1, #resource_ui_node do
        for i = 1, 5 do
            if (i+(j-1)*(5)+adding) <= resources_amount then
                if keys[i+(j-1)*(5)+adding] then
                    local name = localize(keys[i+(j-1)*(5)+adding])
                    local amount = G.GAME.craftr[keys[i+(j-1)*(5)+adding]]
                    table.insert(resource_ui_node[j].nodes, 
                    {n=G.UIT.C, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                            {n=G.UIT.T, config={align = "cm", text = name, scale = 0.35, shadow = true}},
                        }},
                        {n=G.UIT.R, config={align = "cm", padding = 0.2, no_fill = true}, nodes={
                            {n=G.UIT.T, config={align = "cm", text = amount, scale = 0.35, shadow = true}},
                        }}
                    }}
                    )
                end
            end
        end
    end


    resource_ui = UIBox({
        definition = G.UIDEF.resource_ui_menu(resource_page),
        config ={offset = {x=0,y=0}, align = 'cm',},
    })

-- A UIBox must be placed in an Object node

    local texty = "Resources"
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "cm"},nodes={
            {n=G.UIT.T, config={text = texty, scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm"},nodes={
            {n=G.UIT.O, config={object = resource_ui}},
        }},
        {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "bm", minw = 0.5 - 0.15, maxw = 1.5 - 0.15, minh = 0.5, hover = true, shadow = true, colour = HEX('966a2c'), button = 'craft_planks',func = "can_plank"}, nodes={
            {n=G.UIT.T, config={text = localize('b_craft_planks'),colour = G.C.UI.TEXT_LIGHT, scale = 0.6, shadow = true}},
        }},
        {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "bm", minw = 0.5 - 0.15, maxw = 1.5- 0.15, minh = 0.5, hover = true, shadow = true, colour = HEX('966a2c'), button = 'craft_sticks',func = "can_stick"}, nodes={
            {n=G.UIT.T, config={text = localize('b_craft_sticks'),colour = G.C.UI.TEXT_LIGHT, scale = 0.6, shadow = true}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
            create_option_cycle({options = resource_options, w = 3.5, cycle_shoulders = true, opt_callback = 'your_game_resource_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (resource_page or 1), colour = G.C.ORANGE, no_pips = true})
        }},
      }}
    return t
end


G.FUNCS.do_nothing = function(e)
end


