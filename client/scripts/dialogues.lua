local dialogues = dialogues or {}

dialogues.fishing = {
    header = {
        message = 'Welcome to the Fishing Store!',
        icon = 'fa-solid fa-fish'
    },
    conversation = {
        {
            id = 1,
            response = 'Hey there! Looking to gear up for your next outing?',
            options = {
                {
                    icon = 'fa-solid fa-info-circle',
                    message = 'What kind of fishing gear do you have?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Show me what fishing gear you have for sale.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii_fishing:sv:load_store',
                    params = {
                        store = 'fishing'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Just looking around for now, thanks!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'We offer a range of fishing essentials. Whether youre fishing freshwater or out in the sea, we have the gear to get you ready for the trip!',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Back to previous questions.',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-box-open',
                    message = 'Let me see your fishing gear.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii_fishing:sv:load_store',
                    params = {
                        store = 'fishing'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Thanks, Ill take a look around.',
                    next_id = nil,
                    should_end = true
                }
            }
        },
    }
}

dialogues.fish = {
    header = {
        message = 'Fish Vendor',
        icon = 'fa-solid fa-fish'
    },
    conversation = {
        {
            id = 1,
            response = 'Got some fresh fish for sale? Im always looking to buy.',
            options = {
                {
                    icon = 'fa-solid fa-info-circle',
                    message = 'What types of fish do you buy?',
                    next_id = 2,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-dollar-sign',
                    message = 'I want to sell some fish.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii_fishing:sv:load_store',
                    params = {
                        store = 'fish'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Maybe next time!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
        {
            id = 2,
            response = 'Im interested in all kinds of fish sticklebacks, trout, guitarfish, you name it. As long as its fresh, Ill buy it.',
            options = {
                {
                    icon = 'fa-solid fa-arrow-left',
                    message = 'Back to previous questions.',
                    next_id = 1,
                    should_end = false
                },
                {
                    icon = 'fa-solid fa-dollar-sign',
                    message = 'I want to sell some fish.',
                    next_id = nil,
                    should_end = true,
                    action_type = 'server',
                    action = 'boii_fishing:sv:load_store',
                    params = {
                        store = 'fish'
                    }
                },
                {
                    icon = 'fa-solid fa-door-open',
                    message = 'Maybe next time!',
                    next_id = nil,
                    should_end = true
                }
            }
        },
    }
}

--- Event to launch dialogue based on store type.
RegisterNetEvent('boii_fishing:cl:start_conversation', function(data)
    local location = data.location
    local store_type = data.store
    if not is_store_open(store_type) then notify('Store Closed', 'This store is currently closed. Please come back during the opening hours.', 'info', 3500) return end
    local ped, coords = utils.entities.get_closest_ped(vector3(location.x, location.y, location.z), 5.0)
    local dialogue = dialogues[store_type]
    for _, convo in pairs(dialogue.conversation) do
        for _, option in pairs(convo.options) do
            if option.action ~= nil and option.action ~= '' then
                option.params = option.params or {}
                option.params.location = vector3(location.x, location.y, location.z)
            end
        end
    end
    exports.boii_ui:dialogue(dialogue, ped, coords)
end)