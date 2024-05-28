extends CharacterBody2D

const SPEED = 200

var total_elapsed_damage_repair_time = 0
var total_elapsed_breach_repair_time = 0

@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var ship_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship")

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

func _on_damage_hitbox_area_entered(node: Node, delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		total_elapsed_damage_repair_time += delta
	
	if Input.is_action_just_released("ui_accept"):
		total_elapsed_damage_repair_time = 0
	
	if total_elapsed_damage_repair_time > 2:
		total_elapsed_damage_repair_time = 0
		node.get_parent().queue_free()

func _on_breach_hitbox_area_entered(node: Node, delta) -> void:
	if Input.is_action_pressed("ui_select"):
		total_elapsed_breach_repair_time += delta
	
	if Input.is_action_just_released("ui_select"):
		total_elapsed_breach_repair_time = 0
	
	if total_elapsed_breach_repair_time > 2:
		total_elapsed_breach_repair_time = 0
		ship_node.respawn_damage(node)
		node.get_parent().queue_free()

			
