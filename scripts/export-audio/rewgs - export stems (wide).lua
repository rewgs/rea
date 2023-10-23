dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()
    local action_name = 'rewgs - export skinny stems'

    local exports_path = "./exports/" .. parse_project_name().exports_folder_name .. "/renders/"

    local stems = get_wide_stems(get_all_tracks_as_objects())
    local dst_dir = exports_path .. "stems - " .. stems.which

    -- TODO: make sure the `misc_text` property of `parsed_project_name` isn't in the name of the resulting assets
    local success = render_stems(stems, rt_stems, dst_dir, names.convention)

    reaper.Undo_EndBlock(action_name, -1)

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.")
    end

    return true
end

main()
-- reaper.Main_OnCommand(40004, 0) -- closes Reaper
