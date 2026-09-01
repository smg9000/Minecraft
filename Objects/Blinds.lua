

SMODS.Blind{
	key = "creeper",
	loc_txt = {
 		name = 'The Creeper',
 		text = { "Ends run if not",
			"beaten in #1#"},
 	},
	name = "The Creeper",
	dollars = 5,
	mult = 2,
	boss= {min = 3, max = 10},
	boss_colour = HEX("297711"),
	atlas = "mc_blinds",
    pos = { x = 0, y = 0
        },
    vars = {"0:20"},
	config = {},
	set_blind = function(self)
        G.GAME.blind.config.creepertiming = 20
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.blind.config.creepertiming == nil then
            return {vars = {"0:20.00"}}
        end
        local m = math.floor(G.GAME.blind.config.creepertiming / 60)
        local s = (G.GAME.blind.config.creepertiming - (60 * m))
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
        return {vars = {m .. ":" .. s .. "." .. d}}
    end,
}

SMODS.Blind{
	key = "wither",
	loc_txt = {
 		name = 'Midnight Wither',
 		text = { "All cards scored gain",
			"Wither sticker"},
 	},
	dollars = 5,
	mult = 3,
	boss= {showdown = true, min = 10, max = 10}, 
	boss_colour = HEX("1a1a1a"),
	atlas = "mc_blinds",
    pos = { x = 0, y = 1},
    vars = {},
	config = {},
}
local upd = Game.update
function Game:update(dt)
	upd(self, dt)
    if G.GAME and G.GAME.round_resets and G.GAME.blind and G.GAME.blind.name == "The Creeper" and G.GAME.blind.config and (G.GAME.blind.config.creepertiming ~= nil) and not G.GAME.blind.disabled then
        if Talisman then
            if to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
                G.GAME.blind.config.creepertiming = G.GAME.blind.config.creepertiming and math.max(0, (G.GAME.blind.config.creepertiming) - dt) or nil
                G.GAME.blind:set_text()
            end
        else
            if (G.GAME.chips) < (G.GAME.blind.chips) then
                G.GAME.blind.config.creepertiming = G.GAME.blind.config.creepertiming and math.max(0, (G.GAME.blind.config.creepertiming) - dt) or nil
                G.GAME.blind:set_text()
            end
        end
		if Talisman then
			if (G.GAME.blind.config.creepertiming <= 0) and (G.STATE == G.STATES.SELECTING_HAND) and not (to_big(G.GAME.chips) > to_big(G.GAME.blind.chips)) then
            end_round()
            end
        else 
			if (G.GAME.blind.config.creepertiming <= 0) and (G.STATE == G.STATES.SELECTING_HAND) and not (G.GAME.chips > G.GAME.blind.chips) then
                end_round()		
            end
		end
    end    
end
