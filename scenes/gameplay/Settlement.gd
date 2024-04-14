extends Sprite2D

var mobHealth: float = 5000
@onready var mobManager = $"../../Enemy manager"
@export var team = 0
var destroyed = false
@export var destroyedImage: CompressedTexture2D
@onready var Player = $"../../Player"

func _ready():
	if mobManager:
		match team:
			0:
				mobManager.team1Mobs.append(self)
			1:
				mobManager.team2Mobs.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function to calculate damage based on damage type and armor type
func calculateDamage(damage: float, damageType: String, armorType: String) -> float:
	# Placeholder logic for damage calculation based on damage type and armor type
	# You can implement your own logic here based on your game design
	if damageType == "PENETRATION" and armorType == "LIGHT":
		return damage * 0.5  # Example reduction for light armor against penetration damage
	else:
		return damage


# Function to receive damage
func receiveDamage(damage: float, damageType: String, armorType: String) -> void:
	# Calculate final damage based on damage type and armor type
	var finalDamage = calculateDamage(damage, damageType, armorType)
	
	# Reduce mob health
	mobHealth -= finalDamage
	
	# Spawn particles at the position of the mob
	var particlesScene = load("res://scenes/gameplay/effects/arta_damage.tscn")
	var particlesInstance = particlesScene.instantiate()
	get_parent().add_child(particlesInstance)
	particlesInstance.global_position = global_position
	
	# Check if mob is destroyed
	if mobHealth <= 0:
		# Destroy mob
		destroyed = true
		set_process(false)
		texture = destroyedImage
		#queue_free()
