local function reaDoFile(file)
    local info = debug.getinfo(1, 'S')
    local script_path = info.source:match [[^@?(.*[\/])[^\/]-$]] -- should this not be local?
    dofile(script_path .. file)
end
reaDoFile("modules/helper-functions.lua")


local record = 'REC'
local transcribe = 'TR'
local improve = 'IM'


local function main()
    local action_name = 'rewgs - toggle mark for record'
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()

    -- run code here
    toggle_mark_track(record)

    reaper.Undo_EndBlock(action_name, -1)
end

main()
