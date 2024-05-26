extends CharacterBody2D

const SPEED = 200

var damage_scene = preload("res://scenes/damage.tscn")

func _physics_process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "", "") * SPEED
	move_and_slide()

func _on_damage_hitbox_area_entered(node: Node) -> void:
	print("hi")
	if Input.is_key_pressed(KEY_E):
			print("you pressed ze button")
			node.get_parent().queue_free()

func _on_breach_hitbox_area_entered(node: Node) -> void:
	print("hi part 2")
	if Input.is_key_pressed(KEY_R):
			print("you pressed ze button")
			var damage_instance_name = node.get_parent().name.replace("Breach", "Damage")
			var damage_instance = damage_scene.instantiate()
			damage_instance.position = node.position
			damage_instance.name = damage_instance_name
			get_tree().get_root().get_node("Game/CharacterCanvas/Ship").add_child(damage_instance)
			node.get_parent().queue_free()
			
			
