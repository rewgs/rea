-- dofile(reaper.GetResourcePath() .. "Scripts/rewgs-reaper-scripts/scripts/export-audio/modules/render-tables.lua")
dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/misc.lua")
dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/names.lua")


function print_render_table(rt)
    for key, value in pairs(rt) do
        reaper.ShowConsoleMsg(key .. ": " .. tostring(value) .. "\n")
    end
end

-- TODO: add error handling.
--
-- TODO: strip leading and trailing whitespace from track names. Maybe don't do it in this function, 
-- but also maybe do it here? Wrote a function for this in `misc.lua` but it's not working with 
-- track names, even though it's working in the test file (in `.tests/`)...why?
-- https://www.lua.org/pil/8.4.html
--
-- NOTE: Changed this function to taking a single parameter table called `args`. Keeping the old 
-- declaration with its parameters here for reference.
--
-- function render(rt, dst_dir, file_name_arg, keep_silent_arg)
function render(args)
    local rt = args.rt
    local dst_dir = args.dst_dir
    local file_name = args.file_name or rt.file_name
    local keep_silent = args.keep_silent or false

    local render_table = ultraschall.CreateNewRenderTable(
        rt.source, rt.bounds, rt.start_pos, rt.end_pos, rt.tail_flag, rt.tail_ms, dst_dir,
        file_name, rt.sample_rate, rt.channels, rt.render_type,
        rt.project_sample_rate_fx_processing, rt.render_resample, rt.keep_mono, rt.keep_multichannel,
        rt.dither, rt.render_string, rt.silently_increment_filename, rt.add_to_proj,
        rt.save_copy_of_project, rt.render_queue_delay, rt.render_queue_delay_seconds, rt.close_after_render
    )

    -- This is conflicting with Jon's workflow; perhaps ask for user input?
    if keep_silent == true then
        set_bounds_to_items {empty = true}
    else
        -- Like render(), set_bounds_to_items() takes a table called `args` for easier passing of named arguments.
        -- Calling it with an empty `{}` denotes that all of the default parameter values will be used.
        -- For more, see here: https://www.lua.org/pil/5.3.html 
        -- (If the link above ends up invalid at any point, it's "Programming in Lua" Chapter 5.3: "Named Arguments")
        set_bounds_to_items {}
    end

    -- This changes the current render settings, but doesn't kick off the render process
    retval, dirty = ultraschall.ApplyRenderTable_Project(render_table)

    -- This kicks off the render process
    -- args:
    -- optional string project filename_with_path (to the rpp-file that you want to render; nil, to render the current active project)
    -- optional table RenderTable: the RenderTable with all render-settings, that you want to apply; nil, use the project's existing settings
    -- optional boolean AddToProj: true, add the rendered files to the project; nil or false, don't add them; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed only has an effect, when rendering the current active project
    -- optional boolean CloseAfterRender: true or nil, closes rendering to file-dialog after rendering is finished; false, keep it open; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
    -- optional boolean SilentlyIncrementFilename; true or nil, silently increment filename, when file already exists; false, ask for overwriting; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
    count, media_item_state_chunk_array, file_array = ultraschall.RenderProject_RenderTable(
        nil, render_table, false, true, false
    )

    -- Track: Unselect (clear selection of) all tracks
    reaper.Main_OnCommand(40297, 0)

    return true
end

function render_mix(rt, dir)
    -- local dst_dir = dir .. "mixes"
    -- local success = render(rt, dir)
    local success = render{rt=rt, dst_dir=dir}

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end

function render_mix_minus(rt, dir, file_name)
    -- local success = render(rt, dir, file_name)
    local success = render{rt=rt, dst_dir=dir, file_name=file_name}

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end

function render_stems(stems_table, rt, dir)
    -- reaper.ShowConsoleMsg("Running render_stems()")
    for i, stem in ipairs(stems_table) do
        -- Note: this is ALL wide stems, including those that are muted/don't have items/etc
        -- reaper.ShowConsoleMsg(stem.name .. "\n")
        reaper.SetTrackSelected(stem.media_track, true)
    end

    -- local success = render(rt, dir)
    local success = render{rt=rt, dst_dir=dir}

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end

function render_stems_keep_silent(stems_table, rt, dir)
    -- reaper.ShowConsoleMsg("Running render_stems()")
    for i, stem in ipairs(stems_table) do
        -- Note: this is ALL wide stems, including those that are muted/don't have items/etc
        -- reaper.ShowConsoleMsg(stem.name .. "\n")
        reaper.SetTrackSelected(stem.media_track, true)
    end

    -- function render(rt, dst_dir, file_name_arg, keep_silent_arg)
    local success = render{rt=rt, dst_dir=dir, keep_silent_arg=true}

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end

function render_regions(regions_table, rt, dir)
    local dst_dir = dir .. "all regions"
    -- render(rt, dst_dir)
    render{rt=rt, dst_dir=dst_dir}
end

-- Probably an unnecessary function. Really only useful for calling multiple render jobs in one go,
-- but I think this is ultimately an unnecessary level of abstraction.
-- THOUGH, maybe re-use this by reading jobs/what files are copied to each recipient's directory?
-- function render_assets(exports_folder)
--     local dst_dir = "./exports/" .. exports_folder .. "/renders/"
--     local renders = {
--         render_mix(rt_master_mp3, dst_dir, naming_convention),
--         render_mix(rt_master_wav, dst_dir, naming_convention),
--         render_stems(get_skinny_stems(get_all_tracks_as_objects()), rt_stems, dst_dir, names.convention),
--         render_stems(get_wide_stems(all_tracks), rt_stems, dst_dir, naming_convention),
--         render_regions(get_unmuted_regions(all_tracks), rt_regions, dst_dir, naming_convention),
--         render(video, dst_dir, naming_convention)
--     }
--     -- `job` represents the current element of the table being looped over;
--     -- lua allows you to call it by adding `()` if the element is a function
--     for i, job in ipairs(renders) do
--         job()
--     end
-- end
