--- @section Variables

local current_fish = nil
local player_baits = {}

--- @section Internal Helper Functions

--- Get the zone player is in
local function get_zone_type(zone)
    for type, zones in pairs(config.zones) do
        for _, valid_zone in ipairs(zones) do
            if valid_zone == zone then
                return type
            end
        end
    end
    return nil
end

-- Gets the bait equipped by the player
local function get_player_bait(player_id)
    return player_baits[player_id]
end

--- Calculate the weight of a fish based on its length
local function calculate_weight(length, min_length, max_length, min_weight, max_weight)
    local length_ratio = (length - min_length) / (max_length - min_length)
    return math.floor(min_weight + (length_ratio * (max_weight - min_weight)))
end

--- @section Events

--- Catches a fish.
RegisterServerEvent('boii_fishing:sv:catch_fish', function()
    local _src = source
    if not current_fish then notify(_src, 'FISHING', 'No current stored fish data.', 'error', 3500) return end
    local current_bait = get_player_bait(_src)
    if not current_bait then notify(_src, 'FISHING', 'You need to equip bait before fishing!', 'error', 3500) return end
    notify(_src, 'FISHING', string.format('You caught a %s! Length: %dcm, Weight: %dg', current_fish.label, current_fish.length, current_fish.weight), 'success', 3500)
    utils.fw.adjust_inventory(_src, {
        items = {
            { item_id = current_fish.id, action = 'add', quantity = 1, data = { length = current_fish.length, weight = current_fish.weight } },
            { item_id = current_bait, action = 'remove', quantity = 1 }
        }, 
        note = 'Fishing: Caught a fish.', 
        should_save = true
    })

    local inv_bait = utils.fw.get_item(_src, current_bait)
    if inv_bait then
        bait_amount = inv_bait.quantity or inv_bait.count or inv_bait.amount
    else
        bait_amount = 0
    end

    TriggerClientEvent('boii_fishing:cl:update_bait_value', _src, bait_amount)

    if config.skills_enabled then
        utils.skills.modify_skill(_src, 'fishing', current_fish.xp_reward, 'add')
    end
    current_fish = nil
end)

--- Release a fish.
RegisterServerEvent('boii_fishing:sv:release_fish', function()
    local _src = source
    if not current_fish then return end
    local current_bait = get_player_bait(_src)
    if not current_bait then notify(_src, 'FISHING', 'You need to equip bait before fishing!', 'error', 3500) return end
    notify(_src, 'FISHING', string.format('You released a %s! Length: %dcm, Weight: %dg', current_fish.label, current_fish.length, current_fish.weight), 'success', 3500)
    utils.fw.adjust_inventory(_src, {
        items = {
            { item_id = current_bait, action = 'remove', quantity = 1 }
        }, 
        note = 'Fishing: Caught a fish.', 
        should_save = true
    })
    local inv_bait = utils.fw.get_item(_src, current_bait)
    if inv_bait then
        bait_amount = inv_bait.quantity or inv_bait.count or inv_bait.amount
    else
        bait_amount = 0
    end
    TriggerClientEvent('boii_fishing:cl:update_bait_value', _src, bait_amount)
    if config.skills_enabled then
        utils.skills.modify_skill(_src, 'fishing', current_fish.xp_reward, 'add')
    end
    current_fish = nil
end)

-- Sets the current bait for the player
RegisterServerEvent('boii_fishing:sv:set_bait', function(bait)
    local _src = source
    local has_item = utils.fw.has_item(_src, bait, 1)
    if not has_item then
        notify(_src, 'FISHING', 'You dont have any bait to equip.', 'error', 3500)
        TriggerClientEvent('boii_fishing:cl:reset_player', _src)
        player_baits[_src] = nil
        return
    end
    player_baits[_src] = bait
end)

-- Handles fishing rewards
RegisterServerEvent('boii_fishing:sv:fishing_reward', function(zone)
    local _src = source
    local current_bait = get_player_bait(_src)
    if not current_bait then notify(_src, 'FISHING', 'You need to equip bait before fishing!', 'error', 3500) return end
    local fishing_level = 0
    if config.skills_enabled then
        local fishing_skill = utils.skills.get_skill(_src, 'fishing')
        fishing_level = fishing_skill.level
    end
    local zone_type = get_zone_type(zone)
    if not zone_type then 
        notify(_src, 'FISHING', 'Invalid fishing zone.', 'error', 3500)
        TriggerClientEvent('boii_fishing:cl:reset_player', _src)
        return 
    end
    local eligible_fish = {}
    for _, fish in pairs(config.fish) do
        if fish.zone == zone_type and (not config.skills_enabled or fish.skills.level_required <= fishing_level) and (utils.tables.table_contains(fish.bait, current_bait)) then
            eligible_fish[#eligible_fish + 1] = fish
        end
    end
    if #eligible_fish == 0 then 
        notify(_src, 'FISHING', 'No fish can be caught with this bait in the current zone!', 'error', 3500)
        TriggerClientEvent('boii_fishing:cl:reset_player', _src)
        return 
    end
    local selected_fish = eligible_fish[math.random(#eligible_fish)]
    local length = math.random(selected_fish.length.min, selected_fish.length.max)
    local weight = calculate_weight(length, selected_fish.length.min, selected_fish.length.max, selected_fish.weight.min, selected_fish.weight.max)
    local xp_gain = math.random(selected_fish.skills.xp_gain.min, selected_fish.skills.xp_gain.max)
    local fish_data = {
        id = selected_fish.id,
        label = selected_fish.label,
        weight = weight,
        length = length,
        image = selected_fish.image,
        xp_reward = xp_gain
    }
    current_fish = fish_data
    TriggerClientEvent('boii_fishing:cl:fish_reward', _src, fish_data)
end)

--- @section Callbacks

--- Register callback to fetch players bait amounts.
utils.callback.register('boii_fishing:sv:fetch_baits', function(_src, data, cb)
    if not _src then return end
    if not cb then return end
    local baits = config.baits
    for _, bait in pairs(baits) do
        local inv_item = utils.fw.get_item(_src, bait.id)
        if inv_item then
            baits[bait.id].quantity = inv_item.quantity or inv_item.count or inv_item.amount or 0
        else
            baits[bait.id].quantity = 0
        end
    end
    cb({ baits = baits })
end)