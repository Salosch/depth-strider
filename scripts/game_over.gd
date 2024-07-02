extends Control

@onready var scene_transition = $CanvasLayer/SceneTransition/AnimationPlayer
@onready var score_label = $ScoreLabel
@onready var death_message = $death_message

func _ready():
	AudioPlayer.stop()
	score_label.text = str(Global.final_score)
	death_message.text = Global.death_message
	
	scene_transition.play("fade_out")
	await scene_transition.animation_finished

func _on_restart_button_pressed():
	Sound.button_click()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_menu_pressed():
	Sound.button_click()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
