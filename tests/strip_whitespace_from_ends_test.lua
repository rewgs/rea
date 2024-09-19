dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

-- function strip_whitespace_from_ends(str)
--     return str:gsub("^%s*(.-)%s*$", "%1")
-- end

function main()
    local test_string = "   something      "
    reaper.ShowConsoleMsg(strip_whitespace_from_ends(test_string).. "else")
end
main()
