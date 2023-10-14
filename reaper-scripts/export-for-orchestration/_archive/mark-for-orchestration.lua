local function main()
    local action_name = 'rewgs - mark for orchestration'
    -- local mark = '#'

    reaper.Undo_BeginBlock()
    reaper.ClearConsole()

    local num_tracks = reaper.CountSelectedTracks(0)

    for i = 0, num_tracks - 1 do
        local selected_track = reaper.GetSelectedTrack(0, i)

        -- avoids folders; only appends `#` to children
        if is_child(selected_track) then
            local has_name, selected_track_name = reaper.GetTrackName(selected_track)
            if not is_marked(selected_track_name, mark) then
                local new_name = mark .. ' ' .. selected_track_name
                reaper.GetSetMediaTrackInfo_String(selected_track, "P_NAME", new_name, true)
            end
        end
    end

    reaper.Undo_EndBlock(action_name, -1)
end

main()
