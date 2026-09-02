


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

--???
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