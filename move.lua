-- ... (rest of the script)

-- Function to check if the turtle has enough fuel
function checkFuelLevel(totalFuelNeeded)
    local currentFuel = turtle.getFuelLevel()
    if currentFuel and currentFuel >= totalFuelNeeded then
        print("Turtle has enough fuel. Starting the journey...")
        return true
    else
        print("Error: Turtle does not have enough fuel. Refuel before starting the journey.")
        return false
    end
end

-- ... (rest of the script)

-- Calculate fuel needed and refuel the turtle
local totalFuelNeeded, lavaBucketsNeeded = calculateAndRefuel(startX, startZ, endX, endZ)

-- Display fuel requirements to the player
print("Fuel Required: " .. totalFuelNeeded .. " fuel units or " .. lavaBucketsNeeded .. " lava buckets")

-- Keep prompting for fuel until the turtle has enough
while not checkFuelLevel(totalFuelNeeded) do
    -- Prompt the player to input fuel
    promptAndRefuel(lavaBucketsNeeded)
end

-- Ask the player if they want to continue
print("Do you want to continue? (yes/no)")
local response = read()

if response:lower() == "yes" then
    -- Move the turtle to the destination
    print("Moving the turtle to the destination...")

    -- Move to the destination
    moveTurtleToDestination({x = endX, y = 100, z = endZ})

    print("Turtle has reached the destination.")
else
    print("Operation aborted. Turtle not moving.")
end
