local hit, coords

local function RotationToDirection(rotation)
    local adjustedRotation = { 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function GetAimingHit(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local currentWeapon = GetCurrentPedWeaponEntityIndex(PlayerPedId())
	local coordsWeapon = GetEntityCoords(currentWeapon)

	local direction = RotationToDirection(cameraRotation)
	local destination = {
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance
	}
	local _, hit, coords, _, _ = GetShapeTestResult(StartShapeTestRay(coordsWeapon.x, coordsWeapon.y, coordsWeapon.z, destination.x, destination.y, destination.z, 1, 0, 4))

    return hit, coords
end

-- HaveHitSomething Update
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if IsPedArmed(ped, 4) then
			hit, coords = GetAimingHit(Config.HitDistance)
		else
			hit, coords = nil, nil
		end
		Citizen.Wait(Config.HitCheck)
	end
end)

-- X Drawing
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if coords ~= vector3(0.0, 0.0, 0.0) and coords ~= nil then
			DisablePlayerFiring(128, true)
			DrawText3Ds(coords, Config.Icon, Config.Size)
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(1)
	end
end)
