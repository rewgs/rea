local rewgs_modules = reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules"
local subdirs = reaper.EnumerateSubdirectories(rewgs_modules, -1)
for i, dir in ipairs(subdirs) do
    local files = reaper.EnumerateFiles(dir, -1)
    for i, file in ipairs(files) do
        reaper.ShowConsoleMsg(file)
        dofile(file)
    end
end


