## John Flynn, flynnjohn, 300529347

#### Project Role: Core Game Mechanics and Entity Interactions

<hr>

## Code Discussion

#### Parts I worked on:
- Entities:
  - Characters:
    - Player (Most)
    - Enemy Base/Template (All)
    - Small Enemies (Half)
    - Big Enemies (Half)
    - Explosive Enemies (Half)
    - Ranged Enemies (Half)
    - Hitboxes, Hurtboxes, and Player Detection (All)
    - Grapple Body and Grapple Area (All)
  - Environmental:
    - Bombs (Most)
    - Pillars (All)
    - Explosions (All)
    - Bullets (Half)
    - Ropes (All)
  - Enemy Drops:
    - Drop Base/Template (All)
    - Health Drops (All)
    - Coin Drops (All)
  - Floating Text for Damage Numbers (All)
- Game Scene (Some)
- World (All)


#### Video Discussing Critical Aspects of My Code
https://youtu.be/mOliKQZD0Hw
<!--
- GrappleBody Hierarchy (Inheritance mixed with composition)
- Hitboxes, Hurtboxes (Use of collision layers)
- Entity Spawning (Centralisation of spawning)
- Ropes (Works well, poor decomposition and comments)
-->

#### Most Interesting Code Contribution

[GrappleBody.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Equipment/GrappleBody.gd#L2-35)

[Character.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Characters/Character.gd#L1-50)

[Enemy.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Characters/Enemies/Enemy.gd#L1-9)

<!-- A description and link to the most interesting part of code/blueprint written by you - the link can include a line number reference by adding #L2-20 on the end of the git url. or images of the blueprint -->

The code I found most interesting to write and refactor was definitely the tree of classes in the GrappleBody hierarchy. In tree form, the class hierarchy looks like this:

RigidBody2D:
- GrappleBody:
  - Character:
    - Player
    - Enemy:
      - Different types of Enemy (Big, Small, etc.)
  - Other types of GrappleBody (Bombs, Pillars, etc.)

This hierarchy can be seen in the first two lines of each .gd script linked above, through how each class extends its parent. 
In terms of the actual functionality:
- GrappleBody describes a RigidBody2D (physics body) that can be grappled onto by the Player, have Ropes attached, and possibly be destroyed.
- Character represents a GrappleBody that has health, can be damaged or healed, and possibly moves by itself.
- Enemy is a Character that serves as a template for specialised enemy types. It drops health and coins when destroyed, and although not shown in the script, its scene (Enemy.tscn) also has a Sprite, handles collisions, and handles Player detection.

Despite my experience with Godot, I have never created a class hierarchy of this scale and with so much shared functionality. The reason I found it so interesting was because I did not expect inheritance to work so well.

All my research regarding Godot design patterns had led me to believe that 'composition', where common functionality is added as child nodes, is much better than 'inheritance' due to Godot's node system. However, 'composition' seemed very unintuitive and almost like an antipattern for what I was trying to achieve. For example, I wanted all Characters (Player and Enemies) to share the same movement code. With composition, this would involve creating a "movement node" added as a child to each Character. This would work, but unless the movement node knows about its parent (not allowed with composition), the movement node has no way of directly moving the Character. This means the Character would have the query the movement node for how to move, then apply the movement itself. This would add a lot of boiler plate code and would have to be done for every Character, so I decided to try inheritance instead.

The hierarchy of inherited classes worked surprisingly well. All the inherited code works as expected, including the different signals like 'destroyed', 'damaged', and 'healed'. Most importantly however, many fields like 'health' and 'max_speed' are exported (e.g., Character.gd lines 6 to 10) so these values can be easily customised in any inheriting classes like Enemy or Player. This adds plenty of customisable yet shared functionality to many different entities in the game, saving space and making it easier to maintain. I also found it easy to move methods up the hierarchy when they were shared by enough inherited classes. From this I learned that it is purely situational whether inheritance or composition is better, even in Godot, and this lesson was very interesting to me.


#### Section I'm Most Proud of

[Entities.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Singletons/Entities.gd#L5-43)

[World.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/World.gd#L16-46)

<!-- Identification of the section of code/blueprint/Behaviour tree/... you are most proud of - and why you feel that this is particularly good code. (this could be the same as above) -->

Although I was proud of my effective use of inheritance mentioned in the previous section, I was also especially proud of the entity spawning system I created.

Entities.gd is an autoload singleton, which in Godot is essentially a public static class, meaning any script can access it. Inside, an enum contains identifiers for all the spawnable entities in the game. Under this, a dictionary maps each of these enums to a scene (or class) that can easily be instanced. Finally, the function at the bottom (get_scene(entity_enum)) simply returns a scene given its enum.

The magic behind Entities.gd is shown in World.gd, more specifically in the spawn_entity(entity_enum, pos, meta_data) function. To spawn any entity into the game, all you need to do is call this function with the entity's identifying enum, and a position to spawn it at. The other functions in World.gd simply handle special events/signals from these entities, like how an EnemyRanged should occasionally spawn Bullets into the game.

I am proud of this system because it greatly simplifies the spawning process, which can quickly get out of hand with such a large number of different entities. It eliminates the need to keep track of entity scene files, which signals need to be connected to what, and whether the entity requires any special fields that need to be initialised first. All that's needed is the entity's enum identifier, and a way to access the spawn_entity() function. As a result, Donovan's code for spawning entities in a Room ([Game.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Game.gd#L29-39)) is concise and easy to understand.


#### Code in Need of Improvement

[Rope.gd](https://gitlab.ecs.vuw.ac.nz/course-work/comp313/2022/assignments/hethertren/game-development-project/-/blob/main/Chair%20Knight/Scenes/Equipment/Rope.gd#L29-72)

<!-- Identification of a section of code/blueprint you see as bad code/blueprint and why it represents hard-to-understand or poorly written code/blueprint -->


Rope.gd's _ready() function works very well. However, it is arguably one of the most difficult functions to understand in the entire game, and this is not helped by the fact that I forgot to add comments. Furthermore, the function clearly has different sections to it as hinted by the for loops, and is in desperate need of being decomposed into smaller functions.

Even if it was fully document and decomposed, this function would still be quite complex. Here is how it works:
- A Rope can be thought of like a spinal column with bones (links) and joints connecting them.
- The number of links (RigidBody2Ds) and joints (DampedSprintJoint2Ds) is determined by the length of the Rope.
- The links and joints are placed evenly between the two ends of the Rope.
- The links and joints are connected, and the length of each joint is minimised so the Rope contracts.
- A Line2D is drawn over the Rope so it can be seen.

The code gets complicated quickly when accounting for special conditions (e.g., how should the joints be rotated if the Rope is created at an angle? What if the Rope is so short that no links are made?). Consequently, the code would be much easier to maintain, update, or simply just understand if it had any kind of documentation or decomposition. In its current state my brain melts when looking at it, and I'm very lucky it never caused any problems after its creation despite Ropes being a core mechanic of the game.


## Learning Reflection

#### What I Learnt and How I Developed as a Programmer

<!-- Reflection on what you have learnt and how you have developed as a programmer in this project -->

One important lesson I learned was that inheritance in Godot can be an effective way to implement shared functionality, even if composition is praised much more online (from what I've seen). As stated before, I found inheritance to be the best way to solve problems like sharing movement code between different types of Characters (Player and Enemy). This was due to composition feeling less intuitive and adding more boilerplate code in this specific situation. However, composition also has plenty of uses too, proven by how Godot's node system is built around it, so the ultimate lesson I've learnt from this is that its best to experiment with different approaches before labelling one as better. I feel like this is a common trap for developers, and I have grown as a programmer through my newfound awareness of it.

Another important lesson I learned is that Godot's collision layer system is a powerful tool that makes handling collisions simple and efficient. Instead of using if statements to check whether a collision is with a certain entity type, you can simply change the entity's collision_layer (which layers it is on) and collision_mask (which layers it detects). This way, the entity only collides with a physics body if it can detect the body or if it is detected by the body, all based on the collision layer/mask combination. This was invaluable to our game with all the different entities and their interactions, and therefore this was the first time I've taken full advantage of it.

Setting it up was simple. For example, I've placed the Player on layer 2, and Enemies on layer 3. I've made it so Enemies can detect layers 2 and 3, meaning they collide with the Player but also with other Enemies. However, they do not detect layer 6, which is where Drops are placed, and so they do not collide with them. This system greatly reduced the boilerplate code necessary to set up entity interactions, and worked perfectly with little set up. I'm sure it also made the code faster and easier to maintain (compared to long lists of if statements). As a programmer, this experience taught me that editors and engines come packed with tools for a reason, and these tools can benefit me greatly given the time to learn them. I'm sure Godot isn't the only game engine with this system, so I'll be sure to look out for something similar when using other engines.


#### My Most Important Takeaway for Future Projects

<!-- A description of the most important thing you will use from this project in future projects. -->

My main takeaway from this project is the valuable lesson that my first approach, even if seemingly the most popular and reasonable, is sometimes not the best. Instead of making assumptions, I should experiment with different approaches and do my own research, as this can pay off immensely.

When planning how to implement shared behaviour between entities, I spent hours thinking of the best way to add it using composition. This felt like the only option because of Godot's node-based design philosophy, and I wasted plenty of time trying to force a design pattern that did not fit the situation. I eventually gave up and decided to try inheritance, which would be my first choice in other projects using languages like Java. To my surprise, it worked better than composition in almost every way. In the end using a different approach resulted in a project that was much simpler, easier to maintain, and more intuitive than if I had used my first choice.

This lesson also applies to my experience with Godot's collision layers. As stated before, Godot's collision layer system made handling the complex web of entity interactions much easier. However, this was not the first option I considered. In the game's prototype, I hardcoded that if a physics body collides with an Enemy, the Enemy should check if the physics body is a Player, and if so, the Enemy dies if the Player is moving fast enough. When designing the different Enemy types (EnemyBig, EnemySmall, etc.), I quickly realised that this would not scale well, and performance would probably suffer with rooms full of Enemies colliding with each other and checking that if statement constantly. So, remembering a tutorial I watched that implemented Godot's collision layer system (https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=1), I decided to learn how to use it. This required no code to be added, made all interactions easier to maintain and update, and worked flawlessly. Once again, my second option worked best.

In future projects, I think this lesson will also help me to be more open-minded of the ideas of others, and therefore work more cohesively in a team. I believe this will help me to create better software in the future, regardless of what language, editor, or engine I'm using.
