ESX = exports['es_extended']:getSharedObject()

lib.callback.register('skap_givevehicle:checkIdentifier', function(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        for _, allowed in ipairs(Config.AllowedIdentifiers) do
            if id == allowed then
                return true
            end
        end
    end
    return false
end)

local Nums = {}
local Chars = {}

for i = 48, 57 do table.insert(Nums, string.char(i)) end -- 0-9
for i = 65, 90 do table.insert(Chars, string.char(i)) end -- A-Z
for i = 97, 122 do table.insert(Chars, string.char(i)) end -- a-z

local function IsPlateTaken(plate)
    local res = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    return res[1] ~= nil
end

local function GeneratePlate()
    local generatedPlate = ""

    for c = 1, 3 do 
        generatedPlate = generatedPlate .. Chars[math.random(1, #Chars)]
    end
    generatedPlate = generatedPlate .. ' '
    for c = 1, 3 do 
        generatedPlate = generatedPlate .. Nums[math.random(1, #Nums)]
    end
    generatedPlate = string.upper(generatedPlate)

    if IsPlateTaken(generatedPlate) then
        return GeneratePlate()
    end
    return generatedPlate
end

ESX.RegisterServerCallback('skap_givevehicle:GeneratePlate', function(source, cb)
    cb(GeneratePlate())
end)

RegisterNetEvent('skap_givevehicle:addVehicle', function(targetId, model, plate)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local allowed = false
    for _, id in ipairs(identifiers) do
        for _, allowedId in ipairs(Config.AllowedIdentifiers) do
            if id == allowedId then
                allowed = true
                break
            end
        end
    end
    if not allowed then
        Config.Notify(src, 'Nemáš oprávnění', 'error')
        return
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        Config.Notify(src, 'Neplatné ID hráče', 'error')
        return
    end

    if not plate or plate == '' then
        plate = GeneratePlate()
    end

    local function _U(key)
    return Locales[Config.Locale][key] or key
end

    local vehProps = json.encode({model = GetHashKey(model), plate = plate})

    local res = MySQL.Sync.execute(
        'INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
        {
            ['@owner'] = xTarget.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = vehProps,
            ['@type'] = Config.DefaultType
        }
    )

    if res then
        Config.Notify(src, 'Vozidlo přidáno: ' .. plate)
        Config.Notify(xTarget.source, 'Dostal jsi nové vozidlo: ' .. plate)
    else
        Config.Notify(src, 'Chyba při ukládání do databáze', 'error')
    end
end)