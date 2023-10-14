function get_parent_track_name(parent_track)
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)

        if track == parent_track then
            local _, track_name = reaper.GetTrackName(track)
            if track_name ~= nil then
                -- reaper.ShowConsoleMsg(track_name .. "\n")
                return track_name
            end
        end
    end
end

function create_named_audio_click_track()
    local function get_click_tracks()
        total_num_tracks = reaper.CountTracks(0)
        click_tracks = {}
        for i = 0, total_num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local _, track_name = reaper.GetTrackName(track)

            if track_name == "Click" then
                table.insert(click_tracks, track)
            end
        end
        return click_tracks
    end

    local function confirm_only_one_click_track(click_tracks)
        local function delete_final_tracks_with_no_name(total_num_tracks)
            for i = 0, total_num_tracks - 1 do
                local track = reaper.GetTrack(0, i)
                local _, track_name = reaper.GetTrackName(track)
                local track_num = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
                -- FIX ME: would prefer to do this this way, but need to remove the `.0` from the end of track_num
                -- local empty = "Track " .. tostring(track_num)
                local empty = "Track " .. tostring(total_num_tracks)
                if track_name == empty then
                    reaper.DeleteTrack(track)
                    total_num_tracks = reaper.CountTracks(0)
                    delete_final_tracks_with_no_name(total_num_tracks)
                end
            end
        end

        -- first, get rid of any tracks that have been added but not yet named "Click"
        -- operates only on all the final tracks with no name
        total_num_tracks = reaper.CountTracks(0)
        delete_final_tracks_with_no_name(total_num_tracks)

        if #click_tracks == 0 then
            -- create track called "Click"
            reaper.InsertTrackAtIndex(total_num_tracks, true)
            local total_num_tracks = reaper.CountTracks(0)
            local click_track = reaper.GetTrack(0, total_num_tracks - 1)
            reaper.GetSetMediaTrackInfo_String(click_track, "P_NAME", "Click", true)
            -- return true
        end
        if #click_tracks > 1 then
            for i, track in ipairs(click_tracks) do
                local _, track_name = reaper.GetTrackName(track)
                reaper.DeleteTrack(track)
            end
        end
        return true
    end

    local function create_click_source()
        local total_num_tracks = reaper.CountTracks(0)
        for i = 0, total_num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local _, track_name = reaper.GetTrackName(track)

            if track_name == "Click" then
                set_bounds_to_items { clear_track_selection_after_running = true }
                reaper.SetOnlyTrackSelected(track)

                -- 'Insert click source' (i.e. print click to audio)
                reaper.Main_OnCommand(40013, 0)
            end
        end
    end

    -- I shouldn't need this but in the interest of getting this to work quickly...
    local function rename_final_track_to_click()
        local total_num_tracks = reaper.CountTracks(0)

        for i = 0, total_num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local _, track_name = reaper.GetTrackName(track)
            -- FIX ME: would prefer to do this this way, but need to remove the `.0` from the end of track_num
            -- local track_num = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
            -- if track_name == "Track " .. tostring(track_num) then
            local empty = "Track " .. tostring(total_num_tracks)
            if track_name == empty then
                reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Click", true)
            end
        end
    end

    local function make_click_track_first_track()
        local total_num_tracks = reaper.CountTracks(0)
        for i = 0, total_num_tracks - 1 do
            local track = reaper.GetTrack(0, i)

            -- FIXME: these have decimals, need to not in order for this to work
            local track_num = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
            -- if track_name == "Click" then
            --     reaper.SetMediaTrackInfo_Value(track, "IP_TRACKNUMBER", 1)
            -- end
        end
    end

    click_tracks = get_click_tracks()

    if confirm_only_one_click_track(click_tracks) then
        create_click_source()
        rename_final_track_to_click()
        -- make_click_track_first_track()
    end
end

function get_all_tracks_as_objects()
    -- returns all tracks in project as an object with the following properties:
    -- media_track
    -- number
    -- name
    -- depth
    -- parent
    -- num_media_items
    -- unmuted_media_items {
    -- { media_item, index }
    -- }
    -- muted_media_items {
    -- { media_item, index }
    -- }

    local all_tracks = {}

    for i = 0, reaper.CountTracks(0) - 1 do
        local media_track = reaper.GetTrack(0, i)

        -- 0 = normal
        -- 1 = track is a folder parent
        -- -1 = track is the last in the innermost folder,
        -- -2 = track is the last in the innermost and next-innermost folders, etc...
        local depth = reaper.GetMediaTrackInfo_Value(media_track, "I_FOLDERDEPTH")
        local _, track_name = reaper.GetTrackName(media_track)
        local parent = reaper.GetMediaTrackInfo_Value(media_track, "P_PARTRACK")
        local num_media_items = reaper.CountTrackMediaItems(media_track)

        local unmuted_media_items = {}
        local muted_media_items = {}
        for m = 0, num_media_items - 1 do
            local media_item = reaper.GetMediaItem(0, m)
            local mute_state = reaper.GetMediaItemInfo_Value(media_item, "B_MUTE_ACTUAL")

            local unmuted_media_item_obj = {}
            local muted_media_item_obj = {}
            if mute_state == false then
                unmuted_media_item_obj.media_item = media_item
                unmuted_media_item_obj.index = m
                table.insert(unmuted_media_items, unmuted_media_item_obj)
            else
                muted_media_item_obj.media_item = media_item
                muted_media_item_obj.index = m
                table.insert(muted_media_items, muted_media_item_obj)
            end
        end

        local track_obj = {
            media_track = media_track,
            number = i,
            name = track_name,
            depth = depth,
            parent = parent,
            num_media_items = num_media_items,
            unmuted_media_items = unmuted_media_items,
            muted_media_items = muted_media_items
        }

        table.insert(all_tracks, track_obj)
    end

    return all_tracks
end

function get_skinny_stems(all_tracks)
    local skinny_stems = {}
    skinny_stems.which = "skinny"

    for i, track in ipairs(all_tracks) do
        local parent_track_name = get_parent_track_name(track.parent)

        -- Lua lacks a `continue` statement, so the if/then branch here effectively `continue`s past
        -- `parent_track_name`s with a value of `nil`.
        --
        if parent_track_name ~= nil then
            if parent_track_name == "Music Sub Mix" then
                if track.name ~= "Orchestra" and track.name ~= "Effects" then
                    table.insert(skinny_stems, track)
                end
            elseif parent_track_name == "Orchestra" then
                table.insert(skinny_stems, track)
            end
        end
    end

    return skinny_stems
end

function get_next_track_obj(current_track, all_tracks)
    local next_track = reaper.GetTrack(0, current_track.number + 1)

    for i, track in ipairs(all_tracks) do
        if next_track == track.media_track then
            return track
        end
    end
end

function get_child_folder_tracks_of(parent_folder_track, next_folder_track, all_tracks)
    local child_folder_tracks = {}

    local next_track = get_next_track_obj(parent_folder_track, all_tracks)
    -- reaper.ShowConsoleMsg(next_track.name)

    -- This loops through all the parent folder track's children
    -- for i = next_track.number, i < next_folder_track.number, i += 1
    -- reaper.ShowConsoleMsg()
    -- end

    -- for i, track in ipairs(all_tracks) do
    -- end


    -- for i, track in ipairs(all_tracks) do
    --     if track.media_track == parent_folder_track.media_track then
    --         -- This is the next track immediately after parent_folder_track.
    --         local current_track = all_tracks[i+1]
    --         -- reaper.ShowConsoleMsg("The track immediately after " .. parent_folder_track.name .. " is " .. current_track.name .. "\n.")
    --         reaper.ShowConsoleMsg("The depth of " .. current_track.name .. " is " .. current_track.depth .. ".\n")

    --         if current_track.depth == 1 then
    --             table.insert(child_folder_tracks, current_track)
    --         end

    --     end
    -- end
end

function get_wide_stems(all_tracks)
    local wide_stems = {}
    wide_stems.which = "wide"

    -- This will gather some tracks that don't belong in the final `wide_stems` table
    local candidates = {}
    for i, track in ipairs(all_tracks) do
        if track.depth < 0 then
            table.insert(candidates, track.parent)
        end
    end

    for i, track in ipairs(all_tracks) do
        for j, candidate in ipairs(candidates) do
            if track.media_track == candidate then
                table.insert(wide_stems, track)
            end
        end
    end

    -- This removes the tracks that don't belong
    for i, stem in ipairs(wide_stems) do
        if stem.name == "Movie" or stem.name == "Effects" then
            table.remove(wide_stems, i)
        end
    end

    -- for i, stem in ipairs(wide_stems) do
    -- reaper.ShowConsoleMsg(stem.name .. "\n")
    -- end

    return wide_stems
end


function get_tracks_to_print()
    local tracks_to_print = {}

    for t = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, t)

        -- 0 = normal, 1 = track is a folder parent, -1 = track is the last in the innermost folder,
        -- -2 = track is the last in the innermost and next-innermost folders, etc...
        local depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
        local _, track_name = reaper.GetTrackName(track)
        local num_media_items = reaper.CountTrackMediaItems(track)
        local parent_track = reaper.GetMediaTrackInfo_Value(track, "P_PARTRACK")
        local parent_track_name = get_parent_track_name(parent_track)

        if (depth <= 0) and (num_media_items > 0) and (parent_track_name ~= "Movie") then
            local num_muted_media_items = 0

            for i = 0, num_media_items - 1 do
                local media_item = reaper.GetTrackMediaItem(track, i)
                local mute_state = reaper.GetMediaItemInfo_Value(media_item, "B_MUTE")

                -- Since `mute_state` == 0 for unmuted and 1 for muted, the following line simply
                -- adds the number of muted media items, i.e. `num_muted_media_items = num_muted_media_items + 1`
                num_muted_media_items = num_muted_media_items + mute_state
            end

            -- reaper.ShowConsoleMsg(track_name .. " has " .. tostring(num_muted_media_items) .. " muted media items out of a total of " .. tostring(num_media_items) .. ".\n")
            if num_muted_media_items < num_media_items then
                table.insert(tracks_to_print, track_name)
            end
        end
    end

    return tracks_to_print
end

function search_up_family_tree(track, table)
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local parent_track = reaper.GetMediaTrackInfo_Value(track, "P_PARTRACK")

        for i, t in ipairs(table) do
            if t == parent_track then
                local parent_track_name = get_parent_track_name(parent_track)
                -- reaper.ShowConsoleMsg(parent_track_name .. "\n")
                -- return parent_track
            end

            -- search_up_family_tree(parent_track, table)
        end
    end
end
