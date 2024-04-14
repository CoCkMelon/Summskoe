extends Node

var player

class Resources:
	var materials: int = 0
	var energy: int = 0
	var precision: int = 0
	var influence: int = 0
	
	func _init(amaterials: int, aenergy: int, aprecision: int, ainfluence: int):
		self.materials = amaterials
		self.energy = aenergy
		self.precision = aprecision
		self.influence = ainfluence

	func can_afford(other):
		return self.materials >= other.materials and self.energy >= other.energy and self.precision >= other.precision and self.influence >= other.influence
	func sub(other):
		self.materials -= other.materials
		self.energy -= other.energy
		self.precision -= other.precision
		self.influence -= other.influence
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



@onready var mob_prices: Dictionary = {
	MobsEnum.ARTA: Resources.new(30, 20, 10, 5)
}

func spawn_friendly_mob(pos) -> void:
	assert(friendly_mobs_parent_node != null, "initialize friendly_mobs_parent_node before spawning mobs")
	assert(player != null, "initialize player before spawning mobs")

	if player.resources.can_afford(mob_prices[selected_mob]):
		var newmob = all_mobs[selected_mob].instantiate()
		newmob.position.x = pos
		newmob.position.y = randf_range(-300, 300)
		friendly_mobs_parent_node.add_child(newmob)

		player.resources.sub(mob_prices[selected_mob])
	else:
		print("can't afford")
		print(player.resources.materials)
