class_name MobSelector extends TextureButton

@export var mob_enum_to_spawn: Mobs.MobsEnum = Mobs.MobsEnum.ARTA

func _on_pressed() -> void:
	print_debug('selected new mob type: ' + str(mob_enum_to_spawn))
	Mobs.selected_mob = mob_enum_to_spawn
	#Mobs.spawn_friendly_mob() # do we want to call spawn here?
