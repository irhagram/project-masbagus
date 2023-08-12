RegisterServerEvent('KickPlayer:EmergencyVehicle')
AddEventHandler('KickPlayer:EmergencyVehicle', function()
  	DropPlayer(source, "You have been kicked for attempting to steal an emergency vehicle. This action has been logged as well, so don\'t do it again, or you may be banned.")
end)