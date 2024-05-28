extends CharacterBody2D

const SPEED = 200
const REPAIR_TIME = 2.0

var total_elapsed_repair_time = 0.0
var current_repairing_node: Node = null

@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
@onready var ship_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship")
@onready var repair_progress = get_tree().get_root().get_node("Game/UI/Control/RepairProgress")

func _physics_process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	if Input.is_action_pressed("ui_right"):
		animation_player.play("walk_right")
	elif Input.is_action_pressed("ui_left"):
		animation_player.play("walk_left")
	elif Input.is_action_pressed("ui_up"):
		animation_player.play("walk_up")
	elif Input.is_action_pressed("ui_down"):
		animation_player.play("walk_down")
	else:
		animation_player.play("idle")
		
	move_and_slide()

func _on_damage_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_accept")

func _on_breach_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_select")

func handle_repair(node: Node, delta: float, action: String) -> void:
	
	if Input.is_action_pressed(action):
		play_sound_off_action(action)
		total_elapsed_repair_time += delta
		self.set_physics_process(false)
		repair_progress.visible = true
		repair_progress.value = total_elapsed_repair_time
	
	if Input.is_action_just_released(action):
		stop_sound()
		total_elapsed_repair_time = 0
		self.set_physics_process(true)
		repair_progress.visible = false
		repair_progress.value = 0
	
	if total_elapsed_repair_time > REPAIR_TIME:
		stop_sound()
		total_elapsed_repair_time = 0
		self.set_physics_process(true)
		repair_progress.visible = false
		
		if action == "ui_accept":
			node.get_parent().queue_free()
		elif action == "ui_select":
			ship_node.respawn_damage(node)
			node.get_parent().queue_free()

func play_sound_off_action(action: String) -> void:
	if action == "ui_accept":
		if not audio_player.playing:
			var hammering = load("res://assets/sound_effects/hammering.wav")
			audio_player.stream = hammering
			audio_player.play()

	elif action == "ui_select":
		if not audio_player.playing:
			var welding = load("res://assets/sound_effects/welding.wav")
			audio_player.stream = welding
			audio_player.play()

func stop_sound() -> void:
	audio_player.stop()
