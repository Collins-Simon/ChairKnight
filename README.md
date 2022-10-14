# Game Development Project


UML class diagram provided by [mermaid](https://mermaid-js.github.io/mermaid/#/classDiagram)
<!-- https://mermaid-js.github.io/mermaid-live-editor -->
```mermaid
%% This is the UMl of the main system
classDiagram
    class World
    class Room
    class Wall
    class Player
    class Enemy
    class GrapplePoint

    Enemy "1" -- "*" GrapplePoint
    GrapplePoint "1" <-- "*" Player
    Wall "0..1" -- "*" GrapplePoint
    Room "1" -- "*" Enemy
    Room "1" -- "*" Wall
    World "1" -- "1" Room
    World "1" -- "1" Player
```

```mermaid
%% This is the UML of the menu system
classDiagram

    MenuSystem "1..*" *-- SubMenu : child(ren)
    OptionsMenu <|-- SubMenu
    PauseMenu <|-- SubMenu
    MenuSystem "0..1" --> LoadingScene : child

    SubMenu : +Control local_focus
    SubMenu : +Void register_focus_as_local()

    MenuSystem : +SubMenu active_menu
    MenuSystem : +Void quit()
    MenuSystem : -_ready()
    MenuSystem : +transition_to_menu(String path)
    MenuSystem : +custom_load_scene(String path)

    LoadingScene : +Control Loading
    LoadingScene : +ProgressBar Loading/bar

    PauseMenu : -_unhandled_input(event)
    PauseMenu : +set_paused(bool value)
    PauseMenu : +change_scene(String path)
    PauseMenu : quit()

```
