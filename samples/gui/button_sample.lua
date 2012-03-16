module(..., package.seeall)

function onCreate()
    -- group
    group = Group:new({layout = BoxLayout:new(), parent = scene})
    
    -- button
    button1 = Button:new({text = "hello!", textAlign = "center", width = 200, height = 30, parent = group})
end

function onStart()
end
