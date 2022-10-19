## Trent Hetherington, hethertren
###### Project role: GUI (Menu), Gitlab, misc
<hr>

## Code Discussion

###### Parts I worked on:
- Menu System (ALL)
    - Title Screen (ALL)
    - Options Menu (ALL)
    - Pause Menu (ALL)
    - Death / Respawn Screen (ALL)
    - Menu Theme (MOST)
- Gitlab (HALF)
    - Automated CI/CD pipeline (ALL)
    - Setting Up repository / settings (SOME)

###### Video link (critical aspects)
###### Most interesting part of code I worked on. (and link)
Menu system<br>
The menu system was designed in such a way that adding a new screen is easy and does not require much code reproduction. It was also designed to be modified readily throught the use of the Memu_Theme object.

###### Section most proud of
Title Screen Animation<br>
The title screen animation uses Godot's inbuilt animations window in conjuction with real code in order to display a visually-appealing graphic when the menu loads in.

###### Section as bad code and why it is bad
Death / respawn screen<br>
This screen features a Node2D component (the coin) which took much fiddling to get working as intended. However, I realised after submitting that I should've worked on it more - the respawn button has a question mark which doesn't need to be there, and when resizing the game, the coin and score label(s) follow the top left corner instead of the center as it should've.

<hr>

## Learning reflection

###### What learnt, how develop
###### Most important thing that will be used in future
