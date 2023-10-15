dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

local function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()
    local action_name = 'rewgs - export MIDI for orchestration'

    -- OLD
    -- local total_num_tracks = reaper.CountTracks(0)
    -- local marked_tracks = get_marked_tracks(total_num_tracks)
    -- set_bounds_to_items {}
    -- export_marked_tracks(marked_tracks, total_num_tracks)

    -- NEW
    local tracks_marked_record = get_marked_tracks(track_marks.record)
    local tracks_marked_transcribe = get_marked_tracks(track_marks.transcribe)

    reaper.Undo_EndBlock(action_name, -1)
end

main()
