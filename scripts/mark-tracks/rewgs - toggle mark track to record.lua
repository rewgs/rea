dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

local mark = 'REC'

local function main()
    local action_name = 'rewgs - toggle mark for record'
    reaper.Undo_BeginBlock()
    reaper.ClearConsole()

    toggle_mark_track(mark)

    reaper.Undo_EndBlock(action_name, -1)
end
main()
