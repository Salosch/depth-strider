extends CharacterBody2D

const SPEED = 225
const REPAIR_TIME = 2.0
const MAX_MESSAGE_TIME = 5

var total_elapsed_repair_time = 0.0
var current_repairing_node: Node = null
var current_message_time = 0

@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var hammer_weld_audio = $hammer_and_weld
@onready var recharge_audio = $recharge
@onready var message_audio = $message
@onready var ai_companion = $ai_companion
@onready var game_node = get_tree().get_root().get_node("Game")
@onready var ship_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship")
@onready var other_character = get_tree().get_root().get_node("Game/CharacterCanvas/Character")
@onready var repair_progress = $RepairProgress
@onready var exclamation_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship/Message/exclamation_mark")

func _ready():
	var sb = StyleBoxFlat.new()
	repair_progress.add_theme_stylebox_override("fill", sb)
	sb.set_corner_radius_all(2)
	sb.expand_margin_top = 1
	sb.expand_margin_bottom = 1
	sb.bg_color = Color('BF64CF')

func _physics_process(delta):
	velocity = Input.get_vector("ui_left_2", "ui_right_2", "ui_up_2", "ui_down_2") * SPEED

	if Input.is_action_pressed("ui_right_2"):
		animation_player.play("walk_right")
	elif Input.is_action_pressed("ui_left_2"):
		animation_player.play("walk_left")
	elif Input.is_action_pressed("ui_up_2"):
		animation_player.play("walk_up")
	elif Input.is_action_pressed("ui_down_2"):
		animation_player.play("walk_down")
	else:
		animation_player.play("idle_down")
		
	move_and_slide()

func _on_damage_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_accept_2")

func _on_breach_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_select_2")
	
func _on_core_hitbox_area_entered(core_node: Node, delta) -> void:
	handle_recharge(core_node, delta)

func _on_message_hitbox_area_entered(message_node: Node) -> void:
	handle_message(message_node)

func handle_repair(node: Node, delta: float, action: String) -> void:
	
	if Input.is_action_pressed(action):
		play_sound_off_action(action)
		animation_player.play("idle_down")
		total_elapsed_repair_time += delta
		self.set_physics_process(false)
		repair_progress.visible = true
		repair_progress.value = total_elapsed_repair_time
	
	if Input.is_action_just_released(action):
		stop_sound()
		animation_player.play("idle_down")
		total_elapsed_repair_time = 0
		self.set_physics_process(true)
		repair_progress.visible = false
		repair_progress.value = 0
	
	if total_elapsed_repair_time > REPAIR_TIME:
		stop_sound()
		animation_player.play("idle_down")
		total_elapsed_repair_time = 0
		self.set_physics_process(true)
		repair_progress.visible = false
		
		if action == "ui_accept_2":
			node.get_parent().queue_free()
		elif action == "ui_select_2":
			ship_node.respawn_damage(node)
			node.get_parent().queue_free()

func play_sound_off_action(action: String) -> void:
	if action == "ui_accept_2":
		if not hammer_weld_audio.playing:
			var hammering = load("res://assets/sound_effects/hammering.wav")
			hammer_weld_audio.stream = hammering
			hammer_weld_audio.play()

	elif action == "ui_select_2":
		if not hammer_weld_audio.playing:
			var welding = load("res://assets/sound_effects/welding.wav")
			hammer_weld_audio.stream = welding
			hammer_weld_audio.play()
		

func handle_recharge(core_node: Node, delta) -> void:
	if Input.is_action_pressed("ui_accept_2"):
		game_node.set_energy_bar(500)
		if not recharge_audio.playing:
			recharge_audio.play()
	else:
		recharge_audio.stop()
			

func handle_message(message_node: Node) -> void:
	if other_character.is_message_active:
		if Input.is_action_pressed("ui_accept_2"):
			other_character.is_message_active = false
			exclamation_node.visible = false
			game_node.show_and_write_dialog()
			other_character.current_message_time = 0

func stop_sound() -> void:
	hammer_weld_audio.stop()
