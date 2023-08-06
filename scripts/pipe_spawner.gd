extends Node3D

class_name PipeSpawner

signal pipes_moved_past_flappy_bird()

@export_category("Components")
@export var pipes_scene : Resource

@export_category("Parameters")
@export var distance_between_pipes: float = 1.5
@export var start_local_x_position: float = 0
@export var end_local_x_position: float = -6
@export var min_pipes_vertical_positon: float = -1.0
@export var max_pipes_vertical_positon: float = 1.0
@export var base_movement_speed: float = 1.0
@export var max_movement_speed: float = 5.0
@export var movement_speed_increase_step: float = 0.02


var movement_speed: float
var start_game_position_offset: float
var pipes_array : Array[Pipes]
var pipes_count: int

@onready var is_game_running: bool = false



func _ready():
	start_game_position_offset = (end_local_x_position-start_local_x_position)/2.0
	initialise_pipes_array()

func initialise_pipes_array():
	Pipes.END_LOCAL_X_POSITION = end_local_x_position
	pipes_count = absf(end_local_x_position-start_local_x_position) / distance_between_pipes
	pipes_array = []
	var pipes_instance: Pipes
	
	for i in pipes_count:
		pipes_instance = pipes_scene.instantiate()
		add_child(pipes_instance)
		pipes_array.append(pipes_instance)
		pipes_instance.reached_end_of_screen.connect(_on_pipes_reached_end_of_screen)
		pipes_instance.moved_past_flappy_bird.connect(_on_pipes_moved_past_flappy_bird)
		
func reset_pipes_positions():
	var pipes_next_vertical_position: float
	for i in pipes_count:
		pipes_next_vertical_position = lerp(min_pipes_vertical_positon,max_pipes_vertical_positon,randf())
		pipes_array[i].set_start_local_position(start_game_position_offset+start_local_x_position+distance_between_pipes*i)
		pipes_array[i].set_vertical_position(pipes_next_vertical_position)
	
	pipes_next_vertical_position = lerp(min_pipes_vertical_positon,max_pipes_vertical_positon,0.5)
	pipes_array[pipes_count-1].set_vertical_position(pipes_next_vertical_position)
	
func reset_movement_speed() -> void:
	movement_speed = base_movement_speed


func _on_gameplay_scene_game_reset():
	reset_pipes_positions()
	reset_movement_speed()

func _on_gameplay_scene_game_started():
	is_game_running = true

func _on_gameplay_scene_game_over():
	is_game_running = false


func _process(delta):
	if is_game_running:
		var distance_to_move: float = movement_speed*delta
		for i in pipes_count:
			pipes_array[i].move_to_the_left(distance_to_move)

func _on_pipes_reached_end_of_screen(pipes: Pipes, distance_overshoot: float):
	var pipes_next_vertical_position: float = lerp(min_pipes_vertical_positon,max_pipes_vertical_positon,randf())
	
	pipes.set_start_local_position(distance_overshoot)
	pipes.set_vertical_position(pipes_next_vertical_position)

func _on_pipes_moved_past_flappy_bird() -> void:
	pipes_moved_past_flappy_bird.emit()


func _on_gameplay_scene_score_changed(new_score):
	movement_speed += movement_speed_increase_step
	movement_speed = min(max_movement_speed,movement_speed)
