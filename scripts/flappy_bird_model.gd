extends Node3D

class_name FlappyBirdModel


@export_category("Components")
@export var left_wing: Node3D
@export var right_wing: Node3D
@export var rotation_pivot: Node3D


@export_category("Parameters")
@export var wing_down_angle: float = -65.0
@export var wing_up_angle: float = 65.0
@export var ascending_angle: float = 25.0
@export var descending_angle: float = -80.0


var wings_tween: Tween
var bird_rotation_tween: Tween


func flap_wings() -> void:
	stop_animations()
	
	wings_tween = create_tween()
	wings_tween.tween_property(right_wing,"rotation_degrees:z",wing_down_angle,0.05)
	wings_tween.parallel().tween_property(left_wing,"rotation_degrees:z",-wing_down_angle,0.05)
	wings_tween.tween_property(right_wing,"rotation_degrees:z",wing_up_angle,0.4)
	wings_tween.parallel().tween_property(left_wing,"rotation_degrees:z",-wing_up_angle,0.4)

	
	bird_rotation_tween = create_tween()
	bird_rotation_tween.tween_property(rotation_pivot,"rotation_degrees:z",ascending_angle,0.1)
	bird_rotation_tween.tween_property(rotation_pivot,"rotation_degrees:z",descending_angle,1)


func reset_pose() -> void:
	_set_facing_forward()
	_set_wings_down()

func stop_animations() -> void:	
	if wings_tween:
		wings_tween.stop()
	if bird_rotation_tween:
		bird_rotation_tween.stop()

func _set_facing_forward() -> void:
	rotation_pivot.rotation_degrees.z = 0.0

func _set_wings_down() -> void:
	right_wing.rotation_degrees.z = wing_down_angle
	left_wing.rotation_degrees.z = -wing_down_angle

