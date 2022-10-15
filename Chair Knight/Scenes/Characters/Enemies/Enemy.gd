extends Character
class_name Enemy
# Enemy is a special Character inherited by all the specialised enemy types.
# It handles a sprite, collisions, receiving damage, being grappled,
# and checking if the Player is in range.

# Drops on death:
export(int) var dropped_health := 200
export(int) var dropped_coins := 3
