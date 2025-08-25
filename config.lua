Config = {}

Config.AllowedIdentifiers = {
    "license:"
    --more licences
}

Config.DefaultType = 'car' -- boat, plane, helicopter

Config.Locale = 'cs' -- 'cs' - 'en'

Config.Notify = function(source, msg, type)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Vozidlo', --car
        description = msg,
        type = type or 'success'
    })
end
