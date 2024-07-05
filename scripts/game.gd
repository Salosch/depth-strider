extends Node2D

const SCROLL_SPEED = 200
const MAX_OXYGEN = 100
const MAX_ENERGY = 100000
const MAX_MESSAGE_TIME = 5
const ENERGY_CHANGE_RATE = 80

var oxygen = MAX_OXYGEN
var current_energy = MAX_ENERGY
var current_message_time = 0
var energy_low_playable = true
var oxygen_low_playable = true

var second_character_instance = preload("res://scenes/additional_player.tscn")

@onready var scene_transition = $CanvasLayer/SceneTransition/AnimationPlayer
@onready var parallax_background = $Background/ParallaxBackground
@onready var ship = $CharacterCanvas/Ship
@onready var oxygen_bar = $UI/Control/Oxygen
@onready var distance_label = $UI/Control/DistanceLabel
@onready var energy_bar = $UI/Control/Energy
@onready var pause_screen = $UI/Control/Pause
@onready var dialog_box = $UI/Control/Dialog
@onready var ai_companion = $ai_companion
@onready var character_canvas = $CharacterCanvas
@onready var message_countdown = $UI/message_countdown
@onready var character = $CharacterCanvas/Character
@onready var exclamation_node = $CharacterCanvas/Ship/Message/exclamation_mark
@onready var character_audio = $CharacterCanvas/Character.get_node("ai_companion")
@onready var ship_audio = ship.get_node("ai_companion")

@export var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.stop_music()
	var sb_oxygen = StyleBoxFlat.new()
	oxygen_bar.add_theme_stylebox_override("fill", sb_oxygen)
	sb_oxygen.bg_color = Color('39aae4')

	var sb_energy = StyleBoxFlat.new()
	energy_bar.add_theme_stylebox_override("fill", sb_energy)
	sb_energy.bg_color = Color('ffe900')

	set_distance_label()
	set_energy_bar(0)
	
	if Global.is_coop:
		var second_character = second_character_instance.instantiate()
		second_character.name = "second_character"
		second_character.position = Vector2(933,362)
		character_canvas.add_child(second_character)

	scene_transition.get_parent().get_node("ColorRect").color.a = 255
	scene_transition.play("fade_out")
	await scene_transition.animation_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parallax_background.scroll_offset.x -= SCROLL_SPEED * delta
		
	distance += 5
	set_distance_label()
	
	if ship.has_breach():
		lose_oxygen()

	set_energy_bar(-100)
	
	if distance % 100000 == 0:
		oxygen = MAX_OXYGEN
		set_oxygen_bar()
		if not character_audio.playing and not ship_audio.playing:
			var oxygen_refill = load("res://assets/voice_lines/oxygen_refill.mp3")
			ai_companion.stream = oxygen_refill
			ai_companion.play()
		
	if current_energy == 0:
		death("Out of energy")
	
	if Input.is_action_just_pressed("pause"):
		pause_menu()
	
	if character.is_message_active:
		calc_message_time(delta)
		var message_delta: int = int(MAX_MESSAGE_TIME - current_message_time) + 1
		message_countdown.text = str(message_delta)
	
func pause_menu() -> void:
	$CanvasLayer.show()
	pause_screen.show()
	get_tree().paused = true
	
func set_oxygen_bar() -> void:
	oxygen_bar.value = oxygen
	
func set_distance_label() -> void:
	distance_label.text = str(distance) + "m"

func set_energy_bar(value: int) -> void:
	var delta_change_rate = get_process_delta_time() * ENERGY_CHANGE_RATE
	current_energy += value * delta_change_rate
	if current_energy > MAX_ENERGY:
		current_energy = MAX_ENERGY
		energy_low_playable = true
	
	if float(current_energy) / 100000.0 < 0.5 and energy_low_playable:
		energy_low_playable = false
		if not character_audio.playing and not ship_audio.playing:
			var energy_low = load("res://assets/voice_lines/energy_low.mp3")
			ai_companion.stream = energy_low
			ai_companion.play()
		
	energy_bar.value = current_energy
	
func lose_oxygen() -> void:
	oxygen -= 0.1
	
	if float(oxygen) / 100.0 < 0.5 and oxygen_low_playable:
		oxygen_low_playable = false
		if not character_audio.playing and not ship_audio.playing:
			var oxygen_low = load("res://assets/voice_lines/oxygen_low.mp3")
			ai_companion.stream = oxygen_low
			ai_companion.play()
			
	if oxygen < 0:
		death("Out of oxygen")
		
	set_oxygen_bar()

func show_and_write_dialog() -> void:
	dialog_box.show_and_write()

func calc_message_time(delta: float) -> void:
	current_message_time += delta
	if current_message_time >= MAX_MESSAGE_TIME:
		death("Message not answered in time")

func handle_message(message_node: Node) -> void:
	if character.is_message_active:
		if Input.is_action_pressed("ui_accept"):
			character.is_message_active = false
			exclamation_node.visible = false
			message_countdown.hide()
			show_and_write_dialog()
			current_message_time = 0


func death(death_message: String) -> void:
	Global.final_score = distance
	Global.death_message = death_message
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	scene_transition.play("fade_in")
	await scene_transition.animation_finished

