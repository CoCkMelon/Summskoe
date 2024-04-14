extends Sprite2D

# Constants
const DETECTION_DISTANCE = 100.0
const EXPLOSION_FORCE = 1000.0
const DAMAGE_RADIUS = 50.0
const DAMAGE_AMOUNT = 500.0
var destroyed = true
# Variables
var hasDetonated = false
@export var team: int = 0  # Default team is 0
@onready var mobManager = $"../../../Enemy manager"

# Function to detect enemies within range
func detectEnemies():

	if mobManager:
		var enemyTeam = mobManager.team1Mobs if team == 1 else mobManager.team2Mobs
		var mobPosition = global_position.x  # Assuming 1D position
		for enemyMob in enemyTeam:
			if enemyMob == null:
				continue
			if enemyMob.destroyed:
				continue
			var enemyMobPosition = enemyMob.global_position.x  # Assuming 1D position
			if abs(mobPosition - enemyMobPosition) <= DETECTION_DISTANCE:
				return true
	return false

# Function to handle explosion
func explode():

	if mobManager:
		var enemyTeam = mobManager.team1Mobs if team == 1 else mobManager.team2Mobs
		var mobPosition = global_position.x  # Assuming 1D position
		for enemyMob in enemyTeam:
			if enemyMob == null:
				continue
			if enemyMob.destroyed:
				continue
			var enemyMobPosition = enemyMob.global_position.x  # Assuming 1D position
			if abs(mobPosition - enemyMobPosition) <= DAMAGE_RADIUS:
				var direction = (enemyMobPosition - mobPosition).normalized()
				enemyMob.apply_impulse(Vector2.ZERO, direction * EXPLOSION_FORCE)
				enemyMob.receiveDamage(DAMAGE_AMOUNT, "EXPLOSION", "ARMOR")
	var friendTeam = mobManager.team1Mobs if team == 0 else mobManager.team2Mobs
	friendTeam.erase(self)
	# Destroy the landmine
	queue_free()

# Process function called every frame
func _process(delta: float):
	# Check if an enemy is within detection range
	if detectEnemies() and !hasDetonated:
		# Detonate the landmine if an enemy is within range
		explode()
		hasDetonated = true
