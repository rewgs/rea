-- command ids
track = {
    mute = 40730,
    -- unmute = 40731,
    set_all_fx_offline = 40535,
    -- set_all_fx_online = 40536,
}


function disable_track()
    reaper.Undo_BeginBlock(1)
    reaper.PreventUIRefresh(1)
    
    reaper.Main_OnCommand(track.mute, 0)
    reaper.Main_OnCommand(track.set_all_fx_offline, 0)
    
    local num_tracks = reaper.CountSelectedTracks(0)
    
    for i = 0, num_tracks - 1 do
      local selected_track = reaper.GetSelectedTrack(0, i)
      local num_items = reaper.CountTrackMediaItems(selected_track, i)
    
      for j = 0, num_items - 1 do
        item = reaper.GetTrackMediaItem(selected_track, j)
        reaper.SetMediaItemInfo_Value(item, 'C_LOCK', 1)
      end
    end
    
    reaper.Undo_EndBlock('disable-track', -1)
    reaper.UpdateArrange()
    reaper.PreventUIRefresh(-1)
end


disable_track()
