A collection of hopefully useful Reaper scripts.

# Notes
- Files in `scripts` are meant to be called by the user.
- Files in `modules` are referenced by the files in `scripts`, and thus are not intended to be touched by the user. These will eventually be split out into their own repo.

# Installation
- Install the Ultraschall API -- it's a required dependency.
- Download this repo and place it in your `REAPER/Scripts` folder. 
    - The full path should be `REAPER/Scripts/rewgs-reaper-scripts`.
    - Note that the downloaded .zip might be called something other than `rewgs-reaper-scripts,` such as `rewgs-reaper-scripts-main`. If so, rename it to `rewgs-reaper-scripts` prior to copying it to `REAPER/Scripts`.

# Known issues
- `rewgs - export stems - wide - wet - include silent.lua`
    - Issue: Any skinny stems with duplicate names (e.g. Violin I underneath a Ensemble Long folder, and another Violin I underneath a Ensemble Short folder) will be exported as xxx-001 and xxx-002 (e.g. Violin I-001 and Violin I-002 for long and short, respectively).
    - Planned fix: The name of the parent folder will be appended to the resulting stem name (e.g. Violin I Ensemble Long and Violin I Ensemble Short, respectively).
