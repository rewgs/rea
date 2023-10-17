dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

local function main()
    local p = parse_project_name()
    -- reaper.ShowConsoleMsg(#p)
    -- reaper.ShowConsoleMsg(p.cue_name)
    for k, v in pairs(p) do
        reaper.ShowConsoleMsg(k .. ": " .. v .. '\n')
    end
end
main()
