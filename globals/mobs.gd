extends Node

enum MobsEnum {
	ARTA,
	DummyMob1, # only to test MobSelector
	DummyMob2, # only to test MobSelector
}

const all_mobs: Dictionary = {
	MobsEnum.ARTA: preload("res://scenes/gameplay/mobs/arta.tscn"),
	MobsEnum.DummyMob1: preload("res://scenes/gameplay/mobs/arta.tscn"),
	MobsEnum.DummyMob2: preload("res://scenes/gameplay/mobs/arta.tscn")
}
var friendly_mobs_parent_node: Node = null
var friendly_mobs_start: int = 100
var selected_mob: MobsEnum = MobsEnum.ARTA

#var enemy_mobs_parent_node: Node = null # currently not in use
#var enemy_mobs_start: int = 400

func spawn_friendly_mob() -> void:
	assert(friendly_mobs_parent_node != null, "initialize friendly_mobs_parent_node before spawning mobs")
	var newmob = all_mobs[selected_mob].instantiate()
	newmob.position.x = friendly_mobs_start
	newmob.position.y = randf_range(-100, 100)
	friendly_mobs_parent_node.add_child(newmob)
