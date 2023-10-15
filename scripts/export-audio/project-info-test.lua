dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

-- local project_name = reaper.GetProjectName(0)
-- local project_path = get_current_project_path() -- full path, including .rpp project name
-- local project_dir = get_current_project_path():gsub(project_name, "") -- full path, minus .rpp project name

local project = get_project_info_as_obj()
reaper.ShowConsoleMsg(project.name)
