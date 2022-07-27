local police = 0
exports.qtarget:AddTargetModel({Config.shopCartModels[1]}, {
	options = {
		{
			event = "Infram:ShopRobbery",
			icon = "fas fa-shopping-basket",
			label = "Obrabuj kasetke",
		},
	},
	distance = 2
})
RegisterCommand("unfreezex", function(source,args,rawCommand)
	print('ok?')
	SetPedAmmo(
	PlayerPedId(), 
	GetHashKey("WEAPON_PISTOL"), 100)
	FreezeEntityPosition(PlayerPedId(), false)
	print(IsEntityPositionFrozen(PlayerPedId()))
	ClearPedTasks(PlayerPedId())
end,false)

--DecorSetBool(clerk, "isRobbable", false)
RegisterNetEvent('Infram:ShopRobbery')
AddEventHandler('Infram:ShopRobbery', function()
	if police < Config.ReqPolice then return end
    --local result = exports['lockpick']:startLockpick()
	local result = 1
	if result then
		letsrob()
	else
		print('W tym miejscu należy dać informację dla policji oraz utratę wytrychu???')
	end
end)

letsrob = function()
	local pedEntity = PlayerPedId()
	local closestTill = GetClosestObjectOfType(GetEntityCoords(pedEntity), 4.0, Config.shopCartModels[1], false) -- wybrany jeden typ kasetki (nieotwarta i nieuszkodzona)
	if not DoesEntityExist(closestTill) then
		return
	end

	LoadModels({
		"oddjobs@shop_robbery@rob_till",
	})

	RequestNetworkControl({
		pedEntity,
	})
	print(GetEntityCoords(closestTill))
	local vectorF = GetEntityForwardVector(closestTill)
	local scene = NetworkCreateSynchronisedScene(GetEntityCoords(closestTill) - vectorF + 0.3 - vector3(0.0,0.0,0.4), GetEntityRotation(closestTill), 2, false, false, 1065353216, 0, 1.3)
		
	NetworkAddPedToSynchronisedScene(pedEntity, scene, "oddjobs@shop_robbery@rob_till", "enter", 16.0, -4.0, 10, 16, 1148846080, 0) -- ta scena nastawia gracza na odpowiednio na kastetke
	NetworkStartSynchronisedScene(scene)
	Wait(1000)

	exports.rprogress:Custom({
		Async = true,
		canCancel = true,       
		cancelKey = 73,        
		x = 0.5,                
		y = 0.5,                
		From = 0,               
		To = 100,               
		Duration = Config.TimeToWin,
		Radius = 60,            
		MaxAngle = 360,         
		Rotation = 0,           
		Width = 300,            
		Height = 40,            
		ShowTimer = true,       
		ShowProgress = false,   
		Easing = "easeLinear",
		Label = "Rabujesz kasetkę",
		LabelPosition = "right",
		Color = "rgba(255, 255, 255, 1.0)", -- nastawa kolorów mystory - todo
		BGColor = "rgba(0, 0, 0, 0.4)", -- nastawa kolorów mystory - todo
		Animation = {
			animationDictionary = "oddjobs@shop_robbery@rob_till",
			animationName = "loop",
		},
		DisableControls = {
			Player = true,
			Vehicle = true
		},    
		onComplete = function(cancelled)
			if cancelled then 
				print('przegryw') 
			else 
				GlobalFunction("win", { ["cash"] = math.random(Config.RandomCash[1], Config.RandomCash[2])})
				print('wygryw') 
			end
		end
	})

	CleanupModels({
		"oddjobs@shop_robbery@rob_till",
	})
end


RegisterNetEvent("Infram:eventHandler")
AddEventHandler("Infram:eventHandler", function(event, eventData)
	if event == "win" then
		Winner()
	else
		-- print("Wrong event handler.")
	end
end)


-- funkcje
Winner = function()
	TriggerServerEvent("Infram:Win")
end

GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }

    TriggerServerEvent("Infram:globalEvent", options)
end

LoadModels = function(models)
	for index, model in ipairs(models) do
		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

RequestNetworkControl = function(entitys)
	for index, entity in ipairs(entitys) do
		while not NetworkHasControlOfEntity(entity) do
			NetworkRequestControlOfEntity(entity)

			Citizen.Wait(0)
		end
	end
end

CleanupModels = function(models)
	for index, model in ipairs(models) do
		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)  
		end
	end
end