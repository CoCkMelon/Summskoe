class_name MobsPanel extends HBoxContainer

@export var mob_selector_resource: Resource = preload("res://scenes/UI/MobSelector.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for mob_enum in Mobs.all_mobs:
		var mob_resrouce: Resource = Mobs.all_mobs[mob_enum]

		var mob_instance = mob_resrouce.instantiate()
		# Release unused textures
		#var unused_texture = mob_instance.
		#unused_texture.free_resource()

		var mob_image: Texture = mob_instance.texture
		var new_selector = mob_selector_resource.instantiate()
		new_selector.mob_enum_to_spawn = mob_enum
		$TextureBackGround/HBoxContainer.add_child(new_selector)
