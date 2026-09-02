enchants = {
    sharpness = {
        Joker = true,
        Card = true,
        Consumable = true,
        max = 5,
        loc_txt = 'Sharpness',
        loc_vars = function(value)
            return {2 * value}
        end
    }
}

function random_enchant(card, level)
    if not level then
        level = 0
    end
    local enchanted = false
    local result = {}
    local type_ = "Other"
    if card.ability.set == "Joker" then
        type_ = "Joker"
    elseif card.ability.consumeable then
        type_ = "Consumable"
    elseif card.config.card.suit then
        type_ = "Card"
    end
    for i, j in pairs(enchants) do
        if j[type_] then
            local base = 0
            while pseudorandom('mc_enchant') < 0.10 + 0.05* level do
                base = base + 1
                if base == j.max then
                    break
                end
            end
            if base > 0 then
                result[i] = base
                enchanted = true
            end
        end
    end
    if (level >= 1) and not enchanted then
        local pool = {}
        for i, j in pairs(enchants) do
            if j[type_] then
                table.insert(pool, i)
            end
        end
        if #pool > 0 then
            local enchant = pseudorandom_element(pool, pseudoseed("mc_enchant"))
            enchanted = true
            result[enchant] = 1
        end
    end
    if enchanted then
        return result
    end
end

function Card:add_enchant(enchant)
    self.ability.enchant = enchant
    if self.ability.enchant then
        self.ability.enchanted = true
    end
end

function Card:get_enchant()
    if self.debuff then return end
    if self.ability.enchant then
        local ret = {card = self}
        if self.ability.enchant.sharpness then
            ret.mult_mod = 1 + self.ability.enchant.sharpness
        end
        return ret
    end
end

SMODS.Sticker {
    key = 'enchant',
    rate = 0,
    pos = { x = 0, y = 0 },
    colour = HEX '97F1EF',
    badge_colour = HEX '97F1EF',
    should_apply = function(self, card, center, area)
        return true
    end,
    loc_txt = {
        name = "",
        text = {
            "",
        },
        label = ""
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    apply = function(self, card, val)
        card:add_enchant(random_enchant(card, 0))
    end,
    sets = { 
        Joker = true,
        Tarot = true,
        Planet = true,
        Spectral = true,
        Tarot_Planet = true,
    },
}

SMODS.DrawStep{
  	key = "mc_enchantment",
  	order = 21,
  	func = function(self, layer)
		if self:get_enchant() then
            self.children.center:draw_shader("mc_enchant", nil, self.ARGS.send_to_shader)
            if self.children.front and not self:should_hide_front() then
                self.children.front:draw_shader("mc_enchant", nil, self.ARGS.send_to_shader)
            end
        
        end
  	end,
  	conditions = { vortex = false, facing = 'front' },
}


--Shader--

SMODS.Shader {
    key = 'enchant',
    path = 'enchant.fs'
}