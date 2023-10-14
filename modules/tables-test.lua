local tbl_hfs = require "tables"

local dict_like_table = {
    a = "1",
    b = "2",
    c = {
        "cat",
        "dog",
        "rat"
    },
    d = {
        e = "a value",
        f = "another val"
    }
}

local array_like_table = {
    "a",
    "b",
    "c"
}

-- local return_val_1, return_val_2 = tbl_hfs.recursively_search("cat", dict_like_table)
local return_val_1, return_val_2 = tbl_hfs.recursively_search("a", array_like_table)
print(return_val_1, return_val_2)
