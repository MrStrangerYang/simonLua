-- rime.lua

-- Define a global variable for the log file path
local log_file_path = "./log/file.log"

-- Function to log messages
function log_message(message)
    local file = io.open(log_file_path, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
        file:close()
    else
        print("Failed to open log file: " .. log_file_path)
    end
end

-- Example usage: log a message
log_message("Rime Lua script initialized.")
