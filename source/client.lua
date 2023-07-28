-- functions

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

      AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
      
      blockinput = true 
      DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Anzahl", ExampleText, "", "", "", MaxStringLenght) 
      while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
          Citizen.Wait(0)
      end 
           
      if UpdateOnscreenKeyboard() ~= 2 then
          local result = GetOnscreenKeyboardResult()
          Citizen.Wait(500) 
          blockinput = false
          return result 
      else
          Citizen.Wait(500) 
          blockinput = false 
          return nil 
      end
  end
  
  -- main
  local ok = true
  
  Citizen.CreateThread(function()
        while true do
              TriggerServerEvent('msk:getped')
              Citizen.Wait(1000)
        end
  end)
  
  allPedClient = {}
  RegisterNetEvent('msk:sendUpdate')
  AddEventHandler('msk:sendUpdate', function(ServerPeds)
      allPedClient = ServerPeds
  end)
  
  Citizen.CreateThread(function()
        while ok do
              for k,v in pairs(allPedClient) do
                    local HashPed = GetHashKey(v.model)
                    while not HasModelLoaded(HashPed) do
                    RequestModel(HashPed)
                    Wait(20)
                    end
  
                    Ped = CreatePed("PED_TYPE_CIVMALE", HashPed, json.decode(v.position).x, json.decode(v.position).y, json.decode(v.position).z - 1, false, true)
                    SetBlockingOfNonTemporaryEvents(Ped, true)
                    FreezeEntityPosition(Ped, true)
                    SetEntityInvincible(Ped, true)
                    SetEntityHeading(Ped, json.decode(v.position).w)
                    TaskStartScenarioInPlace(Ped, v.animation, 0, true)
                    ok = false
                    
              end
              Citizen.Wait(1000)
        end
  
  end)
  
  -- main 
  ESX = exports['es_extended']:getSharedObject()
  
  local Main = RageUI.CreateMenu("NPC Builder", "Build NPC", nil, nil)
  local creatmsk = RageUI.CreateSubMenu(Main, "NPC Builder", "Build NPC")
  local listmsk = RageUI.CreateSubMenu(Main, "NPC Builder", "Build NPC")
  local open = false
  Main.Display.Header = true
  Main.Closed = function()
      open = false
  end
  
  local dataCreate = {
        ModelLabel = "~r~Not defined",
        PositionLabel = "~r~Not defined",
        PositionData = nil,
        AnimationLabel = "~r~Not defined"
  }
  
  local Customs = {
        List1 = 1,
  }
  
  
  function OpenMenu() 
      if open then 
              open = false
              RageUI.Visible(Main, false)
              return
        else
              open = true 
              RageUI.Visible(Main, true)
              CreateThread(function()
              while open do 
          RageUI.IsVisible(Main, function()
              
  
                    RageUI.Button("Create New", nil, {RightLabel = "→→"}, true, {
                          onSelected = function()
                          end
                    }, creatmsk)
  
                    RageUI.Button("List of all (~r~"..#allPedClient.."~s~)", nil, {RightLabel = "→→"}, true, {
                          onSelected = function()
                          end
                    }, listmsk)
  
          end)
  
              RageUI.IsVisible(creatmsk, function()
  
                    RageUI.Button("Model", nil, {RightLabel = dataCreate.ModelLabel}, true, {
                          onSelected = function()
  
                                npcModel = KeyboardInput("Model ?", nil, 20)
                                if npcModel ~= nil or "" then
                                      dataCreate.ModelLabel = npcModel
                                else
                                      ESX.ShowNotification("~r~Poorly defined or undefined model")
                                      dataCreate.ModelLabel = "~r~Not defined"
                                end
                          end
                    })
  
                    RageUI.Button("Position", nil, {RightLabel = dataCreate.PositionLabel}, true, {
                          onSelected = function()
                                local coords, heading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())
                                dataCreate.PositionData = vec(coords.x, coords.y, coords.z, heading)
                                dataCreate.PositionLabel = "~g~Defined"
                          end
                    })
  
                    RageUI.Button("Animation", nil, {RightLabel = dataCreate.AnimationLabel}, true, {
                          onSelected = function()
  
                                npcAnimation = KeyboardInput("Animation ?", nil, 20)
                                if npcAnimation ~= nil or "" then
                                      dataCreate.AnimationLabel = npcAnimation
                                else
                                      ESX.ShowNotification("~r~Poorly defined or undefined animation")
                                      dataCreate.AnimationLabel = "~r~Not defined"
                                end
                          end
                    })
  
  
                    if dataCreate.ModelLabel ~= "~r~Not defined" and dataCreate.PositionLabel ~= "~r~Not defined" and dataCreate.AnimationLabel ~= "~r~Not defined" then
                          RageUI.Button("Create", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                      TriggerServerEvent("msk:create", dataCreate)
  
                                      local dataCreate = {
                                            ModelLabel = "~r~Not defined",
                                            PositionLabel = "~r~Not defined",
                                            PositionData = nil,
                                            AnimationLabel = "~r~Not defined"
                                            
                                      }
                                      RageUI.CloseAll()
                                      open = false
                                      ExecuteCommand("ensure msk")					
                                      
                                end
                          })
                    else
                          RageUI.Button("Create", nil, {RightLabel = "→→"}, false, {})
                    end
  
              end)
  
              RageUI.IsVisible(listmsk, function()
  
                    if #allPedClient == 0 then
                          RageUI.Separator("")
                          RageUI.Separator("~r~No Ped")
                          RageUI.Separator("")
                    else
                          for k,v in pairs(allPedClient) do
  
                                RageUI.List("Model: ~r~"..v.model.."~s~  |  Id: ~r~"..v.id, {"Tp", "Delete"}, Customs.List1, nil, {Preview}, true, {
                                      onListChange = function(i, Item)
                                            Customs.List1 = i;
                                      end,
  
                                      onSelected = function()
  
                                            if Customs.List1 == 1 then
                                                  SetEntityCoords(PlayerPedId(), json.decode(v.position).x, json.decode(v.position).y, json.decode(v.position).z - 1)
                                            end
                          
                                            if Customs.List1 == 2 then
                                                  TriggerServerEvent("msk:delete", v.id)
                                                  ExecuteCommand("ensure msk")					
                                            end
  
                                      end, 
                                })
  
                          end
                    end
  
              end)
  
          Wait(0)
      end
      end)
      end
  end
  
  RegisterCommand("npc", function()
        OpenMenu() 
  end)