addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end
function StartPayCheck()
  CreateThread(function()
    while true do
      Wait(Config.PaycheckInterval)
      for player, xPlayer in pairs(ESX.Players) do
        local jobLabel = xPlayer.job.label
        local job = xPlayer.job.grade_name
        local salary = xPlayer.job.grade_salary

        if salary > 0 then
          if job == 'unemployed' then -- unemployed
            xPlayer.addAccountMoney('bank', salary, "Welfare Check")
            TriggerClientEvent('notification:show', player, 'fab fa-cc-visa text-info','Bank', "Pay Check", "Kamu menerima uang dengan jumlah : <b>$"..addCommas(salary).."</b> dari pemerintah!", 15000,"not1")
            if Config.LogPaycheck then
              ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                { name = "Player", value = xPlayer.name,   inline = true },
                { name = "ID",     value = xPlayer.source, inline = true },
                { name = "Amount", value = salary,         inline = true }
              })
            end
          elseif Config.EnableSocietyPayouts then -- possibly a society
            TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
              if society ~= nil then              -- verified society
                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                  if account.money >= salary then -- does the society money to pay its employees?
                    xPlayer.addAccountMoney('bank', salary, "Paycheck")
                    account.removeMoney(salary)
                    if Config.LogPaycheck then
                      ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                        { name = "Player", value = xPlayer.name,   inline = true },
                        { name = "ID",     value = xPlayer.source, inline = true },
                        { name = "Amount", value = salary,         inline = true }
                      })
                    end
                    TriggerClientEvent('notification:show', player, 'fab fa-cc-visa text-info','Bank', "Pay Check", "Kamu menerima uang dengan jumlah : <b>$"..addCommas(salary).."</b> dari pemerintah!", 15000,"not1")
                  else
                    TriggerClientEvent('notification:show', player, 'fab fa-cc-visa text-info','Bank', "Pay Check", "Kamu menerima uang dengan jumlah : <b>$"..addCommas(salary).."</b> dari pemerintah!", 15000,"not1")
                  end
                end)
              else -- not a society
                xPlayer.addAccountMoney('bank', salary, "Paycheck")
                if Config.LogPaycheck then
                  ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                    { name = "Player", value = xPlayer.name,   inline = true },
                    { name = "ID",     value = xPlayer.source, inline = true },
                    { name = "Amount", value = salary,         inline = true }
                  })
                end
                TriggerClientEvent('notification:show', player, 'fab fa-cc-visa text-info','Bank', "Pay Check", "Kamu menerima uang dengan jumlah : <b>$"..addCommas(salary).."</b> dari pemerintah!", 15000,"not1")
              end
            end)
          else -- generic job
            xPlayer.addAccountMoney('bank', salary, "Paycheck")
            if Config.LogPaycheck then
              ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                { name = "Player", value = xPlayer.name,   inline = true },
                { name = "ID",     value = xPlayer.source, inline = true },
                { name = "Amount", value = salary,         inline = true }
              })
            end
            TriggerClientEvent('notification:show', player, 'fab fa-cc-visa text-info','Bank', "Pay Check", "Kamu menerima uang dengan jumlah : <b>$"..addCommas(salary).."</b> dari pemerintah!", 15000,"not1")
          end
        end
      end
    end
  end)
end
