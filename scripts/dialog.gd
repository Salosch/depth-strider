extends Control

@onready var text_field = $box/RichTextLabel

var texts = ["you are doing good commander, this is not rocket science after all...", "I bet the view up there is out of this world!", "you are over the moon with your performance", "shoot for the stars commander!",
			 "everything stellar on your end commander?", "your work is taking us to infinity and beyond!", "no, the answer is not 42...", "astronomical performance, commander"]

func show_and_write() -> void:
	var text_begin = "Mission control here, " 
	var text = text_begin + texts.pick_random()
	text_field.add_text(text)
	self.show()

func _on_close_pressed() -> void:
	Sound.button_click()
	text_field.clear()
	self.hide()
