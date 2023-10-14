function print_render_table(rt)
    for key, value in pairs(rt) do
        reaper.ShowConsoleMsg(key .. ": " .. tostring(value) .. "\n")
    end
end

function render(rt, dst_dir, file_naming_convention)
    local render_table = ultraschall.CreateNewRenderTable(
        rt.source, rt.bounds, rt.start_pos, rt.end_pos, rt.tail_flag, rt.tail_ms, dst_dir,
        rt.file_name, rt.sample_rate, rt.channels, rt.render_type, rt.project_sample_rate_fx_processing,
        rt.render_resample, rt.keep_mono, rt.keep_multichannel, rt.dither, rt.render_string,
        rt.silently_increment_filename, rt.add_to_proj, rt.save_copy_of_project, rt.render_queue_delay,
        rt.render_queue_delay_seconds, rt.close_after_render
    )

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
end


function render_mix(rt, dir, file_naming_convention)
    local dst_dir = dir .. "mixes"
    render(rt, dst_dir, file_naming_convention)
end


-- NOTE: these are printed wet. Also need a dry option.
function render_stems(stems_table, rt, dir, file_naming_convention)
    -- reaper.ShowConsoleMsg("Running render_stems()")
    local dst_dir = dir .. "stems - " .. stems_table.which
    -- reaper.ShowConsoleMsg(dst_dir)

    for i, stem in ipairs(stems_table) do
        reaper.SetTrackSelected(stem.media_track, true)
    end

    render(rt, dst_dir, file_naming_convention)
end


function render_regions(regions_table, rt, dir, file_naming_convention)
    local dst_dir = dir .. "all regions"
    -- render(rt, dst_dir, file_naming_convention)
end
