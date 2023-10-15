Multiple namespaces:
- Project
    - project-specific data
    - tracks (multiple)
- Track
    - track properties such as name, mute state, etc
    - media items
- Item
    - item properties such as location, mute state, etc

Eventually split "modules" and "scripts" into two repos
- modules: "reaify" - **R**ewgs' **E**xtension for the Reaper **A**PI. 
    - Provides a more object-oriented approach for interacting with the Reaper API. 
    - The name is a play on the word "reify," which is adjacent to "objectify," as well as a play on the fact that nearly every extension made for Reaper starts with the letters "rea."
- scripts: Rewgs' Composer Toolbox, or rct.
