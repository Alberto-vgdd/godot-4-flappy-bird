extends Control

class_name GameplayUI

@export var score_label: Label

func _on_gameplay_scene_score_changed(new_score):
	score_label.set_text(str(new_score))
