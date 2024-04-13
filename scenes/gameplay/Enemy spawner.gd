extends Node2D

@onready var enemy_p = $"../Dynamic/Enemy"

# Exported variables
@export var mobScenes: Array[PackedScene]
@export var positions: Array[float]
@export var mobCounts: Array[int]
@export var repeatCounts: Array[int]
@export var burstTimes: Array[float]
@export var delayTimes: Array[float]

# Function to check if all arrays defining mob sequence have the same length
func _checkSequenceLengths():
	var lengths = [mobScenes.size(), positions.size(), mobCounts.size(), repeatCounts.size(), burstTimes.size(), delayTimes.size()]
	for length in lengths:
		if length != lengths[0]:
			push_error("Lengths of arrays defining mob sequence do not match!")
			return false
	return true

# Variables
var currentSequenceIndex = 0
var currentMobCount = 0
var currentRepeatCount = 0
var currentBurstTime = 0.0
var currentDelayTime = 0.0
var spawnTimer = 0.0

# Function to spawn a mob
func spawnMob(mobScene: PackedScene, pos: float, mobCount: int):
	for i in range(mobCount):
		var newMob = mobScene.instantiate()
		newMob.team = 1
		enemy_p.add_child(newMob)
		newMob.position = Vector2(pos, 0)
		newMob.rallyPoint = 0
		# Optionally set position of new mob
		# newMob.position = Vector2(x, y)
		# Example: randomize position within a range
		# Example: set position to spawner's position
		# newMob.position = position
		# Call the new mob's initialization function if needed
		# newMob.init()

# Process function called every frame
func _process(delta: float):
	if currentSequenceIndex < mobScenes.size():
		spawnTimer += delta
		currentDelayTime = delayTimes[currentSequenceIndex]
		if spawnTimer >= currentDelayTime:
			var currentMobScene = mobScenes[currentSequenceIndex]
			var currentPosition = positions[currentSequenceIndex]+position.x
			currentMobCount = mobCounts[currentSequenceIndex]
			currentRepeatCount = repeatCounts[currentSequenceIndex]
			currentBurstTime = burstTimes[currentSequenceIndex]
			
			spawnMob(currentMobScene, currentPosition, currentMobCount)
			

			currentMobCount += 1
			spawnTimer = 0.0
	else:
		currentSequenceIndex = 0
		currentMobCount = 0
		currentRepeatCount = 0
		currentBurstTime = 0.0
		currentDelayTime = 0.0

func _ready():
	if not _checkSequenceLengths():
		# If lengths don't match, stop the spawner
		set_process(false)
