dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")

function main()
    recursively_traverse(get_all_tracks())
end
main()
