function get_current_project_path()
    local proj, str = reaper.EnumProjects(-1, "")
    return str
end

function get_project_info_as_obj()
    local project_name = reaper.GetProjectName(0)
    local project, project_path = reaper.EnumProjects(-1, "")
    -- local project_path = get_current_project_path() -- full path, including .rpp project name

    local project_info_obj = {
        name = project_name,
        path = project_path,
        dir = project_path:gsub(project_name, "") -- full path, minus .rpp project name
        -- dir = project_dir
    }

    return project_info_obj
end

-- TODO: FINISH ME
-- function confirm_project_name_parsing(project_name_obj)
    -- Get values from the user.
    --
    -- If a caption begins with *, for example "*password", the edit field will not display the input text.
    -- Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the
    -- user canceled the dialog. You can supply special extra information via additional caption
    -- fields: extrawidth=XXX to increase text field width, separator=X to use a different separator
    -- for returned fields.
    --
    -- Lua: boolean retval, string retvals_csv = reaper.GetUserInputs(string title, integer num_inputs, string captions_csv, string retvals_csv)

    -- local user_input, retvals_csv = reaper.GetUserInputs(
        -- string "Please confirm project name parsing before continuing.",
        -- num_inputs, captions_csv, retvals_csv
    -- )
-- end
