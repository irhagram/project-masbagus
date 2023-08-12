local USER_DOCUMENTS = {}
local CURRENT_DOCUMENT = nil
local DOCUMENT_FORMS = nil

CreateThread(function()
	while ESX == nil do Wait(10) end
    while not ESX.IsPlayerLoaded do Wait(10) end
    ESX.PlayerData = ESX.GetPlayerData()
    DOCUMENT_FORMS = Config.Documents[Config.Locale]
    SetNuiFocus(false, false)
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
    GetAllUserForms()
end)

RegisterNetEvent('esx:onPlayerLogout',function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Functions
function GetAllUserForms()
    lib.callback('esx_documents:server:getPlayerDocuments', false, function(cb_forms)
        if cb_forms ~= nil then
            USER_DOCUMENTS = cb_forms
        end
    end, data)
end

local function OpenNewPublicFormMenu()
    local elements = {}
    for i=1, #DOCUMENT_FORMS['public'], 1 do
        elements[#elements+1] = {
            title       = DOCUMENT_FORMS['public'][i].headerTitle,
            description = 'Klik untuk membuat formulir',
            event       = 'esx_documents:client:CreateNewForm',
            args        = DOCUMENT_FORMS['public'][i]
        }
    end

    lib.registerContext({
        id      = 'documents_public_menu',
        title   = _U('public_documents'),
        menu    = 'documents_main_menu',
        options = elements
    })
    lib.showContext('documents_public_menu')
end

local function OpenNewJobFormMenu()
    local elements = {}
    if DOCUMENT_FORMS[ESX.PlayerData.job.name] ~= nil then
        for i=1, #DOCUMENT_FORMS[ESX.PlayerData.job.name], 1 do
            elements[#elements+1] = {
                title       = DOCUMENT_FORMS[ESX.PlayerData.job.name][i].headerTitle,
                description = 'Klik untuk membuat formulir',
                event       = 'esx_documents:client:CreateNewForm',
                args        = DOCUMENT_FORMS[ESX.PlayerData.job.name][i]
            }
        end
    end

    lib.registerContext({
        id      = 'documents_job_menu',
        title   = _U('job_documents'),
        menu    = 'documents_main_menu',
        options = elements
    })
    lib.showContext('documents_job_menu')
end

local function OpenMyDocumentsMenu()
    local elements = {}
    for i=#USER_DOCUMENTS, 1, -1 do
        local date_created = ''
        if USER_DOCUMENTS[i].data.headerDateCreated ~= nil then
            date_created = USER_DOCUMENTS[i].data.headerDateCreated .. ' - '
        end

        elements[#elements+1] = {
            title       = date_created .. USER_DOCUMENTS[i].data.headerTitle,
            description = 'Klik untuk melihat lebih banyak',
            event       = 'esx_documents:client:OpenFormPropertiesMenu',
            args        = USER_DOCUMENTS[i]
        }
    end

    lib.registerContext({
        id      = 'documents_saved_menu',
        title   = _U('saved_documents'),
        menu    = 'documents_main_menu',
        options = elements
    })
    lib.showContext('documents_saved_menu')
end

local function OpenMainMenu()
    lib.registerContext({
        id      = 'documents_main_menu',
        title   = _U('document_options'),
        options = {
            {
                title       = _U('public_documents'),
                description = 'Klik untuk melihat daftar data',
                onSelect    = function(args)
                    OpenNewPublicFormMenu()
                end
            },
            {
                title       = _U('job_documents'),
                description = 'Klik untuk melihat daftar data',
                onSelect    = function(args)
                    OpenNewJobFormMenu()
                end
            },
            {
                title       = _U('saved_documents'),
                description = 'Klik untuk melihat daftar data',
                onSelect    = function(args)
                    OpenMyDocumentsMenu()
                end
            }
        }
    })
    lib.showContext('documents_main_menu')
end

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        GetAllUserForms()
    end
end)

RegisterNetEvent('esx_documents:client:CopyFormToPlayer', function(aPlayer)
    TriggerServerEvent('esx_documents:server:CopyToPlayer', aPlayer, CURRENT_DOCUMENT)
    CURRENT_DOCUMENT = nil
    lib.hideContext()
end)

RegisterNetEvent('esx_documents:client:ShowToNearestPlayers', function(aDocument)
    local elements      = {}
    local players_clean = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 3.0)
    CURRENT_DOCUMENT    = aDocument

    if #players_clean > 0 then
        for i=1, #players_clean, 1 do
            elements[#elements+1] = {
                title       = players_clean[i].playerName .. "[" .. tostring(players_clean[i].playerId) .. "]",
                description = 'Klik untuk melihat dokumen',
                event       = 'esx_documents:client:ShowDocument',
                args        = players_clean[i].playerId
            }
        end
    else
        elements[#elements+1] = {
            title       = _U('no_player_found'),
            description = '',
            event       = ''
        }
    end

    lib.registerContext({
        id      = 'documents_shownear_menu',
        title   = _U('show_bt'),
        menu    = 'documents_properties_menu',
        options = elements
    })
    lib.showContext('documents_shownear_menu')
end)

RegisterNetEvent('esx_documents:client:CopyToNearestPlayers', function(aDocument)
    local elements      = {}
    local players_clean = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 3.0)
    CURRENT_DOCUMENT    = aDocument

    if #players_clean > 0 then
        for i=1, #players_clean, 1 do
            elements[#elements+1] = {
                title       = players_clean[i].playerName .. "[" .. tostring(players_clean[i].playerId) .. "]",
                description = 'Click to copy the document to nearby people',
                event       = 'esx_documents:client:CopyFormToPlayer',
                args        = players_clean[i].playerId
            }
        end
    else
        elements[#elements+1] = {
            title       = _U('no_player_found'),
            description = '',
            event       = ''
        }
    end

    lib.registerContext({
        id      = 'documents_copy_menu',
        title   = _U('give_copy'),
        menu    = 'documents_properties_menu',
        options = elements
    })
    lib.showContext('documents_copy_menu')
end)

RegisterNetEvent('esx_documents:client:OpenFormPropertiesMenu', function(aDocument)
    lib.registerContext({
        id      = 'documents_properties_menu',
        title   = _U('saved_documents'),
        menu    = 'documents_saved_menu',
        options = {
            {
                title       = _U('view_bt'),
                description = 'Klik untuk melihat dokumen',
                event       = 'esx_documents:client:ViewDocument',
                args        = aDocument.data
            },
            {
                title       = _U('show_bt'),
                description = 'Klik untuk memperlihatkan dokumen kepada orang terdekat',
                event       = 'esx_documents:client:ShowToNearestPlayers',
                args        = aDocument.data
            },
            {
                title       = _U('give_copy'),
                description = 'Klik untuk menyalin dokumen ke orang terdekat',
                event       = 'esx_documents:client:CopyToNearestPlayers',
                args        = aDocument.data
            },
            {
                title       = _U('delete_bt'),
                description = 'Klik untuk menghapus dokumen',
                event       = 'esx_documents:client:OpenDeleteFormMenu',
                args        = aDocument
            },
        }
    })
    lib.showContext('documents_properties_menu')
end)

RegisterNetEvent('esx_documents:client:OpenDeleteFormMenu', function(aDocument)
    lib.registerContext({
        id      = 'documents_delete_menu',
        title   = _U('delete_bt'),
        menu    = 'documents_properties_menu',
        options = {
            {
                title       = _U('yes_delete'),
                description = '',
                event       = 'esx_documents:client:DeleteDocument',
                args        = aDocument
            },
        }
    })
    lib.showContext('documents_delete_menu')
end)

RegisterNetEvent('esx_documents:client:DeleteDocument', function(aDocument)
    local key_to_remove = nil
    lib.callback('esx_documents:server:DeleteDocument', false, function(cb)
        if cb == true then
            for i=1, #USER_DOCUMENTS, 1 do
                if USER_DOCUMENTS[i].id == aDocument.id then
                    key_to_remove = i
                end
            end

            if key_to_remove ~= nil then
                table.remove(USER_DOCUMENTS, key_to_remove)
            end
            OpenMyDocumentsMenu()
        end
    end, aDocument.id)
end)

RegisterNetEvent('esx_documents:client:CreateNewForm', function(aDocument)
    lib.callback('esx_documents:server:getPlayerDetails', false, function(cb_player_details)
        if cb_player_details ~= nil then
            SetNuiFocus(true, true)
            aDocument.headerFirstName   = cb_player_details.firstname
            aDocument.headerLastName    = cb_player_details.lastname
            aDocument.headerDateOfBirth = cb_player_details.dateofbirth
            aDocument.headerJobLabel    = ESX.PlayerData.job.label
            aDocument.headerJobGrade    = ESX.PlayerData.job.grade_label
            aDocument.locale            = Config.Locale

            SendNUIMessage({
                type = 'createNewForm',
                data = aDocument
            })
        end
    end, data)
end)

RegisterNetEvent('esx_documents:client:ShowDocument', function(aPlayer)
    TriggerServerEvent('esx_documents:server:ShowToPlayer', aPlayer, CURRENT_DOCUMENT)
    CURRENT_DOCUMENT = nil
    lib.hideContext()
end)

RegisterNetEvent('esx_documents:client:ViewDocument', function(data)
    ViewDocument(data)
end)

function ViewDocument(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'ShowDocument',
        data = aDocument
    })
end

RegisterNetEvent('esx_documents:client:copyForm', function(data)
    USER_DOCUMENTS[#USER_DOCUMENTS+1] = data
end)

-- Nui Callback
RegisterNUICallback('form_close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('form_submit', function(data, cb)
    lib.hideContext()
    lib.callback('esx_documents:server:submitDocument', false, function(cb_form)
        if cb_form ~= nil then
            USER_DOCUMENTS[#USER_DOCUMENTS+1] = cb_form
            TriggerEvent('esx_documents:client:OpenFormPropertiesMenu', cb_form)
        end
    end, data)

    SetNuiFocus(false, false)
end)

RegisterNetEvent('documents:openMenu', function()
    OpenMainMenu()
end)