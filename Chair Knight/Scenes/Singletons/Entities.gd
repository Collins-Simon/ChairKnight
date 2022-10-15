extends Node


# Enum representing the different types of entity:
enum {
	PLAYER,

	ENEMY_BIG,
	ENEMY_SMALL,
	ENEMY_EXPLOSIVE,
	ENEMY_RANGED,

	PILLAR,
	BOMB,

	HEALTH,
	COIN,
}

# Dictionary mapping each entity enum to its scene:
var scenes := {
	PLAYER: load("res://Scenes/Characters/Player.tscn"),

	ENEMY_BIG: load("res://Scenes/Characters/Enemies/EnemyBig.tscn"),
	ENEMY_SMALL: load("res://Scenes/Characters/Enemies/EnemySmall.tscn"),
	ENEMY_EXPLOSIVE: load("res://Scenes/Characters/Enemies/EnemyExplosive.tscn"),
	ENEMY_RANGED: load("res://Scenes/Characters/Enemies/EnemyRanged.tscn"),

	PILLAR: load("res://Scenes/Environment/Pillar.tscn"),
	BOMB: load("res://Scenes/Environment/Bomb.tscn"),

	HEALTH: load("res://Scenes/Drops/Health.tscn"),
	COIN: load("res://Scenes/Drops/Coin.tscn"),
}

# Retrieves an entity's scene given its enum:
func get_scene(entity_enum: int) -> PackedScene:
	return scenes[entity_enum]
