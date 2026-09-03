SMODS.DungeonNodes = {}


--[[
Param Explaination:

Key: Unique Identifier
Type: Node type, such as boss, mob, resource...
DungeonPools: What dungeons this node can appear in.
Rarity: How rare this node is.
]]--
SMODS.MapNode = SMODS.GameObject:extend {
    obj_table = SMODS.DungeonNodes,
    obj_buffer = {},
    set = "DungeonMapNodes",
    required_params = {
        'key',
        'type',
        'dungeonPools',
        'rarity',
    },
}

--Dungeon Pools--
SMODS.ObjectType {
    key = "Overworld_Dungeon_Pool",
    mapNodes = {
        ["mc_exampleNode"] = false
    },
    rarities = {
        {
            key = "mc_DungeonNode_Common",
            rate = 0.75,
        },
        {
            key = "mc_DungeonNode_Uncommon",
            rate = 0.5,
        },
        {
            key = "mc_DungeonNode_Rare",
            rate = 0.25,
        },
        {
            key = "mc_DungeonNode_Legendary",
            rate = 0.05,
        },
    },
}