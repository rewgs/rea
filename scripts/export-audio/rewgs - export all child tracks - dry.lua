-- Export every non-parent/folder track
-- Put in file name: name of skinny stem (i.e. folder track that outputs to Music Sub Mix)
-- NOTE: ALSO do this DRY

dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()

    local action_name = 'rewgs - export all child tracks - dry'

    local exports_path = "./exports/" .. parse_project_name().exports_folder_name .. "/renders/"
    local dst_dir = exports_path .. "all child tracks - " .. " - dry"

    mute_effects()

    -- args are parent tracks to ignore i.e. not include them or their child tracks in `child_tracks`
    -- TODO: This currently only ignores immediate non-folder children of the ignored parent; folders under parent are not ignored.
    local child_tracks = get_all_child_tracks({"Movie", "Effects"})

    -- debug
    -- for _, track in ipairs(child_tracks) do
    --     reaper.ShowConsoleMsg(track.name .. "\n")
    -- end

    -- local success = render_stems(child_tracks, rt_stems, dst_dir)

    reaper.Undo_EndBlock(action_name, -1)

    if success ~= true then
        -- TODO: This is temporary. Handle this better.
        reaper.ShowConsoleMsg("There was a problem printing.\n")
    end

    return true
end
main()
