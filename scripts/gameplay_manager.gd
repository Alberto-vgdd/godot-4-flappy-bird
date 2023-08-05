extends Node

class_name GameplayManager

const RESET_TIME: float = 1.5

signal game_started()
signal game_over()
signal game_reset()
signal score_changed(new_score: int)


@export_category("Components")
@export var game_over_audio_stream_player: AudioStreamPlayer
@export var score_up_audio_stream_player: AudioStreamPlayer

var is_waiting_for_player_input: bool = false
var is_game_running: bool = false
var score: int


func _ready():
	game_reset.connect(on_game_reset)
	game_reset.emit()


func on_game_reset():
	score = 0
	score_changed.emit(score)
	is_waiting_for_player_input = true
	

func _process(_delta):
	if !is_game_running and is_waiting_for_player_input:
		if Input.is_action_just_pressed("fly"):
			is_waiting_for_player_input = false
			is_game_running = true
			game_started.emit()


func _on_flappy_bird_collided_with_obstacle():
	game_over_audio_stream_player.play(0.0)
	is_game_running = false
	game_over.emit()
	await get_tree().create_timer(RESET_TIME).timeout
	game_reset.emit()
	
	
func _on_pipe_spawner_pipes_moved_past_flappy_bird():
	score_up_audio_stream_player.play(0.0)
	score += 1
	score_changed.emit(score)
