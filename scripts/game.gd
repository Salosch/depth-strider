extends Node2D

const SCROLL_SPEED = 200
const MAX_OXYGEN = 100

var oxygen = MAX_OXYGEN

@onready var parallax_background = $Background/ParallaxBackground
@onready var ship = $CharacterCanvas/Ship
@onready var oxygen_label = $UI/Control/OxygenLabel
@onready var oxygen_bar = $UI/Control/Oxygen
@onready var distance_label = $UI/Control/DistanceLabel

@export var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_oxygen_label()
	set_distance_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parallax_background.scroll_offset.x -= SCROLL_SPEED * delta
		
	distance += 5
	set_distance_label()
	
	if ship.has_breach():
		lose_oxygen()

func set_oxygen_label() -> void:
	oxygen_label.text = "Oxygen: " + str(oxygen)
	
func set_oxygen_bar() -> void:
	oxygen_bar.value = oxygen
	
func set_distance_label() -> void:
	distance_label.text = str(distance) + "m"
	
func lose_oxygen() -> void:
	oxygen -= 0.1
	
	if oxygen < 0:
		death()
		
	set_oxygen_label()
	set_oxygen_bar()
	
func death() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
