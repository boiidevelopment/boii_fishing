-- Import utility library
utils = exports.boii_utils:get_utils()

--- Version check options
--- @field resource_name: The name of the resource to check, you can set a value here or use the current resource.
--- @field url_path: The path to your json file.
--- @field callback: Callback to invoking resource version check details *optional*
local opts = {
    resource_name = 'boii_fishing',
    url_path = 'boiidevelopment/fivem_resource_versions/main/versions.json',
}
utils.version.check(opts)

--- @section Global functions

--- Handles debug logging.
--- @param type string: The type of debug message.
--- @param message string: The debug message.
function debug_log(type, message)
    if config.debug and utils.debug[type] then utils.debug[type](message) end
end

--- Send notifications.
--- @param _src number: The source player ID.
--- @param header string: Notification header.
--- @param message string: Notification message.
--- @param type string: Notification type.
--- @param duration number: Notification duration in ms.
function notify(_src, header, message, type, duration)
    utils.ui.notify(_src, { header = header, message = message, type = type, duration = duration })
end

--- @section Callbacks

--- Server callback to provide config sections to client.
--- @param _src number: The players server ID requesting the data.
--- @param data table: Unused parameter for consistency with callback pattern.
--- @param cb function: Callback function to return.
utils.callback.register('boii_fishing:sv:request_config', function(_src, data, cb)
    cb({ debug = config.debug, use_target = config.use_target, stores = config.stores, zones = config.zones })
end)

--- @section Items

--- Hang script until framework is not nil
--- For some reason this was not ready at time of creating items causing an error, messy but it works.
local framework = utils.fw.get_framework()
if framework == nil then
    repeat
        Wait(100)
        framework = utils.fw.get_framework()
    until framework ~= nil
end

--- Register dealer phone as usable through utils.
utils.fw.register_item('fishing_rod', function(_src)
    if _src and _src ~= 0 then
        TriggerClientEvent('boii_fishing:cl:start_fishing', _src)
    end
end)