extends Camera2D

@export var minx = -10000
@export var maxx = 10000
var sel = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
@onready var friendly = $"../../Dynamic/Friendly"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mp = get_viewport().get_mouse_position()/get_viewport().get_visible_rect().size
	if mp.x < 0.1 and position.x > minx:
		position.x -= 40
	elif mp.x > 0.9 and position.x < maxx:
		position.x += 40

func  _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Mouse Click/Unclick at: ", event.position)
			var newmob = Mobs.all_mobs[sel].instantiate()
			newmob.position.x = get_local_mouse_position().x+position.x
			newmob.position.y = randf_range(-100,100)
			friendly.add_child(newmob)
