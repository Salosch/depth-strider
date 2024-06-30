extends Control

@onready var blur = get_tree().get_root().get_node("Game/CanvasLayer")

func _on_resume_pressed():
	get_tree().paused = false
	blur.hide()
	self.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
