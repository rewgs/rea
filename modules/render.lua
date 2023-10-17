-- dofile(reaper.GetResourcePath() .. "Scripts/rewgs-reaper-scripts/scripts/export-audio/modules/render-tables.lua")
dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/names.lua")


function print_render_table(rt)
    for key, value in pairs(rt) do
        reaper.ShowConsoleMsg(key .. ": " .. tostring(value) .. "\n")
    end
end

-- TODO: add error handling
-- https://www.lua.org/pil/8.4.html
function render(rt, dst_dir, naming_convention)
    -- reaper.ShowConsoleMsg("Running render()")
    local render_table = ultraschall.CreateNewRenderTable(
        rt.source, rt.bounds, rt.start_pos, rt.end_pos, rt.tail_flag, rt.tail_ms, dst_dir,
        rt.file_name, rt.sample_rate, rt.channels, rt.render_type, rt.project_sample_rate_fx_processing,
        rt.render_resample, rt.keep_mono, rt.keep_multichannel, rt.dither, rt.render_string,
        rt.silently_increment_filename, rt.add_to_proj, rt.save_copy_of_project, rt.render_queue_delay,
        rt.render_queue_delay_seconds, rt.close_after_render
    )

    -- This is conflicting with Jon's workflow; perhaps ask for user input?
    set_bounds_to_items {}

    -- This changes the current render settings, but doesn't kick off the render process
    retval, dirty = ultraschall.ApplyRenderTable_Project(render_table)

    -- This kicks off the render process
    -- args:
    -- optional string project filename_with_path (to the rpp-file that you want to render; nil, to render the current active project)
    -- optional table RenderTable: the RenderTable with all render-settings, that you want to apply; nil, use the project's existing settings
    -- optional boolean AddToProj: true, add the rendered files to the project; nil or false, don't add them; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed only has an effect, when rendering the current active project
    -- optional boolean CloseAfterRender: true or nil, closes rendering to file-dialog after rendering is finished; false, keep it open; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
    -- optional boolean SilentlyIncrementFilename; true or nil, silently increment filename, when file already exists; false, ask for overwriting; will overwrite the settings in the RenderTable; will default to true, if no RenderTable is passed
    count, media_item_state_chunk_array, file_array = ultraschall.RenderProject_RenderTable(nil, render_table, false, true, false)

    -- Track: Unselect (clear selection of) all tracks
    reaper.Main_OnCommand(40297, 0)

    return true
end


function render_mix(rt, dir, naming_convention)
    -- local dst_dir = dir .. "mixes"
    local success = render(rt, dir, naming_convention)

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end


-- NOTE: these are printed wet. Also need a dry option.
function render_stems(stems_table, rt, dir, naming_convention)
    -- reaper.ShowConsoleMsg("Running render_stems()")
    for i, stem in ipairs(stems_table) do
        reaper.SetTrackSelected(stem.media_track, true)
    end

    local success = render(rt, dir, naming_convention)

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
        return false
    else
        return true
    end
end


function render_regions(regions_table, rt, dir, naming_convention)
    local dst_dir = dir .. "all regions"
    render(rt, dst_dir, naming_convention)
end


-- Probably an unnecessary function. Really only useful for calling multiple render jobs in one go, 
-- but I think this is ultimately an unnecessary level of abstraction.
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
