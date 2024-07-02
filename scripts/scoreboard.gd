extends Node2D

@onready var score_container = $ScrollContainer/MarginContainer/ScoreContainer
@onready var submit_button = $SubmitButton
@onready var contender_textedit = $ContenderTextEdit
@onready var result_label = $score

@onready var submitted = false:
	set(value):
		submitted = value
		submit_button.disabled = value

@onready var current_score = (Global.final_score):
	set(value):
		current_score = value
		result_label.set_text("%d" % value)

func _ready():
	generate_scoreboard()

func set_score(contender, score):
	Global.scores[contender] = score
	Global.save_scores()
	sort_dict(Global.scores)

func sort_dict(dict: Dictionary) -> void:
	var pairs = dict.keys().map(func (key): return [key, dict[key]])
	pairs.sort_custom(func(a, b): return a[1] > b[1])
	dict.clear()
	for p in pairs:
		dict[p[0]] = p[1]

func clear_scoreboard():
	for n in score_container.get_children():
		score_container.remove_child(n)

func generate_scoreboard():
	var entries = []

	var contender_title = Label.new()
	var score_title = Label.new()

	contender_title.set_text(" ")
	score_title.set_text(" ")

	for header in [contender_title, score_title]:
		header.add_theme_font_size_override("font_size", 32)
		header.add_theme_color_override("font_color", Color8(221, 32, 48, 255))

	entries += [contender_title, score_title]

	sort_dict(Global.scores)
	for key in Global.scores.keys():
		var contender_label = Label.new()
		var score_label = Label.new()

		score_label.set_text("%d" % Global.scores[key])
		contender_label.set_text(key)

		entries += [contender_label, score_label]

	for i in entries.size():
		var entry : Label = entries[i]
		score_container.add_child(entry)

		if i % 2 == 1:
			entry.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)

func _on_submit_button_pressed():
	Sound.button_click()
	var contender = contender_textedit.text
	if contender != "":
		var updated_score = max(current_score, Global.scores.get(contender, -1))
		set_score(contender, updated_score)
		submitted = true

		clear_scoreboard()
		generate_scoreboard()


func _on_contender_text_edit_mouse_entered():
	$ContenderTextEdit.set_placeholder("")


func _on_contender_text_edit_mouse_exited():
	$ContenderTextEdit.set_placeholder("Enter your name")
