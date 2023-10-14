function is_child(track)
    if reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") == 1 then
        return false
    else
        return true
    end
end

function is_marked(subject, pattern)
    local start_index, end_index = string.find(subject, pattern)
    if start_index ~= nil and end_index ~= nil then
        return true
    else
        return false
    end
end


-- NOTE: this was copied verbatim from export-audio/modules/helper-functions.lua.
-- I hate this function. It's huge and ugly. Worse, having two copies of the same function is 
-- horrible form and is just asking for conflicts. 
-- I commit this sin in the name of time :)
-- I only copied this function because set_bounds_to_items() needs it.
-- TODO: fix all that shit! ^
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

-- NOTE: this was copied verbatim from export-audio/modules/helper-functions.lua.
-- I hate this function. It's huge and ugly. Worse, having two copies of the same function is 
-- horrible form and is just asking for conflicts. 
-- I commit this sin in the name of time :)
-- TODO: fix all that shit! ^
function set_bounds_to_items(args)
    -- args
    audio = args.audio or true                                                              -- default: true
    click = args.click or false                                                             -- default: false
    empty = args.empty or false                                                             -- default: false
    midi = args.midi or true                                                                -- default: true
    video = args.video or false                                                             -- default: false
    ignore_movie_folder = args.ignore_movie_folder or true                                  -- default: true
    clear_track_selection_after_running = args.clear_track_selection_after_running or false -- default: false

    -- Transport: Stop
    reaper.Main_OnCommand(1016, 0)

    -- 'Script: Track Visibility - Show all tracks.lua'
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_RSdf5deea70710b2bb6a464cbab98fb628980c0ab1"), 0)

    ----------------------------------------------------------------------------
    -- type selection
    ----------------------------------------------------------------------------

    -- SWS/BR: Select all audio items
    if audio then reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ALL_ITEMS_AUDIO"), 0) end

    -- SWS/BR: Select all click source items
    if click then reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ALL_ITEMS_CLICK"), 0) end

    -- SWS/BR: Select all empty items
    if empty then reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ALL_ITEMS_EMPTY"), 0) end

    -- SWS/BR: Select all MIDI items
    if midi then reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ALL_ITEMS_MIDI"), 0) end

    -- _BR_SEL_ALL_ITEMS_VIDEO
    if video then reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ALL_ITEMS_VIDEO"), 0) end

    ----------------------------------------------------------------------------
    -- ignore_movie_folder
    ----------------------------------------------------------------------------
    if ignore_movie_folder then
        local total_num_tracks = reaper.CountTracks(0)

        for i = 0, total_num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local _, track_name = reaper.GetTrackName(track)

            -- 0 = normal, 1 = track is a folder parent, -1 = track is the last in the innermost
            -- folder, -2 = track is the last in the innermost and next-innermost folders, etc...
            local depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
            local parent_track = reaper.GetMediaTrackInfo_Value(track, "P_PARTRACK")
            local parent_track_name = get_parent_track_name(parent_track)

            if track_name == "Movie" and depth == 1 then
                reaper.SetTrackSelected(track, false)
                local num_media_items = reaper.CountTrackMediaItems(track)

                for j = 0, num_media_items - 1 do
                    local item = reaper.GetTrackMediaItem(track, j)

                    -- B_UISEL : bool * : selected in arrange view
                    if reaper.GetMediaItemInfo_Value(item, "B_UISEL") then
                        reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
                    end
                end
            end

            if parent_track_name == "Movie" then
                reaper.SetTrackSelected(track, false)
                local num_media_items = reaper.CountTrackMediaItems(track)

                for j = 0, num_media_items - 1 do
                    local item = reaper.GetTrackMediaItem(track, j)

                    -- B_UISEL : bool * : selected in arrange view
                    if reaper.GetMediaItemInfo_Value(item, "B_UISEL") then
                        reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
                    end
                end
            end
        end
    end

    ----------------------------------------------------------------------------
    -- continue
    ----------------------------------------------------------------------------

    -- 'Time selection: Set time selection to items'
    reaper.Main_OnCommand(40290, 0)

    -- FIXME: maybe change this to "show only selected tracks?" or "show only tracks with selected items?"
    -- 'Script: Track Visibility - Show only tracks with items.lua'
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS18025988e0ed4e2830abe9a10d91e47698d54b71"), 0)

    -- Item: Unselect (clear selection of) all items
    reaper.Main_OnCommand(40289, 0)

    if clear_track_selection_after_running then
        -- Track: Unselect (clear selection of) all tracks
        reaper.Main_OnCommand(40297, 0)
    end

    -- Go to start of time selection
    reaper.Main_OnCommand(40630, 0)
end
