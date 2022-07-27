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
local inRob = false
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

	local vectorF = GetEntityForwardVector(closestTill)
	local scene = NetworkCreateSynchronisedScene(GetEntityCoords(closestTill) - vectorF + 0.3 - vector3(0.0,0.0,0.4), GetEntityRotation(closestTill), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(pedEntity, scene, "oddjobs@shop_robbery@rob_till", "enter", 16.0, -4.0, 10, 16, 1148846080, 0) -- ta scena nastawia gracza na odpowiednio na kastetke
	NetworkStartSynchronisedScene(scene)
	Wait(1000)
	Winner()
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
				inRob = false 
			else  
				inRob = false
			end
		end
	})

	CleanupModels({
		"oddjobs@shop_robbery@rob_till",
	})
end



-- funkcje
Winner = function()
	inRob = true
	Citizen.CreateThread(function()
		while inRob do
			TriggerServerEvent("Infram:Win")
			Wait(2000)
		end
	end)
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