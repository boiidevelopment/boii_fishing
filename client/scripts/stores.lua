--- Opens the store UI.
--- @param data table: Data containing store information.
RegisterNetEvent('boii_fishing:cl:open_store', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open_store',
        data = data
    })
end)

--- Closes the UI and removes focus.
RegisterNUICallback('close_ui', function()
    SetNuiFocus(false, false)
end)

--- Requests store data from the server.
--- @param data table: Data containing store request information.
RegisterNetEvent('boii_fishing:cl:request_store', function(data)
    if not is_store_open(data.store) then notify('Store Closed', 'This store is currently closed. Please come back during the opening hours.', 'info', 3500) return end
    TriggerServerEvent('boii_fishing:sv:load_store', data)
end)

--- Handles store actions.
--- @param data table: Store action data.
RegisterNUICallback('handle_store_action', function(data)
    TriggerServerEvent('boii_fishing:sv:handle_store_action', data)
end)
