-- Geo Scanner Script with Selection Menu, Ore List, and Client Settings File Handling

local oreListFileName = "ORE_TABLE.ore"
local settingsFileName = "CLIENT-SETTINGS.SET"
local maxOptionsPerScreen = 7
local cooldownTime = 5  -- in seconds
local maxOresToShow = 3

-- Function to read ore names from a file or create a new file
function readOrCreateOreListFile(filename)
    local oreList = {}

    local file = io.open(filename, "r")

    if file then
        for line in file:lines() do
            table.insert(oreList, line)
        end
        file:close()
    else
        print("File not found. Creating a new file:", filename)
        print("Enter ore names to search for (each ore on a new line). Enter 'done' to finish:")

        oreList = {}

        repeat
            local oreName = read()
            if oreName ~= "done" then
                table.insert(oreList, oreName)
            end
        until oreName == "done"

        local newFile = io.open(filename, "w")
        if newFile then
            for _, ore in ipairs(oreList) do
                newFile:write(ore .. "\n")
            end
            newFile:close()
            print("Ore list saved to:", filename)
        else
            print("Failed to create file:", filename)
        end
    end

    return oreList
end

-- Function to read client settings from a file or create a new file
function readOrCreateSettingsFile(filename)
    local settings = {}

    local file = io.open(filename, "r")

    if file then
        for line in file:lines() do
            local key, value = line:match("([^=]+)=(.+)")
            if key and value then
                settings[key] = value
            end
        end
        file:close()
    else
        print("Settings file not found. Creating a new file:", filename)

        -- Ask the user for initial settings
        print("Enter initial settings:")
        
        -- Set the default scan size to 16 (max allowed)
        print("1. Set scan size (max 16):")
        local scanSize = tonumber(read()) or 16
        scanSize = math.min(scanSize, 16) -- Ensure scan size is not greater than 16
        settings["scanSize"] = tostring(scanSize)

        -- Add more settings prompts as needed

        -- Save the settings to the file
        local newFile = io.open(filename, "w")
        if newFile then
            for key, value in pairs(settings) do
                newFile:write(key .. "=" .. value .. "\n")
            end
            newFile:close()
            print("Settings saved to:", filename)
        else
            print("Failed to create settings file:", filename)
        end
    end

    return settings
end

-- Function to perform a scan with the configured scan radius and search for a list of ores
function performScanWithOreListAndSettings(oreList, settings)
    local scanRadius = tonumber(settings["scanSize"]) or 16

    -- Perform the scan
    local scanResult, errorMsg = geoScanner.scan(scanRadius)

    -- Check if the scan was successful
    if scanResult then
        print("Scan successful!")

        -- Sort the scan result by distance
        table.sort(scanResult, function(a, b)
            local distA = math.sqrt(a.x^2 + a.y^2 + a.z^2)
            local distB = math.sqrt(b.x^2 + b.y^2 + b.z^2)
            return distA < distB
        end)

        -- Display information about the closest 3 ores or fewer if not enough are found
        local oresToShow = math.min(#scanResult, maxOresToShow)
        for i = 1, oresToShow do
            local blockInfo = scanResult[i]
            print("Ore found:", blockInfo.name)
            print("Coordinates:", blockInfo.x, blockInfo.y, blockInfo.z)
            print("Distance:", math.sqrt(blockInfo.x^2 + blockInfo.y^2 + blockInfo.z^2))
        end
    else
        print("Scan failed. Error:", errorMsg)
    end

    -- Output settings
    print("Current Settings:")
    for key, value in pairs(settings) do
        print(key .. "=" .. value)
    end
end

-- Function to add an ore to the list
function addOreToList(oreList)
    print("Enter the name of the ore to add:")
    local oreName = read()

    table.insert(oreList, oreName)

    -- Save the updated ore list to the file
    local oreListFile = io.open(oreListFileName, "a")
    if oreListFile then
        oreListFile:write(oreName .. "\n")
        oreListFile:close()
        print("Ore added to the list:", oreName)
    else
        print("Failed to add ore to the list.")
    end
end

-- Function to remove an ore from the list
function removeOreFromList(oreList)
    print("Select an ore to remove by typing its corresponding number:")

    for i, ore in ipairs(oreList) do
        print(i .. ". " .. ore)
        if i % maxOptionsPerScreen == 0 then
            print("Press Enter to see more options...")
            read()
        end
    end

    local selection = tonumber(read())

    if selection and selection >= 1 and selection <= #oreList then
        local removedOre = table.remove(oreList, selection)

        -- Save the updated ore list to the file
        local oreListFile = io.open(oreListFileName, "w")
        if oreListFile then
            for _, ore in ipairs(oreList) do
                oreListFile:write(ore .. "\n")
            end
            oreListFile:close()
            print("Ore removed from the list:", removedOre)
        else
            print("Failed to remove ore from the list.")
        end
    else
        print("Invalid selection. No changes made.")
    end
end

-- Function to handle user input and execute the corresponding action
function handleMenuSelection()
    local oreList = readOrCreateOreListFile(oreListFileName)
    local settings = readOrCreateSettingsFile(settingsFileName)

    local scanLoopActive = false

    while true do
        displayMenu()

        -- Get user input
        local choice = tonumber(read())

        -- Check user's choice
        if choice == 1 then
            performScanWithOreListAndSettings(oreList, settings)
        elseif choice == 2 then
            addOreToList(oreList)
        elseif choice == 3 then
            removeOreFromList(oreList)
        elseif choice == 4 then
            if not scanLoopActive then
                scanLoopActive = true
                print("Starting scan loop. Press 5 to stop.")
                repeat
                    performScanWithOreListAndSettings(oreList, settings)
                    os.sleep(cooldownTime)
                until os.pullEvent() == "key" and read() == "5"
                scanLoopActive = false
            else
                print("Scan loop is already active.")
            end
        elseif choice == 5 then
            print("Exiting Geo Scanner program.")
            break
        else
            print("Invalid choice. Please enter a valid option.")
        end
    end
end

-- Start the program
handleMenuSelection()
