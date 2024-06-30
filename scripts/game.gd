extends Node2D

const SCROLL_SPEED = 200
const MAX_OXYGEN = 100
const MAX_ENERGY = 100000.0

var oxygen = MAX_OXYGEN
var current_energy = MAX_ENERGY


@onready var parallax_background = $Background/ParallaxBackground
@onready var ship = $CharacterCanvas/Ship
@onready var oxygen_bar = $UI/Control/Oxygen
@onready var distance_label = $UI/Control/DistanceLabel
@onready var energy_bar = $UI/Control/Energy
@onready var pause_screen = $UI/Control/Pause

@export var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.stop_music()
	var sb_oxygen = StyleBoxFlat.new()
	oxygen_bar.add_theme_stylebox_override("fill", sb_oxygen)
	sb_oxygen.bg_color = Color('45b0e6')

	var sb_energy = StyleBoxFlat.new()
	energy_bar.add_theme_stylebox_override("fill", sb_energy)
	sb_energy.bg_color = Color('dbbc1f')

	set_distance_label()
	set_energy_bar(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parallax_background.scroll_offset.x -= SCROLL_SPEED * delta
		
	distance += 5
	set_distance_label()
	
	if ship.has_breach():
		lose_oxygen()
		
	set_energy_bar(-100)
	
	if current_energy == 0:
		death()
	
	if Input.is_action_just_pressed("pause"):
		pause_menu()
	
func pause_menu() -> void:
	$CanvasLayer.show()
	pause_screen.show()
	get_tree().paused = true
	
func set_oxygen_bar() -> void:
	oxygen_bar.value = oxygen
	
func set_distance_label() -> void:
	distance_label.text = str(distance) + "m"

func set_energy_bar(value: int) -> void:
	current_energy += value
	if current_energy > MAX_ENERGY:
		current_energy = MAX_ENERGY
		
	energy_bar.value = current_energy
	
func lose_oxygen() -> void:
	oxygen -= 0.1
	
	if oxygen < 0:
		death()
		
	set_oxygen_bar()



func death() -> void:
	Global.final_score = distance
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

