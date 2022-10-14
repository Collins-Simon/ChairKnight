extends Node


enum {
	PLAYER,

	ENEMY_BIG,
	ENEMY_SMALL,
	ENEMY_EXPLOSIVE,
	ENEMY_RANGED,

	PILLAR,
	BOMB,
}

var scenes := {
	PLAYER: load("res://Scenes/Characters/Player.tscn"),

	ENEMY_BIG: load("res://Scenes/Characters/Enemies/EnemyBig.tscn"),
	ENEMY_SMALL: load("res://Scenes/Characters/Enemies/EnemySmall.tscn"),
	ENEMY_EXPLOSIVE: load("res://Scenes/Characters/Enemies/EnemyExplosive.tscn"),
	ENEMY_RANGED: load("res://Scenes/Characters/Enemies/EnemyRanged.tscn"),

	PILLAR: load("res://Scenes/Environment/Pillar.tscn"),
	BOMB: load("res://Scenes/Environment/Bomb.tscn"),
}

func get_scene(entity_enum: int) -> PackedScene:
	return scenes[entity_enum]
