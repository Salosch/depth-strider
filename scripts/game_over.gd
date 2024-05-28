extends Control

var score_label: Label

func _ready():
	score_label = $ScoreLabel
	score_label.text = str(Global.final_score)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
