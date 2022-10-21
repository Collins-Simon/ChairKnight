## Donovan Tull, tulldono, 300475393

Project Role: Room/Corridor Generation, Player Tracking, Entity Spawning, Misc.

### Code Discussion

**Sections worked on**

Game (Most)
Room (All)
Corridor (All)
Player (Touched)
Character (Touched)

#### Video Link
https://www.youtube.com/watch?v=dQw4w9WgXcQ
# (Remember to replace with actual link don't be dumb future me)

#### Most Interesting Code Contribution

Game.gd, func _process(delta) (#105-148)

This section of code could definitely be cleaned up, but it is the most important function in handling room generation, which was in turn far and away the most interesting component of the game I worked on. As rooms and corridors are of a set size, this process checks that the players current position is in the room they're currently supposed to be in (or closer to it in an adjacent corridor than to the next room). If it is not, it first checks if a room already exists at that location, by testing if a set of coordinates matches the coordinates of a previous room. For instance, if the player moves right from the initial room ([0,0]), this will check if the set of existing rooms contains one at the coordinates [1,0]. 

If there is a room already present, it will set the player's current room to the room at that coordinates. If a room does not exist, it generates one at that location. This allows it to generate rooms endlessly as needed, without causing memory issues.

The game also needs to check, if the player is not just closest to the room but within the confines of the room itself, if the player has not previously visited this room before, so on a player entering a new room it can lock the player in and spawn in entities, while not doing so for reentering an old room. As such, it similarly checks coordinates against all previously visited rooms; if present in visited rooms, this does nothing, if entering an unvisited room, it instructs the room to close all doors and spawns entities, in line with the players selected difficulty level.

### Section I am Most Proud of

Room.gd, in its entirety

I have not previously worked in Godot before; Room.gd was my first attempt working in Godot, and I started with one of the most essential and challenging to implement components of the game, room creation. I'm very proud of how this turned out, I feel the rooms ended up with solid variation and reproducibility, and the way they're handled by game logic is fairly elegant in minimising resource use in memory. Aspects like addObstacles are poorly written, requiring manually writing out an array of arrays, but for my first endeavour in the engine, I'm very happy with how Room.gd is handled overall.

If I was instead looking for the code which I believe is best written, I would go with Game.gd entered_new_room, #24-39, in combination with Game.gd randomEligibleRoomSpot, #42-47. The former makes use of the latter, as after locking the door and adding it to the list of visited rooms, it spawns in entities in specified quantities at randomly selected points via randomEligibleRoomSpot. This in turn selects x and y coordinates randomly between the room's origin plus 128 (Tile width 64, top left is two tiles in each way from 0,0) and 1280, (the bottom right of the room 20 tiles in from 0,0), then runs recursively if the spot overlaps with a tile until an eligible spot is found (this recursion avoids the possibility of a player being softlocked by an enemy spawning inside the tiles). 

These two functions replace our initial mechanism, which spawned a fixed number of entities all at global 0,0 on Game.gd _ready, which would cause issue when trying to enter rooms away from the global 0,0, was only called on starting the game, and would also lead to all the enemies being in a predictable and uninteresting spawn location. I believe this is a fairly neat solution to all of these issues, and created a relatively versatile and easily expandable means of spawning in entities in desired numbers. If we wanted to add another enemy, for instance, it is easy to understand what changes would need to be made (another num parameter, and another "for i in range(numParam)" line). I believe this to be fairly well written and easy to extend code.

