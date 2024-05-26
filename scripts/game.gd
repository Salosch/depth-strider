extends Node2D

var MAX_OXYGEN = 100
@export var distance = 0
var oxygen = MAX_OXYGEN
var SCROLL_SPEED = -200
@onready var parallax_layer = $Background/ParallaxBackground

# Called when the node enters the scene tree for the first time.
func _ready():
	set_oxygen_label()
	set_distance_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for layer in parallax_layer.get_children():
		if layer is ParallaxLayer:
			layer.motion_offset.x += SCROLL_SPEED * delta
	
	distance += 5
	set_distance_label()
	
	if $CharacterCanvas/Ship.has_breach:
		lose_oxygen()

func set_oxygen_label() -> void:
	$UI/Control/OxygenLabel.text = "Oxygen: " + str(oxygen)
	
func set_oxygen_bar() -> void:
	$UI/Control/Oxygen.value = oxygen
	
func set_distance_label() -> void:
	$UI/Control/DistanceLabel.text = str(distance) + "m"
	
func lose_oxygen() -> void:
	oxygen -= 0.1
	if oxygen < 0:
		death()
		
	set_oxygen_label()
	set_oxygen_bar()
	
func death() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
