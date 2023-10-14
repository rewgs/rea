function remove_rpp_from_string(s)
    local start_index_lower, end_index_lower = string.find(s, ".rpp")
    local start_index_upper, end_index_upper = string.find(s, ".RPP")

    if start_index_lower ~= nil and end_index_lower ~= nil then
        return s:gsub("%.rpp", "")
    end
    if start_index_upper ~= nil and end_index_upper ~= nil then
        return s:gsub("%.RPP", "")
    end
end

function parse_project_name(project_name, delimiter)
    local parts = {}
    local project_name_obj = {}

    -- local sep = delimiter or " "
    -- Removes whitespace from left and right of string
    local sep = delimiter:gsub("^%s*(.-)%s*$", "%1") or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(project_name, pattern, function(c) parts[#parts + 1] = c end)

    local previous_part = nil
    for i, part in ipairs(parts) do
        if previous_part ~= sep then
            -- Removes whitespace from left and right of string
            local stripped_part = part:gsub("^%s*(.-)%s*$", "%1")
            -- reaper.ShowConsoleMsg(i .. ": " .. stripped_part .. "\n")
            if i == 1 then
                project_name_obj.project_code = stripped_part
            elseif i == 2 then
                project_name_obj.cue_number = stripped_part
            elseif i == 3 then
                project_name_obj.cue_name = stripped_part
            elseif i == 4 then
                project_name_obj.cue_version = stripped_part
            elseif i == 5 then
                project_name_obj.misc_text = remove_rpp_from_string(stripped_part)
            else
                reaper.ShowConsoleMsg(
                    "This Reaper project's file name might not be following the correct naming convention. Potentially problematic part of the text: " ..
                    tostring(part[i]) .. ". Check the file name and then try again."
                )
            end
        end
        previous_part = part
    end

    project_name_obj.exports_folder_name = project_name_obj.project_code .. delimiter ..
                                           project_name_obj.cue_number .. delimiter ..
                                           project_name_obj.cue_name .. delimiter ..
                                           project_name_obj.cue_version

    -- debug
    -- for key, value in pairs(project_name_obj) do
    --     reaper.ShowConsoleMsg(key .. ": " .. value .. '\n')
    -- end

    return project_name_obj
end
