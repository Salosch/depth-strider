extends CharacterBody2D

const SPEED = 200

var total_delta = 0
var damage_scene = preload("res://scenes/damage.tscn")
@onready var ship_node = get_tree().get_root().get_node("Game/CharacterCanvas/Ship")

func _physics_process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	if Input.is_action_pressed("ui_right"):
		$Sprite2D/AnimationPlayer.play("walk_right")
	elif Input.is_action_pressed("ui_left"):
		$Sprite2D/AnimationPlayer.play("walk_left")
	elif Input.is_action_pressed("ui_up"):
		$Sprite2D/AnimationPlayer.play("walk_up")
	elif Input.is_action_pressed("ui_down"):
		$Sprite2D/AnimationPlayer.play("walk_down")
	else:
		$Sprite2D/AnimationPlayer.play("idle")
		
	move_and_slide()

func _on_damage_hitbox_area_entered(node: Node, delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		total_delta += delta
	
	if Input.is_action_just_released("ui_accept"):
		total_delta = 0
	
	if total_delta > 2:
		total_delta = 0
		node.get_parent().queue_free()

func _on_breach_hitbox_area_entered(node: Node, delta) -> void:
	if Input.is_action_pressed("ui_select"):
		total_delta += delta
	
	if Input.is_action_just_released("ui_select"):
		total_delta = 0
	
	if total_delta > 2:
		total_delta = 0
		ship_node.respawn_damage(node)
		node.get_parent().queue_free()

			
