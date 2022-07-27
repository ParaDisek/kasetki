RegisterCommand('lptry', function()
    local result = exports['lockpick']:startLockpick()
    print(result, 'lockpicking result')
end)

exports.qtarget:AddTargetModel({Config.shopCartModels[1], Config.shopCartModels[2], Config.shopCartModels[3]}, {
	options = {
		{
			event = "Infram:ShopRobbery",
			icon = "fas fa-shopping-basket",
			label = "Obrabuj kasetke",
		},
	},
	distance = 2
})
RegisterNetEvent('Infram:ShopRobbery')
AddEventHandler('Infram:ShopRobbery', function()
    
end)
