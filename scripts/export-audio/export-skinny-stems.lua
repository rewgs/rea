-- dofile(reaper.GetResourcePath() .. "/UserPlugins/ultraschall_api.lua")
dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function main()
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()
    local action_name = 'rewgs - export skinny stems'

    local parsed_project_name = parse_project_name()
    local exports_folder = parsed_project_name.exports_folder_name

    -- TODO: make sure the `misc_text` property of `parsed_project_name` isn't in the name of the resulting assets
    render_assets(exports_folder)

    reaper.Undo_EndBlock(action_name, -1)
end
main()
-- reaper.Main_OnCommand(40004, 0) -- closes Reaper
