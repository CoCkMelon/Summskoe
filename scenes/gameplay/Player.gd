extends Node2D

var team = 0
@onready var mobManager = $"../Enemy manager"
var defeatScene = "res://scenes/UI/defeat.tscn"

var resources = Mobs.Resources.new(0,0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Mobs.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var no_friends = true
	for mob in mobManager.team1Mobs:
		if mob.destroyed == false:
			no_friends = false
			break
	if no_friends:
		defeat()
	passive_income()

func defeat():
	
	## Create a new label node
	#var defeatedLabel = Label.new()
	#
	## Set properties of the label
	#defeatedLabel.text = "Defeated"
	##defeatedLabel.align = Label.
	##defeatedLabel.valign = Label.VALIGN_CENTER
	##defeatedLabel.custom_minimum_size = Vector2(200, 50)
	#defeatedLabel.modulate = Color(1, 0, 0)  # Set color to red
	
	# Add the label to the scene
	#add_child(defeatedLabel)
	
	
	load(defeatScene).instantiate()
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	

func passive_income():
	resources.materials += 1
	resources.energy += 1
	resources.precision += 1
	resources.influence += 1
