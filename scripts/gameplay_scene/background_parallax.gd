extends Node3D

class_name BackgroundParallax

@export_category("Components")
@export var background_layers: Array[Node3D]

@export_category("Parameters")
@export var start_local_x_position: float = 0
@export var end_local_x_position: float = -6 
@export var background_layers_speed_multipliers: Array[float]

@export var base_movement_speed: float = 1.0
@export var max_movement_speed: float = 5.0
@export var movement_speed_increase_step: float = 0.02

var movement_speed: float
var is_game_running: bool

func _ready():
	assert(background_layers.size() == background_layers_speed_multipliers.size(),"the number of layers does not match the number of speed multipliers")

func _process(delta):
	if is_game_running:
		for i in background_layers.size():
			background_layers[i].position.x -= movement_speed*background_layers_speed_multipliers[i]*delta
			if background_layers[i].position.x < end_local_x_position:
				var overshoot_offset: float = background_layers[i].position.x - end_local_x_position
				background_layers[i].position.x = start_local_x_position + overshoot_offset




func _on_gameplay_scene_game_reset():
	reset_movement_speed()
	reset_background_layers_positions()
	
func reset_movement_speed() -> void:
	movement_speed = base_movement_speed

func reset_background_layers_positions() -> void:
	for i in background_layers.size():
		background_layers[i].position.x = start_local_x_position


func _on_gameplay_scene_game_started():
	is_game_running = true
	
func _on_gameplay_scene_score_changed(new_score):
	movement_speed = min(max_movement_speed,movement_speed+movement_speed_increase_step)

func _on_gameplay_scene_game_over():
	is_game_running = false
