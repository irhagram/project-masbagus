# esx_status
ESX Status Optimize Version<br>

INSTALLATION
<br>1. Open the file es_extended/server/functions.lua
<br>2. Search function Core.SavePlayer
<br>3. Replace all the functions of Core.SavePlayer with below or you can add update data for the 'status' table only
```lua

function Core.SavePlayer(xPlayer, cb)
  MySQL.prepare(
    'UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `status` = ? WHERE `identifier` = ?',
    {
      json.encode(xPlayer.getAccounts(true)), 
      xPlayer.job.name, xPlayer.job.grade, 
      xPlayer.group, 
      json.encode(xPlayer.getCoords()),
      json.encode(xPlayer.getInventory(true)), 
      json.encode(xPlayer.getLoadout(true)), 
      json.encode(xPlayer.get('status')),
      xPlayer.identifier
    }, function(affectedRows)
      if affectedRows == 1 then
        print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
        TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
      end
      if cb then
        cb()
      end
    end)
end

```
<br>4. Search function Core.SavePlayers
<br>5. Replace all the functions of Core.SavePlayers with below or you can add update data for the 'status' table only
```lua

function Core.SavePlayers(cb)
  local xPlayers = ESX.GetExtendedPlayers()
  local count = #xPlayers
  if count > 0 then
    local parameters = {}
    local time = os.time()
    for i = 1, count do
      local xPlayer = xPlayers[i]
      parameters[#parameters + 1] = {
        json.encode(xPlayer.getAccounts(true)), 
        xPlayer.job.name, 
        xPlayer.job.grade, 
        xPlayer.group,
        json.encode(xPlayer.getCoords()), 
        json.encode(xPlayer.getInventory(true)), 
        json.encode(xPlayer.getLoadout(true)),
        json.encode(xPlayer.get('status')),
        xPlayer.identifier}
    end
    MySQL.prepare(
      "UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `status` = ? WHERE `identifier` = ?",
      parameters, function(results)
        if results then
          if type(cb) == 'function' then
            cb()
          else
            print(('[^2INFO^7] Saved ^5%s^7 %s over ^5%s^7 ms'):format(count, count > 1 and 'players' or 'player', ESX.Math.Round((os.time() - time) / 1000000, 2)))
          end
        end
      end)
  end
end

```
<b>Make sure you test it again on the server, whether you can save the status or not<b>
# Good luck ^^
