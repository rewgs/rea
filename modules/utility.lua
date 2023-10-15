-- This is a function that enables single-line, relative path imports of other lua files.
-- Written by Xenakios in this thread: https://forums.cockos.com/showthread.php?t=174073
local function reaDoFile(file)
    local info = debug.getinfo(1, 'S')
    local script_path = info.source:match [[^@?(.*[\/])[^\/]-$]]
    dofile(script_path .. file)
end
-- reaDoFile("modules/file-hierarchy.lua")
-- reaDoFile("modules/helper-functions.lua")
-- reaDoFile("modules/render-tables.lua")
-- reaDoFile("modules/render-functions.lua")
