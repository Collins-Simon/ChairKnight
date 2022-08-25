# Game Development Project


UML class diagram provided by [mermaid](https://mermaid-js.github.io/mermaid/#/classDiagram)
<!-- https://mermaid-js.github.io/mermaid-live-editor -->
```mermaid
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
