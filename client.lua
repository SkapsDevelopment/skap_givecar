RegisterCommand('givecar', function()
    local canUse = lib.callback.await('skap_givevehicle:checkIdentifier', false)
    if not canUse then 
        lib.notify({title = 'Chyba', description = 'Nemáš oprávnění', type = 'error'})
        return 
    end

    local input = lib.inputDialog('Přidat vozidlo', {
        { type = 'number', label = 'ID hráče', required = true },
        { type = 'input', label = 'Model vozidla', required = true },
        { type = 'input', label = 'SPZ (volitelné)', required = false }
    })

    if not input then return end

    local targetId = tonumber(input[1])
    local model = tostring(input[2])
    local plate = input[3] ~= '' and input[3] or nil

    TriggerServerEvent('skap_givevehicle:addVehicle', targetId, model, plate)
end)

local function _U(key)
    return Locales[Config.Locale][key] or key
end
