-- local function reaDoFile(file)
--     local info = debug.getinfo(1, 'S')
--     local script_path = info.source:match [[^@?(.*[\/])[^\/]-$]] -- should this not be local?

--     dofile(script_path .. file)
-- end
-- reaDoFile("modules/helper-functions.lua")
-- reaDoFile("modules/mark.lua")

dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

local function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()
    local action_name = 'rewgs - export MIDI for orchestration'

    local total_num_tracks = reaper.CountTracks(0)
    local marked_tracks = get_marked_tracks(total_num_tracks)

    set_bounds_to_items {}

    export_marked_tracks(marked_tracks, total_num_tracks)

    reaper.Undo_EndBlock(action_name, -1)
end

main()
