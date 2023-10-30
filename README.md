A collection of hopefully useful Reaper scripts.

Note: Files in `scripts` are meant to be called by the user. Files in `modules` are referenced by the files in `scripts`, and thus are not intended to be touched by the user; these will eventually be split out into their own repo.

# Installation
- Install the Ultraschall API -- it's a required dependency.
- Download this repo and place it in your `REAPER/Scripts` folder. 
    - The full path should be `REAPER/Scripts/rewgs-reaper-scripts`.
    - Note that the downloaded .zip might be called something other than `rewgs-reaper-scripts,` such as `rewgs-reaper-scripts-main`. If so, rename it to `rewgs-reaper-scripts` prior to copying it to `REAPER/Scripts`.


# Change log: 2023-10-30

### Additions
- Added a keymaps folder. Users should be able to simply export the keymap, and the target lua scripts should be accurately pointed to.
- Added the ability to export MIDI tracks marked "to improve" ("IM"), in addition to tracks marked "to orchestrate" ("REC").

### Regressions
- **Had to backtrack/refactor in order to enable the inclusion of silent stems when exporting stems.** At the moment, the only stems-export script is `rewgs - export stems - wide - wet - include silent.lua`, which is needed for mix engineers. 
- Coming ASAP:
    - `rewgs - export stems - skinny - dry - include silent.lua`
    - `rewgs - export stems - skinny - wet - include silent.lua`
    - `rewgs - export stems - wide - dry - include silent.lua`
- Coming shortly after the above:
    - `rewgs - export stems - skinny - dry - exclude silent.lua`
    - `rewgs - export stems - skinny - wet - exclude silent.lua`
    - `rewgs - export stems - wide - dry - exclude silent.lua`
    - `rewgs - export stems - wide - wet - exclude silent.lua`
- Coming after that, TBD:
    - `rewgs - export all assets.lua`
    - `rewgs - export mix-minuses - dry.lua`
    - `rewgs - export mix-minuses - wet.lua`

### Known issues
- `rewgs - export stems - wide - wet - include silent.lua`
    - Issue: Any skinny stems with duplicate names (e.g. Violin I underneath a Ensemble Long folder, and another Violin I underneath a Ensemble Short folder) will be exported as xxx-001 and xxx-002 (e.g. Violin I-001 and Violin I-002 for long and short, respectively).
    - Planned fix: The name of the parent folder will be appended to the resulting stem name (e.g. Violin I Ensemble Long and Violin I Ensemble Short, respectively).
- keymaps
    - Issue: No Windows or Linux keymaps.
    - Planned fix: Will make them if/when requested.
