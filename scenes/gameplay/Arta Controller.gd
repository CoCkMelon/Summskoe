extends Sprite2D

# Constants
var attack_distance = 500.0
@export var penetration_force = 500.0
var attackCooldown = 1.0  # Cooldown time between attacks in seconds
var lastAttackTime = 0.0  # Time of the last attack


# Variables
@export var team = 0
@export var rallyPoint = 5550.0
@export var mobSpeed = 500.0  # Example mob speed, you can adjust as needed
@export var mobHealth = 100.0  # Example starting health
@onready var mobManager = $"../../../Enemy manager"
var destroyed = false
var attack_

@onready var player = $"../../../Player"

enum MovementState {
	IDLE,
	MOVE_TO_RALLY_POINT,
	MOVE_TO_ENEMY,
}

enum ActionState {
	IDLE,
	ATTACK,
}

var currentMovementState = MovementState.IDLE
var currentActionState = ActionState.IDLE
var targetEnemyMobId = -1

# Function to move mob towards enemy
func moveToEnemyMob(mobPosition: float, enemyMobPosition: float) -> float:
	# Calculate direction towards enemy
	var direction = sign(enemyMobPosition - mobPosition)
	if direction == -1:
		flip_h = true
	elif direction == 1:
		flip_h = false
	# Calculate new position after moving towards enemy
	var newPosition = mobPosition + direction * mobSpeed * get_process_delta_time()
	
	return newPosition

# Function to move mob towards rally point
func moveToRallyPoint(mobPosition: float) -> float:
	# Calculate direction towards rally point
	var direction = sign(rallyPoint - mobPosition)
	if direction == -1:
		flip_h = true
	elif direction == 1:
		flip_h = false
	
	# Calculate new position after moving towards rally point
	var newPosition = mobPosition + direction * mobSpeed * get_process_delta_time()
	
	return newPosition

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
		#queue_free()

# Process function called every frame
func _process(delta: float):
	var mobPosition = position.x  # Assuming 1D position
	var mobs
	if mobManager:
		match team:
			0:
				mobs = mobManager.team2Mobs
			1:
				mobs = mobManager.team1Mobs
	if targetEnemyMobId != -1:
		if mobs[targetEnemyMobId].destroyed:
			print("DED")
			targetEnemyMobId = -1
	# Handle movement state
	match currentMovementState:
		MovementState.IDLE:
			# Check if there's an enemy mob nearby
			if mobManager:
				targetEnemyMobId = mobManager.findNearestEnemyMob(mobPosition, mobs)
				if targetEnemyMobId != -1:
					currentMovementState = MovementState.MOVE_TO_ENEMY
				else:
					currentMovementState = MovementState.MOVE_TO_RALLY_POINT
		MovementState.MOVE_TO_RALLY_POINT:
			if abs(rallyPoint - position.x) > 10:
				# Move towards rally point
				position.x = moveToRallyPoint(mobPosition)
				# Check if an enemy is nearby
				if mobManager:
					targetEnemyMobId = mobManager.findNearestEnemyMob(mobPosition, mobs)
					#print(targetEnemyMobId)
					if targetEnemyMobId != -1 and (mobs[targetEnemyMobId].destroyed == false):
						currentMovementState = MovementState.MOVE_TO_ENEMY
		MovementState.MOVE_TO_ENEMY:
			# Move towards the enemy mob
			if targetEnemyMobId != -1 and mobManager:
				var enemyMob = mobs[targetEnemyMobId]
				if enemyMob:
					var enemyMobPosition = enemyMob.position.x
					position.x = moveToEnemyMob(mobPosition, enemyMobPosition)
					# Check if the enemy mob moved out of range
					if abs(mobPosition - enemyMobPosition) > attack_distance:
						targetEnemyMobId = mobManager.findNearestEnemyMob(mobPosition, mobs)
						#currentMovementState = MovementState.IDLE
			else: 
				currentMovementState = MovementState.MOVE_TO_RALLY_POINT

	# Handle action state
	match currentActionState:
		ActionState.IDLE:
			# Check if the mob is in range to attack
			if targetEnemyMobId != -1 and mobManager:
				var enemyMob = mobs[targetEnemyMobId]
				if enemyMob:
					var enemyMobPosition = enemyMob.position.x
					if abs(mobPosition - enemyMobPosition) <= attack_distance:
						currentActionState = ActionState.ATTACK
		ActionState.ATTACK:
			# Check if attack is off cooldown
			if Time.get_ticks_msec() / 1000.0 - lastAttackTime >= attackCooldown:
				# Attack the enemy mob
				if targetEnemyMobId != -1 and mobManager:
					var enemyMob = mobs[targetEnemyMobId]
					if enemyMob:
						var enemyMobPosition = enemyMob.position.x
						# Check if the enemy mob moved out of range
						if abs(mobPosition - enemyMobPosition) > attack_distance:
							currentActionState = ActionState.IDLE
						else:
							# Perform attack and apply damage to enemy mob
							var damageType = "PENETRATION"  # Example damage type
							var armorType = "LIGHT"  # Example armor type
							enemyMob.receiveDamage(penetration_force, damageType, armorType)
							# Update last attack time
							lastAttackTime = Time.get_ticks_msec() / 1000.0

func _ready():
	if mobManager:
		match team:
			0:
				mobManager.team1Mobs.append(self)
			1:
				mobManager.team2Mobs.append(self)
