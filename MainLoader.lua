if game.PlaceId == 84188796720288 then
    print ("Anime Realm")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/Cat%20piece"))()
repeat
    wait()
until game:IsLoaded()
wait()
for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
    v:Disable()
end
