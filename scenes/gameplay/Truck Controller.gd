extends Sprite2D

# Constants
var max_cargo = 1000

# Variables
@export var team = 0
@export var mobHealth = 10000
@export var rallyPoint = 0.0
@export var speed = 500.0  # Example speed, you can adjust as needed
@onready var mobManager = $"../../../Enemy manager"
var carrying = 0.0
var targetCargo = -1
var destroyed = false
var base_position = 0.0

@onready var player = $"../../../Player"

enum MovementState {
	IDLE,
	MOVE_TO_RALLY_POINT,
	MOVE_TO_CARGO,
	MOVE_TO_BASE
}

enum ActionState {
	IDLE,
	ATTACK,
}

var currentMovementState = MovementState.IDLE
var currentActionState = ActionState.IDLE
var targetEnemyMobId = -1

# Function to move the truck towards a specific position
func move_to_position(target_position: float) -> float:
	# Calculate direction towards target position
	var direction = sign(target_position - position.x)
	if direction == -1:
		flip_h = true
	elif direction == 1:
		flip_h = false
		
	# Calculate new position after moving towards target position
	var new_position = position.x + direction * speed * get_process_delta_time()
	
	return new_position

# Function to move the truck towards the rally point
func move_to_rally_point(truck_position: float) -> float:
	# Calculate direction towards rally point
	var direction = sign(rallyPoint - truck_position)
	if direction == -1:
		flip_h = true
	elif direction == 1:
		flip_h = false
		
	# Calculate new position after moving towards rally point
	var new_position = truck_position + direction * speed * get_process_delta_time()
	
	return new_position

# Function to find the nearest destroyed mob that the truck can carry
func find_nearest_destroyed_mob() -> int:
	if mobManager:
		for mob_id in range(0, mobManager.team1Mobs.size()):
			var mob = mobManager.team1Mobs[mob_id]
			if mob.destroyed and not carrying:
				return mob_id
		for mob_id in range(0, mobManager.team2Mobs.size()):
			var mob = mobManager.team2Mobs[mob_id]
			if mob.destroyed and not carrying:
				return mob_id
	return -1

# Function to pick up a destroyed mob
func pick_up_cargo(mob: Node):
	carrying = mob.mobHealth
	mob.queue_free()

# Function to drop off cargo at base
func drop_off_cargo():
	carrying = 0.0
	


# Function to calculate damage based on damage type and armor type
func calculateDamage(damage: float, sourceDamageType: String, targetArmorType: String) -> float:
	# Placeholder logic for damage calculation based on damage type and armor type
	# You can implement your own logic here based on your game design
	if sourceDamageType == "PENETRATION" and targetArmorType == "LIGHT":
		return damage * 0.5  # Example reduction for light armor against penetration damage
	else:
		return damage


# Function to receive damage
func receiveDamage(damage: float, sourceDamageType: String, targetArmorType: String) -> void:
	# Calculate final damage based on damage type and armor type
	var finalDamage = calculateDamage(damage, sourceDamageType, targetArmorType)
	
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
		#queue_free()

	
	

# Process function called every frame
func _process(delta: float):
	var truck_position = position.x  # Assuming 1D position
	var mobs
	if mobManager:
		match team:
			0:
				mobs = mobManager.team2Mobs
			1:
				mobs = mobManager.team1Mobs
	
	# Handle movement state
	match currentMovementState:
		MovementState.IDLE:
			# Find the nearest destroyed mob
			targetCargo = find_nearest_destroyed_mob()
			if targetCargo != -1:
				currentMovementState = MovementState.MOVE_TO_CARGO
			elif abs(rallyPoint - position.x) > 10:
				currentMovementState = MovementState.MOVE_TO_RALLY_POINT
			elif carrying > 0:
				currentMovementState = MovementState.MOVE_TO_BASE
		MovementState.MOVE_TO_RALLY_POINT:
			# Move towards rally point
			position.x = move_to_rally_point(truck_position)
			if abs(truck_position - rallyPoint) < 10:
				currentMovementState = MovementState.IDLE
		MovementState.MOVE_TO_CARGO:
			if targetCargo != -1 and mobManager:
				var target_mob = mobs[targetCargo]
				if target_mob:
					var target_mob_position = target_mob.position.x
					position.x = move_to_position(target_mob_position)
					# Check if the truck reached the mob
					if abs(truck_position - target_mob_position) < 10:
						pick_up_cargo(target_mob)
						targetCargo = -1
						currentMovementState = MovementState.MOVE_TO_BASE
		MovementState.MOVE_TO_BASE:
			if carrying > 0:
				# Move towards base
				position.x = move_to_position(base_position)
				# Check if the truck reached the base
				if abs(truck_position - base_position) < 10:
					drop_off_cargo()
					currentMovementState = MovementState.IDLE

func _ready():
	if mobManager:
		match team:
			0:
				mobManager.team1Mobs.append(self)
			1:
				mobManager.team2Mobs.append(self)
