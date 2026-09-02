
function uncover_cell(e)
    if e.children[1].config.state == "undiscovered" then
        if e.config.mine == true then
            e.children[1].config.state = "mine"
        else
            e.children[1].config.state = "discovered"
            if e.config.adjacent_mines == 0 then
                local grid = e.parent.parent.children
                local index_x = e.config.index.x
                local index_y = e.config.index.y
                local x_grid = #grid
                local y_grid = #grid[1].children
                --stored like
                --123
                --4#5
                --678
                local grid_config_around = {}
                if index_x~=1 then
                    if index_y~=1 then
                        grid_config_around[1] = grid[index_x-1].children[index_y-1]
                    end
                    grid_config_around[4] = grid[index_x-1].children[index_y]
                    if index_y~=y_grid then
                        grid_config_around[6] = grid[index_x-1].children[index_y+1]
                    end
                end
                if index_y~=1 then
                    grid_config_around[2] = grid[index_x].children[index_y-1]
                end
                if index_y~=y_grid then
                    grid_config_around[7] = grid[index_x].children[index_y+1]
                end
                if index_x~=x_grid then
                    if index_y~=1 then
                        grid_config_around[3] = grid[index_x+1].children[index_y-1]
                    end
                    grid_config_around[5] = grid[index_x+1].children[index_y]
                    if index_y~=y_grid then
                        grid_config_around[8] = grid[index_x+1].children[index_y+1]
                    end
                end
                local local_mine_count = 0
                for u, y in pairs(grid_config_around) do
                    uncover_cell(y)
                end
            end
        end
    end
end

local mc_controller_queue_R_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    mc_controller_queue_R_cursor_press_ref(self, x, y)
    local press_node = self.hovering.target or self.focused.target
    if press_node and press_node.config and press_node.config.id and press_node.config.id == "mc_minesweeper_cell" then
        if press_node.children[1].config.state == "undiscovered" then
            press_node.children[1].config.state = "flagged"
        elseif press_node.children[1].config.state == "flagged" then
            press_node.children[1].config.state = "undiscovered"
        end
    end
    
end






local function update_minesweeper_pack(self, dt)
    if G.buttons then G.buttons:remove(); G.buttons = nil end
    if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end

    if not G.STATE_COMPLETE then
        G.STATE_COMPLETE = true
        G.CONTROLLER.interrupt.focus = true
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if self.particles and type(self.particles) == "function" then self:particles() end
                G.booster_pack = UIBox{
                    definition = self:create_UIBox(),
                    config = {align="cm", offset = {x=0,y=G.ROOM.T.y/1.5}, major = G.hand, bond = 'Weak'}
                }
                G.booster_pack.alignment.offset.y = -2.2
                G.ROOM.jiggle = G.ROOM.jiggle + 3
                self:ease_background_colour()
                return true
            end
        }))
        
    end
    if G.pack_cards and G.pack_cards.cards[1] then
        G.pack_cards.cards[1]:remove()
    end
end

local function create_minesweeper_UIBox(self)
    local gridx = SMODS.OPENED_BOOSTER.ability.gridx
    local gridy = SMODS.OPENED_BOOSTER.ability.gridy
    local dimension = SMODS.OPENED_BOOSTER.ability.dimension

    G.pack_cards = CardArea(
        G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
        G.CARD_W * 1.1, G.CARD_H * 1.05,
        {card_limit = 1, type = 'consumeable', highlight_limit = 1, negative_info = true}
    )

    local grid = {}

    for x = 1, gridx do
        local col = {
            n = G.UIT.C,
            config = { align = 'cm', padding = -0.015 },
            nodes = {}
        }
        for y = 1, gridy do
            -- TODO: add sprites to replace direct colour
            local index = {x = x, y = y}
            col.nodes[#col.nodes + 1] = {
                n = G.UIT.R,
                config = {id = "mc_minesweeper_cell", index = index, mine = false, adjacent_mines = 0, padding = -0.015, align = 'cm', w = 0.5, h = 0.5, button_dist = 0, button = 'minesweeper_click', hover = true },
                nodes = { {
                    n = G.UIT.O,
                    config = { object = SMODS.create_sprite(0, 0, 0.5, 0.5, 'mc_minesweeper_sprites', { x = 0, y = 0 }), func = 'mc_upd_minesweeper_cell_sprite', state = "undiscovered", dimension = dimension}, -- TODO: add logic to set sprites (use func = 'blah_func' and G.FUNCS.blah_func(e)!)
                    nodes = { {
                        n = G.UIT.T,
                        config = { text = "9" }, -- TODO: add logic to set text (use func = 'blah_func' and G.FUNCS.blah_func(e)!)
                        nodes = {}
                    } }
                } }
            }
        end
        grid[#grid + 1] = col
    end

    local t = {
        n = G.UIT.ROOT,
        config = { align = 'tm', r = 0.15, colour = G.C.RED, padding = 0.15, minh = 9, minw = 9 },
        nodes = {{
            n = G.UIT.C,
            config = { align = 'cm'},
            nodes = {{
                n = G.UIT.R,
                config = { generated_mines = false, align = 'cm', colour = G.C.BLACK, id = "minesweeper", min_mines = SMODS.OPENED_BOOSTER.ability.min_mines, max_mines = SMODS.OPENED_BOOSTER.ability.max_mines, density = SMODS.OPENED_BOOSTER.ability.density},
                nodes = grid
                },{
                n = G.UIT.R,
                config = { align = 'cm', w = 0, h = 0.2 }
                },{
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.2, minh = 1.2, minw = 1.8, r = 0.15, colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true, shadow = true },
                nodes = {{
                    n = G.UIT.T,
                    config = {text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}
                }}
            }}
        },
        {
            n = G.UIT.C,
            config = { align = 'cm'},
            nodes = {{
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.2, minh = 1.2, minw = 1.8, r = 0.15, colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true, shadow = true },
                nodes = {{
                        n = G.UIT.T,
                        config = { text = "9" }, -- TODO: add logic to set text (use func = 'blah_func' and G.FUNCS.blah_func(e)!)
                        nodes = {}
                    }}
            },
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.2, minh = 1.2, minw = 1.8, r = 0.15, colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true, shadow = true },
                nodes = {{
                        n = G.UIT.T,
                        config = { text = "9" }, -- TODO: add logic to set text (use func = 'blah_func' and G.FUNCS.blah_func(e)!)
                        nodes = {}
                    }}
            },
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.2, minh = 1.2, minw = 1.8, r = 0.15, colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true, shadow = true },
                nodes = {{
                        n = G.UIT.T,
                        config = { text = "9" }, -- TODO: add logic to set text (use func = 'blah_func' and G.FUNCS.blah_func(e)!)
                        nodes = {}
                    }}
            }}
        }}
    }

    return t
end

SMODS.Booster {
    key = 'resource_normal1',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 1,
    cost = 4,
    name = "Resource Pack",
    pos = {x = 0, y = 0},
    config = {extra = 0, choose = 0, gridx = 16, gridy = 16, dimension = "Overworld", min_mines = 0, max_mines = 150, density = 5 },
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    update_pack = update_minesweeper_pack,
    create_UIBox = create_minesweeper_UIBox,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_normal2',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 1,
    cost = 4,
    name = "Resource Pack",
    pos = {x = 1, y = 0},
    config = {extra = 0, choose = 0, gridx = 16, gridy = 16, dimension = "Mine", min_mines = 0, max_mines = 150, density = 10 },
	create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    update_pack = update_minesweeper_pack,
    create_UIBox = create_minesweeper_UIBox,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_jumbo',
    atlas = 'mc_ani_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Jumbo Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 0.75,
    cost = 4,
    name = "Jumbo Resource Pack",
    pos = {x = 0, y = 0},
    config = {extra = 0, choose = 0, gridx = 16, gridy= 16, dimension = "Deepslate", min_mines = 20, max_mines = 60, density = 15 },
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    update_pack = update_minesweeper_pack,
    create_UIBox = create_minesweeper_UIBox,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_mega',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Mega Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 0.5,
    cost = 4,
    name = "Mega Resource Pack",
    pos = {x = 3, y = 0},
    config = {extra = 0, choose = 0, gridx = 16, gridy= 16, dimension = "Nether",min_mines = 30, max_mines = 150, density = 20 },
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
	update_pack = update_minesweeper_pack,
    create_UIBox = create_minesweeper_UIBox,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}


--Code from Betmma's Vouchers
---@generic T : any
---@param t T[]
---@param prop number
---@param seed string
---@return T[]
function pseudorandom_element_proportion(t, prop, seed)
    local r = {}
    local t_copy = SMODS.shallow_copy(t)
    pseudoshuffle(t_copy, seed)
    local amount = math.ceil(#t_copy * prop)

    for i = 1, amount do
        r[#r+1] = t_copy[i]
    end

    return r
end

---@generic T : any
---@param t T[]
---@param amount integer
---@param seed string
---@return T[]
function pseudorandom_element_amount(t, amount, seed)
    local r = {}
    local t_copy = SMODS.shallow_copy(t)
    pseudoshuffle(t_copy, seed)

    for i = 1, amount do
        r[#r+1] = t_copy[i]
    end

    return r
end

function mine_board_generation(density, grid, maximum_mines, minimum_mines, starting_cell)
    local x_grid = #grid
    local y_grid = #grid[1].children
    local element_list = {}
    for i = 1, x_grid do
        for v = 1, y_grid do
            if math.abs(i-starting_cell.x) > 1 or math.abs(v-starting_cell.y) > 1 then
                element_list[#element_list + 1] = grid[i].children[v]
            end
        end
    end
    local mine_cells = pseudorandom_element_proportion(element_list,density/100, "mc_Minesweeper")
    for _, p in pairs(mine_cells) do
        p.config.mine = true
    end

    for i = 1, x_grid do
        for v = 1, y_grid do
            --stored like
            --123
            --4#5
            --678
            local grid_config_around = {}
            if i~=1 then
                if v~=1 then
                    grid_config_around[1] = grid[i-1].children[v-1].config
                end
                grid_config_around[4] = grid[i-1].children[v].config
                if v~=y_grid then
                    grid_config_around[6] = grid[i-1].children[v+1].config
                end
            end
            if v~=1 then
                grid_config_around[2] = grid[i].children[v-1].config
            end
            if v~=y_grid then
                grid_config_around[7] = grid[i].children[v+1].config
            end
            if i~=x_grid then
                if v~=1 then
                    grid_config_around[3] = grid[i+1].children[v-1].config
                end
                grid_config_around[5] = grid[i+1].children[v].config
                if v~=y_grid then
                    grid_config_around[8] = grid[i+1].children[v+1].config
                end
            end
            local local_mine_count = 0
            for u, y in pairs(grid_config_around) do
                if y.mine == true then
                    local_mine_count = local_mine_count + 1
                end
            end
            local grid_config = grid[i].children[v].config
            grid_config.adjacent_mines = local_mine_count


            

        end
    end





end
G.FUNCS.can_reserve_card = function(e)
	if #G.consumeables.cards < G.consumeables.config.card_limit then
		e.config.colour = G.C.GREEN
		e.config.button = "reserve_card"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

local sweeper_atlas_positions = {
    undiscovered = 0,
    discovered = 1,
    flagged = 11,
    mine = 2
}

local sweeper_dimension_positions = {
    Overworld = 0,
    Mine = 1,
    Deepslate = 2,
    Nether = 3,
    Sift = 4,
    End = 5   
}
function G.FUNCS.mc_upd_minesweeper_cell_sprite(e)
    local spr_x = sweeper_atlas_positions[e.config.state] or 0
    local spr_y = sweeper_dimension_positions[e.config.dimension] or 0
    if e.config.state == "discovered" then
        if e.parent.config.adjacent_mines ~= 0 then
            e.config.object:set_sprite_pos({x = 2 + e.parent.config.adjacent_mines , y = spr_y})
            goto skip_set_sprite2
        end
    end
    e.config.object:set_sprite_pos({x = spr_x, y = spr_y})
    ::skip_set_sprite2::

end




    

G.FUNCS.minesweeper_click = function(e)
    local min_mines = e.parent.parent.config.min_mines
    local max_mines = e.parent.parent.config.max_mines
    local grid = e.parent.parent.children
    local x_grid = #grid
    local y_grid = #grid[1].children

    local density = e.parent.parent.config.density
    if e.parent.parent.generated_mines ~= true then
        mine_board_generation(density, grid, max_mines, min_mines, e.config.index)
        e.parent.parent.generated_mines = true
    end
    if e.children[1].config.state == "discovered" then
        
        local grid_config_around = {}
        if e.config.index.x~=1 then
            if e.config.index.y~=1 then
                grid_config_around[1] = grid[e.config.index.x-1].children[e.config.index.y-1]
            end
            grid_config_around[4] = grid[e.config.index.x-1].children[e.config.index.y]
            if e.config.index.y~=y_grid then
                grid_config_around[6] = grid[e.config.index.x-1].children[e.config.index.y+1]
            end
        end
        if e.config.index.y~=1 then
            grid_config_around[2] = grid[e.config.index.x].children[e.config.index.y-1]
        end
        if e.config.index.y~=y_grid then
            grid_config_around[7] = grid[e.config.index.x].children[e.config.index.y+1]
        end
        if e.config.index.x~=x_grid then
            if e.config.index.y~=1 then
                grid_config_around[3] = grid[e.config.index.x+1].children[e.config.index.y-1]
            end
            grid_config_around[5] = grid[e.config.index.x+1].children[e.config.index.y]
            if e.config.index.y~=y_grid then
                grid_config_around[8] = grid[e.config.index.x+1].children[e.config.index.y+1]
            end
        end
        local local_flag_count = 0
        for u, y in pairs(grid_config_around) do
            if y.children[1].config.state == "flagged" then
                local_flag_count = local_flag_count + 1
            end
        end
        if local_flag_count == e.config.adjacent_mines then
            for j, k in pairs(grid_config_around) do
                if k.children[1].config.state ~= "flagged" then
                    uncover_cell(k)
                end
            end
        end
    else
        uncover_cell(e)
    end
    
    
end

G.FUNCS.reserve_card = function(e)
	local c1 = e.config.ref_table
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then
				c1.children.price:remove()
			end
			c1.children.price = nil
			if c1.children.buy_button then
				c1.children.buy_button:remove()
			end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.consumeables:emplace(c1)
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end,
	}))
end

