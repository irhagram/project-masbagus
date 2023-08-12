local Adverts, GeneratedPlates, MIPhone, Tweets, AppAlerts, MentionedTweets, Hashtags, Calls, TWData = {},{},{},{},{},{},{},{},{}
local WebHook = "https://discord.com/api/webhooks/1004124975919267930/BLwtil6AIehb5d8rW2zvo6eYwMpHf8s1pmcuqaQnwiXXldb4FrLesXwuZb3NnN65_BpD"
local BolehTF = {
    "steam:11000013f5fbf6a",
    "steam:110000106a54d8e",
    "steam:1100001081ccd49",
    "steam:110000134f18d0f",
    "steam:11000013ff9e129",
    "steam:110000110b0a540",
    "steam:110000112cd089b",
    "steam:110000135c18c46",
    "steam:1100001461d550d",
    --DONASI
    "steam:11000010fe001dc", --NANDA RIFALDO
    "steam:11000010a2527a1", -- hans ahmad
    "steam:110000114cbfe94", --RIFKII
    "steam:110000143b9355c", --2BAD
    "steam:110000156b26912", --JEFRI
    "steam:110000114c5e57c", --MIKE
    "steam:110000143b9355c",
    "steam:11000014a78725a", --DEVIL
}

AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    local sourcePlayer = playerId
    local identifier = xPlayer.getIdentifier()
    getOrGeneratePhoneNumber(identifier, function(myPhoneNumber) end)
    --getOrGenerateIBAN(identifier, function(iban) end)
end)

-- Number and IBAN Generate Stuff 
function getPhoneRandomNumber()
    local numBase0 = 0
    local numBase1 = 8
    local numBase2 = math.random(11111111, 99999999)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. "")
    return num
end

function generateIBAN()
    local numBase0 = math.random(10000, 99999)
    local num = string.format(numBase0)
	return num
end

function getNumberPhone(identifier)
    local result = MySQL.query.await("SELECT users.phone FROM users WHERE users.identifier = ?", { identifier  })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end

function getIBAN(identifier)
    local result = MySQL.query.await("SELECT users.iban FROM users WHERE users.identifier = ?", { identifier})
    if result[1] ~= nil then
        return result[1].iban
    end
    return nil
end

function getOrGenerateIBAN(identifier, cb)
    local identifier = identifier
    local myIBAN = getIBAN(identifier)
    if myIBAN == '0' or myIBAN == nil then
        repeat
            myIBAN = generateIBAN()
            local id = getPlayerFromIBAN(myIBAN)

        until id == nil

        MySQL.update("UPDATE users SET iban = ? WHERE identifier = ?", {  myIBAN, identifier }, function()
            cb(myIBAN)
        end)
    else
        cb(myIBAN)
    end
end

function getOrGeneratePhoneNumber(identifier, cb)
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)

    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = GetPlayerFromPhone(myPhoneNumber)

        until id == nil

        MySQL.update("UPDATE users SET phone = ? WHERE identifier = ?", {  myPhoneNumber, identifier }, function()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end

-- Twitter --
RegisterNetEvent('alan-phone:server:DeleteTweet', function(tweetId)
    local Player = ESX.GetPlayerFromId(source)
    local delete = false
    local TID = tweetId
    local Data = MySQL.scalar.await('SELECT identifier FROM phone_tweets WHERE tweetId = ?', {TID})
    if Data == Player.identifier then
        MySQL.query.await('DELETE FROM phone_tweets WHERE tweetId = ?', {TID})
        delete = true
    end

    if delete then
        for k, _ in pairs(TWData) do
            if TWData[k].tweetId == TID then
                TWData = nil
            end
        end
        TriggerClientEvent('alan-phone:client:UpdateTweets', -1, TWData, nil, true)
    end
end)

RegisterNetEvent('alan-phone:server:UpdateTweets', function(NewTweets, TweetData)
    local src = source
    MySQL.insert('INSERT INTO phone_tweets (identifier, username, message, date, url, picture, tweetid) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        TweetData.identifier,
        TweetData.username,
        TweetData.message,
        TweetData.time,
        TweetData.url:gsub("[%<>\"()\' $]",""),
        TweetData.picture:gsub("[%<>\"()\' $]",""),
        TweetData.tweetId
    })

    TriggerClientEvent('alan-phone:client:UpdateTweets', -1, src, NewTweets, TweetData, false)
end)

RegisterNetEvent('alan-phone:server:MentionedPlayer', function(username, TweetMessage)
    local xPlayers = ESX.GetExtendedPlayers()
	for _, Player in pairs(xPlayers) do
        local character = MySQL.query.await('SELECT * FROM twitter_accounts WHERE identifier=?',{Player.identifier})

        if Player ~= nil then
            if (character[1] and character[1].username == username) then
                MIPhone.SetPhoneAlerts(Player.identifier, "twitter")
                MIPhone.AddMentionedTweet(Player.identifier, TweetMessage)
                TriggerClientEvent('alan-phone:client:GetMentioned', Player.source, TweetMessage, AppAlerts[Player.identifier]["twitter"])
            else
                local query1 = '%' .. username .. '%'
                local result = MySQL.query.await('SELECT * FROM twitter_accounts WHERE username LIKE ?', {query1})
                if result[1] ~= nil then
                    local MentionedTarget = result[1].identifier
                    MIPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                    MIPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                end
            end
        end
    end
end)

RegisterNetEvent('alan-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    end
    TriggerClientEvent('alan-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

lib.callback.register('alan-phone:twitterLogin', function(source, username, password)
    local result = MySQL.query.await('SELECT * FROM twitter_accounts WHERE username=? AND password=?',{username, password})
    if result[1] then
        return true
    else
        return false
    end
end)

lib.callback.register('alan-phone:twitterRegister', function(source, username, password)
    local Player = ESX.GetPlayerFromId(source)
    local account = MySQL.query.await('SELECT * FROM twitter_accounts WHERE username=?', {username})
    if account[1] then
        return false
    else
        local result = MySQL.insert.await('INSERT INTO twitter_accounts(username, password, identifier) VALUES (?,?,?)',{username, password, Player.identifier})
        return result
    end
end)
--

RegisterNetEvent('alan-phone:server:AddAdvert', function(msg, url)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local Identifier = Player.identifier
	local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', { Player.identifier })
    if result[1] then
        if Adverts[Identifier] ~= nil then
            Adverts[Identifier].message = msg
            Adverts[Identifier].name = "@" .. result[1].firstname .. "" .. result[1].lastname
            Adverts[Identifier].number = result[1].phone
            Adverts[Identifier].url = url
        else
            Adverts[Identifier] = {
                message = msg,
                name = "@" .. result[1].firstname .. "_" .. result[1].lastname,
                number = result[1].phone,
                url = url
            }
        end
    end

    TriggerClientEvent('alan-phone:client:UpdateAdverts', -1, Adverts, "@" .. result[1].firstname .. "" .. result[1].lastname)
end)

RegisterNetEvent('alan-phone:server:DeleteAdvert', function()
    local Player = ESX.GetPlayerFromId(source)
    local Identifier = Player.identifier
    Adverts[Identifier] = nil
    
    TriggerClientEvent('alan-phone:client:UpdateAdvertsDel', -1, Adverts)
end)

function GetOnlineStatus(number)
    local Target = GetPlayerFromPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

RegisterNetEvent('alan-phone:server:updateForEveryone', function(newTweet)
    local src = source
    TriggerClientEvent('alan-phone:updateForEveryone', -1, newTweet)
end)

RegisterNetEvent('alan-phone:server:updateidForEveryone', function()
    TriggerClientEvent('alan-phone:updateidForEveryone', -1)
end)

lib.callback.register('alan-phone:server:GetPhoneData', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            SelfTweets = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            Tweets = {},
            Images = {}
        }
        
        PhoneData.Adverts = Adverts

        local result = MySQL.query.await('SELECT * FROM player_contacts WHERE identifier = ? ORDER BY name ASC', {Player.identifier})
        if result[1] ~= nil then
            for _, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end

            PhoneData.PlayerContacts = result
        end

        local messages = MySQL.query.await('SELECT * FROM phone_messages WHERE identifier = ?', { Player.identifier })
        if messages ~= nil and next(messages) ~= nil then
            PhoneData.Chats = messages
        end

        if AppAlerts[Player.identifier] ~= nil then 
            PhoneData.Applications = AppAlerts[Player.identifier]
        end
    
        if MentionedTweets[Player.identifier] ~= nil then 
            PhoneData.MentionedTweets = MentionedTweets[Player.identifier]
        end
    
        if Hashtags ~= nil and next(Hashtags) ~= nil then
            PhoneData.Hashtags = Hashtags
        end

        local Tweets = MySQL.query.await('SELECT * FROM phone_tweets WHERE `date` > NOW() - INTERVAL ? hour', {Config.TweetDuration})

        if Tweets ~= nil and next(Tweets) ~= nil then
            PhoneData.Tweets = Tweets
            TWData = Tweets
        end

        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` ASC', { Player.identifier })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end

            PhoneData.Mails = mails
        end

        local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE identifier = ? ORDER BY `date` DESC',{Player.identifier})
        if images ~= nil and next(images) ~= nil then
            PhoneData.Images = images
        end

        local garageresult = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ?', {Player.identifier})
        if garageresult[1] ~= nil then
            PhoneData.Garage = garageresult
        end

        return PhoneData
    end
end)

lib.callback.register('alan-phone:server:GetCallState', function(source, ContactData)
    local Target = GetPlayerFromPhone(ContactData.number)

    if Target ~= nil then
        if Calls[Target.identifier] ~= nil then
            if Calls[Target.identifier].inCall then
                return {false, true}
            else
                return {true, true}
            end
        else
            return {true, true}
        end
    else
        return {false, false}
    end
end)

RegisterNetEvent('alan-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)

    if Calls[Ply.identifier] ~= nil then
        Calls[Ply.identifier].inCall = bool
    else
        Calls[Ply.identifier] = {}
        Calls[Ply.identifier].inCall = bool
    end
end)

RegisterNetEvent('alan-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    MySQL.query('DELETE FROM player_mails WHERE mailid = ? AND identifier = ?', { MailId, Player.identifier })
    SetTimeout(100, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` ASC', { Player.identifier })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('alan-phone:client:UpdateMails', src, mails)
    end)
end)


function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterNetEvent('alan-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', { Player.identifier, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0 })
    else
        MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', { Player.identifier, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button) })
    end
    TriggerClientEvent('alan-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` DESC', { Player.identifier })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('alan-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('alan-phone:server:sendNewMailToOffline', function(license, mailData)
    local Player = ESX.GetPlayerFromIdentifier(license)
    if Player then
        local src = Player.source
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {Player.identifier, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
            TriggerClientEvent('alan-phone:client:NewMailNotify', src, mailData)
        else
            MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.identifier, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
            TriggerClientEvent('alan-phone:client:NewMailNotify', src, mailData)
        end
        SetTimeout(200, function()
            local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` ASC', {Player.identifier})
            if mails[1] ~= nil then
                for k, _ in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('alan-phone:client:UpdateMails', src, mails)
        end)
    else
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {license, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
        else
            MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {license, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
        end
    end
end)

RegisterNetEvent('alan-phone:server:sendNewEventMail', function(license, mailData)
    local Player = ESX.GetPlayerFromIdentifier(license)
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {license, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
    else
        MySQL.insert('INSERT INTO player_mails (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {license, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
    end
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` ASC', {license})
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('alan-phone:client:UpdateMails', Player.PlayerData.source, mails)
    end)
end)

RegisterNetEvent('alan-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.update('UPDATE player_mails SET button = ? WHERE mailid = ? AND identifier = ?', {'', mailId, Player.identifier})
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE identifier = ? ORDER BY `date` ASC', {Player.identifier})
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        
        TriggerClientEvent('alan-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('alan-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    local Target = GetPlayerFromPhone(TargetData.number)
    local character = GetCharacter(src)

    if Target ~= nil then
        TriggerClientEvent('alan-phone:client:GetCalled', Target.source, character.phone, CallId, AnonymousCall)
    end
end)

lib.callback.register("alan-phone:server:GetWebhook",function(_)
	if WebHook ~= "" then
		return WebHook
	else
		print('Set your webhook to ensure that your camera will work!!!!!! Set this on line 10 of the server sided script!!!!!')
		return nil
	end
end)

lib.callback.register('alan-phone:server:GetBankData', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)
    local tabungan = xPlayer.getAccount('bank').money

    return {xPlayer.getAccount('bank').money, character.iban}
end)

lib.callback.register('alan-phone:server:CanPayInvoice', function(source, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    return (xPlayer.getAccount('bank').money >= amount)
end)

lib.callback.register('alan-phone:server:GetInvoices', function(source)
    local Player = ESX.GetPlayerFromId(source)
    local invoices = MySQL.query.await('SELECT * FROM billing  WHERE `identifier` = ?', {Player.identifier})
    if invoices[1] ~= nil then
        for k, v in pairs(invoices) do
            local Ply = ESX.GetPlayerFromIdentifier(v.sender)
            if Ply ~= nil then
                v.number = GetCharacter(Ply.source).phone
            else
                local res = MySQL.query.await('SELECT phone FROM `users` WHERE `identifier` = ?', {v.sender})
                if res[1] ~= nil then
                    v.number = res[1].phone
                else
                    v.number = nil
                end
            end
        end
        
        PhoneData.Invoices = invoices
        return invoices
    else
        return {}
    end
end)

MIPhone.AddMentionedTweet = function(identifier, TweetData)
    if MentionedTweets[identifier] == nil then 
        MentionedTweets[identifier] = {} 
    end

    MentionedTweets[identifier][#MentionedTweets[identifier]+1] = TweetData
end

MIPhone.SetPhoneAlerts = function(identifier, app, alerts)
    if identifier ~= nil and app ~= nil then
        if AppAlerts[identifier] == nil then
            AppAlerts[identifier] = {}
            if AppAlerts[identifier][app] == nil then
                if alerts == nil then
                    AppAlerts[identifier][app] = 1
                else
                    AppAlerts[identifier][app] = alerts
                end
            end
        else
            if AppAlerts[identifier][app] == nil then
                if alerts == nil then
                    AppAlerts[identifier][app] = 1
                else
                    AppAlerts[identifier][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[identifier][app] = AppAlerts[identifier][app] + 1
                else
                    AppAlerts[identifier][app] = AppAlerts[identifier][app] + 0
                end
            end
        end
    end
end

lib.callback.register('alan-phone:server:GetContactPictures', function(_, Chats)
    for _, v in pairs(Chats) do
        local query = '%' .. v.number .. '%'
        local result = MySQL.query.await('SELECT profilepicture FROM users WHERE phone LIKE ?', {query})
        if result[1] ~= nil then
            if result[1].profilepicture ~= nil then
                v.picture = result[1].profilepicture
            else
                v.picture = "default"
            end
        end
    end
    
    return Chats
end)

lib.callback.register('alan-phone:server:GetContactPicture', function(_, Chat)
    local query = '%' .. Chat.number .. '%'
    local result = MySQL.query.await('SELECT background FROM users WHERE phone LIKE ?', {query})
    if result[1] and result[1].background then
        Chat.picture = result[1].background
    else
        Chat.picture = "default"
    end

    return Chat
end)

lib.callback.register('alan-phone:server:getBackground', function(source)
    local Player = ESX.GetPlayerFromId(source)
	local result = MySQL.query.await('SELECT background FROM users WHERE identifier = ?',{ Player.identifier })
    local bground = {}
    if #result > 0 then
        for i=1, #result, 1 do
            bground[#bground+1] = {
                background = result[i].background
            }
        end
    end

    return bground
end)

lib.callback.register('alan-phone:server:getAvatar', function(source)
    local Player = ESX.GetPlayerFromId(source)
	local result = MySQL.query.await('SELECT profilepicture FROM users WHERE identifier = ?',{ Player.identifier })
    local avatarr = {}
    if result[1] ~= nil then
        for i=1, #result, 1 do
            avatarr[#avatarr+1] = {
                profilepicture = result[i].profilepicture
            }
        end
    end

    return avatarr
end)

lib.callback.register('alan-phone:server:GetPicture', function(_, number)
    local Picture = nil
    local query = '%' .. number .. '%'
    local result = MySQL.query.await('SELECT profilepicture FROM users WHERE phone LIKE ?', {query})
    if result[1] ~= nil then
        if result[1].profilepicture ~= nil then
            Picture = result[1].profilepicture
        else
            Picture = "default"
        end
    end

    return Picture
end)

RegisterNetEvent('alan-phone:server:savedocuments', function(data)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    if data.Type == "New" then
        MySQL.insert('INSERT INTO phone_note (identifier, title, text) VALUES (?, ?, ?)',{Ply.identifier, data.Title, data.Text})
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, {type='success', text ='Note Tersimpan'})

    elseif data.Type == "Update" then
        local ID = tonumber(data.ID)
        local Note = MySQL.query.await('SELECT * FROM phone_note WHERE id = ?', {ID})
        if Note[1] ~= nil then
            MySQL.update('DELETE FROM phone_note WHERE id = ?', {ID})
            MySQL.insert('INSERT INTO phone_note (identifier, title,  text) VALUES (?, ?, ?)',{Ply.identifier, data.Title, data.Text})
            TriggerClientEvent('alan-tasknotify:client:SendAlert', src, {type='success', text ='Note Updated'})
        end

    elseif data.Type == "Delete" then
        local ID = tonumber(data.ID)
        MySQL.update('DELETE FROM phone_note WHERE id = ?', {ID})
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, {type='success', text ='Note Dihapus'})
    end

    Wait(100)

    TriggerClientEvent('alan-phone:getdocuments', src)
end)

lib.callback.register('alan-phone:server:GetNote_for_Documents_app', function(source)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    local Note = MySQL.query.await('SELECT * FROM phone_note WHERE identifier = ? ORDER BY `date` ASC', {Ply.identifier})
    Wait(400)
    if Note[1] ~= nil then return Note else return nil end
end)

RegisterNetEvent('alan-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local Identifier = ESX.GetPlayerFromId(src).identifier
    MIPhone.SetPhoneAlerts(Identifier, app, alerts)
end)

RegisterNetEvent('alan-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = ESX.GetPlayerFromId(src)

    if IsBolehTF(src) or rwt == 0 then
        ExecuteSql(false, "SELECT * FROM `users` WHERE `iban`='"..iban.."'", function(result)
            if result[1] ~= nil then
                local recieverSteam = ESX.GetPlayerFromIdentifier(result[1].identifier)

                if recieverSteam ~= nil then
                    local PhoneItem = recieverSteam.getInventoryItem("phone").count and recieverSteam.getInventoryItem("phone").count > 0
                    recieverSteam.addAccountMoney('bank', amount)
                    sender.removeAccountMoney('bank', amount)

                    if PhoneItem ~= nil then
                        TriggerClientEvent('alan-phone:client:TransferMoney', recieverSteam.source, amount, recieverSteam.getAccount('bank').money)

                        ExecuteSql(false, "SELECT * FROM `users` WHERE `identifier`='"..ESX.GetPlayerFromId(src).identifier.."'", function(result)
                            TriggerClientEvent('alan-tasknotify:client:SendAlert', sender.source, {type='success', text ='Transfer Berhasil'})
                            TriggerClientEvent('alan-tasknotify:client:SendAlert', recieverSteam.source, {type='success', text ='Menerima Transfer '..amount..' Dari: '..result[1].iban})
                        end)
                    end
                else
                    ExecuteSql(false, "UPDATE `users` SET `bank` = '"..result[1].bank + amount.."' WHERE `identifier` = '"..result[1].identifier.."'")
                    sender.removeAccountMoney('bank', amount)
                end
            else
                TriggerClientEvent('alan-tasknotify:client:SendAlert', src, {type='error', text ='Rekening Tidak Terdaftar'})
            end
        end)
    else
        TriggerClientEvent('alan-phone:client:NotiftfRWT', src)
    end
end)

RegisterNetEvent('alan-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, _)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.update(
        'UPDATE player_contacts SET name = ?, number = ?, iban = ? WHERE identifier = ? AND name = ? AND number = ?',
        {newName, newNumber, newIban, Player.identifier, oldName, oldNumber})
end)

RegisterNetEvent('alan-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.update('DELETE FROM player_contacts WHERE name = ? AND number = ? AND identifier = ?',
        {Name, Number, Player.identifier})
end)

RegisterNetEvent('alan-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.insert('INSERT INTO player_contacts (identifier, name, number, iban) VALUES (?, ?, ?, ?)', {Player.identifier, tostring(name), tostring(number), tostring(iban)})
end)

RegisterNetEvent('alan-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = ESX.GetPlayerFromId(src)
    local SenderCharacter = GetCharacter(src)
    local query = '%' .. ChatNumber .. '%'
    local Player = MySQL.query.await('SELECT * FROM users WHERE phone LIKE ?', {query})

    if Player[1] ~= nil then
        local TargetData = ESX.GetPlayerFromIdentifier(Player[1].identifier)
        if TargetData ~= nil then
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE identifier = ? AND number = ?', {SenderData.identifier, ChatNumber})
            local TargetCharacter = GetCharacter(TargetData.source)
            if Chat[1] ~= nil then
                -- Update for target
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE identifier = ? AND number = ?', {json.encode(ChatMessages), TargetData.identifier, SenderCharacter.phone})
                -- Update for sender
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE identifier = ? AND number = ?', {json.encode(ChatMessages), SenderData.identifier, TargetCharacter.phone})
                -- Send notification & Update messages for target
                TriggerClientEvent('alan-phone:client:UpdateMessages', TargetData.source, ChatMessages, SenderCharacter.phone, false)
            else
                -- Insert for target
                MySQL.insert('INSERT INTO phone_messages (identifier, number, messages) VALUES (?, ?, ?)', {TargetData.identifier, SenderCharacter.phone, json.encode(ChatMessages)})
                -- Insert for sender
                MySQL.insert('INSERT INTO phone_messages (identifier, number, messages) VALUES (?, ?, ?)', {SenderData.identifier, TargetCharacter.phone, json.encode(ChatMessages)})
                -- Send notification & Update messages for target
                TriggerClientEvent('alan-phone:client:UpdateMessages', TargetData.source, ChatMessages, SenderCharacter.phone, true)
            end
        else
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE identifier = ? AND number = ?', {SenderData.identifier, ChatNumber})
            if Chat[1] ~= nil then
                -- Update for target
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE identifier = ? AND number = ?', {json.encode(ChatMessages), Player[1].identifier, SenderCharacter.phone})
                -- Update for sender
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE identifier = ? AND number = ?', {json.encode(ChatMessages), SenderData.identifier, Player[1].phone})
            else
                -- Insert for target
                MySQL.insert('INSERT INTO phone_messages (identifier, number, messages) VALUES (?, ?, ?)', {Player[1].identifier, SenderCharacter.phone, json.encode(ChatMessages)})
                -- Insert for sender
                MySQL.insert('INSERT INTO phone_messages (identifier, number, messages) VALUES (?, ?, ?)', {SenderData.identifier, Player[1].phone, json.encode(ChatMessages)})
            end
        end
    end
end)

RegisterNetEvent('alan-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('alan-phone:client:AddRecentCall', src, data, label, type)

    local Trgt = GetPlayerFromPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('alan-phone:client:AddRecentCall', Trgt.source, {
            name = character.firstname .. " " ..character.lastname,
            number = character.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterNetEvent('alan-phone:server:CancelCall', function(ContactData)
    local Ply = GetPlayerFromPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('alan-phone:client:CancelCall', Ply.source)
    end
end)

RegisterNetEvent('alan-phone:server:AnswerCall', function(CallData)
    local Ply = GetPlayerFromPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('alan-phone:client:AnswerCall', Ply.source)
    end
end)

RegisterNetEvent('alan-phone:server:SaveMetaData', function(column, data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if data and column then
        if type(data) == 'table' then
            ExecuteSql(false, "UPDATE `users` SET `" .. column .. "` = '".. json.encode(data) .."' WHERE `identifier` = '"..Player.identifier.."'")
        else
            ExecuteSql(false, "UPDATE `users` SET `" .. column .. "` = '".. data .."' WHERE `identifier` = '"..Player.identifier.."'")
        end
    end
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

lib.callback.register('alan-phone:server:FetchResult', function(source, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    local character = GetCharacter(src)
    local result = MySQL.query.await('SELECT * FROM `users` WHERE firstname LIKE ?', {'%'..search..'%'})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local driverlicense = false
            local weaponlicense = false
            local doingSomething = true

            if Config.UseESXLicense then
                CheckLicense(v.identifier, 'weapon', function(has)
                    if has then
                        weaponlicense = true
                    end

                    CheckLicense(v.identifier, 'drive', function(has)
                        if has then
                            driverlicense = true
                        end
                        
                        doingSomething = false
                    end)
                end)
            else
                doingSomething = false
            end


            while doingSomething do Wait(1) end
            
            table.insert(searchData, {
                identifier = v.identifier,
                firstname = character.firstname,
                lastname = character.lastname,
                birthdate = character.dateofbirth,
                phone = character.phone,
                gender = character.sex,
                weaponlicense = weaponlicense,
                driverlicense = driverlicense,
            })
        end
        
        return searchData
    else
        return nil
    end
end)

function CheckLicense(target, type, cb)
	local target = target
	if target then
		MySQL.query('SELECT COUNT(*) as count FROM player_licenses WHERE type = ? AND identifier = ?', {  type, target }, function(result)
			if tonumber(result[1].count) > 0 then cb(true) else cb(false) end
		end)
	else
		cb(false)
	end
end

lib.callback.register('alan-phone:server:GetVehicleSearchResults', function(source, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}

    local result = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `plate` LIKE ? OR `owner` = ?', {'%'..search..'%', search})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local player = MySQL.query.await('SELECT * FROM `users` WHERE `identifier` = ?', {result[k].identifier})
            if player[1] ~= nil then
                local vehicleInfo = { ['name'] = json.decode(result[k].vehicle).model }
                if vehicleInfo ~= nil then 
                    table.insert(searchData, {
                        plate = result[k].plate,
                        status = true,
                        owner = player[1].firstname .. " " .. player[1].lastname,
                        identifier = result[k].identifier,
                        label = vehicleInfo["name"]
                    })
                else
                    table.insert(searchData, {
                        plate = result[k].plate,
                        status = true,
                        owner = player[1].firstname .. " " .. player[1].lastname,
                        identifier = result[k].identifier,
                        label = "Name Not Found"
                    })
                end
            end
        end
    elseif GeneratedPlates[search] ~= nil then
        table.insert(searchData, {
            plate = GeneratedPlates[search].plate,
            status = GeneratedPlates[search].status,
            owner = GeneratedPlates[search].owner,
            identifier = GeneratedPlates[search].identifier,
            label = "Brand Unknown.."
        })
    else
        local ownerInfo = GenerateOwnerName()
        GeneratedPlates[search] = {
            plate = search,
            status = true,
            owner = ownerInfo.name,
            identifier = ownerInfo.identifier,
        }
        table.insert(searchData, {
            plate = search,
            status = true,
            owner = ownerInfo.name,
            identifier = ownerInfo.identifier,
            label = "Brand Unknown.."
        })
    end
    
    return searchData
end)

lib.callback.register('alan-phone:server:ScanPlate', function(source, plate)
    local src = source
    local vehicleData = {}

    if plate ~= nil then 
        local result = MySQL.query.await('SELECT identifier FROM `owned_vehicles` WHERE `plate` = ?', {plate})
        if result[1] ~= nil then
           local player = MySQL.query.await('SELECT firstname, lastname FROM `users` WHERE `identifier` = ?', {result[1].identifier})
            if player[1] ~= nil then
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = player[1].firstname .. " " .. player[1].lastname,
                    identifier = result[1].identifier,
                }
            end
        elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then 
            vehicleData = GeneratedPlates[plate]
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[plate] = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                identifier = ownerInfo.identifier,
            }
            vehicleData = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                identifier = ownerInfo.identifier,
            }
        end
        
        return vehicleData
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, {type='error', text ='No Vehicle Nearby'})
        return nil
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", identifier = "DSH091G93" },
        [2] = { name = "Jay Dendam", identifier = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", identifier = "DVH091T93" },
        [4] = { name = "Karel Bakker", identifier = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", identifier = "DRH09Z193" },
        [6] = { name = "Nico Wolters", identifier = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", identifier = "ODF09S193" },
        [8] = { name = "Bert Johannes", identifier = "KSD0919H3" },
        [9] = { name = "Karel de Grote", identifier = "NDX091D93" },
        [10] = { name = "Jan Pieter", identifier = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", identifier = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", identifier = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", identifier = "TEW0J9193" },
        [14] = { name = "Bart Rielink", identifier = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", identifier = "QBC091H93" },
        [16] = { name = "Aad Keizer", identifier = "YDN091H93" },
        [17] = { name = "Thijn Kiel", identifier = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", identifier = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", identifier = "QWE091A93" },
        [20] = { name = "Dries Stielstra", identifier = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", identifier = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", identifier = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", identifier = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", identifier = "IOP091O93" },
        [25] = { name = "Renske de Raaf", identifier = "PIO091R93" },
        [26] = { name = "Krisje Moltman", identifier = "LEK091X93" },
        [27] = { name = "Mirre Steevens", identifier = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", identifier = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", identifier = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", identifier = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

lib.callback.register('alan-phone:server:GetGarageVehicles', function(source)
    local Player = ESX.GetPlayerFromId(source)
    local Vehicles = {}

    local result = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ?', {Player.identifier})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local garage = Config.Garasinya[v.garage] and Config.Garasinya[v.garage] or v.garage

            if v.garage == nil then
                garage = 'Diluar'
                VehicleState = "Asuransi"
            else
                VehicleState = "Di Garasi"
            end

            local policeim = MySQL.Sync.fetchScalar('SELECT plate FROM h_impounded_vehicles WHERE plate=@plate', {
                ['@plate'] = v.plate
            })
            if policeim then
                garage = 'Samsat'
                VehicleState = 'Tersita'
            end

            local vehdata = {}

            vehdata = {
                model = json.decode(v.vehicle).model,
                plate = v.plate,
                garage = garage,
                state = VehicleState,
                fuel = v.fuel or 1000,
                engine = v.engine or 1000,
                body = v.body or 1000,
            }

            Vehicles[#Vehicles+1] = vehdata
        end
        
        return Vehicles
    else
        return nil
    end
end)

lib.callback.register('alan-phone:server:GetCharacterData', function(source, id)
    local src = source or id

    return GetCharacter(src)
end)

RegisterNetEvent('alan-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    local SuggestionData = {
        name = {
            [1] = character.firstname,
            [2] = character.lastname
        },
        number = character.phone,
        bank = Player.getAccount('bank').money,
    }

    TriggerClientEvent('alan-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterNetEvent('alan-phone:server:addImageToGallery', function(image)
    local src = source
   local Player = ESX.GetPlayerFromId(src)
    MySQL.insert('INSERT INTO phone_gallery (`identifier`, `image`) VALUES (?, ?)',{Player.identifier,image})
end)

RegisterNetEvent('alan-phone:server:getImageFromGallery', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE identifier = ? ORDER BY `date` DESC',{Player.identifier})
    TriggerClientEvent('alan-phone:refreshImages', src, images)
end)

RegisterNetEvent('alan-phone:server:RemoveImageFromGallery', function(data)
    local src = source
   local Player = ESX.GetPlayerFromId(src)
    local image = data.image
    MySQL.update('DELETE FROM phone_gallery WHERE identifier = ? AND image = ?',{Player.identifier,image})
end)

RegisterServerEvent('alan-phone:addsms', function(coords, pesan, jobs, time)
    local steam = ESX.GetPlayerFromId(source).identifier
    local date = os.date('*t')
			
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    TriggerClientEvent("alan-phone:client:addPoliceAlert", -1, { title = source .. " | #" .. getNumberPhone(steam) .. " (" .. date.hour .. ':' .. date.min .. ")", phone = getNumberPhone(steam),  coords = {x = coords.x, y = coords.y, z = coords.z}, description = pesan }, jobs)
end)

lib.callback.register('alan-phone:server:GetCurrentLawyers', function(source)
    local Lawyers = {}

    local countstate = 0
    local countpolice = 0
    local countems = 0
    local countpedagang = 0
    local countmechanic = 0
    local countojek = 0
    local playerps = 0

    local xPlayers = ESX.GetExtendedPlayers()
	for _, Player in pairs(xPlayers) do
        if Player ~= nil then
            local nama = Player.getName()

            if Player.job.name == 'state' then
                countstate = countstate + 1
            end
            if Player.job.name == 'police' then
                countpolice = countpolice + 1
            end
            if Player.job.name == 'ambulance' then
                countems = countems + 1
            end
            if Player.job.name == 'pedagang' then
                countpedagang = countpedagang + 1
            end
            if Player.job.name == 'mechanic' then
                countmechanic = countmechanic + 1
            end
            if Player.job.name == 'taxi' then
                countojek = countojek + 1
            end
            playerps = playerps + 1

            if Player.job.name == 'state' then
                table.insert(Lawyers, {
                    firstname = nama,
                    lastname = nama,
                    phone = 'stateplayer',
                })
            end

            if Player.job.name == 'ambulance' then
                table.insert(Lawyers, {
                    firstname = nama,
                    lastname = nama,
                    phone = 'ambulanceplayer',
                })
            end

            if Player.job.name == 'pedagang' then
                table.insert(Lawyers, {
                    firstname = nama,
                    lastname = nama,
                    phone = 'pedagangplayer',
                })
            end

            if Player.job.name == 'taxi' then
                table.insert(Lawyers, {
                    firstname = nama,
                    lastname = nama,
                    phone = 'taxiplayer',
                })
            end

            if Player.job.name == 'mechanic' then
                table.insert(Lawyers, {
                    firstname = nama,
                    lastname = nama,
                    phone = 'mechanicplayer',
                })
            end
        end
    end

    table.insert(Lawyers, {
        firstname = countstate,
        lastname = 'PEMERINTAH',
        phone = 'state',
    })

    table.insert(Lawyers, {
        firstname = countpolice,
        lastname = 'POLISI',
        phone = 'police',
    })

    table.insert(Lawyers, {
        firstname = 'P',
        lastname = 'Kantor Pusat',
        phone = 'policeplayer',
    })
    
    table.insert(Lawyers, {
        firstname = countems,
        lastname = 'EMS',
        phone = 'ambulance',
    })

    table.insert(Lawyers, {
        firstname = countpedagang,
        lastname = 'PEDAGANG',
        phone = 'pedagang',
    })
    
    table.insert(Lawyers, {
        firstname = countmechanic,
        lastname = 'MEKANIK',
        phone = 'mechanic',
    })

    table.insert(Lawyers, {
        firstname = countojek,
        lastname = 'TRANS',
        phone = 'taxi',
    })

    table.insert(Lawyers, {
        firstname = playerps,
        lastname = 'Warga',
        phone = ' ',
    })

    return Lawyers
end)

-- ESX(V1_Final) Fix
function GetCharacter(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', { xPlayer.identifier })
    return result[1]
end

function GetPlayerFromPhone(phone)
    local result = MySQL.query.await('SELECT * FROM users WHERE phone = ?', { phone })
    
    if result[1] and result[1].identifier then
        return ESX.GetPlayerFromIdentifier(result[1].identifier)
    end

    return nil
end

function IsBolehTF(player)
    local allowed = false
	for i, id in ipairs(BolehTF) do
		for x, pid in ipairs(GetPlayerIdentifiers(player)) do
			if string.lower(pid) == string.lower(id) then
				allowed = true
			end
		end
	end		
    return allowed
end

function getPlayerFromIBAN(iban)
    local result = MySQL.query.await('SELECT * FROM users WHERE iban = ?', { iban })
    
    if result[1] and result[1].identifier then
        return ESX.GetPlayerFromIdentifier(result[1].identifier)
    end

    return nil
end

function ExecuteSql(wait, query, cb)
	local rtndata = {}
	local waiting = true
	MySQL.query(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
    end
    
	return rtndata
end