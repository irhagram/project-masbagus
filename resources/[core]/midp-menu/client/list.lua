
Citizen.CreateThread(function()


	local GUITime     = 0
	local MenuType    = 'list'
	local OpenedMenus = {}
	local inMenu = false

	local openMenu = function(namespace, name, data)

		OpenedMenus[namespace .. '_' .. name] = true

		SendNUIMessage({
			menuaction = 'list',
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		ESX.SetTimeout(200, function()
			inMenu = true
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
		end)

	end

	local closeMenu = function(namespace, name)

		OpenedMenus[namespace .. '_' .. name] = nil
		local OpenedMenuCount = 0

		SendNUIMessage({
			menuaction = 'list',
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		for k,v in pairs(OpenedMenus) do
			if v == true then
				OpenedMenuCount = OpenedMenuCount + 1
			end
		end

		if OpenedMenuCount == 0 then
			inMenu = false
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
		end

	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit_list', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel_list', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	Citizen.CreateThread(function()
		while true do
			local letsleep = 1000

			if inMenu then
				letsleep = 0

				DisableControlAction(0, 1, true) -- Disable pan
				DisableControlAction(0, 2, true) -- Disable tilt
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Aim
				DisableControlAction(0, 263, true) -- Melee Attack 1
				DisableControlAction(0, 32, true) -- W
				DisableControlAction(0, 34, true) -- A
				DisableControlAction(0, 31, true) -- S
				DisableControlAction(0, 30, true) -- D
				DisableControlAction(0, 45, true) -- Reload
				DisableControlAction(0, 22, true) -- Jump
				DisableControlAction(0, 44, true) -- Cover
				DisableControlAction(0, 37, true) -- Select Weapon
				DisableControlAction(0, 23, true) -- Also 'enter'?
				DisableControlAction(0, 288,  true) -- Disable phone
				DisableControlAction(0, 289, true) -- Inventory
				DisableControlAction(0, 170, true) -- Animations
				DisableControlAction(0, 167, true) -- Job
				DisableControlAction(0, 0, true) -- Disable changing view
				DisableControlAction(0, 26, true) -- Disable looking behind
				DisableControlAction(0, 73, true) -- Disable clearing animation
				DisableControlAction(2, 199, true) -- Disable pause screen
				DisableControlAction(0, 59, true) -- Disable steering in vehicle
				DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
				DisableControlAction(0, 72, true) -- Disable reversing in vehicle
				DisableControlAction(2, 36, true) -- Disable going stealth
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle
				DisableControlAction(0, 177, true) -- Disable exit vehicle

				if IsDisabledControlPressed(0, 177) and (GetGameTimer() - GUITime) > 150 then
					SendNUIMessage({
						menuaction = 'list',
						action  = 'ForcecloseMenu'
					})
					GUITime = GetGameTimer()
				end
			end

			Citizen.Wait(letsleep)
		end
	end)
end)