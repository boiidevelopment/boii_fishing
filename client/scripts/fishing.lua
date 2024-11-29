--- @section Variables

local rod = nil
local fishing_ui_open = false
local is_fishing = false
local bait_equipped = false
local current_zone = false

--- @section Local Functions

--- Get the type of zone the player is in.
--- @param zone string The zone name to check.
--- @return string|nil The type of zone ('freshwater' or 'saltwater') or nil if not found.
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

--- Check if the player is near water.
--- @param player number The player entity ID.
--- @return boolean Whether the player is near water.
local function near_water(player)
    if IsPedSwimming(player) then return false end
    local bone_coords = GetPedBoneCoords(player, 31086, 0.0, 0.0, 0.0)
    local forward_coords = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)
    local is_near = TestProbeAgainstWater(bone_coords.x, bone_coords.y, bone_coords.z, forward_coords.x, forward_coords.y, forward_coords.z)
    if not is_near then
        local distance_to_water = utils.environment.get_distance_to_water()
        if distance_to_water > 0 and distance_to_water <= 5.0 then
            return true
        end
    end
    return is_near
end

--- Equip a fishing rod to the player.
--- @param player number The player entity ID.
local function give_rod(player)
    local model = 'prop_fishing_rod_01'
    utils.requests.model(model)
    local coords = GetEntityCoords(player)
    rod = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    local bone = GetPedBoneIndex(player, 18905)
    AttachEntityToEntity(rod, player, bone, 0.1, 0.05, 0.0, 70.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(model)
    Wait(500)
    SendNUIMessage({ action = 'open_fishing' })
end

--- Remove the fishing rod from the player.
local function remove_rod()
    if DoesEntityExist(rod) then
        DeleteEntity(rod)
        rod = nil
    end
end

--- Stop fishing and clean up the UI.
local function stop_fishing()
    if fishing_ui_open then
        fishing_ui_open = false
        remove_rod()
        SendNUIMessage({ action = 'close_fishing' })
    end
end

--- Monitor the player's fishing state.
--- @param player number The player entity ID.
local function monitor_fishing(player)
    while fishing_ui_open do
        Wait(1000)
        if IsPlayerDead(player) then
            stop_fishing()
            notify('FISHING', 'You died.. Stopping fishing...', 'error', 3500)
            break
        end
        local weapon = GetSelectedPedWeapon(player)
        if weapon ~= `WEAPON_UNARMED` then
            stop_fishing()
            notify('FISHING', 'You have a weapon equipped.. Stopping fishing...', 'error', 3500)
            break
        end
        local pos = GetEntityCoords(player)
        local zone = GetNameOfZone(pos.x, pos.y, pos.z)
        local zone_type = get_zone_type(zone)
        current_zone = zone
        if not zone_type or not near_water(player) then
            stop_fishing()
            notify('FISHING', 'No longer near water.. Stopping fishing...', 'error', 3500)
            break
        end
    end
end

--- Run the fishing minigame.
--- @param player number The player entity ID.
local function run_minigame(player)
    local settings = { style = 'default', score_limit = 3, miss_limit = 3, fall_delay = 3000, new_letter_delay = 2000 }
    exports.boii_minigames:key_drop(settings, function(success)
        if success then
            TriggerServerEvent('boii_fishing:sv:fishing_reward', current_zone)
        else
            ClearPedTasksImmediately(player)
            is_fishing = false
            FreezeEntityPosition(player, false)
        end
    end)
end

--- Start the fishing sequence.
--- @param player number The player entity ID.
local function start_fishing(player)
    if not is_fishing then return end

    local function fish(player)
        local delay = 10
        SendNUIMessage({ 
            action = 'start_timer', 
            message = 'Waiting For A Bite...', 
            duration = delay
        })
        utils.player.play_animation(player, {
            dict = 'amb@world_human_stand_fishing@idle_a',
            anim = 'idle_c',
            flags = 49,
            freeze = true,
            continuous = true
        })
        Wait(delay * 1000)
        run_minigame(player)
    end

    local function cast_off(player)
        utils.player.play_animation(player, {
            dict = 'mini@tennis',
            anim = 'forehand_ts_md_far',
            flags = 49,
            duration = 1500,
            freeze = true
        }, function()
            fish(player)
        end)
    end

    cast_off(player)
end

--- Handle key presses while fishing.
--- @param player number The player entity ID.
local function handle_keypresses(player)
    CreateThread(function()
        while fishing_ui_open do
            Wait(0)
            if not is_fishing then
                if IsControlJustReleased(0, utils.keys.get_key('e')) and not bait_ui_open then
                    SetNuiFocus(true, true)
                    bait_ui_open = true
                    SendNUIMessage({ action = 'show_bait_ui' })
                end
                if IsControlJustReleased(0, utils.keys.get_key('f')) then
                    is_fishing = true
                    start_fishing(player)
                end
            end
        end
    end)
end

--- Open the fishing UI and begin fishing.
--- @param player number The player entity ID.
local function open_fishing_ui(player)
    fishing_ui_open = true
    give_rod(player)
    notify('FISHING', 'Fishing rod equipped. You are now fishing!', 'success', 3500)
    handle_keypresses(player)
    monitor_fishing(player)
end

--- @section NUI Callbacks

--- Close the NUI fishing UI.
RegisterNUICallback('close_ui', function()
    SetNuiFocus(false, false)
    bait_ui_open = false
end)

--- Handle the fish caught/released decision.
--- @param data table Contains information about whether the fish was kept.
RegisterNUICallback('handle_fish', function(data)
    local _src = source
    local player = PlayerPedId()
    SetNuiFocus(false, false)
    ClearPedTasksImmediately(player)
    is_fishing = false
    FreezeEntityPosition(player, false)
    if data.keep then
        TriggerServerEvent('boii_fishing:sv:catch_fish')
    else
        TriggerServerEvent('boii_fishing:sv:release_fish')
    end
end)

--- Fetch baits
RegisterNUICallback('fetch_baits', function(data, cb)
    utils.callback.cb('boii_fishing:sv:fetch_baits', nil, function(response)
        if not response.baits then 
            return cb({})
        end
        cb({ baits = response.baits })
    end)
end)

--- Set bait
RegisterNUICallback('set_bait', function(data)
    SetNuiFocus(false, false)
    TriggerServerEvent('boii_fishing:sv:set_bait', data.bait)
end)

--- @section Events

--- Display the fish reward UI
--- @param current_fish table The details of the fish caught
RegisterNetEvent('boii_fishing:cl:fish_reward', function(current_fish)
    SetNuiFocus(true, false)
    SendNUIMessage({
        action = 'fish_reward',
        fish_data = current_fish
    })
end)

--- Update bait value when action is completed.
RegisterNetEvent('boii_fishing:cl:update_bait_value', function(quantity)
    SendNUIMessage({
        action = 'update_bait_quantity',
        quantity = tonumber(quantity) or 0
    })
end)

--- Reset player to prevent position freezing when server side returns false
RegisterNetEvent('boii_fishing:cl:reset_player', function()
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())
end)

--- Starts fishing
RegisterNetEvent('boii_fishing:cl:start_fishing', function()
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    local zone = GetNameOfZone(pos.x, pos.y, pos.z)
    local zone_type = get_zone_type(zone)
    debug_log('info', string.format('Zone: %s | Zone Type: %s', zone, zone_type))
    if rod then
        stop_fishing()
        notify('FISHING', 'Fishing rod removed.', 'info', 3500)
        return
    end
    if not zone_type or not near_water(player) then notify('FISHING', 'You are not near water.', 'error', 3500) return end
    open_fishing_ui(player)
end)