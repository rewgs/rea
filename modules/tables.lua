-- Searches for `search_term`, which is presumably an element of an array-like table, or a value of a dict-like table.
-- Returns two values, depending on one of these outcomes:
--  1. If `search_term` is a bad type (i.e. a table):
--      a. return val 1 is `nil`
--      b. return val 2 is an error message.
--  2. If `search_term`  is a valid type (i.e. not a table):
--      a. return val 1 is a bool for whether `search_term` exists in `input`
--      b. if return val 1 is true, return val 2 is the index of `search_term`; if return val 1 is false, return val 2 is nil
local function recursively_search(search_term, input)
    local function is_array(tbl)
        local i = 0
        for _ in pairs(tbl) do
            i = i + 1
            if tbl[i] == nil then return false end
        end
        return true
    end

    assert (search_term ~= nil, "arg1 should not be nil!")
    assert (type(search_term) ~= "table", search_term .. " should not be a table!")

    if type(input) == "table" then
        print("input is a table")
        if not is_array(input) then     -- dict-like table
            print("input is a dict-like table")
            local index = {}
            for k, v in pairs(table) do
                if type(v) ~= "table" then
                    index[v] = k
                    if v == search_term then
                        return true, index[v]
                    end
                else
                    recursively_search(search_term, v)
                end
            end
            return false, nil
        elseif is_array(input) then     -- array-like table
            print("input is an array-like table")
            for i, t in ipairs(table) do
                if type(t) ~= "table" then
                    if t == search_term then
                        return true, i
                    end
                else
                    recursively_search(search_term, t)
                end
            end
            return false, nil
        else
            -- TODO: needs more graceful exit with error message, etc
            -- This indicates that something very strange went wrong. Should never run.
            return
        end
    end
end


return {
    recursively_search = recursively_search
}
