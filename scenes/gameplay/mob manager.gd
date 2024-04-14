extends Node

# Arrays to store mobs of each team
var team1Mobs: Array = []
var team2Mobs: Array = []

# Function to initialize mobs for each team
func initMobs(team1: Array, team2: Array):
	team1Mobs = team1
	team2Mobs = team2

# Function to find the nearest enemy mob
func findNearestEnemyMob(mobPosition: float, teamMobs: Array) -> int:
	var nearestDistance = INF
	var nearestIndex = -1
	
	for i in range(teamMobs.size()):
		if teamMobs[i] == null:
			continue
		if teamMobs[i].destroyed:
			continue
		var enemyMobPosition = teamMobs[i].position.x
		
		# Calculate distance between mobs
		var distance = abs(mobPosition - enemyMobPosition)
		
		# Update nearest enemy if closer than previous nearest
		if distance < nearestDistance:
			nearestDistance = distance
			nearestIndex = i
	
	return nearestIndex
# Function to find the nearest destroyed mob
func findNearestDestroyedMob(mobPosition: float, teamMobs: Array) -> int:
	var nearestDistance = INF
	var nearestIndex = -1
	
	for i in range(teamMobs.size()):
		if teamMobs[i].destroyed == false:
			continue
		var enemyMobPosition = teamMobs[i].position.x
		
		# Calculate distance between mobs
		var distance = abs(mobPosition - enemyMobPosition)
		
		# Update nearest enemy if closer than previous nearest
		if distance < nearestDistance:
			nearestDistance = distance
			nearestIndex = i
	
	return nearestIndex
