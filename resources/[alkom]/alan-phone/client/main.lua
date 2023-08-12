local PlayerJob = {}
local phoneProp = 0
local frontCam = false
local isLoggedIn = false
local patt = "[?!@#]"
local phoneModel = `prop_npc_phone_02`

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    currentTab = nil,
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    id = 1,
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    Images = {}
}

CreateThread(function()
    while ESX.GetPlayerData().job == nil do Wait(10) end
    ESX.PlayerData = ESX.GetPlayerData()

    Wait(200)
    LoadPhone()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
	LoadPhone()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerOn = ESX.PlayerData.job
    Work = ESX.PlayerData.job.name

    SendNUIMessage({
        action = "UpdateApplications",
        JobData = Work,
        applications = Config.PhoneApplications
    })
end)

RegisterNetEvent('alan-phone:LoadHP')
AddEventHandler('alan-phone:LoadHP', function()
    LoadPhone()
    exports['alan-tasknotify']:SendAlert('success', '[DEBUG] PHONE LOADED')
end)

function string:split(delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
	result[#result+1] = string.sub(self, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
	result[#result+1] = string.sub(self, from)
    return result
end

local function escape_str(s)
	return s
end

local function GenerateTweetId()
    local tweetId = 'TWEET-'..math.random(11111111, 99999999)
    return tweetId
end

local function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local  function CalculateTimeToDisplay()
    hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

    if minute <= 9 then
    minute = '0' .. minute
    end

    obj.hour = hour
    obj.minute = minute
    return obj
end

local function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

local function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

local function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

local function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

local function findVehFromPlateAndLocate(plate)
    local gameVehicles = ESX.Game.GetVehicles()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if GetVehicleNumberPlateText(vehicle) == plate then
                local vehCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehCoords.x, vehCoords.y)
                return true
            end
        end
    end
end

local function DisableSemua()
    DisableControlAction(0, 1, true) -- disable mouse look
    DisableControlAction(0, 2, true) -- disable mouse look
    DisableControlAction(0, 3, true) -- disable mouse look
    DisableControlAction(0, 4, true) -- disable mouse look
    DisableControlAction(0, 5, true) -- disable mouse look
    DisableControlAction(0, 6, true) -- disable mouse look
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape
    DisableControlAction(0, 245, true) -- disable chat
end

RegisterNetEvent('alan-phone:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = 'Race',
                text = message,
                icon = 'fas fa-flag-checkered',
                color = '#353b48',
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = 'Notification',
            NotifyData = {
                title = 'Race',
                content = message,
                icon = 'fas fa-flag-checkered',
                timeout = 3500,
                color = '#353b48',
            },
        })
    end
end)

RegisterNetEvent('alan-phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'phone')
    Config.PhoneApplications['phone'].Alerts = Config.PhoneApplications['phone'].Alerts + 1
    SendNUIMessage({
        action = 'RefreshAppAlerts',
        AppData = Config.PhoneApplications
    })
end)

RegisterNUICallback('getdocsme', function(data)
    TriggerServerEvent('alan-phone:server:savedocuments', data)
end)

RegisterNUICallback('GetNote_for_Documents_app', function(data, cb)
    lib.callback('alan-phone:server:GetNote_for_Documents_app', false, function(Has)
        cb(Has)
    end)
end)

RegisterNetEvent('alan-phone:getdocuments', function()
    SendNUIMessage({
        action = "DocumentRefresh",
    })
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'phone', 0)
    Config.PhoneApplications['phone'].Alerts = 0
    SendNUIMessage({ action = 'RefreshAppAlerts', AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background
    TriggerServerEvent('alan-phone:server:SaveMetaData', 'background', background)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

RegisterNetEvent('alan-phone:openPhone', function()
    OpenPhone()
end)

RegisterCommand('phone', function()  
    TriggerEvent('alan-phone:openPhone') 
end)

CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = 'UpdateTime',
                InGameTime = CalculateTimeToDisplay(),
            })
        end

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if isLoggedIn then
            lib.callback('alan-phone:server:GetPhoneData', false, function(pData)
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
                    PhoneData.Contacts = pData.PlayerContacts
                end

                SendNUIMessage({
                    action = 'RefreshContacts',
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

function LoadPhone()
    Wait(100)
    isLoggedIn = true
    lib.callback('alan-phone:server:GetPhoneData', false, function(pData)
        PlayerJob = ESX.PlayerData.job
        PhoneData.PlayerData = ESX.PlayerData
        PhoneData.MetaData = {}
        PhoneData.Twitter = {}
        PhoneData.PlayerData.charinfo = pData.charinfo ~= nil and pData.charinfo or {}
        PhoneData.PlayerData.identifier = pData.charinfo ~= nil and pData.charinfo.identifier or ''

        if PhoneData.PlayerData.charinfo.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneData.PlayerData.charinfo.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then
            PhoneData.MentionedTweets = pData.MentionedTweets
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.Images ~= nil and next(pData.Images) ~= nil then
            PhoneData.Images = pData.Images
        end

        SendNUIMessage({
            action = 'LoadPhoneData',
            PhoneData = PhoneData,
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications,
            --[[ PlayerId = GetPlayerServerId(PlayerId()) ]]
        })
    end)

    Wait(2000)
end

RegisterNUICallback('HasPhone', function(data, cb)
    local phone = exports.ox_inventory:Search('count', 'phone')

    if phone > 0 then
        cb(true)
    else
        cb(false)
    end
end)

function OpenPhone()
    local phone = exports.ox_inventory:Search('count', 'phone')

    if phone > 0 then
        lib.callback('alan-phone:server:GetCharacterData', false, function(chardata)
            PlayerJob = ESX.PlayerData.job
            PhoneData.PlayerData = ESX.PlayerData
            PhoneData.Twitter = {}
            PhoneData.PlayerData.charinfo = chardata ~= nil and chardata or {}
            PhoneData.PlayerData.identifier = chardata ~= nil and chardata.identifier or {}

            SetNuiFocus(true, true)
            --SetNuiFocusKeepInput(true)
            SendNUIMessage({
                action = 'open',
                Tweets = PhoneData.Tweets,
                AppData = Config.PhoneApplications,
                applications = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerJob = PhoneData.PlayerData.job,
                PlayerData = PhoneData.PlayerData,
            })

            PhoneData.isOpen = true

            CreateThread(function()
                while PhoneData.isOpen do
                    DisableSemua()
                    Wait(1)
                end
            end)

            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end

            SetTimeout(250, function()
                newPhoneProp()
            end)

            -- Garage Fix
            lib.callback('alan-phone:server:GetGarageVehicles', false, function(vehicles)
                if vehicles ~= nil then
                    for k,v in pairs(vehicles) do
                        vehicles[k].fullname = GetLabelText(GetDisplayNameFromVehicleModel(v.model))
                    end
                    PhoneData.GarageVehicles = vehicles
                end
            end)

            lib.callback('alan-phone:server:getBackground', false, function(backp)
                if backp ~= nil then
                    for k, v in pairs(backp) do
                        SendNUIMessage({action = 'ReloadBackground', background = v.background})
                    end
                end
            end)

            lib.callback('alan-phone:server:getAvatar', false, function(avtr)
                if avtr ~= nil then
                    for k, v in pairs(avtr) do
                        SendNUIMessage({action = 'ReloadAvatar', profilepicture = v.profilepicture})
                    end
                end
            end)
        end)
    else
        exports['alan-tasknotify']:SendAlert('error', 'Anda Tidak Memiliki HP!')
    end
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId
    TriggerServerEvent('alan-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('alan-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = 'UpdateMails',
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    if data.buttonEvent ~= nil or  data.buttonData ~= nil then
        TriggerEvent(data.buttonEvent, data.buttonData)
    end
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('alan-phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('alan-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number

    lib.callback('alan-phone:server:GetPicture', false, function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNetEvent("alan-phone:client:BankNotify", function(text)
    SendNUIMessage({
        action = "PhoneNotification",
        NotifyData = {
            title = "Bank",
            content = text,
            icon = "fas fa-university",
            timeout = 3500,
            color = "#ff002f",
        },
    })
end)

RegisterNUICallback('GetBankData', function(data, cb)
    lib.callback('alan-phone:server:GetBankData', false, function(data)
        local bankData = {bank = data[1], iban = data[2]}

        cb(bankData)
    end)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType
    local Ped = PlayerPedId()
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)

    if PhoneData.Chats[NumberKey] ~= nil then
        if(PhoneData.Chats[NumberKey].messages == nil) then
            PhoneData.Chats[NumberKey].messages = {}
        end
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                }
            elseif ChatType == "location" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Shared Location",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                }
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('alan-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            PhoneData.Chats[NumberKey].messages[#PhoneData.Chats[NumberKey].messages+1] = {
                date = ChatDate,
                messages = {},
            }
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                }
            elseif ChatType == "location" then
                PhoneData.Chats[NumberKey].messages[ChatDate].messages[#PhoneData.Chats[NumberKey].messages[ChatDate].messages+1] = {
                    message = "Shared Location",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                }
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('alan-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        PhoneData.Chats[#PhoneData.Chats+1] = {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        }
        NumberKey = GetKeyByNumber(ChatNumber)
        PhoneData.Chats[NumberKey].messages[#PhoneData.Chats[NumberKey].messages+1] = {
            date = ChatDate,
            messages = {},
        }
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {},
            }
        elseif ChatType == "location" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = "Shared Location",
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            }
        elseif ChatType == "picture" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = "Photo",
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {
                    url = data.url
                },
            }
        end
        TriggerServerEvent('alan-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end

    lib.callback('alan-phone:server:GetContactPicture', false, function(Chat)
        SendNUIMessage({
            action = 'UpdateChat',
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
    cb("ok")
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = 'PhoneNotification',
        PhoneNotify = {
            title = "Whatsapp",
            text = "Location has been set!",
            icon = 'fab fa-whatsapp',
            color = '#25D366',
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('alan-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local NumberKey = GetKeyByNumber(SenderNumber)

    if New then
        PhoneData.Chats[#PhoneData.Chats+1] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = {},
        }

        NumberKey = GetKeyByNumber(SenderNumber)

        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Messaged yourself",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            lib.callback('alan-phone:server:GetContactPictures', false, function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
	    SendNUIMessage({
	        action = "PhoneNotification",
	        PhoneNotify = {
		    title = "Whatsapp",
		    text = "New message from "..IsNumberInContacts(SenderNumber).."!",
		    icon = "fab fa-whatsapp",
		    color = "#25D366",
		    timeout = 3500,
	        },
	    })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('alan-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Messaged yourself",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            lib.callback('alan-phone:server:GetContactPictures', false, function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Whatsapp",
                    text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    color = "#25D366",
                    timeout = 3500,
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('alan-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)

RegisterNetEvent('alan-phone:client:BankNotify', function(text)
    print('wow')
    SendNUIMessage({
        action = 'Notification',
        NotifyData = {
            title = "Bank",
            content = text,
            icon = 'fas fa-university',
            timeout = 3500,
            color = '#ff002f',
        },
    })
end)

CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = 'updateTweets',
                tweets = PhoneData.Tweets
            })
        end

        Wait(2000)
    end
end)

RegisterNetEvent('alan-phone:client:NewMailNotify', function(MailData)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Mail",
            text = "You received a new mail from "..MailData.sender,
            icon = "fas fa-envelope",
            color = "#ff002f",
            timeout = 1500,
        },
    })
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'mail')
end)

RegisterNUICallback('PostAdvert', function(data, cb)
    TriggerServerEvent('alan-phone:server:AddAdvert', data.message, data.url)
    cb('ok')
end)

RegisterNUICallback("DeleteAdvert", function(_, cb)
    TriggerServerEvent("alan-phone:server:DeleteAdvert")
    cb('ok')
end)

RegisterNetEvent('alan-phone:client:UpdateAdvertsDel', function(Adverts)
    PhoneData.Adverts = Adverts
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNetEvent('alan-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Advertisement",
            text = "A new ad has been posted by "..LastAd,
            icon = "fas fa-ad",
            color = "#ff8f1a",
            timeout = 2500,
        },
    })
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function(_, cb)
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
    cb('ok')
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'whatsapp', newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = 'RefreshWhatsappAlerts',
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = 'RefreshAppAlerts', AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    lib.callback('alan-phone:server:CanPayInvoice', false, function(CanPay)
        if CanPay then
            PayInvoice(cb,invoiceId)
        else
            cb(false)
        end
    end, amount)
end)

function PayInvoice(cb,invoiceId)
    cb(true)
    ESX.TriggerServerCallback('esx_billing:payBill', function()
        lib.callback('alan-phone:server:GetInvoices', false, function(Invoices)
            PhoneData.Invoices = Invoices
        end)
    end, invoiceId)
end

--[[
RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    ESX.TriggerServerCallback('alan-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)
]]

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('alan-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

RegisterNetEvent('alan-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = 'UpdateHashtags',
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

local function getIndex(tab, val)
    local index = nil
    for i, v in ipairs (tab) do
        if (v.id == val) then
          index = i
        end
    end
    return index
end

RegisterNUICallback('isInHomePage', function(data, cb)

end)

RegisterNUICallback('DeleteTweet',function(data, cb)
    TriggerServerEvent('alan-phone:server:DeleteTweet', data.id)
    cb('ok')
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)

end)

RegisterNUICallback('GetSelfTweets', function(data, cb)
    cb(PhoneData.SelfTweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture
    TriggerServerEvent('alan-phone:server:SaveMetaData', 'profilepicture', pf)
end)

RegisterNetEvent('alan-phone:updateForEveryone', function(newTweet)
    PhoneData.Tweets = newTweet
end)

RegisterNetEvent('alan-phone:updateidForEveryone', function()
    PhoneData.id  = PhoneData.id + 1
end)

RegisterNUICallback('SignoutTwitter', function(data, cb)
    PhoneData.Twitter = {}
    SendNUIMessage({
        action = 'PhoneNotification',
        PhoneNotify = {
            title = "Twitter",
            text = "Berhasil logged out",
            icon = "fab fa-twitter",
            color = "#1DA1F2",
            timeout = 1000,
        },
    })
    cb(true)
end)

RegisterNUICallback('LoginTwitter', function(data, cb)
    lib.callback('alan-phone:twitterLogin', false, function(success)
        if success then
            PhoneData.Twitter.username = data.username    
            SendNUIMessage({
                action = 'PhoneNotification',
                PhoneNotify = {
                    title = "Twitter",
                    text = "Berhasil log in",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        else
            SendNUIMessage({
                action = 'PhoneNotification',
                PhoneNotify = {
                    title = "Twitter",
                    text = "Username or password salah",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
        cb(success)
    end, data.username, data.password)
end)

RegisterNUICallback('RegisterTwitter', function(data, cb)
    if(not data.username or not data.password or data.username == "" or data.password == "") then
        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = "Twitter",
                text = "Username and password tidak boleh kosong!",
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
    lib.callback('alan-phone:twitterRegister', false, function(success)
        if success then
            SendNUIMessage({
                action = 'PhoneNotification',
                PhoneNotify = {
                    title = "Twitter",
                    text = "Berhasil Membuat Akun",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        else
            SendNUIMessage({
                action = 'PhoneNotification',
                PhoneNotify = {
                    title = "Twitter",
                    text = "Registrasi Akun Gagal",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
        cb(success)
    end, data.username, data.password)
end)

RegisterNUICallback('PostNewTweet', function(data, cb)
    if not PhoneData.Twitter.username then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Twitter",
                text = "Log in dulu!",
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1500,
            },
        })
        return
    end

    local TweetMessage = {
        username = PhoneData.Twitter.username,
        identifier = ESX.PlayerData.identifier,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture,
        url = data.url
    }

    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    if #Hashtag <= 3 then
        for i = 2, #Hashtag, 1 do
            local Handle = Hashtag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local InvalidSymbol = string.match(Handle, patt)
                if InvalidSymbol then
                    Handle = Handle:gsub("%"..InvalidSymbol, "")
                end
                TriggerServerEvent('alan-phone:server:UpdateHashtags', Handle, TweetMessage)
            end
        end

        for i = 2, #MentionTag, 1 do
            local Handle = MentionTag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                if Handle ~= PhoneData.Twitter.username then
                    TriggerServerEvent('alan-phone:server:MentionedPlayer', Handle, TweetMessage)
                end
            end
        end

        PhoneData.Tweets[#PhoneData.Tweets+1] = TweetMessage
        Wait(100)
        cb(PhoneData.Tweets)

        TriggerServerEvent('alan-phone:server:UpdateTweets', PhoneData.Tweets, TweetMessage)
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Twitter",
                text = "Invalid Tweet",
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback("TakePhoto", function(_,cb)
    SetNuiFocus(false, false)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    local takePhoto = true
    while takePhoto do
        if IsControlJustPressed(1, 348) or IsControlJustPressed(1, 27) then -- Toogle Mode
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then -- CANCEL
            DestroyMobilePhone()
            CellCamActivate(false, false)
            cb(json.encode({ url = nil }))
            break
        elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
            lib.callback("alan-phone:server:GetWebhook", false, function(hook)
                if hook then
                    exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function(data)
                        local image = json.decode(data)
                        DestroyMobilePhone()
                        CellCamActivate(false, false)
                        TriggerServerEvent('alan-phone:server:addImageToGallery', image.attachments[1].proxy_url)
                        Wait(400)
                        TriggerServerEvent('alan-phone:server:getImageFromGallery')
                        cb(json.encode(image.attachments[1].proxy_url))
                    end)
                else
                    return
                end
            end)

            takePhoto = false
        end

        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        EnableAllControlActions(0)
        Wait(0)
    end

    Wait(1000)
    OpenPhone()
end)

RegisterNetEvent('alan-phone:client:TransferMoney', function(amount, newmoney)
    if PhoneData.isOpen then
        SendNUIMessage({ action = 'UpdateBank', NewBalance = newmoney })
    end
end)

RegisterNetEvent('alan-phone:client:UpdateTweets', function(src, Tweets, NewTweetData, delete)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source
    if not delete then
        if src ~= MyPlayerId then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "New Tweet (@"..NewTweetData.username..")",
                    text = NewTweetData.message:gsub("[%<>\"()\'$]",""),
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 2000,
                },
            })
            SendNUIMessage({
                action = "UpdateTweets",
                Tweets = PhoneData.Tweets
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Twitter",
                    text = "The Tweet has been posted!",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
    else -- Deleting a tweet
        if src == MyPlayerId then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Twitter",
                    text = "The Tweet has been deleted!",
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                    timeout = 1000,
                },
            })
        end
        SendNUIMessage({
            action = "UpdateTweets",
            Tweets = PhoneData.Tweets
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('alan-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "You have been mentioned in a Tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    TweetMessage = {username = TweetMessage.username, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture}
    PhoneData.MentionedTweets[#PhoneData.MentionedTweets+1] = TweetMessage
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNetEvent('alan-phone:refreshImages', function(images)
    PhoneData.Images = images
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications['twitter'].Alerts = 0
    SendNUIMessage({
        action = 'RefreshAppAlerts',
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'twitter', 0)
    SendNUIMessage({ action = 'RefreshAppAlerts', AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = 'RefreshAppAlerts',
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('alan-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = 'RefreshAppAlerts', AppData = Config.PhoneApplications })
    end)
end)

RegisterNetEvent("alan-phone:client:CustomNotification", function(title, text, icon, color, timeout) -- Send a PhoneNotification to the phone from anywhere
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = title,
            text = text,
            icon = icon,
            color = color,
            timeout = timeout,
        },
    })
end)

RegisterNUICallback('TransferMoney', function(data, callback)
    local cb = callback
    local amount = tonumber(data.amount)

    lib.callback('alan-phone:server:GetBankData', false, function(data)
        local bank = data[1]
        local iban = data[2]

        if tonumber(bank) >= amount then
            local amaountata = tonumber(bank) - amount
            TriggerServerEvent('alan-phone:server:TransferMoney', data.iban, amount)
            local cbdata = {
                CanTransfer = true,
                NewAmount = amaountata
            }
            cb(cbdata)
        else
            local cbdata = {
                CanTransfer = false,
                NewAmount = nil,
            }
            cb(cbdata)
        end
    end)
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    lib.callback('alan-phone:server:GetContactPictures', false, function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    lib.callback('alan-phone:server:GetCallState', false, function(CallState)
        local CanCall = CallState[1]
        local IsOnline = CallState[2]
        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

function CancelCall()
    TriggerServerEvent('alan-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == 'ongoing' then
        exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
    end
    
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('alan-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = 'Notification',
            PhoneNotify = {
                title = "Phone",
                text = "The call has been ended",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = "Phone",
                text = "The call has been ended",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = 'SetupHomeCall',
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = 'CancelOutgoingCall',
        })
    end
end

function CallContact(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = 'outgoing'
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    print(AnonymousCall)

    TriggerServerEvent('alan-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('alan-phone:server:SetCallState', true)

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    --TriggerServerEvent('InteractSound_SV:PlayOnSource', 'demo', 0.1)
                else
                    break
                end
                Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

function AnswerCall()
    if (PhoneData.CallData.CallType == 'incoming' or PhoneData.CallData.CallType == 'outgoing') and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = 'ongoing'
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = 'AnswerCall', CallData = PhoneData.CallData})
        SendNUIMessage({ action = 'SetupHomeCall', CallData = PhoneData.CallData})

        TriggerServerEvent('alan-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = 'UpdateCallTime',
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Wait(1000)
            end
        end)

        TriggerServerEvent('alan-phone:server:AnswerCall', PhoneData.CallData)
        exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = "Phone",
                text = "You don't have a incoming call...",
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end

RegisterNetEvent('alan-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == 'ongoing' then
        SendNUIMessage({
            action = 'CancelOngoingCall'
        })
        exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)

    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('alan-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = 'Notification',
            NotifyData = {
                title = "Phone",
                content = "The call has been ended",
                icon = 'fas fa-phone-volume',
                timeout = 3500,
                color = '#e84118',
            },
        })
    else
        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = "Phone",
                text = "The call has been ended",
                icon = 'fas fa-phone-volume',
                color = '#e84118',
            },
        })

        SendNUIMessage({
            action = 'SetupHomeCall',
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = 'CancelOutgoingCall',
        })
    end
end)

RegisterNetEvent('alan-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }

    print(AnonymousCall)

    if AnonymousCall then
        CallData.name = 'Anoniem'
    end

    PhoneData.CallData.CallType = 'incoming'
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('alan-phone:server:SetCallState', true)

    SendNUIMessage({
        action = 'SetupHomeCall',
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'ringing', 0.2)

                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = 'IncomingCallAlert',
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = 'IncomingCallAlert',
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('alan-phone:server:AddRecentCall', 'missed', CallData)
                    break
                end
                Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = 'IncomingCallAlert',
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('alan-phone:server:AddRecentCall', 'missed', CallData)
                break
            end
        else
            TriggerServerEvent('alan-phone:server:AddRecentCall', 'missed', CallData)
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

RegisterNetEvent('alan-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == 'incoming' or PhoneData.CallData.CallType == 'outgoing') and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = 'ongoing'
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = 'AnswerCall', CallData = PhoneData.CallData})
        SendNUIMessage({ action = 'SetupHomeCall', CallData = PhoneData.CallData})

        TriggerServerEvent('alan-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = 'UpdateCallTime',
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Wait(1000)
            end
        end)
        exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = 'PhoneNotification',
            PhoneNotify = {
                title = "Phone",
                text = "You don't have a incoming call...",
                icon = 'fas fa-phone-volume',
                color = '#e84118',
            },
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
     if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
     end
end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    lib.callback('alan-phone:server:FetchResult', false, function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    lib.callback('alan-phone:server:GetVehicleSearchResults', false, function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                result[k].isFlagged = false
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = ESX.Game.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)

    lib.callback('alan-phone:server:ScanPlate', false, function(result)
        result.isFlagged = false
        result.label = model
        cb(result)
    end, plate)
end)

RegisterNetEvent('alan-phone:client:addPoliceAlert')
AddEventHandler('alan-phone:client:addPoliceAlert', function(alertData, tujuan)
    if PlayerJob.name == tujuan then

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Layanan",
                text = "Pesan Baru!",
                icon = "fa fa-bell",
                color = "#00acff",
                timeout = 1500,
            },
        })

        Config.PhoneApplications["meos"].Alerts = Config.PhoneApplications["meos"].Alerts + 1
        TriggerServerEvent('alan-phone:server:SetPhoneAlerts', "meos", Config.PhoneApplications["meos"].Alerts)

        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })

        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords
    exports['alan-tasknotify']:SendAlert('inform', 'GPS Set: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

RegisterNetEvent('alan-phone:client:GiveContactDetails', function()
    local ped = PlayerPedId()

    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('alan-phone:server:GiveContactDetails', PlayerId)
    else
        exports['alan-tasknotify']:SendAlert('error', 'Tidak Ada Orang Di Sekitar')
    end
end)

RegisterNUICallback('GetGalleryData', function(_, cb)
    local data = PhoneData.Images
    cb(data)
end)

RegisterNUICallback('DeleteImage', function(image, cb)
    TriggerServerEvent('alan-phone:server:RemoveImageFromGallery',image)
    Wait(400)
    TriggerServerEvent('alan-phone:server:getImageFromGallery')
    cb(true)
end)

RegisterNUICallback('track-vehicle', function(data, cb)
    local veh = data.veh
    if findVehFromPlateAndLocate(veh.plate) then
        exports['alan-tasknotify']:SendAlert('success', 'Tracking Berhasil')
    else
        exports['alan-tasknotify']:SendAlert('error', 'Gagal Ditemukan')
    end
    cb("ok")
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Phone",
                    text = "You deleted contact!",
                    icon = "fa fa-phone-alt",
                    color = "#04b543",
                    timeout = 1500,
                },
            })
            break
        end
    end
    Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('alan-phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('alan-phone:client:AddNewSuggestion', function(SuggestionData)
    PhoneData.SuggestedContacts[#PhoneData.SuggestedContacts+1] = SuggestionData
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Phone",
            text = "You have a new suggested contact!",
            icon = "fa fa-phone-alt",
            color = "#04b543",
            timeout = 1500,
        },
    })

    Config.PhoneApplications['phone'].Alerts = Config.PhoneApplications['phone'].Alerts + 1
    TriggerServerEvent('alan-phone:server:SetPhoneAlerts', 'phone', Config.PhoneApplications['phone'].Alerts)
end)

RegisterNetEvent('alan-phone:client:RemoveBankMoney', function(amount)
    if amount > 0 then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Bank",
                text = "$"..amount.." has been removed from your balance!",
                icon = "fas fa-university",
                color = "#ff002f",
                timeout = 3500,
            },
        })
    end
end)

RegisterNetEvent('alan-phone:client:NotiftfRWT', function()
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Bank",
            text = "Hpmu Kentang, tidak ada akses transfer",
            icon = "fas fa-university",
            color = "#ff002f",
            timeout = 5000,
        },
    })
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('laprace:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('laprace:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('laprace:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('alan-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = 'UpdateRacingApp',
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('laprace:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['laprace']:IsInRace()
    print(InRace)
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:IsAuthorizedToCreateRaces', function(NameAvailable)
        local data = {
            IsAuthorized = true,
            IsBusy = exports['laprace']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('laprace:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:GetRacingData', function(RaceData)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)
        print(dist)
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('laprace:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            exports['alan-tasknotify']:SendAlert('success', 'You are too far from the race. Your navigation is set to the race.')
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('GetPesanJobs', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local time = GetClockHours() .. ':' .. GetClockMinutes()

    local input = lib.inputDialog('PESAN YANG INGIN DISAMPAIKAN', {'PESAN: '})

    if input then
        local pesan = input[1]
        TriggerServerEvent('alan-phone:addsms', coords, pesan, data.ContactData.number, time)
    end
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == 'editor' then
        cb(exports['laprace']:IsInEditor())
    else
        cb(exports['laprace']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    ESX.TriggerServerCallback('laprace:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

--[[
RegisterNUICallback('GetPlayerHouses', function(_, cb)
    ESX.TriggerServerCallback('alan-phone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)
]]

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
    exports['alan-tasknotify']:SendAlert('success', 'Set GPS: ' .. data.HouseData.HouseData.adress)
    cb("ok")
end)

--[[
RegisterNUICallback('GetPlayerKeys', function(_, cb)
    ESX.TriggerServerCallback('alan-phone:server:GetHouseKeys', function(Keys)
        cb(Keys)
    end)
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn
    ESX.TriggerServerCallback('alan-phone:server:TransferCid', function(CanTransfer)
        cb(CanTransfer)
    end, TransferedCid, data.HouseData)
end)
]]

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('house:server:removeHouseKey', data.HouseData.name, {
        identifier = data.HolderData.identifier,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

--[[
RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    ESX.TriggerServerCallback('alan-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)
]]

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = PlayerPedId()

    SetNewWaypoint(data.coords.x, data.coords.y)
    exports['alan-tasknotify']:SendAlert('success', 'Set GPS')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    exports['alan-tasknotify']:SendAlert('success', 'Set GPS')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    lib.callback('alan-phone:server:GetCurrentLawyers', false, function(lawyers)
        cb(lawyers)
    end)
end)

--[[
RegisterCommand('testem', function()
    TriggerServerEvent('alan-phone:server:sendNewMail', { sender = 'B4RKSY.GG', subject = 'Test!', message = 'https://discord.gg/dailyliferoleplay'})
end)
]]

RegisterCommand('fixphone', function()
    LoadPhone()
    exports['alan-tasknotify']:SendAlert('success', 'Phone fixed')
end)