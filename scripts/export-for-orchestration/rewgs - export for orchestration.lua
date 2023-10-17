dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

local function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()
    local action_name = 'rewgs - export MIDI for orchestration'

    -- File: Save copy of project (automatically increment project name)
    -- reaper.Main_OnCommand(42346, 0)

    -- Get all tracks marked for orchestration
    local tracks_to_orchestrate = {}
    for _, track in ipairs(get_all_marked_tracks()) do
        if is_marked(track.name, track_marks.record) or is_marked(track.name, track_marks.transcribe) then
            table.insert(tracks_to_orchestrate, track)
        end
    end

    -- Remove duplicates from `tracks_to_orchestrate`, if any
    local tracks = remove_duplicates_from_table(tracks_to_orchestrate)

    -- TODO
    -- deactivate humanization MIDI plugins
    -- Item: apply track/take fx to items (midi output) 

    -- Check for empty or muted MIDI regions; delete
    -- for _, track in ipairs(tracks) do
    --     -- reaper.ShowConsoleMsg(track.name)
    --     local items = track.muted_media_items
    --     for _, item in ipairs(items) do
    --         -- FIXME: Why isn't this working?
    --         local deleted = reaper.DeleteTrackMediaItem(track.media_track, item.media_item)
    --         reaper.ShowConsoleMsg(tostring(deleted))
    --     end
    -- end

    set_bounds_to_items {}
    export_marked_tracks(tracks_to_orchestrate)

    -- TODO
    -- change the name of the new .rpp -- replace `_1` with ` - to orch` (perhaps replace misc text?)

    reaper.Undo_EndBlock(action_name, -1)
end

main()
