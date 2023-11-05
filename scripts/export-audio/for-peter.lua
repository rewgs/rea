dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function check_if_ancestor(args)
    local all_tracks = args.all_tracks
    local current_child = args.child
    local potential_ancestor = args.potential_ancestor
    local original_child = args.original_child

    local child_parent_name = get_parent_track_name(current_child.parent)
    if child_parent_name ~= nil then
        if current_child.parent == potential_ancestor.media_track then
            local retvals = {
                true,
                original_child,
                potential_ancestor
            }
            reaper.ShowConsoleMsg(tostring(retvals[1]) .. "\n")
            return retvals
        else
            for _, track in ipairs(all_tracks) do
                if track.media_track == current_child.parent then
                    local new_args = {
                        all_tracks = all_tracks,
                        child = track,
                        potential_ancestor = potential_ancestor,
                        original_child = original_child
                    }
                    check_if_ancestor(new_args)
                end
            end
        end
    end

    local retvals = {
        false,
        original_child,
        potential_ancestor
    }
    reaper.ShowConsoleMsg(tostring(retvals[1]) .. "\n")
    return retvals
end

function get_relatives(all_tracks, children, potential_ancestors)
    local relatives = {}
    for _, c in ipairs(children) do
        for _, p in ipairs(potential_ancestors) do
            local args = {
                all_tracks = all_tracks,
                child = c,
                potential_ancestor = p,
                original_child = c
            }
            local retvals = check_if_ancestor(args)
            reaper.ShowConsoleMsg(tostring(retvals[1]) .. "\n")
        end
    end
    return relatives
end

function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()

    local action_name = 'rewgs - export all child tracks - dry'

    local exports_path = "./exports/" .. parse_project_name().exports_folder_name .. "/renders/"
    local dst_dir = exports_path .. "all child tracks - dry"

    mute_effects()

    local all_tracks = get_all_tracks_as_objects()
    local child_tracks = get_all_child_tracks({ "Movie", "Effects" })
    local skinny_stems = get_skinny_stems(all_tracks)

    local relatives = get_relatives(all_tracks, child_tracks, skinny_stems)

    -- can't use this due to naming scheme...
    -- local success = render_stems(child_tracks, rt_stems_for_mixer, dst_dir)

    -- reaper.Undo_EndBlock(action_name, -1)

    -- if success ~= true then
    -- TODO: This is temporary. Handle this better.
    -- reaper.ShowConsoleMsg("There was a problem printing.\n")
    -- end

    -- return true
end

main()
log_file:close()
