extends Control

class_name MainMenuUI

@export_file var game_scene: String

func _on_play_button_pressed():
	get_tree().change_scene_to_file(game_scene)

func _on_exit_button_pressed():
	get_tree().quit(0)
