extends Node3D

class_name Pipes

static var END_LOCAL_X_POSITION : float = 0
static var GLOBAL_X_FLAPPY_BIRD_POSITION : float = 0

signal reached_end_of_screen(pipes: Pipes, overshoot_distance: float)
signal moved_past_flappy_bird()

@export var vertical_position_node_3D: Node3D

var has_moved_past_flappy_bird: bool


func set_start_local_position(start_local_position_offset: float) -> void:
	has_moved_past_flappy_bird = false
	position = Vector3.LEFT*start_local_position_offset
	
func set_vertical_position(vertical_position_height: float) -> void:
	vertical_position_node_3D.position = Vector3.UP * vertical_position_height

func move_to_the_left(distance_to_move: float) -> void:
	position += Vector3.LEFT*distance_to_move
	
	# This code assumes the pipes move from right to left
	if not has_moved_past_flappy_bird and global_position.x < GLOBAL_X_FLAPPY_BIRD_POSITION:
		has_moved_past_flappy_bird = true
		moved_past_flappy_bird.emit()
	
	var distance_to_end: float = absf(position.x) - absf(END_LOCAL_X_POSITION)
	if  distance_to_end >= 0:
		reached_end_of_screen.emit(self,distance_to_end)
	
