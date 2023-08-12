local shouldExecuteBind = true
AddEventHandler("jn-core:shouldExecuteBind", function(status)
  shouldExecuteBind = status
end)

exports('registerKeyMapping', function(description, onKeyDownCommand, onKeyUpCommand, default, event, name)
	local type = "keyboard"
	if not name then name = "" end
	if not default then default = "" end
	cmdStringDown = "+cmd_wrapper__" .. onKeyDownCommand
    cmdStringUp = "-cmd_wrapper__" .. onKeyDownCommand
    RegisterCommand(cmdStringDown, function()
  		if not shouldExecuteBind then return end
  		if event then TriggerEvent(name) end
  		ExecuteCommand(onKeyDownCommand)
    end, false)    
    RegisterCommand(cmdStringUp, function()
      if not shouldExecuteBind then return end
      if event then TriggerEvent(name) end
      ExecuteCommand(onKeyUpCommand)
    end, false)
    RegisterKeyMapping(cmdStringDown, description, type, default)
end)

Citizen.CreateThread(function()
	  RegisterKeyMapping('cycleproximity', 'Voice Range', 'keyboard', GetConvar('voice_defaultCycle', 'Z'))
    --exports["midp-core"]:registerKeyMapping('Reset Voice', '+resetVoiceRWT', '-resetVoiceRWT', '')
    RegisterKeyMapping('+resetVoiceRWT', 'Reset Voice', 'keyboard', '')
	  RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
    RegisterKeyMapping('+IsLagiKunci', 'Kunci kendaraan', 'keyboard', 'U')
    RegisterKeyMapping('+isShowUI', 'Show ID', 'keyboard', 'H')
    RegisterKeyMapping('+isshowJobs', 'Show Job', 'keyboard', 'B')
    RegisterKeyMapping('+isshowIDPlayer', 'Show ID Players', 'keyboard', 'U')
    RegisterKeyMapping('+drift', 'Toggle vehicle drift', 'keyboard', '')
    RegisterKeyMapping('handsup', 'Angkat Tangan', 'keyboard', 'X')
    RegisterKeyMapping("+helicam", "Heli Camera", "keyboard", "")
    RegisterKeyMapping("+helirappel", "Heli Rappel", "keyboard", "")
    RegisterKeyMapping('ChairBedSystem:Client:Leave', 'Leave Chair/Bed', 'keyboard', 'F')
    RegisterKeyMapping("radialMenu", "Radial Menu", "keyboard", "F1")
    RegisterKeyMapping('cancel', 'Cancel Action(ID CARD)', 'keyboard', 'BACK')
    RegisterKeyMapping('+ecancel', 'Cancel Emote', 'keyboard', 'X')
    RegisterKeyMapping('+ndodok', 'Jongkok', 'keyboard', '')
    RegisterKeyMapping('+nunjuk', 'Nunjuk', 'keyboard', '')
end)