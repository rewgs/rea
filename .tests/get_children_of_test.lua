dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function main()
    local all_tracks = get_all_tracks_as_objects()
    for _, track in ipairs(all_tracks) do
        -- reaper.ShowConsoleMsg(track.index .. ": " .. track.name .. "\n")
        if track.name == "Woodwinds" and track.depth == 1 then
            -- get_children_of(track)
            for i, child in ipairs(get_children_of(track)) do
                reaper.ShowConsoleMsg(child.name .. "\n")
            end
        end
    end

end

main()
