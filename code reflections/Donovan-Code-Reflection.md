## Donovan Tull, tulldono, 300475393

Project Role: Room/Corridor Generation, Player Tracking, Entity Spawning, Misc.

### Code Discussion

**Sections worked on**

Game (Most)

Room + Corridor (All)

Player (Touched)

Character (Touched)

#### Video Link
https://www.youtube.com/watch?v=KQEkrOp7-7w
Subtitles elaborate on some explanations.

#### Most Interesting Code Contribution

Game.gd, func _process(delta) (#105-148)

This section of code could definitely be cleaned up, but it is the most important function in handling room generation, which was in turn far and away the most interesting component of the game I worked on. As rooms and corridors are of a set size, this process checks that the players current position is in the room they're currently supposed to be in (or closer to it in an adjacent corridor than to the next room). If it is not, it first checks if a room already exists at that location, by testing if a set of coordinates matches the coordinates of a previous room. For instance, if the player moves right from the initial room ([0,0]), this will check if the set of existing rooms contains one at the coordinates [1,0]. 

If there is a room already present, it will set the player's current room to the room at that coordinates. If a room does not exist, it generates one at that location. This allows it to generate rooms endlessly as needed, without causing memory issues.

The game also needs to check, if the player is not just closest to the room but within the confines of the room itself, if the player has not previously visited this room before, so on a player entering a new room it can lock the player in and spawn in entities, while not doing so for reentering an old room. As such, it similarly checks coordinates against all previously visited rooms; if present in visited rooms, this does nothing, if entering an unvisited room, it instructs the room to close all doors and spawns entities, in line with the players selected difficulty level.

### Section I am Most Proud of

Room.gd, in its entirety.

I have not previously worked in Godot before; Room.gd was my first attempt working in Godot, and I started with one of the most essential and challenging to implement components of the game, room creation. In this context, I'm very proud of how this turned out; I feel the rooms ended up with solid variation and reproducibility, and the way they're handled by game logic is fairly elegant in minimising resource use in memory. Aspects like addObstacles are poorly written, requiring manually writing out an array of arrays, but for my first endeavour in the engine, I'm very happy with how Room.gd is handled overall.

If I was instead looking for the code which I believe is best written, I would go with Game.gd entered_new_room, (#24-39), in combination with Game.gd randomEligibleRoomSpot, (#42-47). The former makes use of the latter, as after locking the door and adding it to the list of visited rooms, it spawns in entities in specified quantities at randomly selected points via randomEligibleRoomSpot. This in turn selects x and y coordinates randomly between the room's origin plus 128 (Tile width 64, top left is two tiles in each way from 0,0) and 1280, (the bottom right of the room 20 tiles in from 0,0), then runs recursively if the spot overlaps with a tile until an eligible spot is found (this recursion avoids the possibility of a player being softlocked by an enemy spawning inside the tiles). 

These two functions replace our initial mechanism, which spawned a fixed number of entities all at global 0,0 on Game.gd _ready, which would cause issue when trying to enter rooms away from the global 0,0, was only called on starting the game, and would also lead to all the enemies being in a predictable and uninteresting spawn location. I believe this is a fairly neat solution to all of these issues, and created a relatively versatile and easily expandable means of spawning in entities in desired numbers. If we wanted to add another enemy, for instance, it is easy to understand what changes would need to be made (another num parameter, and another "for i in range(numParam)" line). I believe this to be fairly well written and easy to extend code.

### Code in Need of Improvement

As noted above, addObstacles in Room.gd is a weak area; while sufficient for introducing a small selection of room types, the process of entering new arrays of arrays to introduce new obstacle options is very tedious and ill suited to handling a more diverse selection of room types. While easy enough to understand what the function fundamentally does, its limited expandability and the difficulty of understanding what each given array represents as a room, let alone creating further arrays, would certainly merit redress were the project to expand in scope. While not a specific section of code in need of improvement, I'd also note that the system in its current state would be more expandable if sections of the code were less reliant on rooms being of specific dimensions; for instance, if we wanted to incorporate L shapes, or rooms which don't necessarily have four exits at each side of a square room, sections of the code reliant on a room being of a certain length and height would need to be reviewed.

### Learning Reflection

#### What Was Learnt

Inherently, as my first effort in the Godot engine (aside from a short video tutorial which fellow team member John Flynn, separate from this course, recommended late last year), there were a lot of major technical takeaways. For instance, handling the placement of tiles relied on some key functionality of Godot's TileMap node type; functionality which I'm now familiar with, but which was challenging to understand and implement as someone effectively completely new to the engine, particularly in relation to the TileSet used therein. Indeed, working out how to convert a Node2D to a TileMap in the first place wasn't immediately apparent as a new user. Even the basic interface was new to me and had to be learnt. All of these areas, as well as various other components of the Godot engine, were naturally picked up in the process of trying to build a game in it. Fortunately, the programming language in which the code is written was reasonably intuitive. I also gained familiarity with smart commits; previous endeavours on Gitlab made minimal use of issues, but the expectation that commits relate to issues demonstrated the merits of an issues based system.

In terms of non-technical lessons, this project illustrated the importance of time management and long term team collaboration. Beyond a small technical prototype courtesy of John, other courses kept the group busy until the last minute; I only became free to focus on the project on Thursday, and even then had to do so around a 2.5 hour test. While I'm extremely proud of where the game ended up, going from a basic prototype to a game I find genuinely enjoyable to play in days, it would doubtless have saved the group a lot of stress had we collaborated from an earlier date.

#### Most Important Takeaway for Future Projects

The most important thing to bring to future projects would definitely be making proper use of issues and smart commits. Good practice to do so, and the value brought by having clearly laid out tasks which commits must relate to became clear when our initially overly broad issues were broken down into more manageable bites, that individuals could easily branch out and work on. It's also naturally more broadly applicable to any future programming projects than any Godot specific technical lessons, so would prove important more consistently (although I'd be happy to work on another project in Godot down the line)

A less technical honourable mention; good communication on who does what is vital. A completely clean split, along the lines of the SWEN225 project, isn't always practical; but some clear split is extremely helpful. We eventually ended up with fairly clear, albeit somewhat unofficial, sections which we were each in charge of; having these divisions made it far easier to decide what to work on, with the additional benefit of reducing merge conflict issues and being able to specialise wiithout needing to understand the finer details of every class. If an addition related to room generation, that was very clearly my responsibility, if it was menu related, Trent could handle it, animations and sprites were largely Simon's focus, and John handled core mechanics/entities. More explicitly establishing these rough boundaries, and doing so earlier, would have been extremely helpful, and doing so will definitely be a priority for future group projects.
