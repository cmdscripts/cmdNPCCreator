ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("msk:create")
AddEventHandler("msk:create", function(dataCreate)
    local source = source

    MySQL.Async.execute('INSERT INTO npcbuilder (model, position, animation) VALUES (@model, @position, @animation)', {
        ['@model'] = dataCreate.ModelLabel,
        ['@position'] = json.encode(dataCreate.PositionData),
        ['@animation'] = dataCreate.AnimationLabel,
    })
    TriggerClientEvent('esx:showNotification', source, "~g~NPC created")
end)

RegisterServerEvent('msk:getped')
AddEventHandler('msk:getped', function()
    local source = source

    local ServerPeds = {}

    MySQL.Async.fetchAll("SELECT * FROM npcbuilder", {}, function(result)
        if (result) then
            ServerPeds = result
            TriggerClientEvent('msk:sendUpdate', -1, ServerPeds)
        end
    end)

end)

RegisterServerEvent('msk:delete')
AddEventHandler('msk:delete', function(id)
    local source = source
	MySQL.Async.execute("DELETE FROM npcbuilder WHERE id = "..id.."", {}, function(rowsChanged)
		TriggerClientEvent('esx:showNotification', source, "~g~NPC deleted")
	end)
end)