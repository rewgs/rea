Multiple namespaces:
- Project
    - project-specific data (project name, path, etc)
    - state, which includes...
    - tracks (multiple, as objects)
- Track
    - track properties such as name, mute state, etc
    - media items
- Item
    - item properties such as location, mute state, etc

- scripts name ideas: 
    - exporting stuff: 
        - Rewgs' Composer Toolbox, or rct; 
        - Rewgs' Export Assistant, or rea.
    - misc (grid, etc):
        - rewgs basics

The files `modules/Some_Namespace.lua` and `.tests/namespaces_test.lua` show how to go about collecting everything into proper namespaces.
Some good info:
- https://stackoverflow.com/questions/4394303/how-to-make-namespace-in-lua
- https://www.lua.org/pil/15.2.html

- UI inspiration: nvk_CREATE
