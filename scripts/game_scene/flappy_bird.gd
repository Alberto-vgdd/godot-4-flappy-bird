extends Node3D

class_name FlappyBird


const gravity_value: float = -9.81
const max_falling_velocity: float = -20.0


signal collided_with_obstacle()

@export_category("Components")
@export var rigid_body_3D: RigidBody3D
@export var fly_audio_stream_player: AudioStreamPlayer
@export var flappy_bird_model: FlappyBirdModel

@export_category("Parameters")
@export var fly_velocity_value: float 


var is_game_running: bool
var fly_button_pressed: bool
var current_velocity: Vector3


func _ready():
	Pipes.GLOBAL_X_FLAPPY_BIRD_POSITION = global_position.x

func _process(_delta):
	if is_game_running and Input.is_action_just_pressed("fly"):
		fly_button_pressed = true
	pass


func _physics_process(delta):
	if is_game_running: 
		current_velocity.y += gravity_value*delta
		
		if (fly_button_pressed):
			fly_button_pressed = false
			current_velocity.y = fly_velocity_value
			flappy_bird_model.flap_wings()
			fly_audio_stream_player.play(0.0)
		
		rigid_body_3D.linear_velocity = current_velocity

func _on_rigid_body_3d_body_entered(body: PhysicsBody3D):
	if is_game_running and body.is_in_group(Groups.Obstacles):
		collided_with_obstacle.emit()
		pass

func _on_gameplay_scene_game_reset():
	is_game_running = false
	fly_button_pressed = false
	rigid_body_3D.position = Vector3.ZERO
	flappy_bird_model.reset_pose()
	
func _on_gameplay_scene_game_started():
	is_game_running = true

func _on_gameplay_scene_game_over():
	is_game_running = false
	current_velocity.y = 0
	rigid_body_3D.linear_velocity = current_velocity
	flappy_bird_model.stop_animations()
