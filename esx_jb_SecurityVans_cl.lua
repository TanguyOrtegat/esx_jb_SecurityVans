-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
-- Fin Local

ESX 				= nil
local beginmission 	= false
local AImission 	= ""
local PlayerData   	= {}

-- begin init ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
-- End init ESX


local moneyTruckHash = GetHashKey("stockade")


local AItrajet = {
     -- {
        -- destinationx = -2952.046875,
        -- destinationy = 492.81072998047,
        -- destinationz = 15.331346511841,
        -- ped = "s_m_m_armoured_01",
        -- car = "stockade",
    -- },
     {
        destinationx = -2952.046875,
        destinationy = 492.81072998047,
        destinationz = 14.831346511841,
        ped = "s_m_m_armoured_01",
        car = "stockade",
    },
}

RegisterCommand('go', function ()
	ESX.TriggerServerCallback('securityvans:checkmission', function(missionisactivated)
	  if not missionisactivated then
		  -- if NetworkIsHost() then
			-- local AImission = AItrajet[ math.random( #AItrajet ) ]
			-- spawnMoneyTruck(AImission)

			-- while true do
			  -- Wait(0)
			  -- checkMoneyTruckTick()
			-- end
		  -- end
		  TriggerServerEvent('securityvans:startscript')
	  else
		ESX.ShowNotification('Il faut encore attendre avant de faire un nouveau convois')
	  end
	end)
end)



local thisMoneyTruck
local thisMoneyTruckPed
local thisMoneyTruckPed2

local moneyTruckBlip

local cashPickup
local thisMoneyTruckBreached = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(job)
	PlayerData.second_job = job	
end)

function setupModel(model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    RequestModel(model)
    Wait(0)
  end
  SetModelAsNoLongerNeeded(model)
end


function spawnMoneyTruck(mission)
  TriggerServerEvent('securityvans:startmission')
  local moneytruckhash = GetHashKey(mission.car)
  local moneytruckpedhash = GetHashKey(mission.ped)
  setupModel(moneyTruckHash)
  setupModel(moneytruckpedhash)

  thisMoneyTruck = CreateVehicle(moneyTruckHash, -3.936, -709.842, 31.942, 336.8, true, false)
  RequestCollisionForModel(moneyTruckHash)

  N_0x06faacd625d80caa(thisMoneyTruck)

  -- SetVehicleDoorsLocked(thisMoneyTruck , 7)
  SetEntityAsNoLongerNeeded(thisMoneyTruck)
  SetVehicleOnGroundProperly(thisMoneyTruck)
 

  -- thisMoneyTruckPed = CreatePedInsideVehicle(thisMoneyTruck, 4, moneytruckpedhash, -1, true, false)
  -- thisMoneyTruckPed2 = CreatePedInsideVehicle(thisMoneyTruck, 4, moneytruckpedhash, 0, true, false)
  
  setGaurd(thisMoneyTruckPed)
  setGaurd(thisMoneyTruckPed2)
  
  SetEntityAsMissionEntity(thisMoneyTruckPed, 0, 0)
  SetEntityAsMissionEntity(thisMoneyTruckPed2, 0, 0)

  -- moneyTruckBlip = AddBlipForEntity(thisMoneyTruck)
  -- SetBlipColour(moneyTruckBlip, 11)

  TaskVehicleDriveToCoordLongrange(thisMoneyTruckPed, thisMoneyTruck, mission.destinationx, mission.destinationy, mission.destinationz, 25.0,  1074528293 , 1.0)
end

function setGaurd(ped)
	SetEntityAsMissionEntity(ped,  true,  false)
	SetPedPropIndex(ped, 0, 1, 0, false)
	SetPedSuffersCriticalHits(ped, 0)
	SetPedShootRate(ped,  850)
	AddArmourToPed(ped, GetPlayerMaxArmour(thisMoneyTruckPed)- GetPedArmour(thisMoneyTruckPed))
	SetPedAlertness(ped, 100)
	SetPedAccuracy(ped, 100)
	SetPedCanSwitchWeapon(ped, true)
	SetEntityHealth(ped,  200)
	SetPedArmour(ped, 100)
	SetPedCombatAttributes(ped, 46, true)
	SetPedCombatAbility(ped,  2)
	SetPedCombatRange(ped, 50)
	SetPedPathAvoidFire(ped,  1)
	SetPedPathCanUseLadders(ped,1)
	SetPedPathCanDropFromHeight(ped, 1)
	SetPedPathPreferToAvoidWater(ped, 1)
	SetPedGeneratesDeadBodyEvents(ped, 1)
	GiveWeaponToPed(ped, GetHashKey("WEAPON_SMG"), 5000, true, true)
	GiveWeaponToPed(ped, GetHashKey("WEAPON_MINISMG"), 5000, true, true)
	GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 5000, true, true)

	-- Combat
	SetPedCombatAttributes(ped, 1, false) --BF_CanUseVehicles
	SetPedCombatAttributes(ped, 13, false)
	SetPedCombatAttributes(ped, 6, true)
	SetPedCombatAttributes(ped, 8, false)
	SetPedCombatAttributes(ped, 10, true)

	SetPedFleeAttributes(ped, 512, true)
	SetPedConfigFlag(ped, 118, false)
	SetPedFleeAttributes(ped, 128, true)

	SetPedCanRagdollFromPlayerImpact(ped, 0)
	SetEntityIsTargetPriority(ped, 1, 0)
	SetPedGetOutUpsideDownVehicle(ped, 1)
	SetPedPlaysHeadOnHornAnimWhenDiesInVehicle(ped, 1)
	SetPedKeepTask(ped, true)
	SetEntityLodDist(ped, 250)
	Citizen.InvokeNative --[[SetEntityLoadCollisionFlag]](0x0DC7CABAB1E9B67E, ped, true, 1)
	SetPedRelationshipGroupHash(ped, GetHashKey("security_guard"))
end

function checkMoneyTruckTick()
    if DoesEntityExist(thisMoneyTruck) then
		local thisMoneyTruckCoord = GetEntityCoords(thisMoneyTruckPed)
		--check to see if we are at endlocation so we can choose another location rand to go to
		if GetDistanceBetweenCoords(thisMoneyTruckCoord.x, thisMoneyTruckCoord.y, thisMoneyTruckCoord.z, AImission.destinationx, AImission.destinationy, AImission.destinationz, true) < 5.0 then
		  SetEntityAsMissionEntity(thisMoneyTruck, 0, 0)
		  ClearPedTasks(thisMoneyTruckPed)
		  DeleteVehicle(Citizen.PointerValueIntInitialized(thisMoneyTruck))
		  DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed))
		  DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed2))
		  TriggerServerEvent('securityvans:addsocietymoney')
		end
		
		if GetVehicleDoorAngleRatio(thisMoneyTruck, 2) > .1 or GetVehicleDoorAngleRatio(thisMoneyTruck, 3) > .1 then
		  
		  if not thisMoneyTruckBreached then
			GetEntityCoords(thisMoneyTruck, 1)
			cashPickup = CreatePickup(GetHashKey("PICKUP_MONEY_SECURITY_CASE"), GetOffsetFromEntityInWorldCoords(thisMoneyTruck, 0.0, -5.0, 0.0001))
			thisMoneyTruckBreached = true
		  end
		end

		if thisMoneyTruckBreached then
		  --check to see the pickup has been collected
		  if HasPickupBeenCollected(cashPickup) then
			  TriggerServerEvent('securityvans:recieveitem')
			  RemovePickup(cashPickup)
			  --RemoveBlip(moneyTruckBlip)
			  beginmission = false
			  Citizen.Wait(300000)
			  DeleteVehicle(Citizen.PointerValueIntInitialized(thisMoneyTruck))
			  DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed))
			  DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed2))

		  end
		end
    end
end

function exitmarker()
	ESX.UI.Menu.CloseAll()
end

function sellbigbag()
	exports.ft_libs:HelpPromt("Appuyez sur ~INPUT_CONTEXT~ pour vendre le gros sac d'argent")
	if IsControlJustPressed(1, 38) then
		if (PlayerData.job ~= nil and PlayerData.job.name ~= 'brinks') or ( PlayerData.second_job ~= nil and PlayerData.second_job.name ~= 'brinks') then
			TriggerServerEvent("securityvans:sellbigmoneybag")
		else
			ESX.ShowNotification("Vous êtes de la brinks. Impossible de vendre ici")
		end
	end
end

RegisterNetEvent("securityvans:ready")
AddEventHandler('securityvans:ready', function()
	if NetworkIsHost() then
		AImission = AItrajet[ math.random( #AItrajet ) ]
		spawnMoneyTruck(AImission)
		thisMoneyTruckBreached = false
		beginmission = true
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if beginmission then
		checkMoneyTruckTick()
	  end
	end
end)



RegisterNetEvent("ft_libs:OnClientReady")
AddEventHandler('ft_libs:OnClientReady', function()
	exports.ft_libs:AddArea("securityvans_resellpoint", {
		trigger = {
			weight = 1.5,
			active = {
				callback = sellbigbag,
			},
			exit = {
			  callback = exitmarker,
			},
		},
		locations = {
			{
				x = -3.936,
				y = -709.842,
				z = 31.942,
			},
		},
	})
end)