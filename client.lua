local KEY_CODES = {
  ["ESC"] = 322,
  ["F1"] = 288,
  ["F2"] = 289,
  ["F3"] = 170,
  ["F5"] = 166,
  ["F6"] = 167,
  ["F7"] = 168,
  ["F8"] = 169,
  ["F9"] = 56,
  ["F10"] = 57,
  ["~"] = 243,
  ["1"] = 157,
  ["2"] = 158,
  ["3"] = 160,
  ["4"] = 164,
  ["5"] = 165,
  ["6"] = 159,
  ["7"] = 161,
  ["8"] = 162,
  ["9"] = 163,
  ["-"] = 84,
  ["="] = 83,
  ["BACKSPACE"] = 177,
  ["TAB"] = 37,
  ["Q"] = 44,
  ["W"] = 32,
  ["E"] = 38,
  ["R"] = 45,
  ["T"] = 245,
  ["Y"] = 246,
  ["U"] = 303,
  ["P"] = 199,
  ["["] = 39,
  ["]"] = 40,
  ["ENTER"] = 18,
  ["CAPS"] = 137,
  ["A"] = 34,
  ["S"] = 8,
  ["D"] = 9,
  ["F"] = 23,
  ["G"] = 47,
  ["H"] = 74,
  ["K"] = 311,
  ["L"] = 182,
  ["LEFTSHIFT"] = 21,
  ["Z"] = 20,
  ["X"] = 73,
  ["C"] = 26,
  ["V"] = 0,
  ["B"] = 29,
  ["N"] = 249,
  ["M"] = 244,
  [","] = 82,
  ["."] = 81,
  ["LEFTCTRL"] = 36,
  ["LEFTALT"] = 19,
  ["SPACE"] = 22,
  ["RIGHTCTRL"] = 70,
  ["HOME"] = 213,
  ["PAGEUP"] = 10,
  ["PAGEDOWN"] = 11,
  ["DELETE"] = 178,
  ["LEFT"] = 174,
  ["RIGHT"] = 175,
  ["TOP"] = 27,
  ["DOWN"] = 173,
  ["NENTER"] = 201,
  ["N4"] = 108,
  ["N5"] = 60,
  ["N6"] = 107,
  ["N+"] = 96,
  ["N-"] = 97,
  ["N7"] = 117,
  ["N8"] = 61,
  ["N9"] = 118
}

local ESXShared = nil
local localTimer = 0
local copBlips = {}
local hasEnteredMarker = false

TriggerEvent("esx:getSharedObject", function(obj)
  ESXShared = obj
end)

Citizen.CreateThread(function()
  renderHolograms()
  KeyControl()
end)

function isPlayerInsideAnyZone()
  local coords = GetEntityCoords(GetPlayerPed(-1))
  for k, v in pairs(Config.Zones) do
    for i = 1, #v.Pos, 1 do
      if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, false) < 2 then
        return true
      end
    end
  end
  return false
end

function tableContains(tbl, val)
  for i = 1, #tbl do
    if tbl[i] == val then
      return true
    end
  end
  return false
end

function renderHolograms()
  while true do
    Citizen.Wait(5)
    for k, v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if GetDistanceBetweenCoords(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, GetEntityCoords(GetPlayerPed(-1)), false) < 20.0 then
          local markerType = 6
          local markerSize = {
            x = 1.2,
            y = 1.2,
            z = 1.2
          }
          local markerColor = {
            r = 0,
            g = 0,
            b = 500
          }
          DrawMarker(markerType, v.Posm[i].x, v.Posm[i].y, v.Posm[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, markerSize.x,
            markerSize.y, markerSize.z, markerColor.r, markerColor.g, markerColor.b, 100, false, true, 2, false, false,
            false, false)
          showFloatingHelp("~b~[E] -~w~ To Open Rental", v.Posm[i])
          DrawMarker(36, v.Posm[i].x, v.Posm[i].y, v.Posm[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0,
            markerColor.r, markerColor.g, markerColor.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end

function showFloatingHelp(msg, coords)
  SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
  SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentSubstringPlayerName(msg)
  EndTextCommandDisplayHelp(2, false, true, 0)
end

AddEventHandler("onKeyUP", function(control)
  if isPlayerInsideAnyZone() then
    if control == "e" then
      openRentalMenu()
    end
    if control == "back" then
      ESXShared.UI.Menu.CloseAll()
    end
  end
end)

local canSpawn = true
function openRentalMenu()
  local elements = {{
    label = "<b><span style='color:yellow;'>Spawn Bf400</span></b>",
    value = "solo"
  }}

  ESXShared.UI.Menu.Open("default", GetCurrentResourceName(), "Rental_Menu", {
    title = ("Car Rental"),
    align = "center",
    elements = elements
  }, function(data, menu)
    if data.current.value == "solo" then
      if canSpawn then
        TriggerEvent("ess:spawnMaxVehicle", "bf400")
        canSpawn = false
      else
        exports["okokNotify"]:Alert("ERROR", "You've already spawned a bike!", 5000, "error")
      end
    end
    ESXShared.UI.Menu.CloseAll()
  end)
end
