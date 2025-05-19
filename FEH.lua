local socket = require("socket")
local json = require("dkjson") -- optional Lua JSON module

local log_path = os.getenv("HOME") .. "/feh_tick_telemetry.log"

local function quantum_entropy()
    return math.random(100, 300) + (socket.gettime() * 1000) % 100
end

local tick_interval = 1000 + quantum_entropy()
local last_tick = socket.gettime()

while true do
    local now = socket.gettime()
    if now - last_tick >= tick_interval / 1000 then
        last_tick = now
        tick_interval = 1000 + quantum_entropy()
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local event = {
            tick_time = timestamp,
            interval_ms = math.floor(tick_interval),
            feh_sync_mode = "manual", -- change to "pvp", "arena", etc
        }
        local entry = json.encode(event)
        print("[QuantumTick] " .. entry)

        local f = io.open(log_path, "a")
        if f then
            f:write(entry .. "\n")
            f:close()
        end
    end
end