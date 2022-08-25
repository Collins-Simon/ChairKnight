
Click on the image icon to see the diagram (backend servers not configured properly)

```plantuml

class World
class Room
class Wall
class Player
class Enemy
class GrapplePoint

World "1" -- "1" Player
World "1" -- "1" Room

Enemy "1" -- "*" GrapplePoint

GrapplePoint "1" -- "*" Player

Wall "0..1" -- "*" GrapplePoint

Room "1" -- "*" Enemy
Room "1" -- "*" Wall

```
