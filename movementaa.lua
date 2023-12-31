-- Function to save coordinates to a file
function saveCoordinatesToFile(x, y, z)
    local file = fs.open("turtle_coordinates.txt", "w")
    file.writeLine(x)
    file.writeLine(y)
    file.writeLine(z)
    file.close()
end

-- Function to load coordinates from a file
function loadCoordinatesFromFile()
    local file = fs.open("turtle_coordinates.txt", "r")
    if file then
        local x = tonumber(file.readLine())
        local y = tonumber(file.readLine())
        local z = tonumber(file.readLine())
        file.close()
        return x, y, z
    end
    return nil
end

-- ... (rest of the script)

-- Get starting coordinates from the user or load from the file
print("Do you want to use saved coordinates? (yes/no)")
local useSavedCoordinates = read()

local startX, startY, startZ

if useSavedCoordinates:lower() == "yes" then
    local savedX, savedY, savedZ = loadCoordinatesFromFile()
    if savedX and savedY and savedZ then
        startX, startY, startZ = savedX, savedY, savedZ
        print("Using saved coordinates:")
        print("X: " .. startX)
        print("Y: " .. startY)
        print("Z: " .. startZ)
    else
        print("No saved coordinates found. Please enter starting coordinates:")
        startX = promptForNumber("X:")
        startY = promptForNumber("Y:")
        startZ = promptForNumber("Z:")
        saveCoordinatesToFile(startX, startY, startZ)
    end
else
    print("Please enter starting coordinates:")
    startX = promptForNumber("X:")
    startY = promptForNumber("Y:")
    startZ = promptForNumber("Z:")
    saveCoordinatesToFile(startX, startY, startZ)
end

-- ... (rest of the script)

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
