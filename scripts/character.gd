extends CharacterBody2D

const SPEED = 200
const REPAIR_TIME = 2.0
const MAX_MESSAGE_TIME = 5

var total_elapsed_repair_time = 0.0
var current_repairing_node: Node = null
var current_message_time = 0

@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
@onready var game_node = get_tree().get_root().get_node("Game")
@onready var ship_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship")
@onready var repair_progress = get_tree().get_root().get_node("Game/UI/Control/RepairProgress")
@onready var exclamation_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship/Message/exclamation_mark")

@onready var rng = RandomNumberGenerator.new()
@onready var is_message_active = false

func _ready():
	var message_timer = Timer.new()
	add_child(message_timer)
	message_timer.wait_time = 5
	message_timer.start()
	message_timer.timeout.connect(spawn_message)
	var sb = StyleBoxFlat.new()
	repair_progress.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color('582080')

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
		animation_player.play("idle_down")
		
	move_and_slide()
	
	if is_message_active:
		calc_message_time(delta)

func _on_damage_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_accept")

func _on_breach_hitbox_area_entered(node_to_repair: Node, delta) -> void:
	handle_repair(node_to_repair, delta, "ui_select")
	
func _on_core_hitbox_area_entered(core_node: Node, delta) -> void:
	handle_recharge(core_node, delta)

func _on_message_hitbox_area_entered(message_node: Node) -> void:
	handle_message(message_node)

func handle_repair(node: Node, delta: float, action: String) -> void:
	
	if Input.is_action_pressed(action):
		play_sound_off_action(action)
		animation_player.play("repair")
		total_elapsed_repair_time += delta
		self.set_physics_process(false)
		repair_progress.visible = true
		repair_progress.value = total_elapsed_repair_time
	
	if Input.is_action_just_released(action):
		stop_sound()
		animation_player.play("idle")
		total_elapsed_repair_time = 0
		self.set_physics_process(true)
		repair_progress.visible = false
		repair_progress.value = 0
	
	if total_elapsed_repair_time > REPAIR_TIME:
		stop_sound()
		animation_player.play("idle")
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

func handle_recharge(core_node: Node, delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		game_node.set_energy_bar(500)
	
func spawn_message() -> void:
	var rand_num = rng.randi_range(0,100)
	if rand_num >= 75:
		is_message_active = true
		exclamation_node.visible = true
	
func handle_message(message_node: Node) -> void:
	if is_message_active:
		if Input.is_action_pressed("ui_accept"):
			is_message_active = false
			exclamation_node.visible = false
			current_message_time = 0

func calc_message_time(delta: float) -> void:
	current_message_time += delta
	if current_message_time >= MAX_MESSAGE_TIME:
		game_node.death()

func stop_sound() -> void:
	audio_player.stop()
