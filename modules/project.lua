-- TODO: FINISH ME
function confirm_project_name_parsing(project_name_obj)
    -- Get values from the user.
    --
    -- If a caption begins with *, for example "*password", the edit field will not display the input text.
    -- Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the
    -- user canceled the dialog. You can supply special extra information via additional caption
    -- fields: extrawidth=XXX to increase text field width, separator=X to use a different separator
    -- for returned fields.
    --
    -- Lua: boolean retval, string retvals_csv = reaper.GetUserInputs(string title, integer num_inputs, string captions_csv, string retvals_csv)
    local user_input, retvals_csv = reaper.GetUserInputs(string "Please confirm project name parsing before continuing.",
        num_inputs, captions_csv, retvals_csv)
end
