--
-- File: wheat_harvest.lua
-- Author: Brandon Bires-Navel (brandonnavel@outlook.com)
--

local robot = require("robot")
local X = 0 -- Width of the wheat farm
local Y = 0 -- Height of the wheat farm (see the loop function for a picture)
local timeToSleep = 300 -- Time to sleep after the main loop is done


-- Just need to move forward one block since at the start
-- the robot is on a charger in the bottom left corner of the wheat farm
function init()
    robot.forward()
end

-- Navigate the robot to harvest the nxm sized wheat farm
-- w w w w
-- w w w w  : nxm => 3x4
-- w w w w
-- C
-- Where 'C' is the charging station (the robot should be directly above this)
-- and 'w' is one wheat in the wheat farm. The charging station should be on
-- the same level as the wheat.
function loop(n, m)
    local wheatHarvested = 0
    local direction = 0 -- 0 for right 1 for left
    for i = 1, n do
        for i = 1, m do
            if robot.useDown() then
                wheatHarvested = wheatHarvested + 1
            end
        end
        if direction == 0 then
            robot.turnRight()
            robot.forward()
            robot.turnRight()
            direction = 1
        else
            robot.turnLeft()
            robot.forward()
            robot.turnLeft()
            direction = 0
        end
    end
    io.write("Wheat harvested: ", wheatHarvested, "\n")
    return wheatHarvested
end

-- Move the robot from the end of the route to the start of the route
function reset()
    robot.turnLeft()
    for i = 1, X do
        robot.forward()
    end
end

-- Main loop
function main()
    init()
    loop(X, Y)
    io.write("Sleeping for ", timeToSleep, " seconds.\n")
    os.sleep(timeToSleep) -- Sleep for 5 minutes and let wheat grow
end

main()