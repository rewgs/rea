local function reaDoFile(file)
    -- This is a function that enables single-line, relative path imports of other lua files.
    -- Written by Xenakios in this thread: https://forums.cockos.com/showthread.php?t=174073

    local info = debug.getinfo(1, 'S')
    local script_path = info.source:match [[^@?(.*[\/])[^\/]-$]] -- should this not be local?

    dofile(script_path .. file)
end
reaDoFile("modules/helper-functions.lua")
reaDoFile("modules/mark.lua")


local function get_marked_tracks(total_num_tracks)
    local marked_tracks = {}

    for i = 0, total_num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track)

        if is_marked(track_name, mark) then
            -- reaper.ShowConsoleMsg(track_name .. "\n")
            table.insert(marked_tracks, track_name)
        end
    end

    return marked_tracks
end


local function export_marked_tracks(marked_tracks, total_num_tracks)
    for i = 0, total_num_tracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetTrackName(track)
        -- reaper.ShowConsoleMsg("Current track: " .. track_name .. "\n")

        for j, marked_track in ipairs(marked_tracks) do
            if track_name == marked_track then
                reaper.SetTrackSelected(track, true)
            end
        end
    end

    -- File: Export project MIDI...
    reaper.Main_OnCommand(40849, 0)
end


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
