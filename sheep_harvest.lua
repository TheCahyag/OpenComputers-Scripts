--
-- File: sheep_harvest.lua
-- User: Brandon Bires-Navel (brandonnavel@outlook.com)
--

local robot = require("robot")
local computer = require("computer") -- For checking power levels
local x = 10
local y = 9
local MIN_PWR = 8000
local MIN_SHEEP = 90

function init()
    robot.up()
    robot.forworad()
    robot.forworad()
end

-- Main loop that navigates a n by m area
function loop (n, m)
    local sheepSheard = 0
    local direction = 0 -- 0 for right 1 for left
    for i = 1, n, 1 do
        for j = 1, m, 1 do
            if robot.useDown() then
                sheepSheard = sheepSheard + 1
            end
            robot.forward()
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
    io.write("Sheep sheared: ", sheepSheard, "\n")
    return sheepSheard
end

-- Checks if the computers power is below the MIN_PWR level
-- Returns true if it is below the MIN_PWR level and false otherwise
function needsPower()
    local pwrPercent = computer.energy() / computer.maxEnergy()
    io.write(pwrPercent * 100, "% power remaining\n")
    if computer.energy() < MIN_PWR then
        return false
    else
        return true
    end
end

-- Position the robot on the charger and charge until it reaches 98% power
-- Assumes the charger has a redstone signal
function topUpPower()
    robot.back()
    robot.back()
    robot.down()

    -- While power is > 98% sleep for 1 second
    while not ((computer.energy() / computer.maxEnergy()) >= 0.98) do
        os.sleep(1)
    end
end

-- Go from the end of the route to the start of the route
function reset()
    robot.turnLeft()
    for i = 1, y, 1 do
        robot.forward()
    end
    robot.turnRight()
end

-- Main function
function main()
    init()
    while (true) do
        local wait = false
        if loop(x, y) < MIN_SHEEP then
            wait = true;
        end
        reset()
        if needsPower() or wait then
            topUpPower()
            if wait then
                os.sleep(300) -- Sleep for 5 min
            end
            init()
        end
    end
end

